Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3GXU4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:56:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3GXUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:54:38 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 5/9] ARM: msm: Migrate msm_timer to CLOCKSOURCE_OF_DECLARE
Date: Wed, 24 Jul 2013 13:54:30 -0700
Message-Id: <1374699274-18388-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to remove the init_time callback in the DT machine
descriptors, shrinking the code.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                  |  1 +
 arch/arm/mach-msm/board-dt-8660.c |  1 -
 arch/arm/mach-msm/board-dt-8960.c |  1 -
 arch/arm/mach-msm/common.h        |  1 -
 arch/arm/mach-msm/timer.c         | 17 +++--------------
 5 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ba412e0..36dfd06 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -630,6 +630,7 @@ config ARCH_MSM
 	bool "Qualcomm MSM"
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
+	select CLKSRC_OF if OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	help
diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index f1d9c82..95f9cae 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -45,6 +45,5 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
-	.init_time	= msm_dt_timer_init,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index f930eaf..d4ca52c 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -30,7 +30,6 @@ static const char * const msm8960_dt_match[] __initconst = {
 
 DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
-	.init_time	= msm_dt_timer_init,
 	.init_machine = msm_dt_init,
 	.dt_compat = msm8960_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 569bd16..20ebf87 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -14,7 +14,6 @@
 
 extern void msm7x01_timer_init(void);
 extern void msm7x30_timer_init(void);
-extern void msm_dt_timer_init(void);
 extern void qsd8x50_timer_init(void);
 
 extern void msm_map_common_io(void);
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 8697cfc..57a9aec 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -219,15 +219,8 @@ err:
 }
 
 #ifdef CONFIG_OF
-static const struct of_device_id msm_timer_match[] __initconst = {
-	{ .compatible = "qcom,kpss-timer" },
-	{ .compatible = "qcom,scss-timer" },
-	{ },
-};
-
-void __init msm_dt_timer_init(void)
+static void __init msm_dt_timer_init(struct device_node *np)
 {
-	struct device_node *np;
 	u32 freq;
 	int irq;
 	struct resource res;
@@ -235,12 +228,6 @@ void __init msm_dt_timer_init(void)
 	void __iomem *base;
 	void __iomem *cpu0_base;
 
-	np = of_find_matching_node(NULL, msm_timer_match);
-	if (!np) {
-		pr_err("Can't find msm timer DT node\n");
-		return;
-	}
-
 	base = of_iomap(np, 0);
 	if (!base) {
 		pr_err("Failed to map event base\n");
@@ -283,6 +270,8 @@ void __init msm_dt_timer_init(void)
 
 	msm_timer_init(freq, 32, irq, !!percpu_offset);
 }
+CLOCKSOURCE_OF_DECLARE(kpss_timer, "qcom,kpss-timer", msm_dt_timer_init);
+CLOCKSOURCE_OF_DECLARE(scss_timer, "qcom,scss-timer", msm_dt_timer_init);
 #endif
 
 static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

