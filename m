Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3CKSLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:11:31 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61032 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3CKSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:11:23 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 5/5] ARM: at91: fix hanged boot
Date: Mon, 11 Mar 2013 19:07:59 +0100
Message-Id: <1363025279-17615-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
References: <20130311180611.GF8797@localhost>
 <1363025279-17615-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the RTC and RTT-interrupts are masked at boot by adding a new
SOC-initialiser and helpers functions.

This fixes hanged boot on all AT91 SOCs but RM9200, for example, after a
reset during an RTC-update or if an RTC or RTT-alarm goes off after a
non-clean shutdown.

The RTC and RTT-peripherals are powered by backup power (VDDBU) (on all
AT91 SOCs but RM9200) and are not reset on wake-up, user, watchdog or
software reset. This means that their interrupts may be enabled during
early boot if, for example, they where not disabled during a previous
shutdown (e.g. due to a buggy driver or a non-clean shutdown such as a
user reset). Furthermore, an RTC or RTT-alarm may also be active.

The RTC and RTT-interrupts use the shared system-interrupt line, and if
an interrupt occurs before a handler (e.g. RTC-driver) has been
installed this leads to the system interrupt being disabled and prevents
the system from booting.

Note that when boot hangs due to an early RTC or RTT-interrupt, the only
way to get the system to start again is to remove the backup power (e.g.
battery) or to disable the interrupt manually from the bootloader. In
particular, a user reset is not sufficient.

Tested on at91sam9263 and at91sam9g45.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/mach-at91/at91sam9260.c |  6 +++
 arch/arm/mach-at91/at91sam9261.c |  6 +++
 arch/arm/mach-at91/at91sam9263.c |  7 ++++
 arch/arm/mach-at91/at91sam9g45.c |  7 ++++
 arch/arm/mach-at91/at91sam9rl.c  |  7 ++++
 arch/arm/mach-at91/generic.h     |  2 +
 arch/arm/mach-at91/setup.c       | 88 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/soc.h         |  1 +
 8 files changed, 124 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index b67cd53..c47a0db 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -342,6 +342,11 @@ static void __init at91sam9260_ioremap_registers(void)
 	at91_ioremap_matrix(AT91SAM9260_BASE_MATRIX);
 }
 
+static void __init at91sam9260_sysirq_mask(void)
+{
+	at91_sysirq_mask_rtt(AT91SAM9260_BASE_RTT);
+}
+
 static void __init at91sam9260_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
@@ -400,5 +405,6 @@ AT91_SOC_START(sam9260)
 	.default_irq_priority = at91sam9260_default_irq_priority,
 	.ioremap_registers = at91sam9260_ioremap_registers,
 	.register_clocks = at91sam9260_register_clocks,
+	.sysirq_mask = at91sam9260_sysirq_mask,
 	.init = at91sam9260_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 0204f4c..396e4cb 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -286,6 +286,11 @@ static void __init at91sam9261_ioremap_registers(void)
 	at91_ioremap_matrix(AT91SAM9261_BASE_MATRIX);
 }
 
+static void __init at91sam9261_sysirq_mask(void)
+{
+	at91_sysirq_mask_rtt(AT91SAM9261_BASE_RTT);
+}
+
 static void __init at91sam9261_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
@@ -344,5 +349,6 @@ AT91_SOC_START(sam9261)
 	.default_irq_priority = at91sam9261_default_irq_priority,
 	.ioremap_registers = at91sam9261_ioremap_registers,
 	.register_clocks = at91sam9261_register_clocks,
+	.sysirq_mask = at91sam9261_sysirq_mask,
 	.init = at91sam9261_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index c0cbb81..a0166a3 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -325,6 +325,12 @@ static void __init at91sam9263_ioremap_registers(void)
 	at91_ioremap_matrix(AT91SAM9263_BASE_MATRIX);
 }
 
+static void __init at91sam9263_sysirq_mask(void)
+{
+	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT0);
+	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT1);
+}
+
 static void __init at91sam9263_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
@@ -382,5 +388,6 @@ AT91_SOC_START(sam9263)
 	.default_irq_priority = at91sam9263_default_irq_priority,
 	.ioremap_registers = at91sam9263_ioremap_registers,
 	.register_clocks = at91sam9263_register_clocks,
+	.sysirq_mask = at91sam9263_sysirq_mask,
 	.init = at91sam9263_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index b4968aa..3d5498e 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -370,6 +370,12 @@ static void __init at91sam9g45_ioremap_registers(void)
 	at91_ioremap_matrix(AT91SAM9G45_BASE_MATRIX);
 }
 
+static void __init at91sam9g45_sysirq_mask(void)
+{
+	at91_sysirq_mask_rtc(AT91SAM9G45_BASE_RTC);
+	at91_sysirq_mask_rtt(AT91SAM9G45_BASE_RTT);
+}
+
 static void __init at91sam9g45_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
@@ -427,5 +433,6 @@ AT91_SOC_START(sam9g45)
 	.default_irq_priority = at91sam9g45_default_irq_priority,
 	.ioremap_registers = at91sam9g45_ioremap_registers,
 	.register_clocks = at91sam9g45_register_clocks,
+	.sysirq_mask = at91sam9g45_sysirq_mask,
 	.init = at91sam9g45_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 3de3e04..bde999f 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -289,6 +289,12 @@ static void __init at91sam9rl_ioremap_registers(void)
 	at91_ioremap_matrix(AT91SAM9RL_BASE_MATRIX);
 }
 
+static void __init at91sam9rl_sysirq_mask(void)
+{
+	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
+	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
+}
+
 static void __init at91sam9rl_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
@@ -346,5 +352,6 @@ AT91_SOC_START(sam9rl)
 	.default_irq_priority = at91sam9rl_default_irq_priority,
 	.ioremap_registers = at91sam9rl_ioremap_registers,
 	.register_clocks = at91sam9rl_register_clocks,
+	.sysirq_mask = at91sam9rl_sysirq_mask,
 	.init = at91sam9rl_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index fc593d6..90a854d 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -33,6 +33,8 @@ extern int  __init at91_aic_of_init(struct device_node *node,
 				    struct device_node *parent);
 extern int  __init at91_aic5_of_init(struct device_node *node,
 				    struct device_node *parent);
+extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
+extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
 
  /* Timer */
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 4b67847..4c5790f 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -19,6 +19,8 @@
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 #include <mach/at91_pmc.h>
+#include <mach/at91_rtc.h>
+#include <mach/at91_rtt.h>
 
 #include "at91_shdwc.h"
 #include "soc.h"
@@ -311,6 +313,39 @@ void __init at91_ioremap_matrix(u32 base_addr)
 		panic("Impossible to ioremap at91_matrix_base\n");
 }
 
+void __init __at91_sysirq_mask_rtc(void __iomem *rtc_base)
+{
+	u32 mask;
+
+	mask = __raw_readl(rtc_base + AT91_RTC_IMR);
+	if (mask) {
+		pr_info("AT91: Disabling rtc irq\n");
+		__raw_writel(mask, rtc_base + AT91_RTC_IDR);
+	}
+}
+
+void __init __at91_sysirq_mask_rtt(void __iomem *rtt_base)
+{
+	u32 mr;
+
+	mr = __raw_readl(rtt_base + AT91_RTT_MR);
+	if (mr & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN)) {
+		pr_info("AT91: Disabling rtt irq\n");
+		mr &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+		__raw_writel(mr, rtt_base + AT91_RTT_MR);
+	}
+}
+
+void __init at91_sysirq_mask_rtc(u32 rtc_base)
+{
+	__at91_sysirq_mask_rtc(AT91_IO_P2V(rtc_base));
+}
+
+void __init at91_sysirq_mask_rtt(u32 rtt_base)
+{
+	__at91_sysirq_mask_rtt(AT91_IO_P2V(rtt_base));
+}
+
 #if defined(CONFIG_OF)
 static struct of_device_id rstc_ids[] = {
 	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_alt_restart },
@@ -440,6 +475,54 @@ end:
 	of_node_put(np);
 }
 
+static struct of_device_id sysirq_mask_rtc_ids[] = {
+	{ .compatible = "atmel,at91sam9g45-rtc" },
+	{ /* sentinel */ }
+};
+
+static void at91_dt_sysirq_mask_rtc(void)
+{
+	struct device_node *np;
+	void __iomem *base;
+
+	for_each_matching_node(np, sysirq_mask_rtc_ids) {
+		base = of_iomap(np, 0);
+		if (!base) {
+			pr_warn("AT91: unable to map rtc cpu registers\n");
+			continue;
+		}
+		__at91_sysirq_mask_rtc(base);
+		iounmap(base);
+	}
+}
+
+static struct of_device_id sysirq_mask_rtt_ids[] = {
+	{ .compatible = "atmel,at91sam9260-rtt" },
+	{ /* sentinel */ }
+};
+
+static void at91_dt_sysirq_mask_rtt(void)
+{
+	struct device_node *np;
+	void __iomem *base;
+
+	for_each_matching_node(np, sysirq_mask_rtt_ids) {
+		base = of_iomap(np, 0);
+		if (!base) {
+			pr_warn("AT91: unable to map rtt cpu registers\n");
+			continue;
+		}
+		__at91_sysirq_mask_rtt(base);
+		iounmap(base);
+	}
+}
+
+static void at91_dt_sysirq_mask(void)
+{
+	at91_dt_sysirq_mask_rtc();
+	at91_dt_sysirq_mask_rtt();
+}
+
 void __init at91rm9200_dt_initialize(void)
 {
 	at91_dt_ramc();
@@ -467,6 +550,8 @@ void __init at91_dt_initialize(void)
 
 	if (at91_boot_soc.init)
 		at91_boot_soc.init();
+
+	at91_dt_sysirq_mask();
 }
 #endif
 
@@ -482,5 +567,8 @@ void __init at91_initialize(unsigned long main_clock)
 
 	at91_boot_soc.init();
 
+	if (at91_boot_soc.sysirq_mask)
+		at91_boot_soc.sysirq_mask();
+
 	pinctrl_provide_dummies();
 }
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index 9c6d3d4..134f4c4 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -10,6 +10,7 @@ struct at91_init_soc {
 	void (*map_io)(void);
 	void (*ioremap_registers)(void);
 	void (*register_clocks)(void);
+	void (*sysirq_mask)(void);
 	void (*init)(void);
 };
 
-- 
1.8.1.5

