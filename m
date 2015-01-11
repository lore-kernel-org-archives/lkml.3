Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbbAKWFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:33 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38176 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbAKWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:09 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 02/11] x86,fpu: replace fpu_switch_t with a thread flag
Date: Sun, 11 Jan 2015 16:46:24 -0500
Message-Id: <1421012793-30106-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Replace fpu_switch_t with a thread flag, in preparation for only
restoring the FPU state on return to user space.

I have left the code around fpu_lazy_restore intact, even though
there appears to be no protection against races with eg. ptrace,
and the optimization appears equally valid with eager fpu mode.
This is addressed later in the series.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 38 +++++++++++++------------------------
 arch/x86/include/asm/thread_info.h  |  4 +++-
 arch/x86/kernel/process_32.c        |  5 ++---
 arch/x86/kernel/process_64.c        |  5 ++---
 4 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e97622f..5f8f971 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -385,20 +385,6 @@ static inline void drop_init_fpu(struct task_struct *tsk)
 }
 
 /*
- * FPU state switching for scheduling.
- *
- * This is a two-stage process:
- *
- *  - switch_fpu_prepare() saves the old state and
- *    sets the new state of the CR0.TS bit. This is
- *    done within the context of the old process.
- *
- *  - switch_fpu_finish() restores the new state as
- *    necessary.
- */
-typedef struct { int preload; } fpu_switch_t;
-
-/*
  * Must be run with preemption disabled: this clears the fpu_owner_task,
  * on this CPU.
  *
@@ -416,15 +402,13 @@ static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 		cpu == new->thread.fpu.last_cpu;
 }
 
-static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
+static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
 {
-	fpu_switch_t fpu;
-
 	/*
 	 * If the task has used the math, pre-load the FPU on xsave processors
 	 * or if the past 5 consecutive context-switches used math.
 	 */
-	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
+	bool preload = tsk_used_math(new) && (use_eager_fpu() ||
 					     new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
@@ -433,8 +417,9 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
 
 		/* Don't change CR0.TS if we just switch! */
-		if (fpu.preload) {
+		if (preload) {
 			new->thread.fpu_counter++;
+			set_thread_flag(TIF_LOAD_FPU);
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
 		} else if (!use_eager_fpu())
@@ -442,16 +427,19 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 	} else {
 		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
-		if (fpu.preload) {
+		if (preload) {
 			new->thread.fpu_counter++;
 			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
-				fpu.preload = 0;
-			else
+				/* XXX: is this safe against ptrace??? */
+				__thread_fpu_begin(new);
+			else {
 				prefetch(new->thread.fpu.state);
+				set_thread_flag(TIF_LOAD_FPU);
+			}
 			__thread_fpu_begin(new);
 		}
+		/* else: CR0.TS is still set from a previous FPU switch */
 	}
-	return fpu;
 }
 
 /*
@@ -460,9 +448,9 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
  * state - all we need to do is to conditionally restore the register
  * state itself.
  */
-static inline void switch_fpu_finish(struct task_struct *new, fpu_switch_t fpu)
+static inline void switch_fpu_finish(struct task_struct *new)
 {
-	if (fpu.preload) {
+	if (test_and_clear_thread_flag(TIF_LOAD_FPU)) {
 		if (unlikely(restore_fpu_checking(new)))
 			drop_init_fpu(new);
 	}
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 547e344..077fcd9 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -91,6 +91,7 @@ struct thread_info {
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
 #define TIF_X32			30	/* 32-bit native x86-64 binary */
+#define TIF_LOAD_FPU		31	/* load FPU on return to userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -115,6 +116,7 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_ADDR32		(1 << TIF_ADDR32)
 #define _TIF_X32		(1 << TIF_X32)
+#define _TIF_LOAD_FPU		(1 << TIF_LOAD_FPU)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -141,7 +143,7 @@ struct thread_info {
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
+	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE | _TIF_LOAD_FPU)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8f3ebfe..c4b00e6 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -249,11 +249,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 				 *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
-	fpu_switch_t fpu;
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
+	switch_fpu_prepare(prev_p, next_p, cpu);
 
 	/*
 	 * Reload esp0.
@@ -320,7 +319,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (prev->gs | next->gs)
 		lazy_load_gs(next->gs);
 
-	switch_fpu_finish(next_p, fpu);
+	switch_fpu_finish(next_p);
 
 	this_cpu_write(current_task, next_p);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3ed4a68..ee3824f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -279,9 +279,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
-	fpu_switch_t fpu;
 
-	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
+	switch_fpu_prepare(prev_p, next_p, cpu);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
@@ -351,7 +350,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 	prev->gsindex = gsindex;
 
-	switch_fpu_finish(next_p, fpu);
+	switch_fpu_finish(next_p);
 
 	/*
 	 * Switch the PDA and FPU contexts.
-- 
1.9.3

