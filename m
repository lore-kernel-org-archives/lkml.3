Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3IKFbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:31:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3IKE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:23 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=qf5hFJ-4kf0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ezZvhX8_QgcA:10 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=0zw58A1aZs0fF7rhRjMA:9 a=ESTKKtUg-DoA:10 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=vHuA_cAHhKNQiwS_:21 a=UoxFgsIoIZ4ReBBH:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042913.373407203@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [127/251] ARM: 7790/1: Fix deferred mm switch on VIVT processors
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0127-ARM-7790-1-Fix-deferred-mm-switch-on-VIVT-processors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit bdae73cd374e28db544fdd9b77de689a36e3c129 ]

As of commit b9d4d42ad9 (ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on
pre-ARMv6 CPUs), the mm switching on VIVT processors is done in the
finish_arch_post_lock_switch() function to avoid whole cache flushing
with interrupts disabled. The need for deferred mm switch is stored as a
thread flag (TIF_SWITCH_MM). However, with preemption enabled, we can
have another thread switch before finish_arch_post_lock_switch(). If the
new thread has the same mm as the previous 'next' thread, the scheduler
will not call switch_mm() and the TIF_SWITCH_MM flag won't be set for
the new thread.

This patch moves the switch pending flag to the mm_context_t structure
since this is specific to the mm rather than thread.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: <stable@vger.kernel.org> # 3.5+
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/mmu.h         |    2 ++
 arch/arm/include/asm/mmu_context.h |   20 ++++++++++++++++----
 arch/arm/include/asm/thread_info.h |    1 -
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index 1496565..49122c4 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -7,6 +7,8 @@ typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	unsigned int id;
 	raw_spinlock_t id_lock;
+#else
+	int		switch_pending;
 #endif
 	unsigned int kvm_seq;
 } mm_context_t;
diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 0306bc6..549f1c6 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -121,7 +121,7 @@ static inline void check_and_switch_context(struct mm_struct *mm,
 		 * on non-ASID CPUs, the old mm will remain valid until the
 		 * finish_arch_post_lock_switch() call.
 		 */
-		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
+		mm->context.switch_pending = 1;
 	else
 		cpu_switch_mm(mm->pgd, mm);
 }
@@ -130,9 +130,21 @@ static inline void check_and_switch_context(struct mm_struct *mm,
 	finish_arch_post_lock_switch
 static inline void finish_arch_post_lock_switch(void)
 {
-	if (test_and_clear_thread_flag(TIF_SWITCH_MM)) {
-		struct mm_struct *mm = current->mm;
-		cpu_switch_mm(mm->pgd, mm);
+	struct mm_struct *mm = current->mm;
+
+	if (mm && mm->context.switch_pending) {
+		/*
+		 * Preemption must be disabled during cpu_switch_mm() as we
+		 * have some stateful cache flush implementations. Check
+		 * switch_pending again in case we were preempted and the
+		 * switch to this mm was already done.
+		 */
+		preempt_disable();
+		if (mm->context.switch_pending) {
+			mm->context.switch_pending = 0;
+			cpu_switch_mm(mm->pgd, mm);
+		}
+		preempt_enable_no_resched();
 	}
 }
 
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index af7b0bd..86682b1 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -153,7 +153,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SECCOMP		21
-#define TIF_SWITCH_MM		22	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-- 
1.7.10.4


