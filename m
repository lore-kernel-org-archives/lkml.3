Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3IAVqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 17:46:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3IAVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 17:46:08 -0400
Date: Sun, 1 Sep 2013 14:45:56 -0700
From: tip-bot for Al Viro <tipbot@zytor.com>
Message-ID: <tip-es5p6y64if71k8p5u08agv9n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viro@ZenIV.linux.org.uk, tglx@linutronix.de, viro@ZenIV.linux.org.uk,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, tglx@linutronix.de, hpa@linux.intel.com,
        viro@ZenIV.linux.org.uk
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] Introduce [compat_]save_altstack_ex()
  to unbreak x86 SMAP
Git-Commit-ID: bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 01 Sep 2013 14:46:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5
Gitweb:     http://git.kernel.org/tip/bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5
Author:     Al Viro <viro@ZenIV.linux.org.uk>
AuthorDate: Sun, 1 Sep 2013 20:35:01 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 1 Sep 2013 14:16:33 -0700

Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

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
Cc: <stable@vger.kernel.org> # v3.8+
Link: http://lkml.kernel.org/n/tip-es5p6y64if71k8p5u08agv9n@git.kernel.org
---
 arch/x86/ia32/ia32_signal.c | 2 +-
 arch/x86/kernel/signal.c    | 6 +++---
 include/linux/compat.h      | 7 +++++++
 include/linux/signal.h      | 8 ++++++++
 4 files changed, 19 insertions(+), 4 deletions(-)

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
