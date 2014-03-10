Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCJQSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:18:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33693 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaCJQSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:18:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,625,1389744000"; 
   d="scan'208";a="108384862"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <xen-devel@lists.xen.org>, David Vrabel <david.vrabel@citrix.com>
Subject: [PATCHv1] x86: don't schedule when handling #NM exception
Date: Mon, 10 Mar 2014 16:17:53 +0000
Message-ID: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

math_state_restore() is called from the #NM exception handler.  It may
do a GFP_KERNEL allocation (in init_fpu()) which may schedule.

Change this allocation to GFP_ATOMIC, but leave all the other callers
of init_fpu() or fpu_alloc() using GFP_KERNEL.

do_group_exit() will also call schedule() so replace the call with
force_sig(SIGKILL, tsk) instead.

Scheduling in math_state_restore() is particularly bad in Xen PV
guests since the Xen clears CR0.TS before raising #NM exception (in
the expectation that the #NM handler always clears TS).  If task A is
descheduled and task B is scheduled.  Task B may end up with CR0.TS
unexpectedly clear and any FPU instructions will not raise #NM and
will corrupt task A's FPU state instead.

Reported-by: Zhu Yanhai <zhu.yanhai@gmail.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/fpu-internal.h |    4 ++--
 arch/x86/include/asm/i387.h         |    2 +-
 arch/x86/include/asm/xsave.h        |    2 +-
 arch/x86/kernel/i387.c              |   16 ++++++++--------
 arch/x86/kernel/process.c           |    2 +-
 arch/x86/kernel/traps.c             |    9 ++-------
 arch/x86/kernel/xsave.c             |    4 ++--
 arch/x86/kvm/x86.c                  |    2 +-
 8 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..e32a73c 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -567,11 +567,11 @@ static bool fpu_allocated(struct fpu *fpu)
 	return fpu->state != NULL;
 }
 
-static inline int fpu_alloc(struct fpu *fpu)
+static inline int fpu_alloc(struct fpu *fpu, gfp_t gfp)
 {
 	if (fpu_allocated(fpu))
 		return 0;
-	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, gfp);
 	if (!fpu->state)
 		return -ENOMEM;
 	WARN_ON((unsigned long)fpu->state & 15);
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ed8089d..5559c80 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -18,7 +18,7 @@
 struct pt_regs;
 struct user_i387_struct;
 
-extern int init_fpu(struct task_struct *child);
+extern int init_fpu(struct task_struct *child, gfp_t gfp);
 extern void fpu_finit(struct fpu *fpu);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 extern void math_state_restore(void);
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 5547389..e6d6610 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -44,7 +44,7 @@ extern struct xsave_struct *init_xstate_buf;
 
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
-extern int init_fpu(struct task_struct *child);
+extern int init_fpu(struct task_struct *child, gfp_t gfp);
 
 static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 {
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e8368c6..baf94ad 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -217,7 +217,7 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  * value at reset if we support XMM instructions and then
  * remember the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+int init_fpu(struct task_struct *tsk, gfp_t gfp)
 {
 	int ret;
 
@@ -231,7 +231,7 @@ int init_fpu(struct task_struct *tsk)
 	/*
 	 * Memory allocation at the first usage of the FPU and other state.
 	 */
-	ret = fpu_alloc(&tsk->thread.fpu);
+	ret = fpu_alloc(&tsk->thread.fpu, gfp);
 	if (ret)
 		return ret;
 
@@ -266,7 +266,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -285,7 +285,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -318,7 +318,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -348,7 +348,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_xsave)
 		return -ENODEV;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -515,7 +515,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -546,7 +546,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	ret = init_fpu(target);
+	ret = init_fpu(target, GFP_KERNEL);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95..10705a6 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -69,7 +69,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	*dst = *src;
 	if (fpu_allocated(&src->thread.fpu)) {
 		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
-		ret = fpu_alloc(&dst->thread.fpu);
+		ret = fpu_alloc(&dst->thread.fpu, GFP_KERNEL);
 		if (ret)
 			return ret;
 		fpu_copy(dst, src);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..c8078d2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -624,18 +624,13 @@ void math_state_restore(void)
 	struct task_struct *tsk = current;
 
 	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
+		if (init_fpu(tsk, GFP_ATOMIC)) {
 			/*
 			 * ran out of memory!
 			 */
-			do_group_exit(SIGKILL);
+			force_sig(SIGKILL, tsk);
 			return;
 		}
-		local_irq_disable();
 	}
 
 	__thread_fpu_begin(tsk);
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c..0512744 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -347,7 +347,7 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	if (!access_ok(VERIFY_READ, buf, size))
 		return -EACCES;
 
-	if (!used_math() && init_fpu(tsk))
+	if (!used_math() && init_fpu(tsk, GFP_KERNEL))
 		return -1;
 
 	if (!static_cpu_has(X86_FEATURE_FPU))
@@ -628,7 +628,7 @@ void eager_fpu_init(void)
 	 * This is same as math_state_restore(). But use_xsave() is
 	 * not yet patched to use math_state_restore().
 	 */
-	init_fpu(current);
+	init_fpu(current, GFP_KERNEL);
 	__thread_fpu_begin(current);
 	if (cpu_has_xsave)
 		xrstor_state(init_xstate_buf, -1);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b85784..fc74b68 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6619,7 +6619,7 @@ int fx_init(struct kvm_vcpu *vcpu)
 {
 	int err;
 
-	err = fpu_alloc(&vcpu->arch.guest_fpu);
+	err = fpu_alloc(&vcpu->arch.guest_fpu, gfp);
 	if (err)
 		return err;
 
-- 
1.7.2.5

