Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3CTW5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:57:31 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59956 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3CTWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:32 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 03/11] ARM: timer-sp: convert to use CLKSRC_OF init
Date: Wed, 20 Mar 2013 17:54:03 -0500
Message-Id: <1363820051-24428-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds CLKSRC_OF based init for sp804 timer. The clock initialization is
refactored to support retrieving the clock(s) from the DT.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/Kconfig                         |    1 +
 arch/arm/common/timer-sp.c               |   98 +++++++++++++++++++++++++-----
 arch/arm/include/asm/hardware/timer-sp.h |   16 +++--
 3 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f0f90f0..774131a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1172,6 +1172,7 @@ config PLAT_VERSATILE
 config ARM_TIMER_SP804
 	bool
 	select CLKSRC_MMIO
+	select CLKSRC_OF if OF
 	select HAVE_SCHED_CLOCK
 
 source arch/arm/mm/Kconfig
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 9d2d3ba..3e86835 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -25,33 +25,28 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <asm/sched_clock.h>
 #include <asm/hardware/arm_timer.h>
 
-static long __init sp804_get_clock_rate(const char *name)
+static long __init sp804_get_clock_rate(struct clk *clk)
 {
-	struct clk *clk;
 	long rate;
 	int err;
 
-	clk = clk_get_sys("sp804", name);
-	if (IS_ERR(clk)) {
-		pr_err("sp804: %s clock not found: %d\n", name,
-			(int)PTR_ERR(clk));
-		return PTR_ERR(clk);
-	}
-
 	err = clk_prepare(clk);
 	if (err) {
-		pr_err("sp804: %s clock failed to prepare: %d\n", name, err);
+		pr_err("sp804: clock failed to prepare: %d\n", err);
 		clk_put(clk);
 		return err;
 	}
 
 	err = clk_enable(clk);
 	if (err) {
-		pr_err("sp804: %s clock failed to enable: %d\n", name, err);
+		pr_err("sp804: clock failed to enable: %d\n", err);
 		clk_unprepare(clk);
 		clk_put(clk);
 		return err;
@@ -59,7 +54,7 @@ static long __init sp804_get_clock_rate(const char *name)
 
 	rate = clk_get_rate(clk);
 	if (rate < 0) {
-		pr_err("sp804: %s clock failed to get rate: %ld\n", name, rate);
+		pr_err("sp804: clock failed to get rate: %ld\n", rate);
 		clk_disable(clk);
 		clk_unprepare(clk);
 		clk_put(clk);
@@ -77,9 +72,21 @@ static u32 sp804_read(void)
 
 void __init __sp804_clocksource_and_sched_clock_init(void __iomem *base,
 						     const char *name,
+						     struct clk *clk,
 						     int use_sched_clock)
 {
-	long rate = sp804_get_clock_rate(name);
+	long rate;
+
+	if (!clk) {
+		clk = clk_get_sys("sp804", name);
+		if (IS_ERR(clk)) {
+			pr_err("sp804: clock not found: %d\n",
+			       (int)PTR_ERR(clk));
+			return;
+		}
+	}
+
+	rate = sp804_get_clock_rate(clk);
 
 	if (rate < 0)
 		return;
@@ -171,12 +178,20 @@ static struct irqaction sp804_timer_irq = {
 	.dev_id		= &sp804_clockevent,
 };
 
-void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
-	const char *name)
+void __init __sp804_clockevents_init(void __iomem *base, unsigned int irq, struct clk *clk, const char *name)
 {
 	struct clock_event_device *evt = &sp804_clockevent;
-	long rate = sp804_get_clock_rate(name);
+	long rate;
+
+	if (!clk)
+		clk = clk_get_sys("sp804", name);
+	if (IS_ERR(clk)) {
+		pr_err("sp804: %s clock not found: %d\n", name,
+			(int)PTR_ERR(clk));
+		return;
+	}
 
+	rate = sp804_get_clock_rate(clk);
 	if (rate < 0)
 		return;
 
@@ -186,6 +201,57 @@ void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
 	evt->irq = irq;
 	evt->cpumask = cpu_possible_mask;
 
+	writel(0, clkevt_base + TIMER_CTRL);
+
 	setup_irq(irq, &sp804_timer_irq);
 	clockevents_config_and_register(evt, rate, 0xf, 0xffffffff);
 }
+
+static void __init sp804_of_init(struct device_node *np)
+{
+	static bool initialized = false;
+	void __iomem *base;
+	int irq;
+	u32 irq_num = 0;
+	bool tmr2_evt = false;
+	struct clk *clk0, *clk1;
+	const char *name = of_get_property(np, "compatible", NULL);
+
+	if (initialized || !of_device_is_available(np))
+		return;
+
+	base = of_iomap(np, 0);
+	if (WARN_ON(!base))
+		return;
+
+	clk0 = of_clk_get(np, 0);
+	if (IS_ERR(clk0))
+		clk0 = NULL;
+
+	/* Get the 2nd clock if the timer has 2 timer clocks */
+	if (of_count_phandle_with_args(np, "clocks", "#clock-cells") == 3) {
+		clk1 = of_clk_get(np, 1);
+		if (IS_ERR(clk1)) {
+			pr_err("sp804: %s clock not found: %d\n", np->name,
+				(int)PTR_ERR(clk1));
+			return;
+		}
+	} else
+		clk1 = clk0;
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0)
+		return;
+
+	of_property_read_u32(np, "arm,sp804-has-irq", &irq_num);
+	if (irq_num == 2)
+		tmr2_evt = true;
+
+	__sp804_clockevents_init(base + (tmr2_evt ? TIMER_2_BASE : 0),
+				 irq, tmr2_evt ? clk1 : clk0, name);
+	__sp804_clocksource_and_sched_clock_init(base + (tmr2_evt ? 0 : TIMER_2_BASE),
+						 name, tmr2_evt ? clk0 : clk1, 1);
+
+	initialized = true;
+}
+CLOCKSOURCE_OF_DECLARE(sp804, "arm,sp804", sp804_of_init);
diff --git a/arch/arm/include/asm/hardware/timer-sp.h b/arch/arm/include/asm/hardware/timer-sp.h
index 2dd9d3f..bb28af7 100644
--- a/arch/arm/include/asm/hardware/timer-sp.h
+++ b/arch/arm/include/asm/hardware/timer-sp.h
@@ -1,15 +1,23 @@
+struct clk;
+
 void __sp804_clocksource_and_sched_clock_init(void __iomem *,
-					      const char *, int);
+					      const char *, struct clk *, int);
+void __sp804_clockevents_init(void __iomem *, unsigned int,
+			      struct clk *, const char *);
 
 static inline void sp804_clocksource_init(void __iomem *base, const char *name)
 {
-	__sp804_clocksource_and_sched_clock_init(base, name, 0);
+	__sp804_clocksource_and_sched_clock_init(base, name, NULL, 0);
 }
 
 static inline void sp804_clocksource_and_sched_clock_init(void __iomem *base,
 							  const char *name)
 {
-	__sp804_clocksource_and_sched_clock_init(base, name, 1);
+	__sp804_clocksource_and_sched_clock_init(base, name, NULL, 1);
 }
 
-void sp804_clockevents_init(void __iomem *, unsigned int, const char *);
+static inline void sp804_clockevents_init(void __iomem *base, unsigned int irq, const char *name)
+{
+	__sp804_clockevents_init(base, irq, NULL, name);
+
+}
-- 
1.7.10.4

