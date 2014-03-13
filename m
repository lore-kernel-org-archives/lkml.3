Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaCMAht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:37:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45754 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaCMAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:37:46 -0400
Date: Thu, 13 Mar 2014 00:37:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140313003740.GL18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
 <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
 <20140312181925.GK18016@ZenIV.linux.org.uk>
 <CANq1E4QSFjDiYVmfrNJFfK6zW_HhSBd5d0QF-2t48DzUP+B6pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4QSFjDiYVmfrNJFfK6zW_HhSBd5d0QF-2t48DzUP+B6pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:30:09PM +0100, David Herrmann wrote:
> Hi
> 
> > I think it's trying to fix the problem in the wrong place.  The bug is real,
> > all right, but it's not that alloc_file() for non-regulars doesn't grab
> > writecount; it's that drop_file_write_access() drops it for those.
> >
> > What the hell would we want to play with that counter for, anyway?  It's not
> > as if they could be mmapped, so all it does is making pipe(2) and socket(2)
> > more costly, for no visible reason.
> 
> Please see:
>   shmem_zero_setup()
>     shmem_file_setup()
>       __shmem_file_setup()
>         alloc_file()
> 
> shmem_zero_setup() is used by /dev/zero (drivers/char/mem.c) and
> mmap(MAP_ANON). So yes, we do call mmap() on these files.

We do, but how do you get anything even attempt deny_write_access() on
those?  And what would the semantics of that be, anyway?

> I also disagree on "for no visible reason". The reason to do this is
> uniformity. We make i_writecount work on all inodes regardless how
> they got created. Breaking consistent behavior just to save an
> atomic_inc_unless_negative() in the alloc_file() path seems
> unreasonable to me.

i_writecount is a hack used to implement MAP_DENYWRITE (ignored since way
back) and to provide historical execve() behaviour (note, BTW, that it's
not consistent - e.g. it does apply to binary itself, but not to shared
libraries; scripts don't get much protection either - if the sucker was
opened for write during execve(), you get ETXTBUSY, but as soon as execve()
has opened the interpreter, script itself can be opened for write just fine).

Maintaining it for pipes and sockets is just plain nuts.

> Anyhow, I haven't found any bug if we follow your recommendation.
> Every path using alloc_file() either prevents write access on the
> underlying inode (eg., anon-inode) or prevents user-space from getting
> an FD (all the shmem_file_setup() paths). So it's up to you. Feel free
> to fix it yourself, otherwise I will send a second patch following
> your idea tomorrow.

We want the same in __get_file_write_access() as well (i.e. doing nothing
if the file isn't regular).

file_take_write(), f_mnt_write_state and the rest of CONFIG_DEBUG_WRITECOUNT
stuff should probably just disappear.

TBH, I'm none too happy about all those if (!special_file()) in that logics.
I would rather have do_dentry_open() do something like

	if ((f->f_mode & FMODE_WRITE) && !special_file(inode->i_mode)) {
		error = get_write_access(inode);
		if (error)
                        goto cleanup_file;
                error = __mnt_want_write(f->f_path.mnt);
		if (error) {
			put_write_access(inode);
			goto cleanup_file;
		}
		f->f_mode |= FMODE_WRITER;
	}
....
cleanup_all:
        fops_put(f->f_op);
        if (f->f_mode & FMODE_WRITER) {
                put_write_access(inode);
		__mnt_drop_write(f->f_path.mnt);
	}
cleanup_file:
....

fput() would just do
....
        if (file->f_mode & FMODE_WRITER) {
                put_write_access(inode);
		__mnt_drop_write(mnt);
	}
....
and alloc_file() would stop playing these games:
        /*
         * These mounts don't really matter in practice
         * for r/o bind mounts.  They aren't userspace-
         * visible.  We do this for consistency, and so
         * that we can do debugging checks at __fput()
         */
        if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
                file_take_write(file);
                WARN_ON(mnt_clone_write(path->mnt));
        }

And to hell with __get_file_write_access()/drop_file_write_access().
IOW, FMODE_WRITER == "we have bumped i_writecount and writer count on
vfsmount".  Makes life much simpler...

IOW, how about the following (completely untested):

diff --git a/fs/file_table.c b/fs/file_table.c
index 5b24008..ce1504f 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -52,7 +52,6 @@ static void file_free_rcu(struct rcu_head *head)
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
-	file_check_state(f);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -178,47 +177,12 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 	file->f_mapping = path->dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
-
-	/*
-	 * These mounts don't really matter in practice
-	 * for r/o bind mounts.  They aren't userspace-
-	 * visible.  We do this for consistency, and so
-	 * that we can do debugging checks at __fput()
-	 */
-	if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
-		file_take_write(file);
-		WARN_ON(mnt_clone_write(path->mnt));
-	}
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		i_readcount_inc(path->dentry->d_inode);
 	return file;
 }
 EXPORT_SYMBOL(alloc_file);
 
-/**
- * drop_file_write_access - give up ability to write to a file
- * @file: the file to which we will stop writing
- *
- * This is a central place which will give up the ability
- * to write to @file, along with access to write through
- * its vfsmount.
- */
-static void drop_file_write_access(struct file *file)
-{
-	struct vfsmount *mnt = file->f_path.mnt;
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
-
-	put_write_access(inode);
-
-	if (special_file(inode->i_mode))
-		return;
-	if (file_check_writeable(file) != 0)
-		return;
-	__mnt_drop_write(mnt);
-	file_release_write(file);
-}
-
 /* the real guts of fput() - releasing the last reference to file
  */
 static void __fput(struct file *file)
@@ -253,8 +217,10 @@ static void __fput(struct file *file)
 	put_pid(file->f_owner.pid);
 	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		i_readcount_dec(inode);
-	if (file->f_mode & FMODE_WRITE)
-		drop_file_write_access(file);
+	if (file->f_mode & FMODE_WRITER) {
+		put_write_access(inode);
+		__mnt_drop_write(mnt);
+	}
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
 	file->f_inode = NULL;
diff --git a/fs/open.c b/fs/open.c
index b9ed8b2..ea765e4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -632,35 +632,6 @@ out:
 	return error;
 }
 
-/*
- * You have to be very careful that these write
- * counts get cleaned up in error cases and
- * upon __fput().  This should probably never
- * be called outside of __dentry_open().
- */
-static inline int __get_file_write_access(struct inode *inode,
-					  struct vfsmount *mnt)
-{
-	int error;
-	error = get_write_access(inode);
-	if (error)
-		return error;
-	/*
-	 * Do not take mount writer counts on
-	 * special files since no writes to
-	 * the mount itself will occur.
-	 */
-	if (!special_file(inode->i_mode)) {
-		/*
-		 * Balanced in __fput()
-		 */
-		error = __mnt_want_write(mnt);
-		if (error)
-			put_write_access(inode);
-	}
-	return error;
-}
-
 int open_check_o_direct(struct file *f)
 {
 	/* NB: we're sure to have correct a_ops only after f_op->open */
@@ -690,12 +661,15 @@ static int do_dentry_open(struct file *f,
 
 	path_get(&f->f_path);
 	inode = f->f_inode = f->f_path.dentry->d_inode;
-	if (f->f_mode & FMODE_WRITE) {
-		error = __get_file_write_access(inode, f->f_path.mnt);
-		if (error)
+	if ((f->f_mode & FMODE_WRITE) && !special_file(inode->i_mode)) {
+		error = get_write_access(inode);
+		if (unlikely(error))
+			goto cleanup_file;
+		error = __mnt_want_write(f->f_path.mnt);
+		if (unlikely(error)) {
+			put_write_access(inode);
 			goto cleanup_file;
-		if (!special_file(inode->i_mode))
-			file_take_write(f);
+		}
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -741,18 +715,9 @@ static int do_dentry_open(struct file *f,
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE) {
+	if (f->f_mode & FMODE_WRITER) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode)) {
-			/*
-			 * We don't consider this a real
-			 * mnt_want/drop_write() pair
-			 * because it all happenend right
-			 * here, so just reset the state.
-			 */
-			file_reset_write(f);
-			__mnt_drop_write(f->f_path.mnt);
-		}
+		__mnt_drop_write(f->f_path.mnt);
 	}
 cleanup_file:
 	path_put(&f->f_path);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 23b2a35..d9d88a0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -125,6 +125,8 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 /* File needs atomic accesses to f_pos */
 #define FMODE_ATOMIC_POS	((__force fmode_t)0x8000)
+/* Write access to underlying fs */
+#define FMODE_WRITER		((__force fmode_t)0x10000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
@@ -769,9 +771,6 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 		index <  ra->start + ra->size);
 }
 
-#define FILE_MNT_WRITE_TAKEN	1
-#define FILE_MNT_WRITE_RELEASED	2
-
 struct file {
 	union {
 		struct llist_node	fu_llist;
@@ -809,9 +808,6 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
-#ifdef CONFIG_DEBUG_WRITECOUNT
-	unsigned long f_mnt_write_state;
-#endif
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
@@ -829,49 +825,6 @@ static inline struct file *get_file(struct file *f)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
-#ifdef CONFIG_DEBUG_WRITECOUNT
-static inline void file_take_write(struct file *f)
-{
-	WARN_ON(f->f_mnt_write_state != 0);
-	f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
-}
-static inline void file_release_write(struct file *f)
-{
-	f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
-}
-static inline void file_reset_write(struct file *f)
-{
-	f->f_mnt_write_state = 0;
-}
-static inline void file_check_state(struct file *f)
-{
-	/*
-	 * At this point, either both or neither of these bits
-	 * should be set.
-	 */
-	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
-	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
-}
-static inline int file_check_writeable(struct file *f)
-{
-	if (f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN)
-		return 0;
-	printk(KERN_WARNING "writeable file with no "
-			    "mnt_want_write()\n");
-	WARN_ON(1);
-	return -EINVAL;
-}
-#else /* !CONFIG_DEBUG_WRITECOUNT */
-static inline void file_take_write(struct file *filp) {}
-static inline void file_release_write(struct file *filp) {}
-static inline void file_reset_write(struct file *filp) {}
-static inline void file_check_state(struct file *filp) {}
-static inline int file_check_writeable(struct file *filp)
-{
-	return 0;
-}
-#endif /* CONFIG_DEBUG_WRITECOUNT */
-
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
 /* Page cache limit. The filesystems should put that into their s_maxbytes 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..7a08593 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1030,16 +1030,6 @@ config DEBUG_BUGVERBOSE
 	  of the BUG call as well as the EIP and oops trace.  This aids
 	  debugging but costs about 70-100K of memory.
 
-config DEBUG_WRITECOUNT
-	bool "Debug filesystem writers count"
-	depends on DEBUG_KERNEL
-	help
-	  Enable this to catch wrong use of the writers count in struct
-	  vfsmount.  This will increase the size of each file struct by
-	  32 bits.
-
-	  If unsure, say N.
-
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
 	depends on DEBUG_KERNEL
