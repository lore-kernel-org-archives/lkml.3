Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbbAWFeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:6985 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbbAWFeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444041970"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [Resend Patch v4 05/16] smp, m32r: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:44 +0800
Message-Id: <1421991416-20297-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/m32r/include/asm/smp.h |    1 -
 arch/m32r/kernel/smp.c      |    9 +--------
 arch/m32r/kernel/traps.c    |    3 +--
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
index c689b828dfe2..3a502d4592e9 100644
--- a/arch/m32r/include/asm/smp.h
+++ b/arch/m32r/include/asm/smp.h
@@ -98,7 +98,6 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 #define LOCAL_TIMER_IPI		(M32R_IRQ_IPI3-M32R_IRQ_IPI0)
 #define INVALIDATE_CACHE_IPI	(M32R_IRQ_IPI4-M32R_IRQ_IPI0)
 #define CPU_BOOT_IPI		(M32R_IRQ_IPI5-M32R_IRQ_IPI0)
-#define CALL_FUNC_SINGLE_IPI	(M32R_IRQ_IPI6-M32R_IRQ_IPI0)
 
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index ce7aea34fdf4..c6d0bb93ad2d 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -542,7 +542,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI, 0);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_IPI, 0);
 }
 
 /*==========================================================================*
@@ -569,13 +569,6 @@ void smp_call_function_interrupt(void)
 	irq_exit();
 }
 
-void smp_call_function_single_interrupt(void)
-{
-	irq_enter();
-	generic_smp_call_function_single_interrupt();
-	irq_exit();
-}
-
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Timer Routines                                                            */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index a7a424f852e4..f5d911dcd763 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -39,7 +39,6 @@ extern void smp_invalidate_interrupt(void);
 extern void smp_call_function_interrupt(void);
 extern void smp_ipi_timer_interrupt(void);
 extern void smp_flush_cache_all_interrupt(void);
-extern void smp_call_function_single_interrupt(void);
 
 /*
  * for Boot AP function
@@ -104,7 +103,7 @@ static void set_eit_vector_entries(void)
 	eit_vector[187] = (unsigned long)smp_ipi_timer_interrupt;
 	eit_vector[188] = (unsigned long)smp_flush_cache_all_interrupt;
 	eit_vector[189] = 0;	/* CPU_BOOT_IPI */
-	eit_vector[190] = (unsigned long)smp_call_function_single_interrupt;
+	eit_vector[190] = 0;
 	eit_vector[191] = 0;
 #endif
 	_flush_cache_copyback_all();
-- 
1.7.10.4

