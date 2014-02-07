Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaBGQtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:49:05 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64561 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaBGQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:57 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: [PATCH 13/13] vfs: merge rename2 into rename
Date: Fri,  7 Feb 2014 17:49:11 +0100
Message-Id: <1391791751-2533-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This merges i_op->rename2 back into ->rename.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking           |  6 +-----
 Documentation/filesystems/vfs.txt           |  8 ++------
 drivers/staging/lustre/lustre/llite/namei.c |  3 ++-
 fs/9p/v9fs.h                                |  3 ++-
 fs/9p/vfs_inode.c                           |  4 +++-
 fs/affs/affs.h                              |  3 ++-
 fs/affs/namei.c                             |  3 ++-
 fs/afs/dir.c                                |  6 ++++--
 fs/bad_inode.c                              |  3 ++-
 fs/bfs/dir.c                                |  3 ++-
 fs/btrfs/inode.c                            |  3 ++-
 fs/ceph/dir.c                               |  3 ++-
 fs/cifs/cifsfs.h                            |  2 +-
 fs/cifs/inode.c                             |  3 ++-
 fs/coda/dir.c                               |  8 +++++---
 fs/debugfs/inode.c                          |  2 +-
 fs/ecryptfs/inode.c                         |  3 ++-
 fs/exofs/namei.c                            |  3 ++-
 fs/ext2/namei.c                             |  5 +++--
 fs/ext3/namei.c                             |  5 +++--
 fs/ext4/namei.c                             |  9 ++++-----
 fs/ext4/super.c                             |  6 +++---
 fs/f2fs/namei.c                             |  3 ++-
 fs/fat/namei_msdos.c                        |  3 ++-
 fs/fat/namei_vfat.c                         |  3 ++-
 fs/fuse/dir.c                               |  3 ++-
 fs/gfs2/inode.c                             |  3 ++-
 fs/hfs/dir.c                                |  3 ++-
 fs/hfsplus/dir.c                            |  3 ++-
 fs/hostfs/hostfs_kern.c                     |  3 ++-
 fs/hpfs/namei.c                             |  3 ++-
 fs/jffs2/dir.c                              |  5 +++--
 fs/jfs/namei.c                              |  3 ++-
 fs/kernfs/dir.c                             |  3 ++-
 fs/libfs.c                                  |  3 ++-
 fs/logfs/dir.c                              |  3 ++-
 fs/minix/namei.c                            |  5 +++--
 fs/namei.c                                  | 11 +++--------
 fs/ncpfs/dir.c                              |  5 +++--
 fs/nfs/dir.c                                |  3 ++-
 fs/nfs/internal.h                           |  3 ++-
 fs/nilfs2/namei.c                           |  3 ++-
 fs/ocfs2/namei.c                            |  3 ++-
 fs/omfs/dir.c                               |  3 ++-
 fs/reiserfs/namei.c                         |  3 ++-
 fs/sysv/namei.c                             |  5 +++--
 fs/ubifs/dir.c                              |  3 ++-
 fs/udf/namei.c                              |  3 ++-
 fs/ufs/namei.c                              |  3 ++-
 fs/xfs/xfs_iops.c                           |  3 ++-
 include/linux/fs.h                          |  5 ++---
 kernel/cgroup.c                             |  5 +++--
 mm/shmem.c                                  |  2 +-
 53 files changed, 119 insertions(+), 87 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index f424e0e5b46b..3bbd4140a150 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -46,8 +46,6 @@ prototypes:
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
-	int (*rename2) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
@@ -80,7 +78,6 @@ mkdir:		yes
 unlink:		yes (both)
 rmdir:		yes (both)	(see below)
 rename:		yes (all)	(see below)
-rename2:	yes (all)	(see below)
 readlink:	no
 follow_link:	no
 put_link:	no
@@ -99,8 +96,7 @@ tmpfile:	no
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
-	cross-directory ->rename() and rename2() has (per-superblock)
-->s_vfs_rename_sem.
+	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
 
 See Documentation/filesystems/directory-locking for more detailed discussion
 of the locking scheme for directory operations.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 94eb86287bcb..88a32804b9e9 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -346,8 +346,6 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
-	int (*rename2) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
         void * (*follow_link) (struct dentry *, struct nameidata *);
@@ -415,10 +413,8 @@ otherwise noted.
 
   rename: called by the rename(2) system call to rename the object to
 	have the parent and name given by the second inode and dentry.
-
-  rename2: this has an additional flags argument compared to rename.
-	If no flags are supported by the filesystem then this method
-	need not be implemented.  If some flags are supported then the
+	If the filesystem supports some flags (fifth argument), then
+	it needs to set FS_RENAME_FLAGS in the filesystem type.  The
 	filesystem must return -EINVAL for any unsupported or unknown
 	flags.  Currently the following flags are implemented:
 	(1) RENAME_NOREPLACE: this flag indicates that if the target
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index fc8d264f6c9a..0191e7d9482e 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -1215,7 +1215,8 @@ static int ll_link(struct dentry *old_dentry, struct inode *dir,
 }
 
 static int ll_rename(struct inode *old_dir, struct dentry *old_dentry,
-		     struct inode *new_dir, struct dentry *new_dentry)
+		     struct inode *new_dir, struct dentry *new_dentry,
+		     unsigned int flags)
 {
 	int err;
 	err = ll_rename_generic(old_dir, NULL,
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 099c7712631c..6433da41fdc9 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -149,7 +149,8 @@ extern struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 extern int v9fs_vfs_unlink(struct inode *i, struct dentry *d);
 extern int v9fs_vfs_rmdir(struct inode *i, struct dentry *d);
 extern int v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry);
+			   struct inode *new_dir, struct dentry *new_dentry,
+			   unsigned int flags);
 extern void v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd,
 			void *p);
 extern struct inode *v9fs_inode_from_fid(struct v9fs_session_info *v9ses,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index bb7991c7e5c7..b67d47bf6f8f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -951,12 +951,14 @@ int v9fs_vfs_rmdir(struct inode *i, struct dentry *d)
  * @old_dentry: old dentry
  * @new_dir: new dir inode
  * @new_dentry: new dentry
+ * @flags: rename flags
  *
  */
 
 int
 v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		struct inode *new_dir, struct dentry *new_dentry,
+		unsigned int flags)
 {
 	int retval;
 	struct inode *old_inode;
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 3952121f2f28..badf97e81250 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -163,7 +163,8 @@ extern int	affs_link(struct dentry *olddentry, struct inode *dir,
 extern int	affs_symlink(struct inode *dir, struct dentry *dentry,
 			     const char *symname);
 extern int	affs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry);
+			    struct inode *new_dir, struct dentry *new_dentry,
+			    unsigned int flags);
 
 /* inode.c */
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index c36cbb4537a2..56ba5ee23514 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -401,7 +401,8 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 
 int
 affs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	    struct inode *new_dir, struct dentry *new_dentry)
+	    struct inode *new_dir, struct dentry *new_dentry,
+	    unsigned int flags)
 {
 	struct super_block *sb = old_dir->i_sb;
 	struct buffer_head *bh = NULL;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 529300327f45..09a27fa2f995 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -38,7 +38,8 @@ static int afs_link(struct dentry *from, struct inode *dir,
 static int afs_symlink(struct inode *dir, struct dentry *dentry,
 		       const char *content);
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry);
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags);
 
 const struct file_operations afs_dir_file_operations = {
 	.open		= afs_dir_open,
@@ -1088,7 +1089,8 @@ error:
  * rename a file in an AFS filesystem and/or move it between directories
  */
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct afs_vnode *orig_dvnode, *new_dvnode, *vnode;
 	struct key *key;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 7c93953030fb..02673d57ceda 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -219,7 +219,8 @@ static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
 }
 
 static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags)
 {
 	return -EIO;
 }
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index a399e6d9dc74..3ae986541dcd 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -209,7 +209,8 @@ out_brelse:
 }
 
 static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c4ab9c18940..d68f292e15dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8179,7 +8179,8 @@ static int btrfs_getattr(struct vfsmount *mnt,
 }
 
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(old_dir)->root;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6da4df84ba30..80b827da02c1 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -883,7 +883,8 @@ out:
 }
 
 static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(old_dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 26a754f49ba1..b9e81af57e46 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -61,7 +61,7 @@ extern int cifs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 extern int cifs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int cifs_rmdir(struct inode *, struct dentry *);
 extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
-		       struct dentry *);
+		       struct dentry *, unsigned int);
 extern int cifs_revalidate_file_attr(struct file *filp);
 extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9cb9679d7357..7aed67deefb1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1619,7 +1619,8 @@ do_rename_exit:
 
 int
 cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
-	    struct inode *target_dir, struct dentry *target_dentry)
+	    struct inode *target_dir, struct dentry *target_dentry,
+	    unsigned int flags)
 {
 	char *from_name = NULL;
 	char *to_name = NULL;
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 5efbb5ee0adc..73f4d2b97b4d 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -39,8 +39,9 @@ static int coda_symlink(struct inode *dir_inode, struct dentry *entry,
 			const char *symname);
 static int coda_mkdir(struct inode *dir_inode, struct dentry *entry, umode_t mode);
 static int coda_rmdir(struct inode *dir_inode, struct dentry *entry);
-static int coda_rename(struct inode *old_inode, struct dentry *old_dentry, 
-                       struct inode *new_inode, struct dentry *new_dentry);
+static int coda_rename(struct inode *old_inode, struct dentry *old_dentry,
+		       struct inode *new_inode, struct dentry *new_dentry,
+		       unsigned int flags);
 
 /* dir file-ops */
 static int coda_readdir(struct file *file, struct dir_context *ctx);
@@ -347,7 +348,8 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 
 /* rename */
 static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	const char *old_name = old_dentry->d_name.name;
 	const char *new_name = new_dentry->d_name.name;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 9c0444cccbe1..70fc09be0ffd 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -618,7 +618,7 @@ struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
 	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
 
 	error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
-		dentry);
+			      dentry, 0);
 	if (error) {
 		fsnotify_oldname_free(old_name);
 		goto exit;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index d4a9431ec73c..d35675fda228 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -611,7 +611,8 @@ out:
 
 static int
 ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		struct inode *new_dir, struct dentry *new_dentry,
+		unsigned int flags)
 {
 	int rc;
 	struct dentry *lower_old_dentry;
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 4731fd991efe..bc120ed5f566 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -228,7 +228,8 @@ static int exofs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 static int exofs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index c268d0af1db9..24b24c1f6560 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -320,8 +320,9 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
-	struct inode * new_dir,	struct dentry * new_dentry )
+static int ext2_rename(struct inode *old_dir, struct dentry *old_dentry,
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct inode * old_inode = old_dentry->d_inode;
 	struct inode * new_inode = new_dentry->d_inode;
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f197736dccfa..b1633143bd74 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2375,8 +2375,9 @@ retry:
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
-			   struct inode * new_dir,struct dentry *new_dentry)
+static int ext3_rename(struct inode *old_dir, struct dentry *old_dentry,
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	handle_t *handle;
 	struct inode * old_inode, * new_inode;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb84f78909e..6f1ee2140ee5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3156,8 +3156,8 @@ static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
  * while new_{dentry,inode) refers to the destination dentry/inode
  * This comes from rename(const char *oldpath, const char *newpath)
  */
-static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+static int ext4_plain_rename(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry)
 {
 	handle_t *handle = NULL;
 	struct ext4_renament old = {
@@ -3403,7 +3403,7 @@ end_rename:
 	return retval;
 }
 
-static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
+static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
 {
@@ -3418,7 +3418,7 @@ static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
 	 * Existence checking was done by the VFS, otherwise "RENAME_NOREPLACE"
 	 * is equivalent to regular rename.
 	 */
-	return ext4_rename(old_dir, old_dentry, new_dir, new_dentry);
+	return ext4_plain_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
 /*
@@ -3435,7 +3435,6 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.mknod		= ext4_mknod,
 	.tmpfile	= ext4_tmpfile,
 	.rename		= ext4_rename,
-	.rename2	= ext4_rename2,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1f7784de05b6..9a380ed56495 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -90,7 +90,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_RENAME_FLAGS,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
@@ -106,7 +106,7 @@ static struct file_system_type ext3_fs_type = {
 	.name		= "ext3",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_RENAME_FLAGS,
 };
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
@@ -5432,7 +5432,7 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_RENAME_FLAGS,
 };
 MODULE_ALIAS_FS("ext4");
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 397d459e97bf..a8627157d49d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -374,7 +374,8 @@ out:
 }
 
 static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct super_block *sb = old_dir->i_sb;
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index a783b0e1272a..1bd1ece2f752 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -598,7 +598,8 @@ error_inode:
 
 /***** Rename, a wrapper for rename_same_dir & rename_diff_dir */
 static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct super_block *sb = old_dir->i_sb;
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d885e5..87ab4e09821f 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -903,7 +903,8 @@ out:
 }
 
 static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct buffer_head *dotdot_bh;
 	struct msdos_dir_entry *dotdot_de;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 1d1292c581c3..954f08fd9e72 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -744,7 +744,8 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 }
 
 static int fuse_rename(struct inode *olddir, struct dentry *oldent,
-		       struct inode *newdir, struct dentry *newent)
+		       struct inode *newdir, struct dentry *newent,
+		       unsigned int flags)
 {
 	int err;
 	struct fuse_rename_in inarg;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5c524180c98e..fb9dbae2a985 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1288,7 +1288,8 @@ static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
  */
 
 static int gfs2_rename(struct inode *odir, struct dentry *odentry,
-		       struct inode *ndir, struct dentry *ndentry)
+		       struct inode *ndir, struct dentry *ndentry,
+		       unsigned int flags)
 {
 	struct gfs2_inode *odip = GFS2_I(odir);
 	struct gfs2_inode *ndip = GFS2_I(ndir);
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 145566851e7a..3205d4496471 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -280,7 +280,8 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
  * XXX: how do you handle must_be dir?
  */
 static int hfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	int res;
 
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index bdec66522de3..80cb1fcc83aa 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -494,7 +494,8 @@ static int hfsplus_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 }
 
 static int hfsplus_rename(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+			  struct inode *new_dir, struct dentry *new_dentry,
+			  unsigned int flags)
 {
 	int res;
 
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index fe649d325b1f..03ffa2505248 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -742,7 +742,8 @@ static int hostfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 }
 
 static int hostfs_rename(struct inode *from_ino, struct dentry *from,
-			 struct inode *to_ino, struct dentry *to)
+			 struct inode *to_ino, struct dentry *to,
+			 unsigned int flags)
 {
 	char *from_name, *to_name;
 	int err;
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 1b39afdd86fd..4e2fd3ea59a6 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -516,7 +516,8 @@ const struct address_space_operations hpfs_symlink_aops = {
 };
 	
 static int hpfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	const unsigned char *old_name = old_dentry->d_name.name;
 	unsigned old_len = old_dentry->d_name.len;
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 938556025d64..eb6855ddbb72 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -35,7 +35,7 @@ static int jffs2_mkdir (struct inode *,struct dentry *,umode_t);
 static int jffs2_rmdir (struct inode *,struct dentry *);
 static int jffs2_mknod (struct inode *,struct dentry *,umode_t,dev_t);
 static int jffs2_rename (struct inode *, struct dentry *,
-			 struct inode *, struct dentry *);
+			 struct inode *, struct dentry *, unsigned int);
 
 const struct file_operations jffs2_dir_operations =
 {
@@ -757,7 +757,8 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, umode_t mode
 }
 
 static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
-			 struct inode *new_dir_i, struct dentry *new_dentry)
+			 struct inode *new_dir_i, struct dentry *new_dentry,
+			 unsigned int flags)
 {
 	int ret;
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(old_dir_i->i_sb);
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index d59c7defb1ef..005ebea78a2e 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1062,7 +1062,8 @@ static int jfs_symlink(struct inode *dip, struct dentry *dentry,
  * FUNCTION:	rename a file or directory
  */
 static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct btstack btstack;
 	ino_t ino;
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5d25c5..451e2cd9bc16 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -744,7 +744,8 @@ static int kernfs_iop_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
-			     struct inode *new_dir, struct dentry *new_dentry)
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags)
 {
 	struct kernfs_node *kn  = old_dentry->d_fsdata;
 	struct kernfs_node *new_parent = new_dir->i_private;
diff --git a/fs/libfs.c b/fs/libfs.c
index a1844244246f..b32dad65f350 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -325,7 +325,8 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 EXPORT_SYMBOL(simple_rmdir);
 
 int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		  struct inode *new_dir, struct dentry *new_dentry,
+		  unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 6bdc347008f5..ce1ed61305f6 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -717,7 +717,8 @@ out:
 }
 
 static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	if (new_dentry->d_inode)
 		return logfs_rename_target(old_dir, old_dentry,
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index cd950e2331b6..e4bdbb3edf00 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -184,8 +184,9 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
-			   struct inode * new_dir, struct dentry *new_dentry)
+static int minix_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct inode * old_inode = old_dentry->d_inode;
 	struct inode * new_inode = new_dentry->d_inode;
diff --git a/fs/namei.c b/fs/namei.c
index 50b0ca3dddc3..75e6ff6be70b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4030,7 +4030,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!old_dir->i_op->rename)
 		return -EPERM;
 
-	if (flags && !old_dir->i_op->rename2)
+	if (flags && !(old_dir->i_sb->s_type->fs_flags & FS_RENAME_FLAGS))
 		return -EINVAL;
 
 	/*
@@ -4086,13 +4086,8 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (error)
 			goto out;
 	}
-	if (!flags) {
-		error = old_dir->i_op->rename(old_dir, old_dentry,
-					      new_dir, new_dentry);
-	} else {
-		error = old_dir->i_op->rename2(old_dir, old_dentry,
-					       new_dir, new_dentry, flags);
-	}
+	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry,
+				      flags);
 	if (error)
 		goto out;
 
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index c320ac52353e..bcbd159c86ba 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -36,7 +36,7 @@ static int ncp_unlink(struct inode *, struct dentry *);
 static int ncp_mkdir(struct inode *, struct dentry *, umode_t);
 static int ncp_rmdir(struct inode *, struct dentry *);
 static int ncp_rename(struct inode *, struct dentry *,
-	  	      struct inode *, struct dentry *);
+		      struct inode *, struct dentry *, unsigned int);
 static int ncp_mknod(struct inode * dir, struct dentry *dentry,
 		     umode_t mode, dev_t rdev);
 #if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
@@ -1113,7 +1113,8 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct ncp_server *server = NCP_SERVER(old_dir);
 	int error;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index be38b573495a..ed335994569a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1901,7 +1901,8 @@ EXPORT_SYMBOL_GPL(nfs_link);
  * the rename.
  */
 int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+	       struct inode *new_dir, struct dentry *new_dentry,
+	       unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 8b5cc04a8611..a2e287eb6b7d 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -303,7 +303,8 @@ int nfs_unlink(struct inode *, struct dentry *);
 int nfs_symlink(struct inode *, struct dentry *, const char *);
 int nfs_link(struct dentry *, struct inode *, struct dentry *);
 int nfs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
-int nfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+int nfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *,
+	       unsigned int);
 
 /* file.c */
 int nfs_file_fsync_commit(struct file *, loff_t, loff_t, int);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9de78f08989e..33c474cf61cc 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -347,7 +347,8 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir,	struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4d609be9400..d8837e37b9dd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1058,7 +1058,8 @@ static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2)
 static int ocfs2_rename(struct inode *old_dir,
 			struct dentry *old_dentry,
 			struct inode *new_dir,
-			struct dentry *new_dentry)
+			struct dentry *new_dentry,
+			unsigned int flags)
 {
 	int status = 0, rename_lock = 0, parents_locked = 0, target_exists = 0;
 	int old_child_locked = 0, new_child_locked = 0, update_dot_dot = 0;
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 1b8e9e8405b2..b0df602aeeea 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -371,7 +371,8 @@ static bool omfs_fill_chain(struct inode *dir, struct dir_context *ctx,
 }
 
 static int omfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct inode *new_inode = new_dentry->d_inode;
 	struct inode *old_inode = old_dentry->d_inode;
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index e825f8b63e6b..361e3f36c32d 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1202,7 +1202,8 @@ static void set_ino_in_dir_entry(struct reiserfs_dir_entry *de,
  * get_empty_nodes or its clones
  */
 static int reiserfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+			   struct inode *new_dir, struct dentry *new_dentry,
+			   unsigned int flags)
 {
 	int retval;
 	INITIALIZE_PATH(old_entry_path);
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 731b2bbcaab3..34000fa0c9bd 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -205,8 +205,9 @@ static int sysv_rmdir(struct inode * dir, struct dentry * dentry)
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
-		  struct inode * new_dir, struct dentry * new_dentry)
+static int sysv_rename(struct inode *old_dir, struct dentry *old_dentry,
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct inode * old_inode = old_dentry->d_inode;
 	struct inode * new_inode = new_dentry->d_inode;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ea41649e4ca5..d47373e5438a 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -950,7 +950,8 @@ static void unlock_3_inodes(struct inode *inode1, struct inode *inode2,
 }
 
 static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct ubifs_info *c = old_dir->i_sb->s_fs_info;
 	struct inode *old_inode = old_dentry->d_inode;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 9737cba1357d..6a16d2e4c823 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1079,7 +1079,8 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
  * higher-level routines.
  */
 static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 90d74b8f8eba..85f5be154e8a 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -259,7 +259,8 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 }
 
 static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f35d5c953ff9..d79bcda51fc9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -349,7 +349,8 @@ xfs_vn_rename(
 	struct inode	*odir,
 	struct dentry	*odentry,
 	struct inode	*ndir,
-	struct dentry	*ndentry)
+	struct dentry	*ndentry,
+	unsigned int	flags)
 {
 	struct inode	*new_inode = ndentry->d_inode;
 	struct xfs_name	oname;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4fbdfae87410..23b47e4d9fd9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1566,8 +1566,6 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
-	int (*rename2) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
@@ -1819,6 +1817,7 @@ struct file_system_type {
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
+#define FS_RENAME_FLAGS		(1 << 16) /* ->rename supports flag(s) */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
@@ -2615,7 +2614,7 @@ extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
-extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, unsigned int);
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2f46ba37f72..66426304d2f6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2439,7 +2439,8 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
  * cgroup_rename - Only allow simple rename of directories in place.
  */
 static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
+			 struct inode *new_dir, struct dentry *new_dentry,
+			 unsigned int flags)
 {
 	int ret;
 	struct cgroup_name *name, *old_name;
@@ -2471,7 +2472,7 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!name)
 		return -ENOMEM;
 
-	ret = simple_rename(old_dir, old_dentry, new_dir, new_dentry);
+	ret = simple_rename(old_dir, old_dentry, new_dir, new_dentry, 0);
 	if (ret) {
 		kfree(name);
 		return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index 1f18c9d0d93e..d92d2d61e8b2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2053,7 +2053,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
  * it exists so that the VFS layer correctly free's it when it
  * gets overwritten.
  */
-static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
-- 
1.8.1.4

