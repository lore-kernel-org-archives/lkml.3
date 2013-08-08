Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3HHP1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:27:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64867 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965835Ab3HHPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:25:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/9] vfs: check unlinked ancestors before mount
Date: Thu,  8 Aug 2013 17:24:43 +0200
Message-Id: <1375975490-18673-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We check submounts before doing d_drop() on a non-empty directory dentry in
NFS (have_submounts()), but we do not exclude a racing mount.  Nor do we
prevent mounts to be added to the disconnected subtree using relative paths
after the d_drop().

This patch fixes these issues by checking for unlinked (unhashed, non-root)
ancestors before proceeding with the mount.  This is done after setting
DCACHE_MOUNTED on the soon-to-be mountpoint and with the rename seqlock
taken for write.  This ensures that the only one of
check_submounts_and_drop() or has_unlinked_ancestor() can succeed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c    | 35 +++++++++++++++++++++++++++++++++++
 fs/internal.h  |  1 +
 fs/namespace.c |  9 +++++++++
 3 files changed, 45 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 020004d..1333445 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1103,6 +1103,41 @@ rename_retry:
 }
 EXPORT_SYMBOL(have_submounts);
 
+static bool __has_unlinked_ancestor(struct dentry *dentry)
+{
+	struct dentry *this;
+
+	for (this = dentry; !IS_ROOT(this); this = this->d_parent) {
+		int is_unhashed;
+
+		/* Need exclusion wrt. check_submounts_and_drop() */
+		spin_lock(&this->d_lock);
+		is_unhashed = d_unhashed(this);
+		spin_unlock(&this->d_lock);
+
+		if (is_unhashed)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * Called by mount code to check if the mountpoint is reachable (e.g. NFS can
+ * unhash a directory dentry and then the complete subtree can become
+ * unreachable).
+ */
+bool has_unlinked_ancestor(struct dentry *dentry)
+{
+	bool found;
+
+	/* Need exclusion wrt. check_submounts_and_drop() */
+	write_seqlock(&rename_lock);
+	found = __has_unlinked_ancestor(dentry);
+	write_sequnlock(&rename_lock);
+
+	return found;
+}
+
 /*
  * Search the dentry child list of the specified parent,
  * and move any unused dentries to the end of the unused
diff --git a/fs/internal.h b/fs/internal.h
index 7c5f01c..d232355 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -126,6 +126,7 @@ extern int invalidate_inodes(struct super_block *, bool);
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+extern bool has_unlinked_ancestor(struct dentry *dentry);
 
 /*
  * read_write.c
diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..bb92a9c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -634,6 +634,15 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 	}
 	dentry->d_flags |= DCACHE_MOUNTED;
 	spin_unlock(&dentry->d_lock);
+
+	if (has_unlinked_ancestor(dentry)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags &= ~DCACHE_MOUNTED;
+		spin_unlock(&dentry->d_lock);
+		kfree(mp);
+		return ERR_PTR(-ENOENT);
+	}
+
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	list_add(&mp->m_hash, chain);
-- 
1.8.1.4

