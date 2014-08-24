Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaHXTux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbaHXTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:50:01 -0400
Date: Sun, 24 Aug 2014 21:47:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86, fpu: don't drop_fpu() in __restore_xstate_sig()
	if use_eager_fpu()
Message-ID: <20140824194736.GA27441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824194700.GA27281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__restore_xstate_sig() calls math_state_restore() with preemption
enabled, not good. But this is minor, the main problem is that this
drop_fpu/set_used_math/math_state_restore sequence creates the nasty
"use_eager_fpu() && !used_math()" special case which complicates other
FPU paths.

Change __restore_xstate_sig() to switch to swapper's fpu state, copy
the user state to the thread's fpu state, and switch fpu->state back
after sanitize_restored_xstate().

Without use_eager_fpu() fpu->state is null in between but this is fine
because in this case we rely on clear_used_math()/set_used_math(), so
this doesn't differ from !fpu_allocated() case.

Note: with or without this patch, perhaps it makes sense to send SEGV
if __copy_from_user() fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/xsave.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 74d4129..51be404 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -325,6 +325,22 @@ static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 		return frstor_user(buf);
 }
 
+static void switch_fpu_xstate(struct task_struct *tsk, union thread_xstate *xstate)
+{
+	preempt_disable();
+	__drop_fpu(tsk);
+	tsk->thread.fpu_counter = 0;
+	tsk->thread.fpu.state = xstate;
+	/* use_eager_fpu() => xstate != NULL */
+	if (use_eager_fpu())
+		math_state_restore();
+	else if (xstate)
+		set_used_math();
+	else
+		clear_used_math();
+	preempt_enable();
+}
+
 int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 {
 	int ia32_fxstate = (buf != buf_fx);
@@ -377,28 +393,20 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		union thread_xstate *xstate = tsk->thread.fpu.state;
 		struct user_i387_ia32_struct env;
 		int err = 0;
-
 		/*
-		 * Drop the current fpu which clears used_math(). This ensures
-		 * that any context-switch during the copy of the new state,
-		 * avoids the intermediate state from getting restored/saved.
-		 * Thus avoiding the new restored state from getting corrupted.
-		 * We will be ready to restore/save the state only after
-		 * set_used_math() is again set.
+		 * Ensure that that any context-switch during the copy of
+		 * the new state, avoids the intermediate state from getting
+		 * restored/saved.
 		 */
-		drop_fpu(tsk);
-
+		switch_fpu_xstate(tsk, init_task.thread.fpu.state);
 		if (__copy_from_user(&xstate->xsave, buf_fx, state_size) ||
 		    __copy_from_user(&env, buf, sizeof(env))) {
+		    	fpu_finit(&tsk->thread.fpu);
 			err = -1;
 		} else {
 			sanitize_restored_xstate(xstate, &env, xstate_bv, fx_only);
-			set_used_math();
 		}
-
-		if (use_eager_fpu())
-			math_state_restore();
-
+		switch_fpu_xstate(tsk, xstate);
 		return err;
 	} else {
 		/*
-- 
1.5.5.1

