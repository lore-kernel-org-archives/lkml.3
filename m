Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3JBLZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:25:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36352 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3JBLZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:25:06 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 1/2] anon_inodes: allow external inode allocations
Date: Wed,  2 Oct 2013 13:24:25 +0200
Message-Id: <1380713066-32519-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM core shares a single address_space across all inodes that belong to
the same DRM device. This allows efficient unmapping of user-space
mappings during buffer eviction. However, there is no easy way to get a
shared address_space for DRM devices during initialization. Therefore, we
currently delay this step until the first ->open() and save the given
inode for future use.

This causes ugly delayed initialization throughout the DRM core. TTM
devices end up without a dev_mapping pointer and we have to carefully
respect any underlying filesystem implementation so we don't corrupt the
inode->i_mapping and inode->i_data fields.

We can avoid this if we were allowed to allocate an anonymous inode for
each DRM device. We only have to set file->f_mapping during ->open()
and no longer need to adjust inode mappings. As fs/anon_inodes.c already
provides a minimal internal FS mount, we extend it to also provide
anonymous inodes for use in drivers like DRM.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Wanted-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
Hi Linus & Al

Any chance I could get an ACK on this? It's fairly trivial and allows us to
simplify the DRM logic quite a bit (see patch 2/2 and I have 2 more DRM cleanup
patches pending). This has been pending on fsdevel for 2 months now and all we
need is an ACK from an VFS maintainer.

I ditched the idea to allocate "struct address_space" separately in DRM as akpm
told me that this might get messy without an underlying inode. So I think the
anon-inode approach is the way to go.

Thanks
David

 fs/anon_inodes.c            | 36 +++++++++++++++++++++++++++++-------
 include/linux/anon_inodes.h |  1 +
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 85c9618..35263a3 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -25,6 +25,7 @@
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode;
 static const struct file_operations anon_inode_fops;
+static struct dentry *anon_inode_root;
 
 /*
  * anon_inodefs_dname() is called from d_path().
@@ -87,19 +88,18 @@ static struct inode *anon_inode_mkinode(struct super_block *s)
 static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
 				int flags, const char *dev_name, void *data)
 {
-	struct dentry *root;
-	root = mount_pseudo(fs_type, "anon_inode:", NULL,
+	anon_inode_root = mount_pseudo(fs_type, "anon_inode:", NULL,
 			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
-	if (!IS_ERR(root)) {
-		struct super_block *s = root->d_sb;
+	if (!IS_ERR(anon_inode_root)) {
+		struct super_block *s = anon_inode_root->d_sb;
 		anon_inode_inode = anon_inode_mkinode(s);
 		if (IS_ERR(anon_inode_inode)) {
-			dput(root);
+			dput(anon_inode_root);
 			deactivate_locked_super(s);
-			root = ERR_CAST(anon_inode_inode);
+			anon_inode_root = ERR_CAST(anon_inode_inode);
 		}
 	}
-	return root;
+	return anon_inode_root;
 }
 
 static struct file_system_type anon_inode_fs_type = {
@@ -285,6 +285,28 @@ err_put_unused_fd:
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
+/**
+ * anon_inode_new - create private anonymous inode
+ *
+ * Creates a new inode on the anonymous inode FS for driver's use. The inode has
+ * it's own address_space compared to the shared anon_inode_inode. It can be
+ * used in situations where user-space mappings have to be shared across
+ * different files but no backing inode is available.
+ *
+ * Call iput(inode) to release the inode.
+ *
+ * RETURNS:
+ * New inode on success, error pointer on failure.
+ */
+struct inode *anon_inode_new(void)
+{
+	if (IS_ERR(anon_inode_root))
+		return ERR_CAST(anon_inode_root);
+
+	return anon_inode_mkinode(anon_inode_root->d_sb);
+}
+EXPORT_SYMBOL_GPL(anon_inode_new);
+
 static int __init anon_inode_init(void)
 {
 	int error;
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index cf573c2..d17378c 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -18,6 +18,7 @@ struct file *anon_inode_getfile_private(const char *name,
 				void *priv, int flags);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags);
+struct inode *anon_inode_new(void);
 
 #endif /* _LINUX_ANON_INODES_H */
 
-- 
1.8.4

