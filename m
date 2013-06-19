Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab3FSAHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:07:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35510 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab3FSAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:46 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/11] ARM: msm: Migrate msm_timer to CLOCKSOURCE_OF_DECLARE
Date: Tue, 18 Jun 2013 17:04:35 -0700
Message-Id: <1371600281-6118-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to remove the init_time callback in the DT machine
descriptors, shrinking the code.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Unchanged from previous sends.

 arch/arm/Kconfig                  |  1 +
 arch/arm/mach-msm/board-dt-8660.c |  1 -
 arch/arm/mach-msm/board-dt-8960.c |  1 -
 arch/arm/mach-msm/common.h        |  1 -
 arch/arm/mach-msm/timer.c         | 17 +++--------------
 5 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index af88c83..430c922 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -622,6 +622,7 @@ config ARCH_MSM
 	bool "Qualcomm MSM"
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
+	select CLKSRC_OF if OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	help
diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index 40523da..f491b9b 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -46,6 +46,5 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.map_io = debug_ll_io_init,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
-	.init_time	= msm_dt_timer_init,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index 59b48e7..83be2b8 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -31,7 +31,6 @@ static const char * const msm8960_dt_match[] __initconst = {
 DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.map_io = debug_ll_io_init,
-	.init_time	= msm_dt_timer_init,
 	.init_machine = msm_dt_init,
 	.dt_compat = msm8960_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index d8f3eac..3776268 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -14,7 +14,6 @@
 
 extern void msm7x01_timer_init(void);
 extern void msm7x30_timer_init(void);
-extern void msm_dt_timer_init(void);
 extern void qsd8x50_timer_init(void);
 
 extern void msm_map_common_io(void);
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 284313f..1167cf6 100644
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

