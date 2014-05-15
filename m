Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaEOVVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:21:41 -0400
Received: from madhathacker.net ([178.63.244.10]:60269 "EHLO madhathacker.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbaEOVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:21:03 -0400
Date: Thu, 15 May 2014 23:10:04 +0200
From: Erik Bosman <erik@minemu.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: SROP mitigation: implement signal canaries
Message-ID: <20140515211004.GA9575@pizzadoos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch implements signal canaries for x86-64, x86-32 and x32.

Signed-off-by: Erik Bosman <erik@minemu.org>

---
 arch/x86/Kconfig                |  1 +
 arch/x86/ia32/ia32_signal.c     | 27 +++++++++++++++++++++++++++
 arch/x86/include/asm/sigframe.h | 12 ++++++++++++
 arch/x86/kernel/signal.c        | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..83eea28 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -128,6 +128,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select HAVE_SIGNAL_CANARY
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
 
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 2206757..1a9285a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -212,9 +212,18 @@ asmlinkage long sys32_sigreturn(void)
 	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
 	sigset_t set;
 	unsigned int ax;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
+
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
+		goto badframe;
+#endif
+
 	if (__get_user(set.sig[0], &frame->sc.oldmask)
 	    || (_COMPAT_NSIG_WORDS > 1
 		&& __copy_from_user((((char *) &set.sig) + 4),
@@ -239,11 +248,20 @@ asmlinkage long sys32_rt_sigreturn(void)
 	struct rt_sigframe_ia32 __user *frame;
 	sigset_t set;
 	unsigned int ax;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 
 	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
+
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
+		goto badframe;
+#endif
+
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
@@ -378,6 +396,11 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__put_user(current->signal_canary, &frame->canary))
+		return -EFAULT;
+#endif
+
 	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 		restorer = ksig->ka.sa.sa_restorer;
 	} else {
@@ -459,6 +482,10 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 		put_user_ex(0, &frame->uc.uc_link);
 		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
+#ifdef CONFIG_SIGNAL_CANARY
+		put_user_ex(current->signal_canary, &frame->canary);
+#endif
+
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		else
diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
index 7c7c27c..6af4a9a 100644
--- a/arch/x86/include/asm/sigframe.h
+++ b/arch/x86/include/asm/sigframe.h
@@ -39,6 +39,9 @@ struct sigframe_ia32 {
 	unsigned long extramask[_NSIG_WORDS-1];
 #endif /* CONFIG_IA32_EMULATION */
 	char retcode[8];
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 	/* fp state follows here */
 };
 
@@ -54,6 +57,9 @@ struct rt_sigframe_ia32 {
 #endif /* CONFIG_IA32_EMULATION */
 	struct ucontext_ia32 uc;
 	char retcode[8];
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 	/* fp state follows here */
 };
 #endif /* defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION) */
@@ -64,6 +70,9 @@ struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 	/* fp state follows here */
 };
 
@@ -73,6 +82,9 @@ struct rt_sigframe_x32 {
 	u64 pretcode;
 	struct ucontext_x32 uc;
 	compat_siginfo_t info;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 	/* fp state follows here */
 };
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de68..0cc4556 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -297,6 +297,11 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 			return -EFAULT;
 	}
 
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__put_user(current->signal_canary, &frame->canary))
+		return -EFAULT;
+#endif
+
 	if (current->mm->context.vdso)
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
 	else
@@ -360,6 +365,9 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		put_user_ex(0, &frame->uc.uc_link);
 		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
+#ifdef CONFIG_SIGNAL_CANARY
+		put_user_ex(current->signal_canary, &frame->canary);
+#endif
 		/* Set up to return from userspace.  */
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
@@ -425,6 +433,9 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		put_user_ex(0, &frame->uc.uc_link);
 		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
+#ifdef CONFIG_SIGNAL_CANARY
+		put_user_ex(current->signal_canary, &frame->canary);
+#endif
 		/* Set up to return from userspace.  If provided, use a stub
 		   already in userspace.  */
 		/* x86-64 should always use SA_RESTORER. */
@@ -493,6 +504,10 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 		put_user_ex(0, &frame->uc.uc__pad0);
 
+#ifdef CONFIG_SIGNAL_CANARY
+		put_user_ex(current->signal_canary, &frame->canary);
+#endif
+
 		if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 			restorer = ksig->ka.sa.sa_restorer;
 		} else {
@@ -539,11 +554,20 @@ asmlinkage unsigned long sys_sigreturn(void)
 	struct sigframe __user *frame;
 	unsigned long ax;
 	sigset_t set;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 
 	frame = (struct sigframe __user *)(regs->sp - 8);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
+
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
+		goto badframe;
+#endif
+
 	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
 		&& __copy_from_user(&set.sig[1], &frame->extramask,
 				    sizeof(frame->extramask))))
@@ -568,10 +592,19 @@ asmlinkage long sys_rt_sigreturn(void)
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
 	sigset_t set;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 
 	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
+
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
+		goto badframe;
+#endif
+
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
@@ -780,6 +813,9 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 	struct rt_sigframe_x32 __user *frame;
 	sigset_t set;
 	unsigned long ax;
+#ifdef CONFIG_SIGNAL_CANARY
+	u32 canary;
+#endif
 
 	frame = (struct rt_sigframe_x32 __user *)(regs->sp - 8);
 
@@ -788,6 +824,11 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
+#ifdef CONFIG_SIGNAL_CANARY
+	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
+		goto badframe;
+#endif
+
 	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
-- 
1.9.1

