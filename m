Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbbAWUwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:52:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbbAWUwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:52:05 -0500
Date: Fri, 23 Jan 2015 15:51:49 -0500
From: Rik van Riel <riel@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: [PATCH, RFC] x86,fpu: make signal handling xstate save & restore
 preemption safe
Message-ID: <20150123155149.4652f0ce@cuia.bos.redhat.com>
In-Reply-To: <54C2A245.4010307@redhat.com>
References: <54C2A245.4010307@redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saving xstate directly to userspace, or restoring it directly from
userspace could result in a page fault, which can lead to the task
context switching and sleeping.

There is no guarantee that after the context switch the FPU state
for the task will be loaded back into the FPU registers, and it
looks like that could potentially cause corruption of the FPU
state.

The straightforward solution is to do the FPU save and restore
with preemption disabled, which requires using a kernel buffer.
That in turn allows us to use the same save and restore routines
that are used at context switch and math exception time, allowing
us to remove the direct-to-userspace variants.

I have only tested this code as part of my larger FPU optimization
series, not yet stand-alone.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 14 ++++----
 arch/x86/kernel/xsave.c             | 72 ++++++++++---------------------------
 2 files changed, 26 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 68089ef86907..724f3e4faf34 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -508,16 +508,18 @@ static inline void __save_fpu(struct task_struct *tsk)
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
-	WARN_ON_ONCE(!__thread_has_fpu(tsk));
+	preempt_disable();
+
+	if (!__thread_has_fpu(tsk))
+		goto out;
 
-	if (use_eager_fpu()) {
+	if (use_eager_fpu())
 		__save_fpu(tsk);
-		return;
-	}
+	else
+		__save_init_fpu(tsk);
 
-	preempt_disable();
-	__save_init_fpu(tsk);
 	__thread_fpu_end(tsk);
+ out:
 	preempt_enable();
 }
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index de9dcf89a302..fc2d30c75e64 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -198,22 +198,6 @@ static inline int save_xstate_epilog(void __user *buf, int ia32_frame)
 	return err;
 }
 
-static inline int save_user_xstate(struct xsave_struct __user *buf)
-{
-	int err;
-
-	if (use_xsave())
-		err = xsave_user(buf);
-	else if (use_fxsr())
-		err = fxsave_user((struct i387_fxsave_struct __user *) buf);
-	else
-		err = fsave_user((struct i387_fsave_struct __user *) buf);
-
-	if (unlikely(err) && __clear_user(buf, xstate_size))
-		err = -EFAULT;
-	return err;
-}
-
 /*
  * Save the fpu, extended register state to the user signal frame.
  *
@@ -251,18 +235,10 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
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
+	/* Then copy it to userspace. */
+	sanitize_i387_state(tsk);
+	if (__copy_to_user(buf_fx, xsave, xstate_size))
+		return -1;
 
 	/* Save the fsave header for the 32-bit frames. */
 	if ((ia32_fxstate || !use_fxsr()) && save_fsave_header(tsk, buf))
@@ -307,28 +283,6 @@ sanitize_restored_xstate(struct task_struct *tsk,
 	}
 }
 
-/*
- * Restore the extended state if present. Otherwise, restore the FP/SSE state.
- */
-static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
-{
-	if (use_xsave()) {
-		if ((unsigned long)buf % 64 || fx_only) {
-			u64 init_bv = pcntxt_mask & ~XSTATE_FPSSE;
-			xrstor_state(init_xstate_buf, init_bv);
-			return fxrstor_user(buf);
-		} else {
-			u64 init_bv = pcntxt_mask & ~xbv;
-			if (unlikely(init_bv))
-				xrstor_state(init_xstate_buf, init_bv);
-			return xrestore_user(buf, xbv);
-		}
-	} else if (use_fxsr()) {
-		return fxrstor_user(buf);
-	} else
-		return frstor_user(buf);
-}
-
 int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 {
 	int ia32_fxstate = (buf != buf_fx);
@@ -408,15 +362,25 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 
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
+		if (use_eager_fpu()) {
+			preempt_disable();
+			math_state_restore();
+			preempt_enable();
+		}
 	}
 
 	return 0;

