Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3IKQJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:09:50 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41855 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3IKQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:09:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 12/25] smp, mn10300: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:16 +0800
Message-Id: <1378915649-16395-13-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

smp, mn10300: rename CALL_FUNC_SINGLE_IPI as CALL_FUNC_IPI

Rename CALL_FUNC_SINGLE_IPI as CALL_FUNC_IPI to prepare for
killing generic_smp_call_function_single_interrupt().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/mn10300/include/asm/smp.h |  2 +-
 arch/mn10300/kernel/smp.c      | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/mn10300/include/asm/smp.h b/arch/mn10300/include/asm/smp.h
index 56c4241..8e689d1 100644
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
index a17f9c9..7ae353d 100644
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
1.8.1.2

