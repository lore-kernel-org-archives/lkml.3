Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3IQGSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 02:18:23 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:42591 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3IQGSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 02:18:20 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>
Subject: [RFC PATCH REBASED 2/3] x86: Move fpu_counter into ARCH specific thread_struct
Date: Tue, 17 Sep 2013 11:47:18 +0530
Message-ID: <1379398639-27403-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379398639-27403-1-git-send-email-vgupta@synopsys.com>
References: <1379398639-27403-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a couple of arches (sh/x86) use fpu_counter in task_struct so it
can be moved out into ARCH specific thread_struct, reducing the size of
task_struct for other arches.

Compile tested i386_defconfig + gcc 4.7.3

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Vincent Palatin <vpalatin@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Pekka Riikonen <priikone@iki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/fpu-internal.h | 10 +++++-----
 arch/x86/include/asm/processor.h    |  9 +++++++++
 arch/x86/kernel/i387.c              |  2 +-
 arch/x86/kernel/process_32.c        |  4 ++--
 arch/x86/kernel/process_64.c        |  2 +-
 arch/x86/kernel/traps.c             |  2 +-
 6 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 4d0bda7..c49a613 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -365,7 +365,7 @@ static inline void drop_fpu(struct task_struct *tsk)
 	 * Forget coprocessor state..
 	 */
 	preempt_disable();
-	tsk->fpu_counter = 0;
+	tsk->thread.fpu_counter = 0;
 	__drop_fpu(tsk);
 	clear_used_math();
 	preempt_enable();
@@ -424,7 +424,7 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 	 * or if the past 5 consecutive context-switches used math.
 	 */
 	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
-					     new->fpu_counter > 5);
+					     new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -433,16 +433,16 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 
 		/* Don't change CR0.TS if we just switch! */
 		if (fpu.preload) {
-			new->fpu_counter++;
+			new->thread.fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
 		} else if (!use_eager_fpu())
 			stts();
 	} else {
-		old->fpu_counter = 0;
+		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
-			new->fpu_counter++;
+			new->thread.fpu_counter++;
 			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 987c75e..7b034a4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -488,6 +488,15 @@ struct thread_struct {
 	unsigned long		iopl;
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
 };
 
 /*
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 5d576ab..e8368c6 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -100,7 +100,7 @@ void unlazy_fpu(struct task_struct *tsk)
 		__save_init_fpu(tsk);
 		__thread_fpu_end(tsk);
 	} else
-		tsk->fpu_counter = 0;
+		tsk->thread.fpu_counter = 0;
 	preempt_enable();
 }
 EXPORT_SYMBOL(unlazy_fpu);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 884f98f..6af43b0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -153,7 +153,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->fpu_counter = 0;
+		p->thread.fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
@@ -166,7 +166,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->fpu_counter = 0;
+	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bb1dc51..bbab295 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -163,7 +163,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->fpu_counter = 0;
+	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8c8093b..64b980f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -653,7 +653,7 @@ void math_state_restore(void)
 		return;
 	}
 
-	tsk->fpu_counter++;
+	tsk->thread.fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-- 
1.8.1.2

