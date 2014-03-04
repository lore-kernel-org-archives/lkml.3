Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaCDUAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:00:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48046 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaCDUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:00:30 -0500
Date: Tue, 4 Mar 2014 20:00:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140304200027.GA11932@ZenIV.linux.org.uk>
References: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <20140303220106.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
 <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
 <20140303234207.GQ18016@ZenIV.linux.org.uk>
 <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
 <20140304002342.GS18016@ZenIV.linux.org.uk>
 <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
 <20140304010517.GT18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20140304010517.GT18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2014 at 01:05:17AM +0000, Al Viro wrote:

> It's probably not worth replacing struct fd with typedef to unsigned long -
> too easy to have it confused with a file descriptor itself and pass to
> something that expects e.g. int.  In any case, since we leave fdget()
> inlined, compiler will see the unsigned long it's been initialized with,
> so if it decides that it's cheaper to replace f.file with v & ~3 through
> the whole thing, keep v around and discard local struct fd completely,
> it'll be able to do so just fine...
> 
> I'll play around with cross-builds a bit and see what falls out of all
> that.

OK, with the attached set (the first one is essentially unchanged from
your first one), it seems to work and produce better code on all targets
I've tried.  Comments?

I've also pushed those (on top of old ocfs2 fix) into vfs.git#for-linus,
if you prefer to read it that way.  Should propagate in a few...

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-atomic-f_pos-accesses-as-per-POSIX.patch"

>From 61660f7691b301dce7ed2d995d9e95ca4353e51d Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Mar 2014 09:36:58 -0800
Subject: [PATCH 1/3] vfs: atomic f_pos accesses as per POSIX

Our write() system call has always been atomic in the sense that you get
the expected thread-safe contiguous write, but we haven't actually
guaranteed that concurrent writes are serialized wrt f_pos accesses, so
threads (or processes) that share a file descriptor and use "write()"
concurrently would quite likely overwrite each others data.

This violates POSIX.1-2008/SUSv4 Section XSI 2.9.7 that says:

 "2.9.7 Thread Interactions with Regular File Operations

  All of the following functions shall be atomic with respect to each
  other in the effects specified in POSIX.1-2008 when they operate on
  regular files or symbolic links: [...]"

and one of the effects is the file position update.

This unprotected file position behavior is not new behavior, and nobody
has ever cared.  Until now.  Yongzhi Pan reported unexpected behavior to
Michael Kerrisk that was due to this.

This resolves the issue with a f_pos-specific lock that is taken by
read/write/lseek on file descriptors that may be shared across threads
or processes.

Reported-by: Yongzhi Pan <panyongzhi@gmail.com>
Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_table.c      |    1 +
 fs/namei.c           |    2 +-
 fs/open.c            |    4 ++++
 fs/read_write.c      |   54 +++++++++++++++++++++++++++++++++++++-------------
 include/linux/file.h |    6 ++++--
 include/linux/fs.h   |    6 +++++-
 6 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5fff903..5b24008 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -135,6 +135,7 @@ struct file *get_empty_filp(void)
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
 	spin_lock_init(&f->f_lock);
+	mutex_init(&f->f_pos_lock);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */
 	return f;
diff --git a/fs/namei.c b/fs/namei.c
index 385f781..2f730ef 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1884,7 +1884,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 		nd->path = f.file->f_path;
 		if (flags & LOOKUP_RCU) {
-			if (f.need_put)
+			if (f.flags & FDPUT_FPUT)
 				*fp = f.file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			rcu_read_lock();
diff --git a/fs/open.c b/fs/open.c
index 4b3e1ed..b9ed8b2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -705,6 +705,10 @@ static int do_dentry_open(struct file *f,
 		return 0;
 	}
 
+	/* POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	if (S_ISREG(inode->i_mode))
+		f->f_mode |= FMODE_ATOMIC_POS;
+
 	f->f_op = fops_get(inode->i_fop);
 	if (unlikely(WARN_ON(!f->f_op))) {
 		error = -ENODEV;
diff --git a/fs/read_write.c b/fs/read_write.c
index edc5746..932bb34 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -264,10 +264,36 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 }
 EXPORT_SYMBOL(vfs_llseek);
 
+/*
+ * We only lock f_pos if we have threads or if the file might be
+ * shared with another process. In both cases we'll have an elevated
+ * file count (done either by fdget() or by fork()).
+ */
+static inline struct fd fdget_pos(int fd)
+{
+	struct fd f = fdget(fd);
+	struct file *file = f.file;
+
+	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
+		if (file_count(file) > 1) {
+			f.flags |= FDPUT_POS_UNLOCK;
+			mutex_lock(&file->f_pos_lock);
+		}
+	}
+	return f;
+}
+
+static inline void fdput_pos(struct fd f)
+{
+	if (f.flags & FDPUT_POS_UNLOCK)
+		mutex_unlock(&f.file->f_pos_lock);
+	fdput(f);
+}
+
 SYSCALL_DEFINE3(lseek, unsigned int, fd, off_t, offset, unsigned int, whence)
 {
 	off_t retval;
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	if (!f.file)
 		return -EBADF;
 
@@ -278,7 +304,7 @@ SYSCALL_DEFINE3(lseek, unsigned int, fd, off_t, offset, unsigned int, whence)
 		if (res != (loff_t)retval)
 			retval = -EOVERFLOW;	/* LFS: should only happen on 32 bit platforms */
 	}
-	fdput(f);
+	fdput_pos(f);
 	return retval;
 }
 
@@ -498,7 +524,7 @@ static inline void file_pos_write(struct file *file, loff_t pos)
 
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
@@ -506,7 +532,7 @@ SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 		ret = vfs_read(f.file, buf, count, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
-		fdput(f);
+		fdput_pos(f);
 	}
 	return ret;
 }
@@ -514,7 +540,7 @@ SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 		size_t, count)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
@@ -522,7 +548,7 @@ SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 		ret = vfs_write(f.file, buf, count, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
-		fdput(f);
+		fdput_pos(f);
 	}
 
 	return ret;
@@ -797,7 +823,7 @@ EXPORT_SYMBOL(vfs_writev);
 SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
@@ -805,7 +831,7 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 		ret = vfs_readv(f.file, vec, vlen, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
-		fdput(f);
+		fdput_pos(f);
 	}
 
 	if (ret > 0)
@@ -817,7 +843,7 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
 	if (f.file) {
@@ -825,7 +851,7 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 		ret = vfs_writev(f.file, vec, vlen, &pos);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
-		fdput(f);
+		fdput_pos(f);
 	}
 
 	if (ret > 0)
@@ -968,7 +994,7 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
 		compat_ulong_t, vlen)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret;
 	loff_t pos;
 
@@ -978,7 +1004,7 @@ COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 	ret = compat_readv(f.file, vec, vlen, &pos);
 	if (ret >= 0)
 		f.file->f_pos = pos;
-	fdput(f);
+	fdput_pos(f);
 	return ret;
 }
 
@@ -1035,7 +1061,7 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 		const struct compat_iovec __user *, vec,
 		compat_ulong_t, vlen)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_pos(fd);
 	ssize_t ret;
 	loff_t pos;
 
@@ -1045,7 +1071,7 @@ COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 	ret = compat_writev(f.file, vec, vlen, &pos);
 	if (ret >= 0)
 		f.file->f_pos = pos;
-	fdput(f);
+	fdput_pos(f);
 	return ret;
 }
 
diff --git a/include/linux/file.h b/include/linux/file.h
index cbacf4f..f2517fa 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -28,12 +28,14 @@ static inline void fput_light(struct file *file, int fput_needed)
 
 struct fd {
 	struct file *file;
-	int need_put;
+	unsigned int flags;
 };
+#define FDPUT_FPUT       1
+#define FDPUT_POS_UNLOCK 2
 
 static inline void fdput(struct fd fd)
 {
-	if (fd.need_put)
+	if (fd.flags & FDPUT_FPUT)
 		fput(fd.file);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6082956..ebfde04 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -123,6 +123,9 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File is opened with O_PATH; almost nothing can be done with it */
 #define FMODE_PATH		((__force fmode_t)0x4000)
 
+/* File needs atomic accesses to f_pos */
+#define FMODE_ATOMIC_POS	((__force fmode_t)0x8000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
@@ -780,13 +783,14 @@ struct file {
 	const struct file_operations	*f_op;
 
 	/*
-	 * Protects f_ep_links, f_flags, f_pos vs i_size in lseek SEEK_CUR.
+	 * Protects f_ep_links, f_flags.
 	 * Must not be taken from IRQ context.
 	 */
 	spinlock_t		f_lock;
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
+	struct mutex		f_pos_lock;
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
-- 
1.7.10.4


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-sockfd_lookup_light-switch-to-fdget-W-Waway-from-fge.patch"

>From 60990b46c2ac7bbf87ecfd64843f7f19a06822f6 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 3 Mar 2014 23:48:18 -0500
Subject: [PATCH 2/3] sockfd_lookup_light(): switch to fdget^W^Waway from
 fget_light

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/socket.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 879933a..fd8d86e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -450,16 +450,17 @@ EXPORT_SYMBOL(sockfd_lookup);
 
 static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 {
-	struct file *file;
+	struct fd f = fdget(fd);
 	struct socket *sock;
 
 	*err = -EBADF;
-	file = fget_light(fd, fput_needed);
-	if (file) {
-		sock = sock_from_file(file, err);
-		if (sock)
+	if (f.file) {
+		sock = sock_from_file(f.file, err);
+		if (likely(sock)) {
+			*fput_needed = f.flags;
 			return sock;
-		fput_light(file, *fput_needed);
+		}
+		fdput(f);
 	}
 	return NULL;
 }
-- 
1.7.10.4


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-get-rid-of-fget_light.patch"

>From 6053e1188ff288d95f3fa21965edf1137f478507 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 4 Mar 2014 14:54:22 -0500
Subject: [PATCH 3/3] get rid of fget_light()

instead of returning the flags by reference, we can just have the
low-level primitive return those in lower bits of unsigned long,
with struct file * derived from the rest.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file.c            |   56 ++++++++++++++++++++++++++++++++++++++------------
 fs/read_write.c      |   16 +--------------
 include/linux/file.h |   21 ++++++++++---------
 include/linux/fs.h   |    2 +-
 4 files changed, 56 insertions(+), 39 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index db25c2b..60a45e9 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -683,35 +683,65 @@ EXPORT_SYMBOL(fget_raw);
  * The fput_needed flag returned by fget_light should be passed to the
  * corresponding fput_light.
  */
-struct file *__fget_light(unsigned int fd, fmode_t mask, int *fput_needed)
+static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
 
-	*fput_needed = 0;
 	if (atomic_read(&files->count) == 1) {
 		file = __fcheck_files(files, fd);
-		if (file && (file->f_mode & mask))
-			file = NULL;
+		if (!file || unlikely(file->f_mode & mask))
+			return 0;
+		return (unsigned long)file;
 	} else {
 		file = __fget(fd, mask);
-		if (file)
-			*fput_needed = 1;
+		if (!file)
+			return 0;
+		return FDPUT_FPUT | (unsigned long)file;
 	}
-
-	return file;
 }
-struct file *fget_light(unsigned int fd, int *fput_needed)
+unsigned long __fdget(unsigned int fd)
 {
-	return __fget_light(fd, FMODE_PATH, fput_needed);
+	return __fget_light(fd, FMODE_PATH);
 }
-EXPORT_SYMBOL(fget_light);
+EXPORT_SYMBOL(__fdget);
 
-struct file *fget_raw_light(unsigned int fd, int *fput_needed)
+unsigned long __fdget_raw(unsigned int fd)
 {
-	return __fget_light(fd, 0, fput_needed);
+	return __fget_light(fd, 0);
+}
+
+unsigned long __fdget_pos(unsigned int fd)
+{
+	struct files_struct *files = current->files;
+	struct file *file;
+	unsigned long v;
+
+	if (atomic_read(&files->count) == 1) {
+		file = __fcheck_files(files, fd);
+		v = 0;
+	} else {
+		file = __fget(fd, 0);
+		v = FDPUT_FPUT;
+	}
+	if (!file)
+		return 0;
+
+	if (file->f_mode & FMODE_ATOMIC_POS) {
+		if (file_count(file) > 1) {
+			v |= FDPUT_POS_UNLOCK;
+			mutex_lock(&file->f_pos_lock);
+		}
+	}
+	return v | (unsigned long)file;
 }
 
+/*
+ * We only lock f_pos if we have threads or if the file might be
+ * shared with another process. In both cases we'll have an elevated
+ * file count (done either by fdget() or by fork()).
+ */
+
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
diff --git a/fs/read_write.c b/fs/read_write.c
index 932bb34..54e19b9 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -264,23 +264,9 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 }
 EXPORT_SYMBOL(vfs_llseek);
 
-/*
- * We only lock f_pos if we have threads or if the file might be
- * shared with another process. In both cases we'll have an elevated
- * file count (done either by fdget() or by fork()).
- */
 static inline struct fd fdget_pos(int fd)
 {
-	struct fd f = fdget(fd);
-	struct file *file = f.file;
-
-	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
-		if (file_count(file) > 1) {
-			f.flags |= FDPUT_POS_UNLOCK;
-			mutex_lock(&file->f_pos_lock);
-		}
-	}
-	return f;
+	return __to_fd(__fdget_pos(fd));
 }
 
 static inline void fdput_pos(struct fd f)
diff --git a/include/linux/file.h b/include/linux/file.h
index f2517fa..4d69123 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -40,23 +40,24 @@ static inline void fdput(struct fd fd)
 }
 
 extern struct file *fget(unsigned int fd);
-extern struct file *fget_light(unsigned int fd, int *fput_needed);
+extern struct file *fget_raw(unsigned int fd);
+extern unsigned long __fdget(unsigned int fd);
+extern unsigned long __fdget_raw(unsigned int fd);
+extern unsigned long __fdget_pos(unsigned int fd);
 
-static inline struct fd fdget(unsigned int fd)
+static inline struct fd __to_fd(unsigned long v)
 {
-	int b;
-	struct file *f = fget_light(fd, &b);
-	return (struct fd){f,b};
+	return (struct fd){(struct file *)(v & ~3),v & 3};
 }
 
-extern struct file *fget_raw(unsigned int fd);
-extern struct file *fget_raw_light(unsigned int fd, int *fput_needed);
+static inline struct fd fdget(unsigned int fd)
+{
+	return __to_fd(__fdget(fd));
+}
 
 static inline struct fd fdget_raw(unsigned int fd)
 {
-	int b;
-	struct file *f = fget_raw_light(fd, &b);
-	return (struct fd){f,b};
+	return __to_fd(__fdget_raw(fd));
 }
 
 extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ebfde04..23b2a35 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -812,7 +812,7 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
-};
+} __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
 	__u32 handle_bytes;
-- 
1.7.10.4


--LZvS9be/3tNcYl/X--
