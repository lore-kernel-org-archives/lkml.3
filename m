Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaAHWKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:10:00 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36447 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaAHWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:09:50 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 04/11] vfs: add renameat2 syscall
Date: Wed,  8 Jan 2014 23:10:08 +0100
Message-Id: <1389219015-10980-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add new renameat2 syscall, which is the same as renameat with an added
flags argument.

Pass flags to vfs_rename() and to i_op->rename() as well.

All filesystems check flags and return -EOPNOTSUPP for unsupported flags.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking                  |  2 +-
 Documentation/filesystems/vfs.txt                  |  4 +++-
 arch/x86/syscalls/syscall_64.tbl                   |  1 +
 .../lustre/lustre/include/linux/lustre_compat25.h  |  4 ++--
 drivers/staging/lustre/lustre/llite/namei.c        |  7 +++++-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |  2 +-
 fs/9p/v9fs.h                                       |  3 ++-
 fs/9p/vfs_inode.c                                  |  7 +++++-
 fs/affs/affs.h                                     |  3 ++-
 fs/affs/namei.c                                    |  6 ++++-
 fs/afs/dir.c                                       |  9 ++++++--
 fs/bad_inode.c                                     |  3 ++-
 fs/bfs/dir.c                                       |  6 ++++-
 fs/btrfs/inode.c                                   |  6 ++++-
 fs/cachefiles/namei.c                              |  2 +-
 fs/ceph/dir.c                                      |  6 ++++-
 fs/cifs/cifsfs.h                                   |  2 +-
 fs/cifs/inode.c                                    |  6 ++++-
 fs/coda/dir.c                                      | 11 ++++++---
 fs/debugfs/inode.c                                 |  2 +-
 fs/ecryptfs/inode.c                                |  8 +++++--
 fs/exofs/namei.c                                   |  6 ++++-
 fs/ext2/namei.c                                    |  8 +++++--
 fs/ext3/namei.c                                    |  8 +++++--
 fs/ext4/namei.c                                    |  6 ++++-
 fs/f2fs/namei.c                                    |  6 ++++-
 fs/fat/namei_msdos.c                               |  6 ++++-
 fs/fat/namei_vfat.c                                |  6 ++++-
 fs/fuse/dir.c                                      |  9 ++++++--
 fs/gfs2/inode.c                                    |  6 ++++-
 fs/hfs/dir.c                                       |  6 ++++-
 fs/hfsplus/dir.c                                   |  6 ++++-
 fs/hostfs/hostfs_kern.c                            |  8 +++++--
 fs/hpfs/namei.c                                    |  6 ++++-
 fs/jffs2/dir.c                                     |  8 +++++--
 fs/jfs/namei.c                                     |  5 ++++-
 fs/libfs.c                                         |  6 ++++-
 fs/logfs/dir.c                                     |  6 ++++-
 fs/minix/namei.c                                   |  8 +++++--
 fs/namei.c                                         | 26 ++++++++++++++++------
 fs/ncpfs/dir.c                                     |  8 +++++--
 fs/nfs/dir.c                                       |  6 ++++-
 fs/nfs/internal.h                                  |  3 ++-
 fs/nfsd/vfs.c                                      |  2 +-
 fs/nilfs2/namei.c                                  |  6 ++++-
 fs/ocfs2/namei.c                                   |  6 ++++-
 fs/omfs/dir.c                                      |  6 ++++-
 fs/reiserfs/namei.c                                |  6 ++++-
 fs/sysv/namei.c                                    |  8 +++++--
 fs/ubifs/dir.c                                     |  6 ++++-
 fs/udf/namei.c                                     |  6 ++++-
 fs/ufs/namei.c                                     |  6 ++++-
 fs/xfs/xfs_iops.c                                  |  6 ++++-
 include/linux/fs.h                                 |  6 ++---
 kernel/cgroup.c                                    |  8 +++++--
 mm/shmem.c                                         |  5 ++++-
 56 files changed, 263 insertions(+), 77 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fe7afe225381..70e800c3d54b 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -46,7 +46,7 @@ prototypes:
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
+		       struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index deb48b5fd883..96ac6ab6357c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -346,7 +346,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
+		       struct inode *, struct dentry *, unsigned int);
 	int (*readlink) (struct dentry *, char __user *,int);
         void * (*follow_link) (struct dentry *, struct nameidata *);
         void (*put_link) (struct dentry *, struct nameidata *, void *);
@@ -413,6 +413,8 @@ otherwise noted.
 
   rename: called by the rename(2) system call to rename the object to
 	have the parent and name given by the second inode and dentry.
+	If a flag (passed as the fifth argument) is not supported by
+	the filesystem, the rename method should return -EOPNOTSUPP.
 
   readlink: called by the readlink(2) system call. Only required if
 	you want to support reading symbolic links
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65dfd14f..fafd73440655 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	renameat2		sys_renameat2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index eefdb8d061b1..81cc7a0134bb 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -105,8 +105,8 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define ll_vfs_unlink(inode,entry,mnt)	  vfs_unlink(inode,entry)
 #define ll_vfs_mknod(dir,entry,mnt,mode,dev)    vfs_mknod(dir,entry,mode,dev)
 #define ll_security_inode_unlink(dir,entry,mnt) security_inode_unlink(dir,entry)
-#define ll_vfs_rename(old,old_dir,mnt,new,new_dir,mnt1,delegated_inode) \
-		vfs_rename(old,old_dir,new,new_dir,delegated_inode)
+#define ll_vfs_rename(old, old_dir, mnt, new, new_dir, mnt1) \
+		vfs_rename(old, old_dir, new, new_dir, NULL, 0)
 
 #define cfs_bio_io_error(a,b)   bio_io_error((a))
 #define cfs_bio_endio(a,b,c)    bio_endio((a),(c))
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 90bbdae824ac..cd24e469cc9a 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -1215,9 +1215,14 @@ static int ll_link(struct dentry *old_dentry, struct inode *dir,
 }
 
 static int ll_rename(struct inode *old_dir, struct dentry *old_dentry,
-		     struct inode *new_dir, struct dentry *new_dentry)
+		     struct inode *new_dir, struct dentry *new_dentry,
+		     unsigned int flags)
 {
 	int err;
+
+	if (flags)
+		return -EOPNOTSUPP;
+
 	err = ll_rename_generic(old_dir, NULL,
 				 old_dentry, &old_dentry->d_name,
 				 new_dir, NULL, new_dentry,
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 09474e7553dd..1ef06fea793b 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -224,7 +224,7 @@ int lustre_rename(struct dentry *dir, struct vfsmount *mnt,
 		GOTO(put_old, err = PTR_ERR(dchild_new));
 
 	err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
-			    dir->d_inode, dchild_new, mnt, NULL);
+			    dir->d_inode, dchild_new, mnt);
 
 	dput(dchild_new);
 put_old:
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a8e127c89627..5d347d10cf55 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -148,7 +148,8 @@ extern struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
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
index 4e65aa903345..6a75edabc645 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -945,12 +945,14 @@ int v9fs_vfs_rmdir(struct inode *i, struct dentry *d)
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
@@ -961,6 +963,9 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct p9_fid *newdirfid;
 	struct p9_wstat wstat;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	p9_debug(P9_DEBUG_VFS, "\n");
 	retval = 0;
 	old_inode = old_dentry->d_inode;
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
index c36cbb4537a2..4f958db92333 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -401,12 +401,16 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 
 int
 affs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	    struct inode *new_dir, struct dentry *new_dentry)
+	    struct inode *new_dir, struct dentry *new_dentry,
+	    unsigned int flags)
 {
 	struct super_block *sb = old_dir->i_sb;
 	struct buffer_head *bh = NULL;
 	int retval;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	pr_debug("AFFS: rename(old=%u,\"%*s\" to new=%u,\"%*s\")\n",
 		 (u32)old_dir->i_ino, (int)old_dentry->d_name.len, old_dentry->d_name.name,
 		 (u32)new_dir->i_ino, (int)new_dentry->d_name.len, new_dentry->d_name.name);
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 529300327f45..ccdd551a0766 100644
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
@@ -1088,12 +1089,16 @@ error:
  * rename a file in an AFS filesystem and/or move it between directories
  */
 static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct afs_vnode *orig_dvnode, *new_dvnode, *vnode;
 	struct key *key;
 	int ret;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	vnode = AFS_FS_I(old_dentry->d_inode);
 	orig_dvnode = AFS_FS_I(old_dir);
 	new_dvnode = AFS_FS_I(new_dir);
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
index a399e6d9dc74..41529673fd42 100644
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
@@ -217,6 +218,9 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct bfs_sb_info *info;
 	int error = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_bh = new_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	if (S_ISDIR(old_inode->i_mode))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a77449d032..884cf012da09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7982,7 +7982,8 @@ static int btrfs_getattr(struct vfsmount *mnt,
 }
 
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(old_dir)->root;
@@ -7995,6 +7996,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int ret;
 	u64 old_ino = btrfs_ino(old_inode);
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index ca65f39dc8dc..31088a969351 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -396,7 +396,7 @@ try_again:
 		cachefiles_io_error(cache, "Rename security error %d", ret);
 	} else {
 		ret = vfs_rename(dir->d_inode, rep,
-				 cache->graveyard->d_inode, grave, NULL);
+				 cache->graveyard->d_inode, grave, NULL, 0);
 		if (ret != 0 && ret != -ENOMEM)
 			cachefiles_io_error(cache,
 					    "Rename failed with error %d", ret);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 2a0bcaeb189a..84bf7c757823 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -879,13 +879,17 @@ out:
 }
 
 static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(old_dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	int err;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (ceph_snap(old_dir) != ceph_snap(new_dir))
 		return -EXDEV;
 	if (ceph_snap(old_dir) != CEPH_NOSNAP ||
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
index 49719b8228e5..84202980a032 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1595,7 +1595,8 @@ do_rename_exit:
 
 int
 cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
-	    struct inode *target_dir, struct dentry *target_dentry)
+	    struct inode *target_dir, struct dentry *target_dentry,
+	    unsigned int flags)
 {
 	char *from_name = NULL;
 	char *to_name = NULL;
@@ -1607,6 +1608,9 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	unsigned int xid;
 	int rc, tmprc;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	cifs_sb = CIFS_SB(source_dir->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 5efbb5ee0adc..f94838543f2d 100644
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
@@ -355,6 +357,9 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int new_length = new_dentry->d_name.len;
 	int error;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	error = venus_rename(old_dir->i_sb, coda_i2f(old_dir),
 			     coda_i2f(new_dir), old_length, new_length,
 			     (const char *) old_name, (const char *)new_name);
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
index c36c44824471..0ce5a6b2ea9d 100644
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
@@ -621,6 +622,9 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *trap = NULL;
 	struct inode *target_inode;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
@@ -641,7 +645,7 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry,
-			NULL);
+			NULL, 0);
 	if (rc)
 		goto out_lock;
 	if (target_inode)
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 4731fd991efe..54db7e2192ca 100644
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
@@ -238,6 +239,9 @@ static int exofs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct exofs_dir_entry *old_de;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_de = exofs_find_entry(old_dir, old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 256dd5f4c1c4..d7da1dad9149 100644
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
@@ -331,6 +332,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct ext2_dir_entry_2 * old_de;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f8cde46de9cd..08ca534c2de4 100644
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
@@ -2384,6 +2385,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	struct ext3_dir_entry_2 * old_de, * new_de;
 	int retval, flush_file = 0;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a0408d7b114..08c40f4e7eed 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3010,7 +3010,8 @@ static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
  * This comes from rename(const char *oldpath, const char *newpath)
  */
 static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	handle_t *handle = NULL;
 	struct inode *old_inode, *new_inode;
@@ -3020,6 +3021,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int inlined = 0, new_inlined = 0;
 	struct ext4_dir_entry_2 *parent_de;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 575adac17f8b..13913085927c 100644
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
@@ -387,6 +388,9 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct f2fs_dir_entry *new_entry;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	f2fs_balance_fs(sbi);
 
 	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index a783b0e1272a..73db3d039ba7 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -598,12 +598,16 @@ error_inode:
 
 /***** Rename, a wrapper for rename_same_dir & rename_diff_dir */
 static int msdos_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	struct super_block *sb = old_dir->i_sb;
 	unsigned char old_msdos_name[MSDOS_NAME], new_msdos_name[MSDOS_NAME];
 	int err, is_hid;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&MSDOS_SB(sb)->s_lock);
 
 	err = msdos_format_name(old_dentry->d_name.name,
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d885e5..ef0fd0703c33 100644
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
@@ -914,6 +915,9 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c3eb2c46c8f1..ffe2f46aa53e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -734,13 +734,18 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 }
 
 static int fuse_rename(struct inode *olddir, struct dentry *oldent,
-		       struct inode *newdir, struct dentry *newent)
+		       struct inode *newdir, struct dentry *newent,
+		       unsigned int flags)
 {
 	int err;
 	struct fuse_rename_in inarg;
 	struct fuse_conn *fc = get_fuse_conn(olddir);
-	struct fuse_req *req = fuse_get_req_nopages(fc);
+	struct fuse_req *req;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
+	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7119504159f1..6613e214ad72 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1243,7 +1243,8 @@ static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
  */
 
 static int gfs2_rename(struct inode *odir, struct dentry *odentry,
-		       struct inode *ndir, struct dentry *ndentry)
+		       struct inode *ndir, struct dentry *ndentry,
+		       unsigned int flags)
 {
 	struct gfs2_inode *odip = GFS2_I(odir);
 	struct gfs2_inode *ndip = GFS2_I(ndir);
@@ -1258,6 +1259,9 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	unsigned int x;
 	int error;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (ndentry->d_inode) {
 		nip = GFS2_I(ndentry->d_inode);
 		if (ip == nip)
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 145566851e7a..540e8bcd331e 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -280,10 +280,14 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
  * XXX: how do you handle must_be dir?
  */
 static int hfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	int res;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/* Unlink destination if it already exists */
 	if (new_dentry->d_inode) {
 		res = hfs_remove(new_dir, new_dentry);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4a4fea002673..802dce49af35 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -494,10 +494,14 @@ static int hfsplus_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 }
 
 static int hfsplus_rename(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+			  struct inode *new_dir, struct dentry *new_dentry,
+			  unsigned int flags)
 {
 	int res;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/* Unlink destination if it already exists */
 	if (new_dentry->d_inode) {
 		if (S_ISDIR(new_dentry->d_inode->i_mode))
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index db23ce1bd903..eeeef55fdd56 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -738,12 +738,16 @@ static int hostfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
-int hostfs_rename(struct inode *from_ino, struct dentry *from,
-		  struct inode *to_ino, struct dentry *to)
+static int hostfs_rename(struct inode *from_ino, struct dentry *from,
+			 struct inode *to_ino, struct dentry *to,
+			 unsigned int flags)
 {
 	char *from_name, *to_name;
 	int err;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if ((from_name = dentry_name(from)) == NULL)
 		return -ENOMEM;
 	if ((to_name = dentry_name(to)) == NULL) {
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 1b39afdd86fd..1bec8e2b4c74 100644
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
@@ -533,6 +534,9 @@ static int hpfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct fnode *fnode;
 	int err;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if ((err = hpfs_chk_name(new_name, &new_len))) return err;
 	err = 0;
 	hpfs_adjust_length(old_name, &old_len);
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index e3aac222472e..a23da79c1ed0 100644
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
@@ -756,7 +756,8 @@ static int jffs2_mknod (struct inode *dir_i, struct dentry *dentry, umode_t mode
 }
 
 static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
-			 struct inode *new_dir_i, struct dentry *new_dentry)
+			 struct inode *new_dir_i, struct dentry *new_dentry,
+			 unsigned int flags)
 {
 	int ret;
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(old_dir_i->i_sb);
@@ -764,6 +765,9 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 	uint8_t type;
 	uint32_t now;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/* The VFS will check for us and prevent trying to rename a
 	 * file over a directory and vice versa, but if it's a directory,
 	 * the VFS can't check whether the victim is empty. The filesystem
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index aa8a3370631b..06841bcaad79 100644
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
@@ -1081,6 +1082,8 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	s64 new_size = 0;
 	int commit_flag;
 
+	if (flags)
+		return -EOPNOTSUPP;
 
 	jfs_info("jfs_rename: %s %s", old_dentry->d_name.name,
 		 new_dentry->d_name.name);
diff --git a/fs/libfs.c b/fs/libfs.c
index a1844244246f..5297352d9b73 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -325,11 +325,15 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 EXPORT_SYMBOL(simple_rmdir);
 
 int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		  struct inode *new_dir, struct dentry *new_dentry,
+		  unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 6bdc347008f5..43b32e7004ee 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -717,8 +717,12 @@ out:
 }
 
 static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (new_dentry->d_inode)
 		return logfs_rename_target(old_dir, old_dentry,
 					   new_dir, new_dentry);
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index cd950e2331b6..19eb25202c0e 100644
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
@@ -195,6 +196,9 @@ static int minix_rename(struct inode * old_dir, struct dentry *old_dentry,
 	struct minix_dir_entry * old_de;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_de = minix_find_entry(old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/namei.c b/fs/namei.c
index f32a899fc039..593673fcbfef 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3969,6 +3969,7 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
  * @new_dir:	parent of destination
  * @new_dentry:	destination
  * @delegated_inode: returns an inode needing a delegation break
+ * @flags:	rename flags
  *
  * The caller must hold multiple mutexes--see lock_rename()).
  *
@@ -4012,7 +4013,7 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
  */
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode *new_dir, struct dentry *new_dentry,
-	       struct inode **delegated_inode)
+	       struct inode **delegated_inode, unsigned int flags)
 {
 	int error;
 	bool is_dir = d_is_dir(old_dentry);
@@ -4082,7 +4083,8 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto out;
 		}
 	}
-	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry,
+				      flags);
 	if (error)
 		goto out;
 
@@ -4107,8 +4109,8 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
-		int, newdfd, const char __user *, newname)
+SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname, unsigned int, flags)
 {
 	struct dentry *old_dir, *new_dir;
 	struct dentry *old_dentry, *new_dentry;
@@ -4120,6 +4122,10 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	unsigned int lookup_flags = 0;
 	bool should_retry = false;
 	int error;
+
+	if (flags)
+		return -EOPNOTSUPP;
+
 retry:
 	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags);
 	if (IS_ERR(from)) {
@@ -4191,8 +4197,8 @@ retry_deleg:
 	if (error)
 		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry,
-				   &delegated_inode);
+			   new_dir->d_inode, new_dentry,
+			   &delegated_inode, flags);
 exit5:
 	dput(new_dentry);
 exit4:
@@ -4222,9 +4228,15 @@ exit:
 	return error;
 }
 
+SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname)
+{
+	return sys_renameat2(olddfd, oldname, newdfd, newname, 0);
+}
+
 SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
-	return sys_renameat(AT_FDCWD, oldname, AT_FDCWD, newname);
+	return sys_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
 int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen, const char *link)
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index c320ac52353e..d4bf4f42d156 100644
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
@@ -1113,13 +1113,17 @@ static int ncp_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 static int ncp_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
 {
 	struct ncp_server *server = NCP_SERVER(old_dir);
 	int error;
 	int old_len, new_len;
 	__u8 __old_name[NCP_MAXPATHLEN + 1], __new_name[NCP_MAXPATHLEN + 1];
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	DPRINTK("ncp_rename: %pd2 to %pd2\n", old_dentry, new_dentry);
 
 	ncp_age_dentry(server, old_dentry);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 812154aff981..09881925d0e6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1892,13 +1892,17 @@ EXPORT_SYMBOL_GPL(nfs_link);
  * the rename.
  */
 int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+	       struct inode *new_dir, struct dentry *new_dentry,
+	       unsigned int flags)
 {
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct dentry *dentry = NULL, *rehash = NULL;
 	int error = -EBUSY;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	dfprintk(VFS, "NFS: rename(%pd2 -> %pd2, ct=%d)\n",
 		 old_dentry, new_dentry,
 		 d_count(new_dentry));
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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7eea63cada1d..ad63df8c1807 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1866,7 +1866,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 		if (host_err)
 			goto out_dput_new;
 	}
-	host_err = vfs_rename(fdir, odentry, tdir, ndentry, NULL);
+	host_err = vfs_rename(fdir, odentry, tdir, ndentry, NULL, 0);
 	if (!host_err) {
 		host_err = commit_metadata(tfhp);
 		if (!host_err)
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9de78f08989e..6f49b9bcefc4 100644
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
@@ -358,6 +359,9 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
 	if (unlikely(err))
 		return err;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4f791f6d27d0..d117184c1eea 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1038,7 +1038,8 @@ static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2)
 static int ocfs2_rename(struct inode *old_dir,
 			struct dentry *old_dentry,
 			struct inode *new_dir,
-			struct dentry *new_dentry)
+			struct dentry *new_dentry,
+			unsigned int flags)
 {
 	int status = 0, rename_lock = 0, parents_locked = 0, target_exists = 0;
 	int old_child_locked = 0, new_child_locked = 0, update_dot_dot = 0;
@@ -1062,6 +1063,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/* At some point it might be nice to break this function up a
 	 * bit. */
 
diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 1b8e9e8405b2..15e821af0c80 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -371,12 +371,16 @@ static bool omfs_fill_chain(struct inode *dir, struct dir_context *ctx,
 }
 
 static int omfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+		       struct inode *new_dir, struct dentry *new_dentry,
+		       unsigned int flags)
 {
 	struct inode *new_inode = new_dentry->d_inode;
 	struct inode *old_inode = old_dentry->d_inode;
 	int err;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (new_inode) {
 		/* overwriting existing file/dir */
 		err = omfs_remove(new_dir, new_dentry);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index dc5236f6de1b..e6d6a9cbb171 100644
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
@@ -1217,6 +1218,9 @@ static int reiserfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	unsigned long savelink = 1;
 	struct timespec ctime;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/* three balancings: (1) old name removal, (2) new name insertion
 	   and (3) maybe "save" link insertion
 	   stat data updates: (1) old directory,
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 731b2bbcaab3..b8811197c529 100644
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
@@ -216,6 +217,9 @@ static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
 	struct sysv_dir_entry * old_de;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_de = sysv_find_entry(old_dentry, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ea41649e4ca5..49d815460bb9 100644
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
@@ -968,6 +969,9 @@ static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct timespec time;
 	unsigned int uninitialized_var(saved_nlink);
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing
 	 * the old inode, and changing old and new parent directory inodes.
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 5f6fc17d6bc5..fd33cc096fda 100644
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
@@ -1091,6 +1092,9 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
 	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 90d74b8f8eba..73ce50ee9e85 100644
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
@@ -269,6 +270,9 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ufs_dir_entry *old_de;
 	int err = -ENOENT;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	old_de = ufs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_de)
 		goto out;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 104455b8046c..9a6f9666bf25 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -346,12 +346,16 @@ xfs_vn_rename(
 	struct inode	*odir,
 	struct dentry	*odentry,
 	struct inode	*ndir,
-	struct dentry	*ndentry)
+	struct dentry	*ndentry,
+	unsigned int	flags)
 {
 	struct inode	*new_inode = ndentry->d_inode;
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	xfs_dentry_to_name(&oname, odentry, 0);
 	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f001c0..6a1cee720e54 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1456,7 +1456,7 @@ extern int vfs_symlink(struct inode *, struct dentry *, const char *);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
-extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **);
+extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 
 /*
  * VFS dentry helper functions.
@@ -1566,7 +1566,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *);
+		       struct inode *, struct dentry *, unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@ -2612,7 +2612,7 @@ extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
-extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, unsigned int);
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bc1dcabe9217..383ad2248d6c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2510,12 +2510,16 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
  * cgroup_rename - Only allow simple rename of directories in place.
  */
 static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
+			 struct inode *new_dir, struct dentry *new_dentry,
+			 unsigned int flags)
 {
 	int ret;
 	struct cgroup_name *name, *old_name;
 	struct cgroup *cgrp;
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	/*
 	 * It's convinient to use parent dir's i_mutex to protected
 	 * cgrp->name.
@@ -2542,7 +2546,7 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!name)
 		return -ENOMEM;
 
-	ret = simple_rename(old_dir, old_dentry, new_dir, new_dentry);
+	ret = simple_rename(old_dir, old_dentry, new_dir, new_dentry, 0);
 	if (ret) {
 		kfree(name);
 		return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index 902a14842b74..094f47f5c014 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2067,11 +2067,14 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
  * it exists so that the VFS layer correctly free's it when it
  * gets overwritten.
  */
-static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 
+	if (flags)
+		return -EOPNOTSUPP;
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
-- 
1.8.1.4

