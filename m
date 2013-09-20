Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3ITUNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:13:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3ITUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 55/93] Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP
Date: Fri, 20 Sep 2013 13:08:50 -0700
Message-Id: <1379707768-1804-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5 upstream.

For performance reasons, when SMAP is in use, SMAP is left open for an
entire put_user_try { ... } put_user_catch(); block, however, calling
__put_user() in the middle of that block will close SMAP as the
STAC..CLAC constructs intentionally do not nest.

Furthermore, using __put_user() rather than put_user_ex() here is bad
for performance.

Thus, introduce new [compat_]save_altstack_ex() helpers that replace
__[compat_]save_altstack() for x86, being currently the only
architecture which supports put_user_try { ... } put_user_catch().

Reported-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-es5p6y64if71k8p5u08agv9n@git.kernel.org
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/ia32/ia32_signal.c | 2 +-
 arch/x86/kernel/signal.c    | 6 +++---
 include/linux/compat.h      | 7 +++++++
 include/linux/signal.h      | 8 ++++++++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index a1daf4a..fb53906 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -467,7 +467,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __compat_save_altstack(&frame->uc.uc_stack, regs->sp);
+		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d6bf1f3..1697f73 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -364,7 +364,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  */
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -429,7 +429,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  If provided, use a stub
 		   already in userspace.  */
@@ -496,7 +496,7 @@ static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 		else
 			put_user_ex(0, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
-		err |= __compat_save_altstack(&frame->uc.uc_stack, regs->sp);
+		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 		put_user_ex(0, &frame->uc.uc__pad0);
 
 		if (ka->sa.sa_flags & SA_RESTORER) {
diff --git a/include/linux/compat.h b/include/linux/compat.h
index dec7e2d..98ac3c5 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -648,6 +648,13 @@ asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
 
 int compat_restore_altstack(const compat_stack_t __user *uss);
 int __compat_save_altstack(compat_stack_t __user *, unsigned long);
+#define compat_save_altstack_ex(uss, sp) do { \
+	compat_stack_t __user *__uss = uss; \
+	struct task_struct *t = current; \
+	put_user_ex(ptr_to_compat((void __user *)t->sas_ss_sp), &__uss->ss_sp); \
+	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
+} while (0);
 #endif
 
 asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 0a89ffc..b50aa60 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -388,4 +388,12 @@ void signals_init(void);
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
 #endif /* _LINUX_SIGNAL_H */
-- 
1.8.1.2

