Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3JYJQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:16:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40990 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3JYJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:16:38 -0400
Date: Fri, 25 Oct 2013 10:16:29 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, "zab@redhat.com" <zab@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [RFC PATCH] vfs: rename: link replacement to source
Message-ID: <20131025091629.GA4949@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really reluctant to implement whiteouts in the filesystem, since its
basically a single-use code, and it would come with introducing a new
object type, adding support for this object to each operation, adding
special support to userspace API, etc...  Instead we can really reuse
existing features of filesystems to implement whiteouts, with all the
kernel and userspace interface issues already sorted out
(e.g. symlink+xattr, as used by old and well used overlayfs code).

So the only operation remaining to allow atomic whiteouts is renaming to an
existing destination and whiteouting the source.

This patch adds an extension to renameat2 (which should now really be
renameat3), that allows this.  It's basically an atomic equivalent to:

  rename source dest
  link replacement source

Unlike plain rename, this is always balanced (source and dest exist and
remain to exist after the operation).  And it only involves locking two
directories.  The only tricky part is having to lock both "dest" and
"replacement" inodes.

The syscall interface is now

  int renameat2(srcdfd, srcname, dstdfd, dstname, replacefd, flags);

where replacefd can be any non-directory, possibly opened with O_PATH.

Not sure if we really need a dfd+name for the replacement argument, but
that's a possibility as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
This is on top of the cross-rename patches posted previously.  Git tree here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

 fs/ext4/ext4.h          |   26 ++++++----
 fs/ext4/namei.c         |   46 +++++++++++++++---
 fs/namei.c              |  121 +++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/fs.h      |    7 +-
 include/uapi/linux/fs.h |    1 
 5 files changed, 171 insertions(+), 30 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3142,6 +3142,7 @@ static void ext4_rename_delete(handle_t
  */
 static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
+			struct dentry *replace_src, struct dentry *replace_dst,
 			unsigned int flags)
 {
 	handle_t *handle = NULL;
@@ -3155,6 +3156,23 @@ static int ext4_rename2(struct inode *ol
 	};
 	int retval;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
+	struct inode *replace = NULL;
+	int nblocks = 2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+		EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2;
+
+	if (flags & ~(RENAME_EXCHANGE | RENAME_REPLACE))
+		return -EOPNOTSUPP;
+
+	if (flags & RENAME_REPLACE) {
+		replace = replace_src->d_inode;
+		if (replace->i_nlink >= EXT4_LINK_MAX)
+			return -EMLINK;
+
+		nblocks += EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+			EXT4_INDEX_EXTRA_TRANS_BLOCKS + 1;
+	}
+	if (!overwrite)
+		nblocks += EXT4_INDEX_EXTRA_TRANS_BLOCKS;
 
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
@@ -3193,9 +3211,7 @@ static int ext4_rename2(struct inode *ol
 		goto end_rename;
 	}
 
-	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
-		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
+	handle = ext4_journal_start(old.dir, EXT4_HT_DIR, nblocks);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -3233,7 +3249,7 @@ static int ext4_rename2(struct inode *ol
 		if (retval)
 			goto end_rename;
 	} else {
-		u8 new_file_type = new.de->file_type;
+		u8 file_type = new.de->file_type;
 		retval = ext4_setent(handle, &new,
 				     old.inode->i_ino, old.de->file_type);
 		if (retval)
@@ -3241,10 +3257,28 @@ static int ext4_rename2(struct inode *ol
 
 		if (!overwrite) {
 			retval = ext4_setent(handle, &old,
-					     new.inode->i_ino, new_file_type);
+					     new.inode->i_ino, file_type);
 			if (retval)
 				goto end_rename;
 		}
+		if (replace) {
+			file_type = ext4_type_by_mode(replace->i_mode);
+			replace->i_ctime = ext4_current_time(replace);
+			ext4_inc_count(handle, replace);
+			ihold(replace);
+
+			retval = ext4_setent(handle, &old,
+					     replace->i_ino, file_type);
+			if (retval) {
+				drop_nlink(replace);
+				iput(replace);
+				goto end_rename;
+			}
+			ext4_mark_inode_dirty(handle, replace);
+			if (replace->i_nlink == 1)
+				ext4_orphan_del(handle, replace);
+			d_instantiate(replace_dst, replace);
+		}
 	}
 
 	/*
@@ -3254,7 +3288,7 @@ static int ext4_rename2(struct inode *ol
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	if (overwrite) {
+	if (overwrite && !replace) {
 		/*
 		 * ok, that's it
 		 */
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3937,6 +3937,17 @@ SYSCALL_DEFINE2(link, const char __user
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+static void rename_lock_for_replace(struct inode *target, struct inode *replace)
+{
+	if (S_ISDIR(target->i_mode) || target < replace) {
+		mutex_lock(&target->i_mutex);
+		mutex_lock_nested(&replace->i_mutex, I_MUTEX_REPLACE);
+	} else {
+		mutex_lock(&replace->i_mutex);
+		mutex_lock_nested(&target->i_mutex, I_MUTEX_REPLACE);
+	}
+}
+
 /*
  * The worst of all namespace operations - renaming directory. "Perverted"
  * doesn't even start to describe it. Somebody in UCB had a heck of a trip...
@@ -3966,7 +3977,7 @@ SYSCALL_DEFINE2(link, const char __user
  */
 static int vfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
 		       struct inode *new_dir, struct dentry *new_dentry,
-		       unsigned int flags)
+		       struct dentry *replace_src, unsigned int flags)
 {
 	int error;
 	const unsigned char *old_name;
@@ -3976,10 +3987,22 @@ static int vfs_rename2(struct inode *old
 	bool new_is_dir = target ? S_ISDIR(target->i_mode) : false;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
 	unsigned max_links = new_dir->i_sb->s_max_links;
+	struct dentry *replace_dst = NULL;
+	struct inode *replace = NULL;
 
 	if (source == target)
 		return 0;
 
+	if (flags & RENAME_REPLACE) {
+		if (!overwrite || !target)
+			return -EINVAL;
+		replace = replace_src->d_inode;
+		if (!replace)
+			return -ENOENT;
+		if (target == replace)
+			return -EINVAL;
+	}
+
 	error = may_delete(old_dir, old_dentry, is_dir);
 	if (error)
 		return error;
@@ -4027,10 +4050,37 @@ static int vfs_rename2(struct inode *old
 			return error;
 	}
 
+	if (flags & RENAME_REPLACE) {
+		if (old_dir->i_sb != replace->i_sb)
+			return -EXDEV;
+		if (IS_APPEND(replace) || IS_IMMUTABLE(replace))
+			return -EPERM;
+		if (S_ISDIR(replace->i_mode))
+			return -EPERM;
+		error = security_inode_link(replace_src, old_dir,
+					    old_dentry);
+		if (error)
+			return error;
+
+		replace_dst = d_alloc(old_dentry->d_parent,
+				      &old_dentry->d_name);
+		if (!replace_dst)
+			return -ENOMEM;
+	}
+
 	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
 	dget(new_dentry);
-	if (overwrite && target)
+	if (replace) {
+		rename_lock_for_replace(target, replace);
+		error =  -ENOENT;
+		if (replace->i_nlink == 0 && !(replace->i_state & I_LINKABLE))
+			goto out;
+		error = -EMLINK;
+		if (max_links && replace->i_nlink >= max_links)
+			goto out;
+	} else if (overwrite && target) {
 		mutex_lock(&target->i_mutex);
+	}
 
 	error = -EBUSY;
 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
@@ -4050,7 +4100,9 @@ static int vfs_rename2(struct inode *old
 
 	if (old_dir->i_op->rename2) {
 		error = old_dir->i_op->rename2(old_dir, old_dentry,
-					       new_dir, new_dentry, flags);
+					       new_dir, new_dentry,
+					       replace_src, replace_dst,
+					       flags);
 	} else {
 		error = old_dir->i_op->rename(old_dir, old_dentry,
 					      new_dir, new_dentry);
@@ -4065,14 +4117,27 @@ static int vfs_rename2(struct inode *old
 		dont_mount(new_dentry);
 	}
 	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE)) {
-		if (overwrite)
+		if (overwrite) {
 			d_move(old_dentry, new_dentry);
-		else
+			if (replace) {
+				d_rehash(replace_dst);
+				if (replace->i_state & I_LINKABLE) {
+					spin_lock(&replace->i_lock);
+					replace->i_state &= ~I_LINKABLE;
+					spin_unlock(&replace->i_lock);
+				}
+
+			}
+		} else {
 			d_exchange(old_dentry, new_dentry);
+		}
 	}
 out:
+	if (replace)
+		mutex_unlock(&replace->i_mutex);
 	if (overwrite && target)
 		mutex_unlock(&target->i_mutex);
+	dput(replace_dst);
 	dput(new_dentry);
 	if (!error) {
 		fsnotify_move(old_dir, new_dir, old_name, is_dir,
@@ -4080,6 +4145,8 @@ static int vfs_rename2(struct inode *old
 		if (!overwrite) {
 			fsnotify_move(new_dir, old_dir, old_dentry->d_name.name,
 				      new_is_dir, NULL, new_dentry);
+		} else if (replace) {
+			fsnotify_link(old_dir, replace, replace_dst);
 		}
 	}
 	fsnotify_oldname_free(old_name);
@@ -4090,12 +4157,13 @@ static int vfs_rename2(struct inode *old
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode *new_dir, struct dentry *new_dentry)
 {
-	return vfs_rename2(old_dir, old_dentry, new_dir, new_dentry, 0);
+	return vfs_rename2(old_dir, old_dentry, new_dir, new_dentry, NULL, 0);
 }
 
 
-SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
-		int, newdfd, const char __user *, newname, unsigned int, flags)
+SYSCALL_DEFINE6(renameat2, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname,
+		int, replacefd, unsigned int, flags)
 {
 	struct dentry *old_dir, *new_dir;
 	struct dentry *old_dentry, *new_dentry;
@@ -4107,9 +4175,10 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 	bool should_retry = false;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
 	int error;
+	struct dentry *replace_src = NULL;
 
 	error = -EOPNOTSUPP;
-	if (flags & ~RENAME_EXCHANGE)
+	if (flags & ~(RENAME_EXCHANGE | RENAME_REPLACE))
 		goto exit;
 
 retry:
@@ -4147,6 +4216,27 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 	if (overwrite)
 		newnd.flags |= LOOKUP_RENAME_TARGET;
 
+
+	if (flags & RENAME_REPLACE) {
+		struct fd f = fdget_raw(replacefd);
+		error = -EBADF;
+		if (!f.file)
+			goto exit2;
+
+		replace_src = dget(f.file->f_path.dentry);
+
+		error = -EXDEV;
+		if (f.file->f_path.mnt != oldnd.path.mnt) {
+			fdput(f);
+			goto exit2;
+		}
+
+		error = may_linkat(&f.file->f_path);
+		fdput(f);
+		if (error)
+			goto exit2;
+	}
+
 	trap = lock_rename(new_dir, old_dir);
 
 	old_dentry = lookup_hash(&oldnd);
@@ -4198,10 +4288,16 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 					     &oldnd.path, old_dentry);
 		if (error)
 			goto exit5;
+	} else if (replace_src) {
+		error = security_path_link(replace_src, &oldnd.path,
+					   old_dentry);
+		if (error)
+			goto exit5;
 	}
 
 	error = vfs_rename2(old_dir->d_inode, old_dentry,
-			    new_dir->d_inode, new_dentry, flags);
+			    new_dir->d_inode, new_dentry,
+			    replace_src, flags);
 exit5:
 	dput(new_dentry);
 exit4:
@@ -4210,6 +4306,7 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 	unlock_rename(new_dir, old_dir);
 	mnt_drop_write(oldnd.path.mnt);
 exit2:
+	dput(replace_src);
 	if (retry_estale(error, lookup_flags))
 		should_retry = true;
 	path_put(&newnd.path);
@@ -4229,12 +4326,12 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return sys_renameat2(olddfd, oldname, newdfd, newname, 0);
+	return sys_renameat2(olddfd, oldname, newdfd, newname, -1, 0);
 }
 
 SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
-	return sys_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return sys_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, -1, 0);
 }
 
 int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen, const char *link)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -634,7 +634,8 @@ enum inode_i_mutex_lock_class
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
 	I_MUTEX_XATTR,
-	I_MUTEX_QUOTA
+	I_MUTEX_QUOTA,
+	I_MUTEX_REPLACE,
 };
 
 /*
@@ -1573,7 +1574,9 @@ struct inode_operations {
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*rename2) (struct inode *, struct dentry *,
-			struct inode *, struct dentry *, unsigned int);
+			struct inode *, struct dentry *,
+			struct dentry *, struct dentry *,
+			unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2644,22 +2644,28 @@ extern void initialize_dirent_tail(struc
 extern int ext4_handle_dirty_dirent_node(handle_t *handle,
 					 struct inode *inode,
 					 struct buffer_head *bh);
+
+static inline unsigned char ext4_type_by_mode(umode_t mode)
+{
 #define S_SHIFT 12
-static unsigned char ext4_type_by_mode[S_IFMT >> S_SHIFT] = {
-	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= EXT4_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= EXT4_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= EXT4_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= EXT4_FT_SYMLINK,
-};
+	static const unsigned char __ext4_type_by_mode[S_IFMT >> S_SHIFT] = {
+		[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
+		[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
+		[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
+		[S_IFBLK >> S_SHIFT]	= EXT4_FT_BLKDEV,
+		[S_IFIFO >> S_SHIFT]	= EXT4_FT_FIFO,
+		[S_IFSOCK >> S_SHIFT]	= EXT4_FT_SOCK,
+		[S_IFLNK >> S_SHIFT]	= EXT4_FT_SYMLINK,
+	};
+	return __ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+#undef S_SHIFT
+}
 
 static inline void ext4_set_de_type(struct super_block *sb,
 				struct ext4_dir_entry_2 *de,
 				umode_t mode) {
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE))
-		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+		de->file_type = ext4_type_by_mode(mode);
 }
 
 
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -36,6 +36,7 @@
 #define SEEK_MAX	SEEK_HOLE
 
 #define RENAME_EXCHANGE	(1 << 0)	/* Exchange source and dest */
+#define RENAME_REPLACE	(1 << 1)	/* Link replacement to source */
 
 struct fstrim_range {
 	__u64 start;
