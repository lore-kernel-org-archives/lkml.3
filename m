Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaHXTtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaHXTtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:49:50 -0400
Date: Sun, 24 Aug 2014 21:47:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86, fpu: change sanitize_restored_xstate() and
	convert_to_fxsr() to accept thread_xstate
Message-ID: <20140824194732.GA27434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824194700.GA27281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation. sanitize_restored_xstate() and convert_to_fxsr() do not
really need task_struct, change them to accept task->thread.fpu.state
instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/kernel/i387.c              |    6 +++---
 arch/x86/kernel/xsave.c             |   13 ++++++-------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 37506df..ae6bd35 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -46,7 +46,7 @@ DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 extern void convert_from_fxsr(struct user_i387_ia32_struct *env,
 			      struct task_struct *tsk);
-extern void convert_to_fxsr(struct task_struct *tsk,
+extern void convert_to_fxsr(union thread_xstate *xstate,
 			    const struct user_i387_ia32_struct *env);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d5dd808..6de1916 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -489,11 +489,11 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-void convert_to_fxsr(struct task_struct *tsk,
+void convert_to_fxsr(union thread_xstate *xstate,
 		     const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.fpu.state->fxsave;
+	struct i387_fxsave_struct *fxsave = &xstate->fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -574,7 +574,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &env, 0, -1);
 	if (!ret)
-		convert_to_fxsr(target, &env);
+		convert_to_fxsr(target->thread.fpu.state, &env);
 
 	/*
 	 * update the header bit in the xsave header, indicating the
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 74b34c2..74d4129 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -272,11 +272,11 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 }
 
 static inline void
-sanitize_restored_xstate(struct task_struct *tsk,
+sanitize_restored_xstate(union thread_xstate *xstate,
 			 struct user_i387_ia32_struct *ia32_env,
 			 u64 xstate_bv, int fx_only)
 {
-	struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+	struct xsave_struct *xsave = &xstate->xsave;
 	struct xsave_hdr_struct *xsave_hdr = &xsave->xsave_hdr;
 
 	if (use_xsave()) {
@@ -299,8 +299,7 @@ sanitize_restored_xstate(struct task_struct *tsk,
 		 * reasons.
 		 */
 		xsave->i387.mxcsr &= mxcsr_feature_mask;
-
-		convert_to_fxsr(tsk, ia32_env);
+		convert_to_fxsr(xstate, ia32_env);
 	}
 }
 
@@ -375,7 +374,7 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		 * thread's fpu state, reconstruct fxstate from the fsave
 		 * header. Sanitize the copied state etc.
 		 */
-		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
+		union thread_xstate *xstate = tsk->thread.fpu.state;
 		struct user_i387_ia32_struct env;
 		int err = 0;
 
@@ -389,11 +388,11 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		drop_fpu(tsk);
 
-		if (__copy_from_user(xsave, buf_fx, state_size) ||
+		if (__copy_from_user(&xstate->xsave, buf_fx, state_size) ||
 		    __copy_from_user(&env, buf, sizeof(env))) {
 			err = -1;
 		} else {
-			sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
+			sanitize_restored_xstate(xstate, &env, xstate_bv, fx_only);
 			set_used_math();
 		}
 
-- 
1.5.5.1

