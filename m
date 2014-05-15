Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaEOVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:21:40 -0400
Received: from madhathacker.net ([178.63.244.10]:60271 "EHLO madhathacker.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaEOVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:21:03 -0400
Date: Thu, 15 May 2014 23:11:46 +0200
From: Erik Bosman <erik@minemu.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: SROP mitigation: implement signal counting
Message-ID: <20140515211146.GA9617@pizzadoos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch implements signal counting for x86-64, x86-32 and x32.

Signed-off-by: Erik Bosman <erik@minemu.org>

---
 arch/x86/Kconfig            |  1 +
 arch/x86/ia32/ia32_signal.c | 10 ++++++++++
 arch/x86/kernel/signal.c    | 19 +++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 83eea28..82d779f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -129,6 +129,7 @@ config X86
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
 	select HAVE_SIGNAL_CANARY
+	select HAVE_SIGNAL_BOOKKEEPING
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
 
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 1a9285a..5b95c26 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -219,6 +219,11 @@ asmlinkage long sys32_sigreturn(void)
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+    if (signals_in_progress_dec(current))
+        goto badframe;
+#endif
+
 #ifdef CONFIG_SIGNAL_CANARY
 	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
 		goto badframe;
@@ -257,6 +262,11 @@ asmlinkage long sys32_rt_sigreturn(void)
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+    if (signals_in_progress_dec(current))
+        goto badframe;
+#endif
+
 #ifdef CONFIG_SIGNAL_CANARY
 	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
 		goto badframe;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 0cc4556..5f51e8c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -558,6 +558,11 @@ asmlinkage unsigned long sys_sigreturn(void)
 	u32 canary;
 #endif
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	if (signals_in_progress_dec(current))
+		goto badframe;
+#endif
+
 	frame = (struct sigframe __user *)(regs->sp - 8);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -600,6 +605,11 @@ asmlinkage long sys_rt_sigreturn(void)
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	if (signals_in_progress_dec(current))
+		goto badframe;
+#endif
+
 #ifdef CONFIG_SIGNAL_CANARY
 	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
 		goto badframe;
@@ -708,6 +718,10 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
 	}
 	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
+
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	signals_in_progress_inc(current);
+#endif
 }
 
 #ifdef CONFIG_X86_32
@@ -824,6 +838,11 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	if (signals_in_progress_dec(current))
+		goto badframe;
+#endif
+
 #ifdef CONFIG_SIGNAL_CANARY
 	if (__get_user(canary, &frame->canary) || (canary != current->signal_canary))
 		goto badframe;
-- 
1.9.1

