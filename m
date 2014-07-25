Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847AbaGYRj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934560AbaGYRiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:38:13 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 1/5] fs: xstat system call VFS bits
Date: Fri, 25 Jul 2014 12:38:04 -0500
Message-Id: <1406309888-10749-2-git-send-email-adas@redhat.com>
In-Reply-To: <1406309888-10749-1-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the VFS bits of the xstat patchset by David
Howells. The xgetdents syscall uses this to obtain stat
information for directory entries.

Signed-off-by: Abhi Das <adas@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl |   2 +
 arch/x86/syscalls/syscall_64.tbl |   2 +
 fs/stat.c                        | 338 ++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h               |   4 +
 include/linux/stat.h             |  14 +-
 include/linux/syscalls.h         |   5 +
 include/uapi/linux/fcntl.h       |   1 +
 include/uapi/linux/stat.h        | 110 +++++++++++++
 8 files changed, 453 insertions(+), 23 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index d6b8679..6d6ca37 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -360,3 +360,5 @@
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
 353	i386	renameat2		sys_renameat2
+354	i386	xstat			sys_xstat
+355	i386	fxstat			sys_fxstat
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1..1308ee3 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,8 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common 	xstat			sys_xstat
+318	common 	fxstat			sys_fxstat
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/stat.c b/fs/stat.c
index ae0c3ce..1fd0b3e 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -18,8 +18,20 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
+/**
+ * generic_fillattr - Fill in the basic attributes from the inode struct
+ * @inode: Inode to use as the source
+ * @stat: Where to fill in the attributes
+ *
+ * Fill in the basic attributes in the kstat structure from data that's to be
+ * found on the VFS inode structure.  This is the default if no getattr inode
+ * operation is supplied.
+ */
 void generic_fillattr(struct inode *inode, struct kstat *stat)
 {
+	struct super_block *sb = inode->i_sb;
+	u32 x;
+
 	stat->dev = inode->i_sb->s_dev;
 	stat->ino = inode->i_ino;
 	stat->mode = inode->i_mode;
@@ -27,14 +39,38 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->uid = inode->i_uid;
 	stat->gid = inode->i_gid;
 	stat->rdev = inode->i_rdev;
-	stat->size = i_size_read(inode);
-	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->blksize = (1 << inode->i_blkbits);
+	stat->size = i_size_read(inode);
 	stat->blocks = inode->i_blocks;
-}
+	stat->blksize = (1 << inode->i_blkbits);
 
+	stat->result_mask |= XSTAT_BASIC_STATS & ~XSTAT_RDEV;
+	if (IS_NOATIME(inode))
+		stat->result_mask &= ~XSTAT_ATIME;
+	else
+		stat->atime = inode->i_atime;
+
+	if (S_ISREG(stat->mode) && stat->nlink == 0)
+		stat->information |= XSTAT_INFO_TEMPORARY;
+	if (IS_AUTOMOUNT(inode))
+		stat->information |= XSTAT_INFO_AUTOMOUNT;
+	if (IS_POSIXACL(inode))
+		stat->information |= XSTAT_INFO_HAS_ACL;
+
+	/* if unset, assume 1s granularity */
+	stat->tv_granularity = sb->s_time_gran ?: 1000000000U;
+
+	if (unlikely(S_ISBLK(stat->mode) || S_ISCHR(stat->mode)))
+		stat->result_mask |= XSTAT_RDEV;
+
+	x  = ((u32*)&stat->volume_id)[0] = ((u32*)&sb->s_volume_id)[0];
+	x |= ((u32*)&stat->volume_id)[1] = ((u32*)&sb->s_volume_id)[1];
+	x |= ((u32*)&stat->volume_id)[2] = ((u32*)&sb->s_volume_id)[2];
+	x |= ((u32*)&stat->volume_id)[3] = ((u32*)&sb->s_volume_id)[3];
+	if (x)
+		stat->result_mask |= XSTAT_VOLUME_ID;
+}
 EXPORT_SYMBOL(generic_fillattr);
 
 /**
@@ -53,6 +89,9 @@ int vfs_getattr_nosec(struct path *path, struct kstat *stat)
 {
 	struct inode *inode = path->dentry->d_inode;
 
+	stat->result_mask = 0;
+	stat->information = 0;
+	stat->ioc_flags = 0;
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path->mnt, path->dentry, stat);
 
@@ -62,7 +101,25 @@ int vfs_getattr_nosec(struct path *path, struct kstat *stat)
 
 EXPORT_SYMBOL(vfs_getattr_nosec);
 
-int vfs_getattr(struct path *path, struct kstat *stat)
+/**
+ * vfs_xgetattr - Get the basic and extra attributes of a file
+ * @path: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  The caller must have preset
+ * stat->request_mask and stat->query_flags to indicate what they want.
+ *
+ * If the file is remote, the filesystem can be forced to update the attributes
+ * from the backing store by passing AT_FORCE_ATTR_SYNC in query_flags.
+ *
+ * Bits must have been set in stat->request_mask to indicate which attributes
+ * the caller wants retrieving.  Any such attribute not requested may be
+ * returned anyway, but the value may be approximate, and, if remote, may not
+ * have been synchronised with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_xgetattr(struct path *path, struct kstat *stat)
 {
 	int retval;
 
@@ -72,42 +129,115 @@ int vfs_getattr(struct path *path, struct kstat *stat)
 	return vfs_getattr_nosec(path, stat);
 }
 
+EXPORT_SYMBOL(vfs_xgetattr);
+
+/**
+ * vfs_getattr - Get the basic attributes of a file
+ * @path: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  If remote, the filesystem isn't
+ * forced to update its files from the backing store. Only the basic set of
+ * attributes will be retrieved; anyone wanting more must use vfs_getxattr(),
+ * as must anyone who wants to force attributes to be sync'd with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_getattr(struct path *path, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = XSTAT_BASIC_STATS;
+	return vfs_xgetattr(path, stat);
+}
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_fstat(unsigned int fd, struct kstat *stat)
+/**
+ * vfs_fxstat - Get basic and extra attributes by file descriptor
+ * @fd: The file descriptor refering to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr(). The main difference is
+ * that is uses a file descriptor to determine the file location.
+ *
+ * The caller must have preset stat->query_flags and stat->request_mask as for
+ * vfs_xgetattr().
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fxstat(unsigned int fd, struct kstat *stat)
 {
 	struct fd f = fdget_raw(fd);
 	int error = -EBADF;
 
+	if (stat->query_flags & ~KSTAT_QUERY_FLAGS)
+		return -EINVAL;
 	if (f.file) {
-		error = vfs_getattr(&f.file->f_path, stat);
+		error = vfs_xgetattr(&f.file->f_path, stat);
 		fdput(f);
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_fxstat);
+
+/**
+ * vfs_fstat - Get basic attributes by file descriptor
+ * @fd: The file descriptor refering to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_getattr(). The main difference is
+ * that it uses a file descriptor to determine the file location.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstat(unsigned int fd, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = XSTAT_BASIC_STATS;
+	return vfs_fxstat(fd, stat);
+}
 EXPORT_SYMBOL(vfs_fstat);
 
-int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
-		int flag)
+/**
+ * vfs_xstat - Get basic and extra attributes by filename
+ * @dfd: A file descriptor respresenting the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr(). The main difference is
+ * that it uses a filename and base directory to determine the file location.
+ * Additionally, the addition of AT_SYMLINK_NOFOLLOW to flags will prevent a
+ * symlink at the given name from being referenced.
+ *
+ * The caller must have preset stat->request_mask as for vfs_xgetattr(). The
+ * flags are also used to load up stat->query_flags.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_xstat(int dfd, const char __user *filename, int flags,
+	      struct kstat *stat)
 {
 	struct path path;
-	int error = -EINVAL;
-	unsigned int lookup_flags = 0;
+	int error = 0, lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
 
-	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		      AT_EMPTY_PATH)) != 0)
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
+		      AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
 		goto out;
 
-	if (!(flag & AT_SYMLINK_NOFOLLOW))
-		lookup_flags |= LOOKUP_FOLLOW;
-	if (flag & AT_EMPTY_PATH)
+	if (flags & AT_SYMLINK_NOFOLLOW)
+		lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & AT_NO_AUTOMOUNT)
+		lookup_flags &= ~LOOKUP_AUTOMOUNT;
+	if (flags & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
+
+	stat->query_flags = flags & KSTAT_QUERY_FLAGS;
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (error)
 		goto out;
 
-	error = vfs_getattr(&path, stat);
+	error = vfs_xgetattr(&path, stat);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -116,17 +246,65 @@ retry:
 out:
 	return error;
 }
+EXPORT_SYMBOL(vfs_xstat);
+
+/**
+ * vfs_fstatat - Get basic attributes by filename
+ * @dfd: A file descriptor representing the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat().  The difference is that it
+ * preselects basic stats only.  The flags are used to load up
+ * stat->query_flags in addition to indicating symlink handling during path
+ * resolution.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
+		int flags)
+{
+	stat->request_mask = XSTAT_BASIC_STATS;
+	return vfs_xstat(dfd, filename, flags, stat);
+}
 EXPORT_SYMBOL(vfs_fstatat);
 
-int vfs_stat(const char __user *name, struct kstat *stat)
+/**
+ * vfs_stat - Get basic attributes by filename
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat().  The difference is that it
+ * preselects basic stats only, terminal symlinks are followed regardless and a
+ * remote filesystem can't be forced to query the server.  If such is desired,
+ * vfs_xstat() should be used instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_stat(const char __user *filename, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, 0);
+	stat->request_mask = XSTAT_BASIC_STATS;
+	return vfs_xstat(AT_FDCWD, filename, 0, stat);
 }
 EXPORT_SYMBOL(vfs_stat);
 
+/**
+ * vfs_lstat - Get basic attributes by filename, without following terminal symlink
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xstat(). The difference is that it
+ * preselects basic stats only, terminal symlinks are not followed regardless
+ * and a remote filesystem can't be forced to query the server. If such is
+ * desired, vfs_xstat() should be used instead.
+ *
+ * 0 is returned on success, and a -ve error code if unsuccessful.
+ */
 int vfs_lstat(const char __user *name, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
+	stat->request_mask = XSTAT_BASIC_STATS;
+	return vfs_xstat(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat);
 }
 EXPORT_SYMBOL(vfs_lstat);
 
@@ -141,7 +319,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -166,7 +344,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -445,6 +623,122 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
+/*
+ * Get the xstat parameters if supplied
+ */
+static int xstat_get_params(unsigned int mask, struct xstat __user *buffer,
+			    struct kstat *stat)
+{
+	memset(stat, 0xde, sizeof(*stat)); // DEBUGGING
+
+	if (!access_ok(VERIFY_WRITE, buffer, sizeof(*buffer)))
+		return -EFAULT;
+
+	stat->request_mask = mask & XSTAT_ALL_STATS;
+	stat->result_mask = 0;
+	return 0;
+}
+
+/*
+ * Set the xstat results
+ *
+ * If the buffer size was 0, we just return the size of the buffer needed to
+ * return the full result.
+ *
+ * If bufsize indicates a buffer of insufficient size to hold the full result,
+ * we return -E2BIG.
+ *
+ * Otherwise we copy the extended stats to userspace and return the amount of
+ * data written into the buffer (or -EFAULT).
+ */
+static long xstat_set_result(struct kstat *stat, struct xstat __user *buffer)
+{
+	u32 mask = stat->result_mask, gran = stat->tv_granularity;
+
+#define __put_timestamp(kts, uts) (                                        \
+		__put_user(kts.tv_sec,  uts.tv_sec                   ) ||  \
+		__put_user(kts.tv_nsec, uts.tv_nsec                  ) ||  \
+		__put_user(gran,        uts.tv_granularity           ))
+
+	/* clear out anything we're not returning */
+	if (!(mask & XSTAT_IOC_FLAGS))
+		stat->ioc_flags = 0;
+	if (!(mask & XSTAT_BTIME))
+		memset(&stat->btime, 0, sizeof(stat->btime));
+	if (!(mask & XSTAT_GEN))
+		stat->gen = 0;
+	if (!(mask & XSTAT_VERSION))
+		stat->version = 0;
+	if (!(mask & XSTAT_VOLUME_ID))
+		memset(&stat->volume_id, 0, sizeof(stat->volume_id));
+
+	/* transfer the results */
+	if (__put_user(mask,                     &buffer->st_mask          ) ||
+	    __put_user(stat->mode,               &buffer->st_mode          ) ||
+	    __put_user(stat->nlink,              &buffer->st_nlink         ) ||
+	    __put_user(__kuid_val(stat->uid),    &buffer->st_uid           ) ||
+	    __put_user(__kgid_val(stat->gid),    &buffer->st_gid           ) ||
+	    __put_user(stat->information,        &buffer->st_information   ) ||
+	    __put_user(stat->ioc_flags,          &buffer->st_ioc_flags     ) ||
+	    __put_user(stat->blksize,            &buffer->st_blksize       ) ||
+	    __put_user(MAJOR(stat->rdev),        &buffer->st_rdev.major    ) ||
+	    __put_user(MINOR(stat->rdev),        &buffer->st_rdev.minor    ) ||
+	    __put_user(MAJOR(stat->dev),         &buffer->st_dev.major     ) ||
+	    __put_user(MINOR(stat->dev),         &buffer->st_dev.minor     ) ||
+	    __put_timestamp(stat->atime,         &buffer->st_atime         ) ||
+	    __put_timestamp(stat->btime,         &buffer->st_btime         ) ||
+	    __put_timestamp(stat->ctime,         &buffer->st_ctime         ) ||
+	    __put_timestamp(stat->mtime,         &buffer->st_mtime         ) ||
+	    __put_user(stat->ino,                &buffer->st_ino           ) ||
+	    __put_user(stat->size,               &buffer->st_size          ) ||
+	    __put_user(stat->blocks,             &buffer->st_blocks        ) ||
+	    __put_user(stat->gen,                &buffer->st_gen           ) ||
+	    __put_user(stat->version,            &buffer->st_version       ) ||
+	    __copy_to_user(&buffer->st_volume_id, &stat->volume_id,
+			   sizeof(buffer->st_volume_id)                    ) ||
+	    __clear_user(&buffer->__spares, sizeof(buffer->__spares)))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * System call to get extended stats by path
+ */
+SYSCALL_DEFINE5(xstat,
+		int, dfd, const char __user *, filename, unsigned, flags,
+		unsigned int, mask, struct xstat __user *, buffer)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_get_params(mask, buffer, &stat);
+	if (error != 0)
+		return error;
+	error = vfs_xstat(dfd, filename, flags, &stat);
+	if (error)
+		return error;
+	return xstat_set_result(&stat, buffer);
+}
+
+/*
+ * System call to get extended stats by file descriptor
+ */
+SYSCALL_DEFINE4(fxstat, unsigned int, fd, unsigned int, flags,
+		unsigned int, mask, struct xstat __user *, buffer)
+{
+	struct kstat stat;
+	int error;
+
+	error = xstat_get_params(mask, buffer, &stat);
+	if (error < 0)
+		return error;
+	stat.query_flags = flags;
+	error = vfs_fxstat(fd, &stat);
+	if (error)
+		return error;
+	return xstat_set_result(&stat, buffer);
+}
+
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 338e6f7..b91f235 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1207,6 +1207,7 @@ struct super_block {
 
 	char s_id[32];				/* Informational name */
 	u8 s_uuid[16];				/* UUID */
+	unsigned char           s_volume_id[16]; /* Volume identifier */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	unsigned int		s_max_links;
@@ -2519,6 +2520,7 @@ extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 int vfs_getattr_nosec(struct path *path, struct kstat *stat);
 extern int vfs_getattr(struct path *, struct kstat *);
+extern int vfs_xgetattr(struct path *, struct kstat *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
@@ -2533,6 +2535,8 @@ extern int vfs_stat(const char __user *, struct kstat *);
 extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
+extern int vfs_xstat(int, const char __user *, int, struct kstat *);
+extern int vfs_fxstat(unsigned int, struct kstat *);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 075cb0c..552e047 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -2,6 +2,7 @@
 #define _LINUX_STAT_H
 
 
+#include <linux/types.h>
 #include <asm/stat.h>
 #include <uapi/linux/stat.h>
 
@@ -19,6 +20,12 @@
 #include <linux/uidgid.h>
 
 struct kstat {
+	u32             query_flags;                /* operational flags */
+#define KSTAT_QUERY_FLAGS (AT_FORCE_ATTR_SYNC)
+	u32             request_mask;               /* what fields the user asked for */
+	u32             result_mask;                /* what fields the user got */
+	u32             information;
+	u32             ioc_flags;                  /* inode flags (FS_IOC_GETFLAGS) */
 	u64		ino;
 	dev_t		dev;
 	umode_t		mode;
@@ -26,12 +33,17 @@ struct kstat {
 	kuid_t		uid;
 	kgid_t		gid;
 	dev_t		rdev;
+	unsigned int    tv_granularity;             /* granularity of times (in nS) */
 	loff_t		size;
-	struct timespec  atime;
+	struct timespec atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
+	struct timespec btime;                      /* file creation time */
 	unsigned long	blksize;
 	unsigned long long	blocks;
+	u64             gen;                        /* inode generation */
+	u64             version;                    /* data version */
+	unsigned char   volume_id[16];              /* volume identifier */
 };
 
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..cf85e40 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -866,4 +866,9 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+
+asmlinkage long sys_xstat(int dfd, const char __user *path, unsigned flags,
+			  unsigned mask, struct xstat __user *buffer);
+asmlinkage long sys_fxstat(unsigned fd, unsigned flags,
+			    unsigned mask, struct xstat __user *buffer);
 #endif
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 074b886..450b310 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -47,6 +47,7 @@
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
 #define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
 #define AT_EMPTY_PATH		0x1000	/* Allow empty relative pathname */
+#define AT_FORCE_ATTR_SYNC      0x2000  /* Force the attributes to be sync'd with the server */
 
 
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 7fec7e3..2907352 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -41,5 +41,115 @@
 
 #endif
 
+/*
+ * Query request/result mask
+ *
+ * Bits should be set in request_mask to request particular items when calling
+ * xstat() or fxstat().
+ *
+ * The bits in st_mask may or may not be set upon return, in part depending on
+ * what was set in the mask argument:
+ *
+ * - if not available at all, the bit will be cleared before returning and the
+ *   field will be cleared; otherise,
+ *
+ * - if AT_FORCE_ATTR_SYNC is set, then the datum will be synchronised to the
+ *   server and the field and bit will be set on return; otherwise,
+ *
+ * - if explicitly requested, the datum will be synchronised to a serer or
+ *   other medium if out of date before being returned, and the bit will be set
+ *   on return; otherwise,
+ *
+ * - if not requested, but available in approximate form without any effort, it
+ *   will be filled in anyway, and the bit will be set upon return  (it might
+ *   not be up to date, however, and no attempt will be made to synchronise the
+ *   internal state first); otherwise,
+ *
+ * - the field and the bit will be cleared before returning.
+ *
+ * Items in XSTAT_BASIC_STATS may be marked unavailable on return, but they
+ * will have a value installed for compatibility purposes so that stat() and
+ * co. can be emulated in userspace.
+ */
+#define XSTAT_MODE             0x00000001U     /* want/got st_mode */
+#define XSTAT_NLINK            0x00000002U     /* want/got st_nlink */
+#define XSTAT_UID              0x00000004U     /* want/got st_uid */
+#define XSTAT_GID              0x00000008U     /* want/got st_gid */
+#define XSTAT_RDEV             0x00000010U     /* want/got st_rdev */
+#define XSTAT_ATIME            0x00000020U     /* want/got st_atime */
+#define XSTAT_MTIME            0x00000040U     /* want/got st_mtime */
+#define XSTAT_CTIME            0x00000080U     /* want/got st_ctime */
+#define XSTAT_INO              0x00000100U     /* want/got st_ino */
+#define XSTAT_SIZE             0x00000200U     /* want/got st_size */
+#define XSTAT_BLOCKS           0x00000400U     /* want/got st_blocks */
+#define XSTAT_BASIC_STATS      0x000007ffU     /* the stuff in the normal stat struct */
+#define XSTAT_IOC_FLAGS        0x00000800U     /* want/got FS_IOC_GETFLAGS */
+#define XSTAT_BTIME            0x00001000U     /* want/got st_btime */
+#define XSTAT_GEN              0x00002000U     /* want/got st_gen */
+#define XSTAT_VERSION          0x00004000U     /* want/got st_version */
+#define XSTAT_VOLUME_ID        0x00008000U     /* want/got st_volume_id */
+#define XSTAT_ALL_STATS        0x0000ffffU     /* all supported stats */
+
+/*
+ * Extended stat structures
+ */
+struct xstat_dev {
+	uint32_t                major, minor;
+};
+
+struct xstat_time {
+	int64_t                 tv_sec;
+	uint32_t                tv_nsec;
+	uint32_t                tv_granularity; /* time granularity (in nS) */
+};
+
+struct xstat {
+	uint32_t                st_mask;        /* what results were written */
+	uint32_t                st_mode;        /* file mode */
+	uint32_t                st_nlink;       /* number of hard links */
+	uint32_t                st_uid;         /* user ID of owner */
+	uint32_t                st_gid;         /* group ID of owner */
+	uint32_t                st_information; /* information about the file */
+	uint32_t                st_ioc_flags;   /* as FS_IOC_GETFLAGS */
+	uint32_t                st_blksize;     /* optimal size for filesystem I/O */
+	struct xstat_dev        st_rdev;        /* device ID of special file */
+	struct xstat_dev        st_dev;         /* ID of device containing file */
+	struct xstat_time       st_atime;       /* last access time */
+	struct xstat_time       st_btime;       /* file creation time */
+	struct xstat_time       st_ctime;       /* last attribute change time */
+	struct xstat_time       st_mtime;       /* last data modification time */
+	uint64_t                st_ino;         /* inode number */
+	uint64_t                st_size;        /* file size */
+	uint64_t                st_blocks;      /* number of 512-byte blocks allocated */
+	uint64_t                st_gen;         /* inode generation number */
+	uint64_t                st_version;     /* data version number */
+	uint8_t                 st_volume_id[16]; /* volume identifier */
+	uint64_t                __spares[11];   /* spare space for future expansion */
+};
+
+/*
+ * Flags to be found in st_information
+ *
+ * These give information about the features or the state of a file that might
+ * be of use to ordinary userspace programs such as GUIs or ls rather than
+ * specialised tools.
+ *
+ * Additional information may be found in st_ioc_flags and we try not to
+ * overlap with it.
+ */
+#define XSTAT_INFO_ENCRYPTED           0x00000001U /* File is encrypted */
+#define XSTAT_INFO_TEMPORARY           0x00000002U /* File is temporary (NTFS/CIFS) */
+#define XSTAT_INFO_FABRICATED          0x00000004U /* File was made up by filesystem */
+#define XSTAT_INFO_KERNEL_API          0x00000008U /* File is kernel API (eg: procfs/sysfs) */
+#define XSTAT_INFO_REMOTE              0x00000010U /* File is remote */
+#define XSTAT_INFO_OFFLINE             0x00000020U /* File is offline (CIFS) */
+#define XSTAT_INFO_AUTOMOUNT           0x00000040U /* Dir is automount trigger */
+#define XSTAT_INFO_AUTODIR             0x00000080U /* Dir provides unlisted automounts */
+#define XSTAT_INFO_NONSYSTEM_OWNERSHIP 0x00000100U /* File has non-system ownership details */
+#define XSTAT_INFO_HAS_ACL             0x00000200U /* File has an ACL of some sort */
+#define XSTAT_INFO_REPARSE_POINT       0x00000400U /* File is reparse point (NTFS/CIFS) */
+#define XSTAT_INFO_HIDDEN              0x00000800U /* File is marked hidden (DOS+) */
+#define XSTAT_INFO_SYSTEM              0x00001000U /* File is marked system (DOS+) */
+#define XSTAT_INFO_ARCHIVE             0x00002000U /* File is marked archive (DOS+) */
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
1.8.1.4

