Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbbAWFe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:23221 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbbAWFez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042002"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: [Resend Patch v4 06/16] smp, mn10300: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:45 +0800
Message-Id: <1421991416-20297-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CALL_FUNC_SINGLE_IPI as CALL_FUNC_IPI to prepare for
killing generic_smp_call_function_single_interrupt().

Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/mn10300/include/asm/smp.h |    2 +-
 arch/mn10300/kernel/smp.c      |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/mn10300/include/asm/smp.h b/arch/mn10300/include/asm/smp.h
index 56c42417d428..8e689d1724bf 100644
--- a/arch/mn10300/include/asm/smp.h
+++ b/arch/mn10300/include/asm/smp.h
@@ -31,7 +31,7 @@
 #include <proc/smp-regs.h>
 
 #define RESCHEDULE_IPI		63
-#define CALL_FUNC_SINGLE_IPI	192
+#define CALL_FUNC_IPI		192
 #define LOCAL_TIMER_IPI		193
 #define FLUSH_CACHE_IPI		194
 #define CALL_FUNCTION_NMI_IPI	195
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index f984193718b1..13aa7ac5a82b 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -164,11 +164,11 @@ static void init_ipi(void)
 	mn10300_ipi_enable(RESCHEDULE_IPI);
 
 	/* set up the call function IPI */
-	irq_set_chip_and_handler(CALL_FUNC_SINGLE_IPI, &mn10300_ipi_type,
+	irq_set_chip_and_handler(CALL_FUNC_IPI, &mn10300_ipi_type,
 				 handle_percpu_irq);
-	setup_irq(CALL_FUNC_SINGLE_IPI, &call_function_ipi);
-	set_intr_level(CALL_FUNC_SINGLE_IPI, CALL_FUNCTION_GxICR_LV);
-	mn10300_ipi_enable(CALL_FUNC_SINGLE_IPI);
+	setup_irq(CALL_FUNC_IPI, &call_function_ipi);
+	set_intr_level(CALL_FUNC_IPI, CALL_FUNCTION_GxICR_LV);
+	mn10300_ipi_enable(CALL_FUNC_IPI);
 
 	/* set up the local timer IPI */
 #if !defined(CONFIG_GENERIC_CLOCKEVENTS) || \
@@ -362,7 +362,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_IPI);
 }
 
 /**
@@ -519,7 +519,7 @@ static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id)
 static irqreturn_t smp_call_function_interrupt(int irq, void *dev_id)
 {
 	/* generic_smp_call_function_interrupt(); */
-	generic_smp_call_function_single_interrupt();
+	generic_smp_call_function_interrupt();
 	return IRQ_HANDLED;
 }
 
@@ -598,8 +598,8 @@ static void __init smp_cpu_init(void)
 	/* Force FPU initialization */
 	clear_using_fpu(current);
 
-	GxICR(CALL_FUNC_SINGLE_IPI) = CALL_FUNCTION_GxICR_LV | GxICR_DETECT;
-	mn10300_ipi_enable(CALL_FUNC_SINGLE_IPI);
+	GxICR(CALL_FUNC_IPI) = CALL_FUNCTION_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(CALL_FUNC_IPI);
 
 	GxICR(LOCAL_TIMER_IPI) = LOCAL_TIMER_GxICR_LV | GxICR_DETECT;
 	mn10300_ipi_enable(LOCAL_TIMER_IPI);
-- 
1.7.10.4

