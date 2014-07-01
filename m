Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaGAJhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:37:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33608 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932125AbaGAJfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:15 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 05/14] AT91: PIT: Rework probe functions
Date: Tue,  1 Jul 2014 11:33:18 +0200
Message-Id: <1404207208-14513-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PIT timer driver until now had a single probe function, disregarding wether
it was probed through DT or in the old-style way. This code later on was
calling some DT function to retrieve the proper values for its base address,
interrupts and clocks.

While this was working, it was preventing the usage of CLOCKSOURCE_OF_DECLARE,
and the two different probe path were not as clearly separated as they could
be.

Rework the probe path to take this into account, and switch to
CLOCKSOURCE_OF_DECLARE.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig            |   1 +
 arch/arm/mach-at91/at91sam926x_time.c | 108 +++++++++++++++-------------------
 arch/arm/mach-at91/board-dt-sam9.c    |   3 +-
 arch/arm/mach-at91/board-dt-sama5.c   |   3 +-
 4 files changed, 51 insertions(+), 64 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 45b55e0f0db6..a64412a020d3 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -37,6 +37,7 @@ config AT91_SAM9G45_RESET
 	default !ARCH_AT91X40
 
 config AT91_SAM9_TIME
+	select CLKSRC_OF if OF
 	bool
 
 config HAVE_AT91_SMD
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index b87a12f05540..f6c44539af6e 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -19,7 +19,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
-#include <asm/mach/time.h>
 #include <mach/hardware.h>
 
 #define AT91_PIT_MR		0x00			/* Mode Register */
@@ -176,81 +175,21 @@ static struct irqaction at91sam926x_pit_irq = {
 	.name		= "at91_tick",
 	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91sam926x_pit_interrupt,
-	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
 };
 
-#ifdef CONFIG_OF
-static struct of_device_id pit_timer_ids[] = {
-	{ .compatible = "atmel,at91sam9260-pit" },
-	{ /* sentinel */ }
-};
-
-static int __init of_at91sam926x_pit_init(void)
-{
-	struct device_node	*np;
-	int			ret;
-
-	np = of_find_matching_node(NULL, pit_timer_ids);
-	if (!np)
-		goto err;
-
-	pit_base_addr = of_iomap(np, 0);
-	if (!pit_base_addr)
-		goto node_err;
-
-	mck = of_clk_get(np, 0);
-
-	/* Get the interrupts property */
-	ret = irq_of_parse_and_map(np, 0);
-	if (!ret) {
-		pr_crit("AT91: PIT: Unable to get IRQ from DT\n");
-		if (!IS_ERR(mck))
-			clk_put(mck);
-		goto ioremap_err;
-	}
-	at91sam926x_pit_irq.irq = ret;
-
-	of_node_put(np);
-
-	return 0;
-
-ioremap_err:
-	iounmap(pit_base_addr);
-node_err:
-	of_node_put(np);
-err:
-	return -EINVAL;
-}
-#else
-static int __init of_at91sam926x_pit_init(void)
-{
-	return -EINVAL;
-}
-#endif
-
 /*
  * Set up both clocksource and clockevent support.
  */
-void __init at91sam926x_pit_init(void)
+static void __init at91sam926x_pit_common_init(void)
 {
 	unsigned long	pit_rate;
 	unsigned	bits;
 	int		ret;
 
-	mck = ERR_PTR(-ENOENT);
-
-	/* For device tree enabled device: initialize here */
-	of_at91sam926x_pit_init();
-
 	/*
 	 * Use our actual MCK to figure out how many MCK/16 ticks per
 	 * 1/HZ period (instead of a compile-time constant LATCH).
 	 */
-	if (IS_ERR(mck))
-		mck = clk_get(NULL, "mck");
-
-	if (IS_ERR(mck))
-		panic("AT91: PIT: Unable to get mck clk\n");
 	pit_rate = clk_get_rate(mck) / 16;
 	pit_cycle = DIV_ROUND_CLOSEST(pit_rate, HZ);
 	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) != 0);
@@ -277,6 +216,51 @@ void __init at91sam926x_pit_init(void)
 	clockevents_register_device(&pit_clkevt);
 }
 
+static void __init at91sam926x_pit_dt_init(struct device_node *node)
+{
+	unsigned int irq;
+
+	pit_base_addr = of_iomap(node, 0);
+	if (!pit_base_addr)
+		return;
+
+	mck = of_clk_get(node, 0);
+	if (IS_ERR(mck))
+		/* Fallback on clkdev for !CCF-based boards */
+		mck = clk_get(NULL, "mck");
+
+	if (IS_ERR(mck))
+		panic("AT91: PIT: Unable to get mck clk\n");
+
+	/* Get the interrupts property */
+	irq = irq_of_parse_and_map(node, 0);
+	if (!irq) {
+		pr_crit("AT91: PIT: Unable to get IRQ from DT\n");
+		goto clk_err;
+	}
+
+	at91sam926x_pit_irq.irq = irq;
+
+	at91sam926x_pit_common_init();
+
+clk_err:
+	clk_put(mck);
+	iounmap(pit_base_addr);
+}
+CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
+		       at91sam926x_pit_dt_init);
+
+void __init at91sam926x_pit_init(void)
+{
+	mck = clk_get(NULL, "mck");
+	if (IS_ERR(mck))
+		panic("AT91: PIT: Unable to get mck clk\n");
+
+	at91sam926x_pit_irq.irq = NR_IRQS_LEGACY + AT91_ID_SYS,
+
+	at91sam926x_pit_common_init();
+}
+
 void __init at91sam926x_ioremap_pit(u32 addr)
 {
 	if (of_have_populated_dt())
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 575b0be66ca8..a9fcdadfd929 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/clk-provider.h>
+#include <linux/clocksource.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -31,7 +32,7 @@ static void __init sam9_dt_timer_init(void)
 #if defined(CONFIG_COMMON_CLK)
 	of_clk_init(NULL);
 #endif
-	at91sam926x_pit_init();
+	clocksource_of_init();
 }
 
 static const struct of_device_id irq_of_match[] __initconst = {
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 075ec0576ada..c07dd2395f36 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/clk-provider.h>
+#include <linux/clocksource.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -32,7 +33,7 @@ static void __init sama5_dt_timer_init(void)
 #if defined(CONFIG_COMMON_CLK)
 	of_clk_init(NULL);
 #endif
-	at91sam926x_pit_init();
+	clocksource_of_init();
 }
 
 static const struct of_device_id irq_of_match[] __initconst = {
-- 
2.0.0

