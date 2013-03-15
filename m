Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3CODbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:31:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4325 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3CODbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:31:42 -0400
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="29880101"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ARM: msm: Wait for timer clear to complete
Date: Thu, 14 Mar 2013 20:31:39 -0700
Message-Id: <1363318299-10814-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
References: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without looping on the status bit, there is no way to guarantee
that a clear of the timer has actually completed. This can cause
us to enable the timer before the count has cleared and miss a
timer interrupt. To simplify this patch, remove the timer
register setup done during timer init, since it's duplicate work
that is eventually done in the set_next_event() callback.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 9f033c3..284313f 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -30,20 +30,22 @@
 
 #include "common.h"
 
-#define TIMER_MATCH_VAL         0x0000
-#define TIMER_COUNT_VAL         0x0004
-#define TIMER_ENABLE            0x0008
-#define TIMER_ENABLE_CLR_ON_MATCH_EN    BIT(1)
-#define TIMER_ENABLE_EN                 BIT(0)
-#define TIMER_CLEAR             0x000C
-#define DGT_CLK_CTL		0x10
-#define DGT_CLK_CTL_DIV_4	0x3
+#define TIMER_MATCH_VAL			0x0000
+#define TIMER_COUNT_VAL			0x0004
+#define TIMER_ENABLE			0x0008
+#define TIMER_ENABLE_CLR_ON_MATCH_EN	BIT(1)
+#define TIMER_ENABLE_EN			BIT(0)
+#define TIMER_CLEAR			0x000C
+#define DGT_CLK_CTL			0x10
+#define DGT_CLK_CTL_DIV_4		0x3
+#define TIMER_STS_GPT0_CLR_PEND		BIT(10)
 
 #define GPT_HZ 32768
 
 #define MSM_DGT_SHIFT 5
 
 static void __iomem *event_base;
+static void __iomem *sts_base;
 
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
@@ -68,6 +70,11 @@ static int msm_timer_set_next_event(unsigned long cycles,
 
 	writel_relaxed(ctrl, event_base + TIMER_CLEAR);
 	writel_relaxed(cycles, event_base + TIMER_MATCH_VAL);
+
+	if (sts_base)
+		while (readl_relaxed(sts_base) & TIMER_STS_GPT0_CLR_PEND)
+			cpu_relax();
+
 	writel_relaxed(ctrl | TIMER_ENABLE_EN, event_base + TIMER_ENABLE);
 	return 0;
 }
@@ -138,9 +145,6 @@ static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 	if (!smp_processor_id())
 		return 0;
 
-	writel_relaxed(0, event_base + TIMER_ENABLE);
-	writel_relaxed(0, event_base + TIMER_CLEAR);
-	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
 	evt->irq = msm_clockevent.irq;
 	evt->name = "local_timer";
 	evt->features = msm_clockevent.features;
@@ -178,9 +182,6 @@ static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 	struct clocksource *cs = &msm_clocksource;
 	int res;
 
-	writel_relaxed(0, event_base + TIMER_ENABLE);
-	writel_relaxed(0, event_base + TIMER_CLEAR);
-	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
 	ce->cpumask = cpumask_of(0);
 	ce->irq = irq;
 
@@ -275,6 +276,7 @@ void __init msm_dt_timer_init(void)
 	of_node_put(np);
 
 	event_base = base + 0x4;
+	sts_base = base + 0x88;
 	source_base = cpu0_base + 0x24;
 	freq /= 4;
 	writel_relaxed(DGT_CLK_CTL_DIV_4, source_base + DGT_CLK_CTL);
@@ -283,7 +285,8 @@ void __init msm_dt_timer_init(void)
 }
 #endif
 
-static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source)
+static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source,
+				u32 sts)
 {
 	void __iomem *base;
 
@@ -294,6 +297,8 @@ static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source)
 	}
 	event_base = base + event;
 	source_base = base + source;
+	if (sts)
+		sts_base = base + sts;
 
 	return 0;
 }
@@ -302,7 +307,7 @@ void __init msm7x01_timer_init(void)
 {
 	struct clocksource *cs = &msm_clocksource;
 
-	if (msm_timer_map(0xc0100000, 0x0, 0x10))
+	if (msm_timer_map(0xc0100000, 0x0, 0x10, 0x0))
 		return;
 	cs->read = msm_read_timer_count_shift;
 	cs->mask = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT));
@@ -313,14 +318,14 @@ void __init msm7x01_timer_init(void)
 
 void __init msm7x30_timer_init(void)
 {
-	if (msm_timer_map(0xc0100000, 0x4, 0x24))
+	if (msm_timer_map(0xc0100000, 0x4, 0x24, 0x80))
 		return;
 	msm_timer_init(24576000 / 4, 32, 1, false);
 }
 
 void __init qsd8x50_timer_init(void)
 {
-	if (msm_timer_map(0xAC100000, 0x0, 0x10))
+	if (msm_timer_map(0xAC100000, 0x0, 0x10, 0x34))
 		return;
 	msm_timer_init(19200000 / 4, 32, 7, false);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

