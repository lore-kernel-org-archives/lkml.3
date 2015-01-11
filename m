Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbbAKWFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:41 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38184 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbAKWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:24 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to userspace
Date: Sun, 11 Jan 2015 16:46:26 -0500
Message-Id: <1421012793-30106-5-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Defer restoring the FPU state, if so desired, until the task returns to
userspace.

In case of kernel threads, KVM VCPU threads, and tasks performing longer
running operations in kernel space, this could mean skipping the FPU state
restore entirely for several context switches.

This also allows the kernel to preserve the FPU state of a userspace task
that gets interrupted by a kernel thread in kernel mode.

If the old task left TIF_LOAD_FPU set, and the new task does not want
an FPU state restore (or does not have an FPU state), clear the flag
to prevent attempted restoring of a non-existent FPU state.

TODO: remove superfluous irq disabling from entry_{32,64}.S, Andy has
some conflicting changes in that part of the code, so wait with that.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 33 +++++++++++++++++++++------------
 arch/x86/kernel/process_32.c        |  2 --
 arch/x86/kernel/process_64.c        |  2 --
 arch/x86/kernel/signal.c            |  9 +++++++++
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 27556f4..539b050 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -382,6 +382,7 @@ static inline void drop_init_fpu(struct task_struct *tsk)
 		else
 			fxrstor_checking(&init_xstate_buf->i387);
 	}
+	clear_thread_flag(TIF_LOAD_FPU);
 }
 
 /*
@@ -435,24 +436,32 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 				prefetch(new->thread.fpu.state);
 				set_thread_flag(TIF_LOAD_FPU);
 			}
-		}
-		/* else: CR0.TS is still set from a previous FPU switch */
+		} else
+			/*
+			 * The new task does not want an FPU state restore,
+			 * and may not even have an FPU state. However, the
+			 * old task may have left TIF_LOAD_FPU set.
+			 * Clear it to avoid trouble.
+			 *
+			 * CR0.TS is still set from a previous FPU switch
+			 */
+			clear_thread_flag(TIF_LOAD_FPU);
 	}
 }
 
 /*
- * By the time this gets called, we've already cleared CR0.TS and
- * given the process the FPU if we are going to preload the FPU
- * state - all we need to do is to conditionally restore the register
- * state itself.
+ * This is called if and when the task returns to userspace.
+ * Clear CR0.TS if necessary, so the task can access the FPU register
+ * state this function restores.
  */
-static inline void switch_fpu_finish(struct task_struct *new)
+static inline void switch_fpu_finish(void)
 {
-	if (test_and_clear_thread_flag(TIF_LOAD_FPU)) {
-		__thread_fpu_begin(new);
-		if (unlikely(restore_fpu_checking(new)))
-			drop_init_fpu(new);
-	}
+	struct task_struct *tsk = current;
+
+	__thread_fpu_begin(tsk);
+
+	if (unlikely(restore_fpu_checking(tsk)))
+		drop_init_fpu(tsk);
 }
 
 /*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c4b00e6..4da02ae 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -319,8 +319,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (prev->gs | next->gs)
 		lazy_load_gs(next->gs);
 
-	switch_fpu_finish(next_p);
-
 	this_cpu_write(current_task, next_p);
 
 	return prev_p;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ee3824f..20e206e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -350,8 +350,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 	prev->gsindex = gsindex;
 
-	switch_fpu_finish(next_p);
-
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index ed37a76..46e3008 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -761,6 +761,15 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		fire_user_return_notifiers();
 
 	user_enter();
+
+	/*
+	 * Test thread flag, as the signal code may have cleared TIF_LOAD_FPU.
+	 * We cannot reschedule after loading the FPU state back into the CPU.
+	 * IRQs will be re-enabled on the switch to userspace.
+	 */
+	local_irq_disable();
+	if (test_thread_flag(TIF_LOAD_FPU))
+		switch_fpu_finish();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
-- 
1.9.3

