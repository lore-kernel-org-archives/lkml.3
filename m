Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708Ab3IEJp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:57 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39455 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3IEJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:54 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/11] vfs: check submounts and drop atomically
Date: Thu,  5 Sep 2013 11:44:36 +0200
Message-Id: <1378374284-1484-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
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
 fs/dcache.c            | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 83 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3b12076..d05f46c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1240,6 +1240,88 @@ void shrink_dcache_parent(struct dentry *parent)
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
+static void check_and_drop(void *_data)
+{
+	struct select_data *data = _data;
+
+	if (d_mountpoint(data->start))
+		data->found = -EBUSY;
+	if (!data->found)
+		__d_drop(data->start);
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
+		struct select_data data;
+
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = dentry;
+		data.found = 0;
+
+		d_walk(dentry, &data, check_and_collect, check_and_drop);
+		ret = data.found;
+
+		if (!list_empty(&data.dispose))
+			shrink_dentry_list(&data.dispose);
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

