Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3HPWnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:43:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab3HPWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 049/133] ARM: 7790/1: Fix deferred mm switch on VIVT processors
Date: Fri, 16 Aug 2013 15:33:11 -0700
Message-Id: <1376692475-28413-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit bdae73cd374e28db544fdd9b77de689a36e3c129 upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/mmu.h         |  2 ++
 arch/arm/include/asm/mmu_context.h | 20 ++++++++++++++++----
 arch/arm/include/asm/thread_info.h |  1 -
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index e3d5554..d1b4998 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -6,6 +6,8 @@
 typedef struct {
 #ifdef CONFIG_CPU_HAS_ASID
 	atomic64_t	id;
+#else
+	int		switch_pending;
 #endif
 	unsigned int	vmalloc_seq;
 } mm_context_t;
diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 863a661..3da6557 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -45,7 +45,7 @@ static inline void check_and_switch_context(struct mm_struct *mm,
 		 * on non-ASID CPUs, the old mm will remain valid until the
 		 * finish_arch_post_lock_switch() call.
 		 */
-		set_ti_thread_flag(task_thread_info(tsk), TIF_SWITCH_MM);
+		mm->context.switch_pending = 1;
 	else
 		cpu_switch_mm(mm->pgd, mm);
 }
@@ -54,9 +54,21 @@ static inline void check_and_switch_context(struct mm_struct *mm,
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
index cddda1f..20038ae 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -155,7 +155,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
-#define TIF_SWITCH_MM		22	/* deferred switch_mm */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-- 
1.8.1.2

