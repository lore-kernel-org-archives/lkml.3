Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbAKWFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:11 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38174 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAKWFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:06 -0500
X-Greylist: delayed 1105 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2015 17:05:06 EST
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 11/11] (BROKEN) x86,fpu: broken signal handler stack setup
Date: Sun, 11 Jan 2015 16:46:33 -0500
Message-Id: <1421012793-30106-12-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The previous patches result in situations where the FPU state
for a task is not present in the FPU registers, when using eager
fpu mode. The signal frame setup and restore code needs to be
adjusted to deal with that situation.

Without this patch, the signal handler stack setup is broken.

With it, it is still broken.

However, I have been staring at it for too long to figure out
why. This patch needs other eyeballs.

In other words: HELP!

The LTP signal handling tests all seem to pass, but SPECjbb2005
crashes in minutes in the signal handler code:

#
# A fatal error has been detected by the Java Runtime Environment:
#
#  SIGSEGV (0xb) at pc=0x00007f4df1f3e753, pid=1711, tid=139972332160768
#
# JRE version: OpenJDK Runtime Environment (8.0) (build 1.8.0-internal-0)
# Java VM: OpenJDK 64-Bit Server VM (25.0-b57-internal mixed mode linux-amd64 compressed oops)
# Problematic frame:
# V  [libjvm.so+0x854753]  JVM_handle_linux_signal+0x5e193

Not-signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 31 +++++++++++++++++-----------
 arch/x86/kernel/xsave.c             | 41 ++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 095dacc..ac45074 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -358,6 +358,8 @@ static inline void __drop_fpu(struct task_struct *tsk)
 			     _ASM_EXTABLE(1b, 2b));
 		__thread_fpu_end(tsk);
 	}
+	/* disable lazy fpu restore */
+	tsk->thread.fpu.last_cpu = ~0;
 }
 
 static inline void drop_fpu(struct task_struct *tsk)
@@ -377,12 +379,12 @@ static inline void drop_init_fpu(struct task_struct *tsk)
 	if (!use_eager_fpu())
 		drop_fpu(tsk);
 	else {
-		if (use_xsave())
-			xrstor_state(init_xstate_buf, -1);
-		else
-			fxrstor_checking(&init_xstate_buf->i387);
+		preempt_disable();
+		__thread_fpu_end(tsk);
+		fpu_finit(&tsk->thread.fpu);
+		set_thread_flag(TIF_LOAD_FPU);
+		preempt_enable();
 	}
-	clear_thread_flag(TIF_LOAD_FPU);
 }
 
 /*
@@ -467,7 +469,7 @@ static inline void switch_fpu_finish(void)
 	if (fpu_lazy_restore(tsk, raw_smp_processor_id()))
 		return;
 
-	if (unlikely(restore_fpu_checking(tsk)))
+	if (restore_fpu_checking(tsk))
 		drop_init_fpu(tsk);
 }
 
@@ -525,16 +527,21 @@ static inline void __save_fpu(struct task_struct *tsk)
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
-	WARN_ON_ONCE(!__thread_has_fpu(tsk));
+	preempt_disable();
 
-	if (use_eager_fpu()) {
+	if (unlikely(!__thread_has_fpu(tsk)))
+		goto out;
+
+	if (use_eager_fpu())
 		__save_fpu(tsk);
-		return;
-	}
+	else
+		__save_init_fpu(tsk);
 
-	preempt_disable();
-	__save_init_fpu(tsk);
 	__thread_fpu_end(tsk);
+
+ out:
+	/* disable lazy fpu restore */
+	tsk->thread.fpu.last_cpu = ~0;
 	preempt_enable();
 }
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4c540c4..5434491 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -251,18 +251,13 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 			sizeof(struct user_i387_ia32_struct), NULL,
 			(struct _fpstate_ia32 __user *) buf) ? -1 : 1;
 
-	if (user_has_fpu()) {
-		/* Save the live register state to the user directly. */
-		if (save_user_xstate(buf_fx))
-			return -1;
-		/* Update the thread's fxstate to save the fsave header. */
-		if (ia32_fxstate)
-			fpu_fxsave(&tsk->thread.fpu);
-	} else {
-		sanitize_i387_state(tsk);
-		if (__copy_to_user(buf_fx, xsave, xstate_size))
-			return -1;
-	}
+	/* Atomically save the FPU state from registers. */
+	save_init_fpu(tsk);
+
+	/* Then copy it to userspace. */
+	sanitize_i387_state(tsk);
+	if (__copy_to_user(buf_fx, xsave, xstate_size))
+		return -1;
 
 	/* Save the fsave header for the 32-bit frames. */
 	if ((ia32_fxstate || !use_fxsr()) && save_fsave_header(tsk, buf))
@@ -400,23 +395,27 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 			set_used_math();
 		}
 
-		if (use_eager_fpu()) {
-			preempt_disable();
-			math_state_restore();
-			preempt_enable();
-		}
+		if (use_eager_fpu())
+			set_thread_flag(TIF_LOAD_FPU);
 
 		return err;
 	} else {
+		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
 		/*
-		 * For 64-bit frames and 32-bit fsave frames, restore the user
-		 * state to the registers directly (with exceptions handled).
+		 * Copy the xstate from user space into the kernel buffer.
+		 * Clear task used math during the operation, to ensure the
+		 * context switching code does not overwrite the xstate buffer
+		 * with whatever is in the FPU registers.
 		 */
-		user_fpu_begin();
-		if (restore_user_xstate(buf_fx, xstate_bv, fx_only)) {
+		drop_fpu(tsk);
+		if (__copy_from_user(xsave, buf_fx, state_size)) {
 			drop_init_fpu(tsk);
 			return -1;
 		}
+		set_used_math();
+
+		if (use_eager_fpu())
+			set_thread_flag(TIF_LOAD_FPU);
 	}
 
 	return 0;
-- 
1.9.3

