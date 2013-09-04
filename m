Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747Ab3IDOJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:09:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38317 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab3IDOFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:49 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/10] vfs: check submounts and drop atomically
Date: Wed,  4 Sep 2013 16:05:48 +0200
Message-Id: <1378303556-7220-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We check submounts before doing d_drop() on a non-empty directory dentry in
NFS (have_submounts()), but we do not exclude a racing mount.

 Process A: have_submounts() -> returns false
 Process B: mount() -> success
 Process A: d_drop()

This patch prepares the ground for the fix by doing the following
operations all under the same rename lock:

  have_submounts()
  shrink_dcache_parent()
  d_drop()

This is actually an optimization since have_submounts() and
shrink_dcache_parent() both traverse the same dentry tree separately.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c            | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 93 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 53dbae1..d0673f7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1253,6 +1253,98 @@ void shrink_dcache_parent(struct dentry * parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static enum d_walk_ret check_and_collect(void *_data, struct dentry *dentry)
+{
+	struct select_data *data = _data;
+
+	if (d_mountpoint(dentry)) {
+		data->found = -EBUSY;
+		return D_WALK_QUIT;
+	}
+
+	return select_collect(_data, dentry);
+}
+
+static void check_and_drop(void *_data, struct dentry *dentry)
+{
+	struct select_data *data = _data;
+
+	/* We're only interested in the root of this subtree */
+	if (data->start == dentry) {
+		if (d_mountpoint(dentry))
+			data->found = -EBUSY;
+		if (!data->found)
+			__d_drop(dentry);
+	}
+}
+
+static int __check_submounts_and_drop(struct dentry *parent,
+					     struct list_head *dispose)
+{
+	struct select_data data = {
+		.start = parent,
+		.dispose = dispose,
+		.found = 0,
+	};
+
+	d_walk(parent, &data, check_and_collect, check_and_drop);
+
+	return data.found;
+}
+
+/**
+ * check_submounts_and_drop - prune dcache, check for submounts and drop
+ *
+ * All done as a single atomic operation relative to has_unlinked_ancestor().
+ * Returns 0 if successfully unhashed @parent.  If there were submounts then
+ * return -EBUSY.
+ *
+ * @dentry: dentry to prune and drop
+ */
+int check_submounts_and_drop(struct dentry *dentry)
+{
+	int ret = 0;
+
+	/* Negative dentries can be dropped without further checks */
+	if (!dentry->d_inode) {
+		d_drop(dentry);
+		goto out;
+	}
+
+	spin_lock(&dentry->d_lock);
+	if (d_unhashed(dentry))
+		goto out_unlock;
+	if (list_empty(&dentry->d_subdirs)) {
+		if (d_mountpoint(dentry)) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+		__d_drop(dentry);
+		goto out_unlock;
+	}
+	spin_unlock(&dentry->d_lock);
+
+	for (;;) {
+		LIST_HEAD(dispose);
+		ret = __check_submounts_and_drop(dentry, &dispose);
+		if (!list_empty(&dispose))
+			shrink_dentry_list(&dispose);
+
+		if (ret <= 0)
+			break;
+
+		cond_resched();
+	}
+
+out:
+	return ret;
+
+out_unlock:
+	spin_unlock(&dentry->d_lock);
+	goto out;
+}
+EXPORT_SYMBOL(check_submounts_and_drop);
+
 /**
  * __d_alloc	-	allocate a dcache entry
  * @sb: filesystem it will belong to
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index efdc944..87bd0d7 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -253,6 +253,7 @@ extern void d_prune_aliases(struct inode *);
 
 /* test whether we have any submounts in a subdir tree */
 extern int have_submounts(struct dentry *);
+extern int check_submounts_and_drop(struct dentry *);
 
 /*
  * This adds the entry to the hash queues.
-- 
1.8.1.4

