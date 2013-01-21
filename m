Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3AUBWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:22:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3AUBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:22:20 -0500
Date: Mon, 21 Jan 2013 01:22:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130121012217.GQ4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
 <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:53:20PM -0800, Linus Torvalds wrote:
> On Sat, Jan 19, 2013 at 7:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK...  I think I understand what's going on.  We need asmlinkage_protect
> > in sys_clone() ;-/  For what it's worth, I really wonder if we ought to
> > treat that as syscall wrappers - i.e. have SYSCALL_DEFINEx on i386 add
> > a wrapper that would do asmlinkage_protect itself.  IMO it's the same kind
> > of thing as argument normalization handled by syscall wrappers - we make
> > sure that C function plays well with what asm glue is doing and expecting.
> 
> Actually, I think we should do it *unconditionally* in the syscall wrappers.
> 
> It's up to the architecture code to make asmlinkage_protect() be a
> no-op or not, depending on how it does things. Right now I think only
> x86 actually defines it, although I suspect there might be others that
> should (anybody who passes arguments on the stack and also uses the
> stack for save-area).

FWIW, I've just done that and I like the result - only one explicit user of
asmlinkage_protect() is left (ftruncate64()) outside of __SYSCALL_DEFINEx
definition.  However, I suspect that we ought to deal with SYSCALL_DEFINE()
as well and I wonder if we could do it in completely, along with the mess
next to its instances.  Look: the reason why e.g. ftruncate64() can't be
just SYSCALL_DEFINE2(int, fd, loff_t, len) is that
	* __SC_LONG() is going to be too narrow
	* __SC_TEST() will barf on long long in arguments
and both are easily fixed -
#define __TYPE_IS_LL(t) (__same_type((t)0, 0LL) || __same_type((t)0, 0ULL))
#define __SC_TEST(t) BUILD_BUG_ON(!__TYPE_IS_LL(t) && sizeof(t) > sizeof(long))
#define __SC_LONG1(t, a) __typeof(__builtin_choose_expr(__TYPE_IS_LL(t), 0LL, 0L)) a
#define __SC_LONG2(t, a, ...) __SC_LONG1(t, a), __SC_LONG1(__VA_ARGS__)
#define __SC_LONG3(t, a, ...) __SC_LONG1(t, a), __SC_LONG2(__VA_ARGS__)
#define __SC_LONG4(t, a, ...) __SC_LONG1(t, a), __SC_LONG3(__VA_ARGS__)
#define __SC_LONG5(t, a, ...) __SC_LONG1(t, a), __SC_LONG4(__VA_ARGS__)
#define __SC_LONG6(t, a, ...) __SC_LONG1(t, a), __SC_LONG5(__VA_ARGS__)

and we are all set.

Not all SYSCALL_DEFINE() instances are killable that way, but almost all of
them are; the only exception I see is semctl(2) - that sucker has union semun
as the last argument...

... and now that I've looked at it, it's completely fucked in head in yet
another way:
#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
asmlinkage long SyS_semctl(int semid, int semnum, int cmd, union semun arg)
{
        return SYSC_semctl((int) semid, (int) semnum, (int) cmd, arg);
}
SYSCALL_ALIAS(sys_semctl, SyS_semctl);
#endif
In other words, that Fine Piece Of Software does *not* normalize anything -
casting int to int is pointless.  1001st proof that staring at Missed'em'V
APIs can cause braindamage...

Anyway, that's a separate story - semctl(2) is going to be ugly, no matter
what we do, but the rest of those guys doesn't have to.  How about the
following (completely untested):

teach SYSCALL_DEFINEx to do asmlinkage_protect and accept long long

... killing explicit users of asmlinkage_protect() and all but one
user of SYSCALL_DEFINE

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index d0964d2..23eb222 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -132,19 +132,9 @@ SYSCALL_DEFINE1(s390_fadvise64_64, struct fadvise64_64_args __user *, args)
  * to
  *   %r2: fd, %r3: mode, %r4/%r5: offset, 96(%r15)-103(%r15): len
  */
-SYSCALL_DEFINE(s390_fallocate)(int fd, int mode, loff_t offset,
-			       u32 len_high, u32 len_low)
+SYSCALL_DEFINE5(s390_fallocate, int, fd, int, mode, loff_t, offset,
+			       u32, len_high, u32, len_low)
 {
 	return sys_fallocate(fd, mode, offset, ((u64)len_high << 32) | len_low);
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_s390_fallocate(long fd, long mode, loff_t offset,
-				   long len_high, long len_low)
-{
-	return SYSC_s390_fallocate((int) fd, (int) mode, offset,
-				   (u32) len_high, (u32) len_low);
-}
-SYSCALL_ALIAS(sys_s390_fallocate, SyS_s390_fallocate);
-#endif
-
 #endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..df11dd7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -114,6 +114,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select GENERIC_SIGALTSTACK
+	select HAVE_SYSCALL_WRAPPERS if X86_32
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 58b7e3e..6ee6a05 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -27,8 +27,8 @@ asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 long sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/tls.c */
-asmlinkage int sys_set_thread_area(struct user_desc __user *);
-asmlinkage int sys_get_thread_area(struct user_desc __user *);
+asmlinkage long sys_set_thread_area(struct user_desc __user *);
+asmlinkage long sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 9d9d2f9..f7fec09 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -3,13 +3,13 @@
 #include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/regset.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/proto.h>
-#include <asm/syscalls.h>
 
 #include "tls.h"
 
@@ -89,11 +89,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	return 0;
 }
 
-asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
+SYSCALL_DEFINE1(set_thread_area, struct user_desc __user *, u_info)
 {
-	int ret = do_set_thread_area(current, -1, u_info, 1);
-	asmlinkage_protect(1, ret, u_info);
-	return ret;
+	return do_set_thread_area(current, -1, u_info, 1);
 }
 
 
@@ -139,11 +137,9 @@ int do_get_thread_area(struct task_struct *p, int idx,
 	return 0;
 }
 
-asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
+SYSCALL_DEFINE1(get_thread_area, struct user_desc __user *, u_info)
 {
-	int ret = do_get_thread_area(current, -1, u_info);
-	asmlinkage_protect(1, ret, u_info);
-	return ret;
+	return do_get_thread_area(current, -1, u_info);
 }
 
 int regset_tls_active(struct task_struct *target,
diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index 5f5feff..15aae91 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -274,7 +274,7 @@ clear:
 	goto out;
 }
 
-int sys_set_thread_area(struct user_desc __user *user_desc)
+SYSCALL_DEFINE1(set_thread_area, struct user_desc __user *, user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
@@ -322,7 +322,7 @@ int ptrace_set_thread_area(struct task_struct *child, int idx,
 	return set_tls_entry(child, &info, idx, 0);
 }
 
-int sys_get_thread_area(struct user_desc __user *user_desc)
+SYSCALL_DEFINE1(get_thread_area, struct user_desc __user *, user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..b69ec35 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1788,7 +1788,5 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 			ret = read_events(ioctx, min_nr, nr, events, timeout);
 		put_ioctx(ioctx);
 	}
-
-	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
diff --git a/fs/dcookies.c b/fs/dcookies.c
index 17c7799..f08375b 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -145,7 +145,7 @@ out:
 /* And here is where the userspace process can look up the cookie value
  * to retrieve the path.
  */
-SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
+SYSCALL_DEFINE3(lookup_dcookie, u64, cookie64, char __user *, buf, size_t, len)
 {
 	unsigned long cookie = (unsigned long)cookie64;
 	int err = -EINVAL;
@@ -201,13 +201,6 @@ out:
 	mutex_unlock(&dcookie_mutex);
 	return err;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_lookup_dcookie(u64 cookie64, long buf, long len)
-{
-	return SYSC_lookup_dcookie(cookie64, (char __user *) buf, (size_t) len);
-}
-SYSCALL_ALIAS(sys_lookup_dcookie, SyS_lookup_dcookie);
-#endif
 
 static int dcookie_init(void)
 {
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ff4a5e..9c51175 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -755,9 +755,9 @@ out_destroy_group:
 	return fd;
 }
 
-SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
-			      __u64 mask, int dfd,
-			      const char  __user * pathname)
+SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
+			      __u64, mask, int, dfd,
+			      const char  __user *, pathname)
 {
 	struct inode *inode = NULL;
 	struct vfsmount *mnt = NULL;
@@ -857,17 +857,6 @@ fput_and_out:
 	return ret;
 }
 
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_fanotify_mark(long fanotify_fd, long flags, __u64 mask,
-				  long dfd, long pathname)
-{
-	return SYSC_fanotify_mark((int) fanotify_fd, (unsigned int) flags,
-				  mask, (int) dfd,
-				  (const char  __user *) pathname);
-}
-SYSCALL_ALIAS(sys_fanotify_mark, SyS_fanotify_mark);
-#endif
-
 /*
  * fanotify_user_setup - Our initialization function.  Note that we cannot return
  * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
diff --git a/fs/open.c b/fs/open.c
index 9b33c0c..cc8e5f5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -189,40 +189,20 @@ out:
 
 SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
 {
-	long ret = do_sys_ftruncate(fd, length, 1);
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(2, ret, fd, length);
-	return ret;
+	return do_sys_ftruncate(fd, length, 1);
 }
 
 /* LFS versions of truncate are only needed on 32 bit machines */
 #if BITS_PER_LONG == 32
-SYSCALL_DEFINE(truncate64)(const char __user * path, loff_t length)
+SYSCALL_DEFINE2(truncate64, const char __user *, path, loff_t, length)
 {
 	return do_sys_truncate(path, length);
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_truncate64(long path, loff_t length)
-{
-	return SYSC_truncate64((const char __user *) path, length);
-}
-SYSCALL_ALIAS(sys_truncate64, SyS_truncate64);
-#endif
 
-SYSCALL_DEFINE(ftruncate64)(unsigned int fd, loff_t length)
+SYSCALL_DEFINE2(ftruncate64, int, fd, loff_t, length)
 {
-	long ret = do_sys_ftruncate(fd, length, 0);
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(2, ret, fd, length);
-	return ret;
+	return do_sys_ftruncate(fd, length, 0);
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_ftruncate64(long fd, loff_t length)
-{
-	return SYSC_ftruncate64((unsigned int) fd, length);
-}
-SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
-#endif
 #endif /* BITS_PER_LONG == 32 */
 
 
@@ -284,7 +264,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	return ret;
 }
 
-SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
+SYSCALL_DEFINE4(fallocate, int, fd, int, mode, loff_t, offset, loff_t, len)
 {
 	struct fd f = fdget(fd);
 	int error = -EBADF;
@@ -296,14 +276,6 @@ SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
 	return error;
 }
 
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_fallocate(long fd, long mode, loff_t offset, loff_t len)
-{
-	return SYSC_fallocate((int)fd, (int)mode, offset, len);
-}
-SYSCALL_ALIAS(sys_fallocate, SyS_fallocate);
-#endif
-
 /*
  * access() needs to use the real uid/gid, not the effective uid/gid.
  * We do this by temporarily clearing all FS-related capabilities and
@@ -969,29 +941,19 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
-	long ret;
-
 	if (force_o_largefile())
 		flags |= O_LARGEFILE;
 
-	ret = do_sys_open(AT_FDCWD, filename, flags, mode);
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, filename, flags, mode);
-	return ret;
+	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 		umode_t, mode)
 {
-	long ret;
-
 	if (force_o_largefile())
 		flags |= O_LARGEFILE;
 
-	ret = do_sys_open(dfd, filename, flags, mode);
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(4, ret, dfd, filename, flags, mode);
-	return ret;
+	return do_sys_open(dfd, filename, flags, mode);
 }
 
 #ifndef __alpha__
diff --git a/fs/read_write.c b/fs/read_write.c
index bb34af3..44b75cc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -480,8 +480,8 @@ SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 	return ret;
 }
 
-SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
-			size_t count, loff_t pos)
+SYSCALL_DEFINE4(pread64, unsigned int, fd, char __user *, buf,
+			size_t, count, loff_t, pos)
 {
 	struct fd f;
 	ssize_t ret = -EBADF;
@@ -499,17 +499,9 @@ SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
 
 	return ret;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_pread64(long fd, long buf, long count, loff_t pos)
-{
-	return SYSC_pread64((unsigned int) fd, (char __user *) buf,
-			    (size_t) count, pos);
-}
-SYSCALL_ALIAS(sys_pread64, SyS_pread64);
-#endif
 
-SYSCALL_DEFINE(pwrite64)(unsigned int fd, const char __user *buf,
-			 size_t count, loff_t pos)
+SYSCALL_DEFINE4(pwrite64, unsigned int, fd, const char __user *, buf,
+			 size_t, count, loff_t, pos)
 {
 	struct fd f;
 	ssize_t ret = -EBADF;
@@ -527,14 +519,6 @@ SYSCALL_DEFINE(pwrite64)(unsigned int fd, const char __user *buf,
 
 	return ret;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_pwrite64(long fd, long buf, long count, loff_t pos)
-{
-	return SYSC_pwrite64((unsigned int) fd, (const char __user *) buf,
-			     (size_t) count, pos);
-}
-SYSCALL_ALIAS(sys_pwrite64, SyS_pwrite64);
-#endif
 
 /*
  * Reduce an iovec's length in-place.  Return the resulting number of segments
diff --git a/fs/sync.c b/fs/sync.c
index 14eefeb..f93cde6 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -283,8 +283,8 @@ EXPORT_SYMBOL(generic_write_sync);
  * already-instantiated disk blocks, there are no guarantees here that the data
  * will be available after a crash.
  */
-SYSCALL_DEFINE(sync_file_range)(int fd, loff_t offset, loff_t nbytes,
-				unsigned int flags)
+SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
+				unsigned int, flags)
 {
 	int ret;
 	struct fd f;
@@ -365,29 +365,11 @@ out_put:
 out:
 	return ret;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_sync_file_range(long fd, loff_t offset, loff_t nbytes,
-				    long flags)
-{
-	return SYSC_sync_file_range((int) fd, offset, nbytes,
-				    (unsigned int) flags);
-}
-SYSCALL_ALIAS(sys_sync_file_range, SyS_sync_file_range);
-#endif
 
 /* It would be nice if people remember that not all the world's an i386
    when they introduce new system calls */
-SYSCALL_DEFINE(sync_file_range2)(int fd, unsigned int flags,
-				 loff_t offset, loff_t nbytes)
+SYSCALL_DEFINE4(sync_file_range2, int, fd, unsigned int, flags,
+				 loff_t, offset, loff_t, nbytes)
 {
 	return sys_sync_file_range(fd, offset, nbytes, flags);
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_sync_file_range2(long fd, long flags,
-				     loff_t offset, loff_t nbytes)
-{
-	return SYSC_sync_file_range2((int) fd, (unsigned int) flags,
-				     offset, nbytes);
-}
-SYSCALL_ALIAS(sys_sync_file_range2, SyS_sync_file_range2);
-#endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 45e2db2..ebc0f19 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -84,13 +84,14 @@ struct sigaltstack;
 #define __SC_DECL4(t4, a4, ...) t4 a4, __SC_DECL3(__VA_ARGS__)
 #define __SC_DECL5(t5, a5, ...) t5 a5, __SC_DECL4(__VA_ARGS__)
 #define __SC_DECL6(t6, a6, ...) t6 a6, __SC_DECL5(__VA_ARGS__)
+#define __TYPE_IS_LL(t) (__same_type((t)0, 0LL) || __same_type((t)0, 0ULL))
 
-#define __SC_LONG1(t1, a1) 	long a1
-#define __SC_LONG2(t2, a2, ...) long a2, __SC_LONG1(__VA_ARGS__)
-#define __SC_LONG3(t3, a3, ...) long a3, __SC_LONG2(__VA_ARGS__)
-#define __SC_LONG4(t4, a4, ...) long a4, __SC_LONG3(__VA_ARGS__)
-#define __SC_LONG5(t5, a5, ...) long a5, __SC_LONG4(__VA_ARGS__)
-#define __SC_LONG6(t6, a6, ...) long a6, __SC_LONG5(__VA_ARGS__)
+#define __SC_LONG1(t, a) __typeof(__builtin_choose_expr(__TYPE_IS_LL(t), 0LL, 0L)) a
+#define __SC_LONG2(t, a, ...) __SC_LONG1(t, a), __SC_LONG1(__VA_ARGS__)
+#define __SC_LONG3(t, a, ...) __SC_LONG1(t, a), __SC_LONG2(__VA_ARGS__)
+#define __SC_LONG4(t, a, ...) __SC_LONG1(t, a), __SC_LONG3(__VA_ARGS__)
+#define __SC_LONG5(t, a, ...) __SC_LONG1(t, a), __SC_LONG4(__VA_ARGS__)
+#define __SC_LONG6(t, a, ...) __SC_LONG1(t, a), __SC_LONG5(__VA_ARGS__)
 
 #define __SC_CAST1(t1, a1)	(t1) a1
 #define __SC_CAST2(t2, a2, ...) (t2) a2, __SC_CAST1(__VA_ARGS__)
@@ -99,7 +100,14 @@ struct sigaltstack;
 #define __SC_CAST5(t5, a5, ...) (t5) a5, __SC_CAST4(__VA_ARGS__)
 #define __SC_CAST6(t6, a6, ...) (t6) a6, __SC_CAST5(__VA_ARGS__)
 
-#define __SC_TEST(type)		BUILD_BUG_ON(sizeof(type) > sizeof(long))
+#define __SC_ARGS1(t1, a1)	a1
+#define __SC_ARGS2(t2, a2, ...) a2, __SC_ARGS1(__VA_ARGS__)
+#define __SC_ARGS3(t3, a3, ...) a3, __SC_ARGS2(__VA_ARGS__)
+#define __SC_ARGS4(t4, a4, ...) a4, __SC_ARGS3(__VA_ARGS__)
+#define __SC_ARGS5(t5, a5, ...) a5, __SC_ARGS4(__VA_ARGS__)
+#define __SC_ARGS6(t6, a6, ...) a6, __SC_ARGS5(__VA_ARGS__)
+
+#define __SC_TEST(t) BUILD_BUG_ON(!__TYPE_IS_LL(t) && sizeof(t) > sizeof(long))
 #define __SC_TEST1(t1, a1)	__SC_TEST(t1)
 #define __SC_TEST2(t2, a2, ...)	__SC_TEST(t2); __SC_TEST1(__VA_ARGS__)
 #define __SC_TEST3(t3, a3, ...)	__SC_TEST(t3); __SC_TEST2(__VA_ARGS__)
@@ -233,13 +241,16 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
 
+#define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
 	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
 	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
+		long ret = SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
+		__PROTECT(x, ret, __SC_ARGS##x(__VA_ARGS__));		\
+		return ret;						\
 	}								\
 	SYSCALL_ALIAS(sys##name, SyS##name);				\
 	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
@@ -432,7 +443,7 @@ asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
 asmlinkage long sys_lstat64(const char __user *filename,
 				struct stat64 __user *statbuf);
 asmlinkage long sys_truncate64(const char __user *path, loff_t length);
-asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);
+asmlinkage long sys_ftruncate64(int fd, loff_t length);
 #endif
 
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..a2d34fc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1627,9 +1627,6 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 	}
 
 	put_pid(pid);
-
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(5, ret, which, upid, infop, options, ru);
 	return ret;
 }
 
@@ -1667,8 +1664,6 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 	ret = do_wait(&wo);
 	put_pid(pid);
 
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(4, ret, upid, stat_addr, options, ru);
 	return ret;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index c535f33..4af19bc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1668,10 +1668,7 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int, tls_val)
 #endif
 {
-	long ret = do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr);
-	asmlinkage_protect(5, ret, clone_flags, newsp,
-			parent_tidptr, child_tidptr, tls_val);
-	return ret;
+	return do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr);
 }
 #endif
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index d7948eb..f6c83d7 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -18,67 +18,43 @@
 
 SYSCALL_DEFINE3(chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
 {
-	long ret = sys_chown(filename, low2highuid(user), low2highgid(group));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, filename, user, group);
-	return ret;
+	return sys_chown(filename, low2highuid(user), low2highgid(group));
 }
 
 SYSCALL_DEFINE3(lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
 {
-	long ret = sys_lchown(filename, low2highuid(user), low2highgid(group));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, filename, user, group);
-	return ret;
+	return sys_lchown(filename, low2highuid(user), low2highgid(group));
 }
 
 SYSCALL_DEFINE3(fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group)
 {
-	long ret = sys_fchown(fd, low2highuid(user), low2highgid(group));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, fd, user, group);
-	return ret;
+	return sys_fchown(fd, low2highuid(user), low2highgid(group));
 }
 
 SYSCALL_DEFINE2(setregid16, old_gid_t, rgid, old_gid_t, egid)
 {
-	long ret = sys_setregid(low2highgid(rgid), low2highgid(egid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(2, ret, rgid, egid);
-	return ret;
+	return sys_setregid(low2highgid(rgid), low2highgid(egid));
 }
 
 SYSCALL_DEFINE1(setgid16, old_gid_t, gid)
 {
-	long ret = sys_setgid(low2highgid(gid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(1, ret, gid);
-	return ret;
+	return sys_setgid(low2highgid(gid));
 }
 
 SYSCALL_DEFINE2(setreuid16, old_uid_t, ruid, old_uid_t, euid)
 {
-	long ret = sys_setreuid(low2highuid(ruid), low2highuid(euid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(2, ret, ruid, euid);
-	return ret;
+	return sys_setreuid(low2highuid(ruid), low2highuid(euid));
 }
 
 SYSCALL_DEFINE1(setuid16, old_uid_t, uid)
 {
-	long ret = sys_setuid(low2highuid(uid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(1, ret, uid);
-	return ret;
+	return sys_setuid(low2highuid(uid));
 }
 
 SYSCALL_DEFINE3(setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid)
 {
-	long ret = sys_setresuid(low2highuid(ruid), low2highuid(euid),
+	return sys_setresuid(low2highuid(ruid), low2highuid(euid),
 				 low2highuid(suid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, ruid, euid, suid);
-	return ret;
 }
 
 SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruidp, old_uid_t __user *, euidp, old_uid_t __user *, suidp)
@@ -100,11 +76,8 @@ SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruidp, old_uid_t __user *, euid
 
 SYSCALL_DEFINE3(setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid)
 {
-	long ret = sys_setresgid(low2highgid(rgid), low2highgid(egid),
+	return sys_setresgid(low2highgid(rgid), low2highgid(egid),
 				 low2highgid(sgid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(3, ret, rgid, egid, sgid);
-	return ret;
 }
 
 
@@ -127,18 +100,12 @@ SYSCALL_DEFINE3(getresgid16, old_gid_t __user *, rgidp, old_gid_t __user *, egid
 
 SYSCALL_DEFINE1(setfsuid16, old_uid_t, uid)
 {
-	long ret = sys_setfsuid(low2highuid(uid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(1, ret, uid);
-	return ret;
+	return sys_setfsuid(low2highuid(uid));
 }
 
 SYSCALL_DEFINE1(setfsgid16, old_gid_t, gid)
 {
-	long ret = sys_setfsgid(low2highgid(gid));
-	/* avoid REGPARM breakage on x86: */
-	asmlinkage_protect(1, ret, gid);
-	return ret;
+	return sys_setfsgid(low2highgid(gid));
 }
 
 static int groups16_to_user(old_gid_t __user *grouplist,
diff --git a/mm/fadvise.c b/mm/fadvise.c
index a47f0f5..1febc51 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -24,7 +24,7 @@
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
  */
-SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
+SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 {
 	struct fd f = fdget(fd);
 	struct address_space *mapping;
@@ -131,26 +131,12 @@ out:
 	fdput(f);
 	return ret;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_fadvise64_64(long fd, loff_t offset, loff_t len, long advice)
-{
-	return SYSC_fadvise64_64((int) fd, offset, len, (int) advice);
-}
-SYSCALL_ALIAS(sys_fadvise64_64, SyS_fadvise64_64);
-#endif
 
 #ifdef __ARCH_WANT_SYS_FADVISE64
 
-SYSCALL_DEFINE(fadvise64)(int fd, loff_t offset, size_t len, int advice)
+SYSCALL_DEFINE4(fadvise64, int, fd, loff_t, offset, size_t, len, int, advice)
 {
 	return sys_fadvise64_64(fd, offset, len, advice);
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_fadvise64(long fd, loff_t offset, long len, long advice)
-{
-	return SYSC_fadvise64((int) fd, offset, (size_t)len, (int)advice);
-}
-SYSCALL_ALIAS(sys_fadvise64, SyS_fadvise64);
-#endif
 
 #endif
diff --git a/mm/readahead.c b/mm/readahead.c
index 7963f23..daed28d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -576,7 +576,7 @@ do_readahead(struct address_space *mapping, struct file *filp,
 	return 0;
 }
 
-SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
+SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
 {
 	ssize_t ret;
 	struct fd f;
@@ -595,10 +595,3 @@ SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
 	}
 	return ret;
 }
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
-{
-	return SYSC_readahead((int) fd, offset, (size_t) count);
-}
-SYSCALL_ALIAS(sys_readahead, SyS_readahead);
-#endif
