Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaIBQHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:07:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29631 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaIBQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:07:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,449,1406592000"; 
   d="scan'208";a="168347184"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Subject: [PATCHv3] x86, fpu: remove the logic of non-eager fpu mem allocation at the first usage
Date: Tue, 2 Sep 2014 17:06:53 +0100
Message-ID: <1409674013-10321-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <sbsiddha@gmail.com>

For non-eager fpu mode, thread's fpu state is allocated during the first
fpu usage (in the context of device not available exception). This can be
a blocking call and hence we enable interrupts (which were originally
disabled when the exception happened), allocate memory and disable
interrupts etc. While this saves 512 bytes or so per-thread, there
are some issues in general.

a.  Most of the future cases will be anyway using eager
FPU (because of processor features like xsaveopt, LWP, MPX etc) and
they do the allocation at the thread creation itself. Nice to have
one common mechanism as all the state save/restore code is
shared. Avoids the confusion and minimizes the subtle bugs
in the core piece involved with context-switch.

b. If a parent thread uses FPU, during fork() we allocate
the FPU state in the child and copy the state etc. Shortly after this,
during exec() we free it up, so that we can later allocate during
the first usage of FPU. So this free/allocate might be slower
for some workloads.

c. math_state_restore() is called from multiple places
and it is error pone if the caller expects interrupts to be disabled
throughout the execution of math_state_restore(). Can lead to subtle
bugs like Ubuntu bug #1265841.

Memory savings will be small anyways and the code complexity
introducing subtle bugs is not worth it. So remove
the logic of non-eager fpu mem allocation at the first usage.

Signed-off-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
v3:
- Rebase on 3.17-rc3.

v2:
- Tweak condition for allocating the first thread's FPU state.
---
 arch/x86/kernel/i387.c    |   20 +++++++++++---------
 arch/x86/kernel/process.c |    6 ------
 arch/x86/kernel/traps.c   |   16 ++--------------
 arch/x86/kernel/xsave.c   |    2 --
 4 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229..956ea86 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -5,6 +5,7 @@
  *  General FPU state handling cleanups
  *	Gareth Hughes <gareth@valinux.com>, May 2000
  */
+#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
@@ -197,6 +198,16 @@ void fpu_init(void)
 
 	mxcsr_feature_mask_init();
 	xsave_init();
+
+	/*
+	 * Now we know the final size of the xsave data, allocate the
+	 * FPU state area for the first task. All other tasks have
+	 * this allocated in arch_dup_task_struct().
+	 */
+	if (!current->thread.fpu.state)
+		current->thread.fpu.state = alloc_bootmem_align(xstate_size,
+				__alignof__(struct xsave_struct));
+
 	eager_fpu_init();
 }
 
@@ -228,8 +239,6 @@ EXPORT_SYMBOL_GPL(fpu_finit);
  */
 int init_fpu(struct task_struct *tsk)
 {
-	int ret;
-
 	if (tsk_used_math(tsk)) {
 		if (cpu_has_fpu && tsk == current)
 			unlazy_fpu(tsk);
@@ -237,13 +246,6 @@ int init_fpu(struct task_struct *tsk)
 		return 0;
 	}
 
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	ret = fpu_alloc(&tsk->thread.fpu);
-	if (ret)
-		return ret;
-
 	fpu_finit(&tsk->thread.fpu);
 
 	set_stopped_child_used_math(tsk);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f804dc9..4137f81 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -129,12 +129,6 @@ void flush_thread(void)
 	flush_ptrace_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	drop_init_fpu(tsk);
-	/*
-	 * Free the FPU state for non xsave platforms. They get reallocated
-	 * lazily at the first use.
-	 */
-	if (!use_eager_fpu())
-		free_thread_xstate(tsk);
 }
 
 static void hard_disable_TSC(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0d0e922..36fc898 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -652,20 +652,8 @@ void math_state_restore(void)
 {
 	struct task_struct *tsk = current;
 
-	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
+	if (!tsk_used_math(tsk))
+		init_fpu(tsk);
 
 	__thread_fpu_begin(tsk);
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 940b142..eed95d6 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -677,8 +677,6 @@ void xsave_init(void)
 
 static inline void __init eager_fpu_init_bp(void)
 {
-	current->thread.fpu.state =
-	    alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
 	if (!init_xstate_buf)
 		setup_init_fpu_buf();
 }
-- 
1.7.10.4

