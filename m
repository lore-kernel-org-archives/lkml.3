Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3CTWzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:55:40 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51559 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3CTWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:37 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 08/11] ARM: versatile: use OF init for sp804 timer
Date: Wed, 20 Mar 2013 17:54:08 -0500
Message-Id: <1363820051-24428-9-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Enable DT based init for the sp804 timers on versatile DT platform.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/versatile-ab.dts     |   12 ++++++++++++
 arch/arm/mach-versatile/core.c         |   26 +++++++++++++-------------
 arch/arm/mach-versatile/versatile_dt.c |    1 -
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index e2fe319..dde75ae 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -121,6 +121,18 @@
 			interrupts = <0>;
 		};
 
+		timer@101e2000 {
+			compatible = "arm,sp804", "arm,primecell";
+			reg = <0x101e2000 0x1000>;
+			interrupts = <4>;
+		};
+
+		timer@101e3000 {
+			compatible = "arm,sp804", "arm,primecell";
+			reg = <0x101e3000 0x1000>;
+			interrupts = <5>;
+		};
+
 		gpio0: gpio@101e4000 {
 			compatible = "arm,pl061", "arm,primecell";
 			reg = <0x101e4000 0x1000>;
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 286303a..5cdfc87 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -748,12 +748,25 @@ void versatile_restart(char mode, const char *cmd)
 /* Early initializations */
 void __init versatile_init_early(void)
 {
+	u32 val;
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 
 	osc4_clk.vcoreg	= sys + VERSATILE_SYS_OSCCLCD_OFFSET;
 	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	versatile_sched_clock_init(sys + VERSATILE_SYS_24MHz_OFFSET, 24000000);
+
+	/*
+	 * set clock frequency:
+	 *	VERSATILE_REFCLK is 32KHz
+	 *	VERSATILE_TIMCLK is 1MHz
+	 */
+	val = readl(__io_address(VERSATILE_SCTL_BASE));
+	writel((VERSATILE_TIMCLK << VERSATILE_TIMER1_EnSel) |
+	       (VERSATILE_TIMCLK << VERSATILE_TIMER2_EnSel) |
+	       (VERSATILE_TIMCLK << VERSATILE_TIMER3_EnSel) |
+	       (VERSATILE_TIMCLK << VERSATILE_TIMER4_EnSel) | val,
+	       __io_address(VERSATILE_SCTL_BASE));
 }
 
 void __init versatile_init(void)
@@ -784,19 +797,6 @@ void __init versatile_init(void)
  */
 void __init versatile_timer_init(void)
 {
-	u32 val;
-
-	/* 
-	 * set clock frequency: 
-	 *	VERSATILE_REFCLK is 32KHz
-	 *	VERSATILE_TIMCLK is 1MHz
-	 */
-	val = readl(__io_address(VERSATILE_SCTL_BASE));
-	writel((VERSATILE_TIMCLK << VERSATILE_TIMER1_EnSel) |
-	       (VERSATILE_TIMCLK << VERSATILE_TIMER2_EnSel) | 
-	       (VERSATILE_TIMCLK << VERSATILE_TIMER3_EnSel) |
-	       (VERSATILE_TIMCLK << VERSATILE_TIMER4_EnSel) | val,
-	       __io_address(VERSATILE_SCTL_BASE));
 
 	sp804_clocksource_init(TIMER3_VA_BASE, "timer3");
 	sp804_clockevents_init(TIMER0_VA_BASE, IRQ_TIMERINT0_1, "timer0");
diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
index 2558f2e..3621b00 100644
--- a/arch/arm/mach-versatile/versatile_dt.c
+++ b/arch/arm/mach-versatile/versatile_dt.c
@@ -45,7 +45,6 @@ DT_MACHINE_START(VERSATILE_PB, "ARM-Versatile (Device Tree Support)")
 	.map_io		= versatile_map_io,
 	.init_early	= versatile_init_early,
 	.init_irq	= versatile_init_irq,
-	.init_time	= versatile_timer_init,
 	.init_machine	= versatile_dt_init,
 	.dt_compat	= versatile_dt_match,
 	.restart	= versatile_restart,
-- 
1.7.10.4

