Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab3ICTUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:20:06 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35742 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403Ab3ICTUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:20:01 -0400
Date: Tue, 3 Sep 2013 21:19:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/smap changes for v3.12
Message-ID: <20130903191957.GA1272@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-smap-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-smap-for-linus

   HEAD: bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5 Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

Fixes for Intel SMAP support, to fix SIGSEGVs during bootup.

out-of-topic modifications in x86-smap-for-linus:
-------------------------------------------------
include/linux/compat.h             # bd1c149: Introduce [compat_]save_altstack_
include/linux/signal.h             # bd1c149: Introduce [compat_]save_altstack_

 Thanks,

	Ingo

------------------>
Al Viro (1):
      Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

H. Peter Anvin (1):
      x86, smap: Handle csum_partial_copy_*_user()


 arch/x86/ia32/ia32_signal.c        |  2 +-
 arch/x86/include/asm/checksum_32.h | 22 +++++++++++++++++-----
 arch/x86/kernel/signal.c           |  6 +++---
 arch/x86/lib/csum-wrappers_64.c    | 12 ++++++++++--
 include/linux/compat.h             |  7 +++++++
 include/linux/signal.h             |  8 ++++++++
 6 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index bccfca6..665a730 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -457,7 +457,7 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __compat_save_altstack(&frame->uc.uc_stack, regs->sp);
+		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 46fc474..f50de69 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -49,9 +49,15 @@ static inline __wsum csum_partial_copy_from_user(const void __user *src,
 						 int len, __wsum sum,
 						 int *err_ptr)
 {
+	__wsum ret;
+
 	might_sleep();
-	return csum_partial_copy_generic((__force void *)src, dst,
-					 len, sum, err_ptr, NULL);
+	stac();
+	ret = csum_partial_copy_generic((__force void *)src, dst,
+					len, sum, err_ptr, NULL);
+	clac();
+
+	return ret;
 }
 
 /*
@@ -176,10 +182,16 @@ static inline __wsum csum_and_copy_to_user(const void *src,
 					   int len, __wsum sum,
 					   int *err_ptr)
 {
+	__wsum ret;
+
 	might_sleep();
-	if (access_ok(VERIFY_WRITE, dst, len))
-		return csum_partial_copy_generic(src, (__force void *)dst,
-						 len, sum, NULL, err_ptr);
+	if (access_ok(VERIFY_WRITE, dst, len)) {
+		stac();
+		ret = csum_partial_copy_generic(src, (__force void *)dst,
+						len, sum, NULL, err_ptr);
+		clac();
+		return ret;
+	}
 
 	if (len)
 		*err_ptr = -EFAULT;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cf91358..d859eea 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -358,7 +358,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  */
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -423,7 +423,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  If provided, use a stub
 		   already in userspace.  */
@@ -490,7 +490,7 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __compat_save_altstack(&frame->uc.uc_stack, regs->sp);
+		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 		put_user_ex(0, &frame->uc.uc__pad0);
 
 		if (ksig->ka.sa.sa_flags & SA_RESTORER) {
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 25b7ae8..7609e0e 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -6,6 +6,7 @@
  */
 #include <asm/checksum.h>
 #include <linux/module.h>
+#include <asm/smap.h>
 
 /**
  * csum_partial_copy_from_user - Copy and checksum from user space.
@@ -52,8 +53,10 @@ csum_partial_copy_from_user(const void __user *src, void *dst,
 			len -= 2;
 		}
 	}
+	stac();
 	isum = csum_partial_copy_generic((__force const void *)src,
 				dst, len, isum, errp, NULL);
+	clac();
 	if (unlikely(*errp))
 		goto out_err;
 
@@ -82,6 +85,8 @@ __wsum
 csum_partial_copy_to_user(const void *src, void __user *dst,
 			  int len, __wsum isum, int *errp)
 {
+	__wsum ret;
+
 	might_sleep();
 
 	if (unlikely(!access_ok(VERIFY_WRITE, dst, len))) {
@@ -105,8 +110,11 @@ csum_partial_copy_to_user(const void *src, void __user *dst,
 	}
 
 	*errp = 0;
-	return csum_partial_copy_generic(src, (void __force *)dst,
-					 len, isum, NULL, errp);
+	stac();
+	ret = csum_partial_copy_generic(src, (void __force *)dst,
+					len, isum, NULL, errp);
+	clac();
+	return ret;
 }
 EXPORT_SYMBOL(csum_partial_copy_to_user);
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 7f0c1dd..ec1aee4 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -669,6 +669,13 @@ asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
 
 int compat_restore_altstack(const compat_stack_t __user *uss);
 int __compat_save_altstack(compat_stack_t __user *, unsigned long);
+#define compat_save_altstack_ex(uss, sp) do { \
+	compat_stack_t __user *__uss = uss; \
+	struct task_struct *t = current; \
+	put_user_ex(ptr_to_compat((void __user *)t->sas_ss_sp), &__uss->ss_sp); \
+	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
+} while (0);
 
 asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 						 struct compat_timespec __user *interval);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index d897484..2ac423b 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -434,6 +434,14 @@ void signals_init(void);
 int restore_altstack(const stack_t __user *);
 int __save_altstack(stack_t __user *, unsigned long);
 
+#define save_altstack_ex(uss, sp) do { \
+	stack_t __user *__uss = uss; \
+	struct task_struct *t = current; \
+	put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
+	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
+} while (0);
+
 #ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void render_sigset_t(struct seq_file *, const char *, sigset_t *);
