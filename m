Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaJMHim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:38:42 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45262 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaJMHih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:38:37 -0400
Date: Mon, 13 Oct 2014 09:38:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu tree changes for v3.18
Message-ID: <20141013073833.GA14790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-fpu-for-linus

   # HEAD: 6f46b3aef0031c08a7b439d63013dad2aeb093b2 x86: copy_thread: Don't nullify ->ptrace_bps twice

x86 FPU handling fixes, cleanups and enhancements from Oleg.

The signal handling race fix and the __restore_xstate_sig() 
preemption fix for eager-mode is marked for -stable as well.

 Thanks,

	Ingo

------------------>
Oleg Nesterov (7):
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()
      x86, fpu: Change __thread_fpu_begin() to use use_eager_fpu()
      x86, fpu: copy_process: Avoid fpu_alloc/copy if !used_math()
      x86, fpu: copy_process: Sanitize fpu->last_cpu initialization
      x86, fpu: Shift "fpu_counter = 0" from copy_thread() to arch_dup_task_struct()
      x86: copy_thread: Don't nullify ->ptrace_bps twice


 arch/x86/include/asm/fpu-internal.h |  2 +-
 arch/x86/kernel/process.c           | 16 +++++++++-------
 arch/x86/kernel/process_32.c        |  6 +-----
 arch/x86/kernel/process_64.c        |  3 ---
 arch/x86/kernel/signal.c            |  5 +++++
 arch/x86/kernel/xsave.c             |  7 ++++---
 6 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 412ececa00b9..e97622f57722 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -344,7 +344,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!static_cpu_has_safe(X86_FEATURE_EAGER_FPU))
+	if (!use_eager_fpu())
 		clts();
 	__thread_set_has_fpu(tsk);
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f804dc935d2a..e127ddaa2d5a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -64,14 +64,16 @@ EXPORT_SYMBOL_GPL(task_xstate_cachep);
  */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	int ret;
-
 	*dst = *src;
-	if (fpu_allocated(&src->thread.fpu)) {
-		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
-		ret = fpu_alloc(&dst->thread.fpu);
-		if (ret)
-			return ret;
+
+	dst->thread.fpu_counter = 0;
+	dst->thread.fpu.has_fpu = 0;
+	dst->thread.fpu.last_cpu = ~0;
+	dst->thread.fpu.state = NULL;
+	if (tsk_used_math(src)) {
+		int err = fpu_alloc(&dst->thread.fpu);
+		if (err)
+			return err;
 		fpu_copy(dst, src);
 	}
 	return 0;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7bc86bbe7485..8f3ebfe710d0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -138,6 +138,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
+	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
@@ -152,9 +153,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->thread.fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
-		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -165,13 +164,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
 
-	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
-
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
 						IO_BITMAP_BYTES, GFP_KERNEL);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca5b02d405c3..3ed4a68d4013 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -163,7 +163,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
@@ -193,8 +192,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->sp = sp;
 
 	err = -ENOMEM;
-	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
-
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
 						  IO_BITMAP_BYTES, GFP_KERNEL);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 2851d63c1202..ed37a768d0fc 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -675,6 +675,11 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 		 * handler too.
 		 */
 		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
+		/*
+		 * Ensure the signal handler starts with the new fpu state.
+		 */
+		if (used_math())
+			drop_init_fpu(current);
 	}
 	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 940b142cc11f..4c540c4719d8 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -271,8 +271,6 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (use_fxsr() && save_xstate_epilog(buf_fx, ia32_fxstate))
 		return -1;
 
-	drop_init_fpu(tsk);	/* trigger finit */
-
 	return 0;
 }
 
@@ -402,8 +400,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 			set_used_math();
 		}
 
-		if (use_eager_fpu())
+		if (use_eager_fpu()) {
+			preempt_disable();
 			math_state_restore();
+			preempt_enable();
+		}
 
 		return err;
 	} else {
