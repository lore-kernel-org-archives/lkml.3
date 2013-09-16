Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3IPKCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:02:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:47139 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3IPKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:02:53 -0400
Date: Mon, 16 Sep 2013 12:02:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [GIT pull] timers core for 3.12
Message-ID: <alpine.DEB.2.02.1309161158280.4089@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers/core git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core

 * armada SoC clocksource overhaul with a trivial merge conflict
 * Minor improvements to various SoC clocksource drivers


Thanks,

	tglx

------------------>
Daniel Lezcano (1):
      ARM: nomadik: add dynamic irq flag to the timer

Ezequiel Garcia (8):
      clocksource: armada-370-xp: Use BIT()
      clocksource: armada-370-xp: Simplify TIMER_CTRL register access
      clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
      clocksource: armada-370-xp: Introduce new compatibles
      clocksource: armada-370-xp: Fix device-tree binding
      clocksource: armada-370-xp: Replace WARN_ON with BUG_ON
      clocksource: armada-370-xp: Get reference fixed-clock by name
      clocksource: armada-370-xp: Add detailed clock requirements in devicetree binding

Laurent Pinchart (1):
      clocksource: em_sti: Convert to devm_* managed helpers

Magnus Damm (1):
      clocksource: sh_cmt: 32-bit control register support

Viresh Kumar (1):
      ARM: timer-sp: Set dynamic irq affinity


 .../bindings/timer/marvell,armada-370-xp-timer.txt |   36 +++++-
 arch/arm/common/timer-sp.c                         |    3 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |    4 +-
 drivers/clocksource/em_sti.c                       |   49 ++-----
 drivers/clocksource/nomadik-mtu.c                  |    3 +-
 drivers/clocksource/sh_cmt.c                       |   50 +++++--
 drivers/clocksource/time-armada-370-xp.c           |  136 +++++++++++---------
 include/linux/time-armada-370-xp.h                 |   18 ---
 8 files changed, 164 insertions(+), 135 deletions(-)
 delete mode 100644 include/linux/time-armada-370-xp.h

diff --git a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
index 3638112..f455182 100644
--- a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
+++ b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
@@ -2,14 +2,40 @@ Marvell Armada 370 and Armada XP Timers
 ---------------------------------------
 
 Required properties:
-- compatible: Should be "marvell,armada-370-xp-timer"
+- compatible: Should be either "marvell,armada-370-timer" or
+  "marvell,armada-xp-timer" as appropriate.
 - interrupts: Should contain the list of Global Timer interrupts and
   then local timer interrupts
 - reg: Should contain location and length for timers register. First
   pair for the Global Timer registers, second pair for the
   local/private timers.
-- clocks: clock driving the timer hardware
 
-Optional properties:
-- marvell,timer-25Mhz: Tells whether the Global timer supports the 25
-  Mhz fixed mode (available on Armada XP and not on Armada 370)
+Clocks required for compatible = "marvell,armada-370-timer":
+- clocks : Must contain a single entry describing the clock input
+
+Clocks required for compatible = "marvell,armada-xp-timer":
+- clocks : Must contain an entry for each entry in clock-names.
+- clock-names : Must include the following entries:
+  "nbclk" (L2/coherency fabric clock),
+  "fixed" (Reference 25 MHz fixed-clock).
+
+Examples:
+
+- Armada 370:
+
+	timer {
+		compatible = "marvell,armada-370-timer";
+		reg = <0x20300 0x30>, <0x21040 0x30>;
+		interrupts = <37>, <38>, <39>, <40>, <5>, <6>;
+		clocks = <&coreclk 2>;
+	};
+
+- Armada XP:
+
+	timer {
+		compatible = "marvell,armada-xp-timer";
+		reg = <0x20300 0x30>, <0x21040 0x30>;
+		interrupts = <37>, <38>, <39>, <40>, <5>, <6>;
+		clocks = <&coreclk 2>, <&refclk>;
+		clock-names = "nbclk", "fixed";
+	};
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 023ee63..e901d0f 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -166,7 +166,8 @@ static int sp804_set_next_event(unsigned long next,
 }
 
 static struct clock_event_device sp804_clockevent = {
-	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
+		CLOCK_EVT_FEAT_DYNIRQ,
 	.set_mode	= sp804_set_mode,
 	.set_next_event	= sp804_set_next_event,
 	.rating		= 300,
diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
index 97cbb80..4ea03ad 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.c
+++ b/arch/arm/mach-mvebu/armada-370-xp.c
@@ -18,7 +18,7 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
-#include <linux/time-armada-370-xp.h>
+#include <linux/clocksource.h>
 #include <linux/dma-mapping.h>
 #include <linux/mbus.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -69,7 +69,7 @@ static void __init armada_370_xp_mbus_init(void)
 static void __init armada_370_xp_timer_and_clk_init(void)
 {
 	of_clk_init(NULL);
-	armada_370_xp_timer_init();
+	clocksource_of_init();
 	coherency_init();
 	armada_370_xp_mbus_init();
 #ifdef CONFIG_CACHE_L2X0
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 4329a29..b9c81b7 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -315,68 +315,47 @@ static int em_sti_probe(struct platform_device *pdev)
 {
 	struct em_sti_priv *p;
 	struct resource *res;
-	int irq, ret;
+	int irq;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (p == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		ret = -EINVAL;
-		goto err0;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get irq\n");
-		ret = -EINVAL;
-		goto err0;
+		return -EINVAL;
 	}
 
 	/* map memory, let base point to the STI instance */
-	p->base = ioremap_nocache(res->start, resource_size(res));
-	if (p->base == NULL) {
-		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		ret = -ENXIO;
-		goto err0;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	p->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(p->base))
+		return PTR_ERR(p->base);
 
 	/* get hold of clock */
-	p->clk = clk_get(&pdev->dev, "sclk");
+	p->clk = devm_clk_get(&pdev->dev, "sclk");
 	if (IS_ERR(p->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(p->clk);
-		goto err1;
+		return PTR_ERR(p->clk);
 	}
 
-	if (request_irq(irq, em_sti_interrupt,
-			IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
-			dev_name(&pdev->dev), p)) {
+	if (devm_request_irq(&pdev->dev, irq, em_sti_interrupt,
+			     IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			     dev_name(&pdev->dev), p)) {
 		dev_err(&pdev->dev, "failed to request low IRQ\n");
-		ret = -ENOENT;
-		goto err2;
+		return -ENOENT;
 	}
 
 	raw_spin_lock_init(&p->lock);
 	em_sti_register_clockevent(p);
 	em_sti_register_clocksource(p);
 	return 0;
-
-err2:
-	clk_put(p->clk);
-err1:
-	iounmap(p->base);
-err0:
-	kfree(p);
-	return ret;
 }
 
 static int em_sti_remove(struct platform_device *pdev)
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 7d2c2c5..1b74bea 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -165,7 +165,8 @@ static void nmdk_clkevt_resume(struct clock_event_device *cedev)
 
 static struct clock_event_device nmdk_clkevt = {
 	.name		= "mtu_1",
-	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC |
+	                  CLOCK_EVT_FEAT_DYNIRQ,
 	.rating		= 200,
 	.set_mode	= nmdk_clkevt_mode,
 	.set_next_event	= nmdk_clkevt_next,
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 08d0c41..0965e98 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -37,6 +37,7 @@
 
 struct sh_cmt_priv {
 	void __iomem *mapbase;
+	void __iomem *mapbase_str;
 	struct clk *clk;
 	unsigned long width; /* 16 or 32 bit version of hardware block */
 	unsigned long overflow_bit;
@@ -79,6 +80,12 @@ struct sh_cmt_priv {
  * CMCSR 0xffca0060 16-bit
  * CMCNT 0xffca0064 32-bit
  * CMCOR 0xffca0068 32-bit
+ *
+ * "32-bit counter and 32-bit control" as found on r8a73a4 and r8a7790:
+ * CMSTR 0xffca0500 32-bit
+ * CMCSR 0xffca0510 32-bit
+ * CMCNT 0xffca0514 32-bit
+ * CMCOR 0xffca0518 32-bit
  */
 
 static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
@@ -109,9 +116,7 @@ static void sh_cmt_write32(void __iomem *base, unsigned long offs,
 
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-
-	return p->read_control(p->mapbase - cfg->channel_offset, 0);
+	return p->read_control(p->mapbase_str, 0);
 }
 
 static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_priv *p)
@@ -127,9 +132,7 @@ static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_priv *p)
 static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
 				      unsigned long value)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
-
-	p->write_control(p->mapbase - cfg->channel_offset, 0, value);
+	p->write_control(p->mapbase_str, 0, value);
 }
 
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_priv *p,
@@ -676,7 +679,7 @@ static int sh_cmt_register(struct sh_cmt_priv *p, char *name,
 static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct resource *res;
+	struct resource *res, *res2;
 	int irq, ret;
 	ret = -ENXIO;
 
@@ -694,6 +697,9 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 		goto err0;
 	}
 
+	/* optional resource for the shared timer start/stop register */
+	res2 = platform_get_resource(p->pdev, IORESOURCE_MEM, 1);
+
 	irq = platform_get_irq(p->pdev, 0);
 	if (irq < 0) {
 		dev_err(&p->pdev->dev, "failed to get irq\n");
@@ -707,6 +713,15 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 		goto err0;
 	}
 
+	/* map second resource for CMSTR */
+	p->mapbase_str = ioremap_nocache(res2 ? res2->start :
+					 res->start - cfg->channel_offset,
+					 res2 ? resource_size(res2) : 2);
+	if (p->mapbase_str == NULL) {
+		dev_err(&p->pdev->dev, "failed to remap I/O second memory\n");
+		goto err1;
+	}
+
 	/* request irq using setup_irq() (too early for request_irq()) */
 	p->irqaction.name = dev_name(&p->pdev->dev);
 	p->irqaction.handler = sh_cmt_interrupt;
@@ -719,11 +734,17 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 	if (IS_ERR(p->clk)) {
 		dev_err(&p->pdev->dev, "cannot get clock\n");
 		ret = PTR_ERR(p->clk);
-		goto err1;
+		goto err2;
 	}
 
-	p->read_control = sh_cmt_read16;
-	p->write_control = sh_cmt_write16;
+	if (res2 && (resource_size(res2) == 4)) {
+		/* assume both CMSTR and CMCSR to be 32-bit */
+		p->read_control = sh_cmt_read32;
+		p->write_control = sh_cmt_write32;
+	} else {
+		p->read_control = sh_cmt_read16;
+		p->write_control = sh_cmt_write16;
+	}
 
 	if (resource_size(res) == 6) {
 		p->width = 16;
@@ -752,22 +773,23 @@ static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device *pdev)
 			      cfg->clocksource_rating);
 	if (ret) {
 		dev_err(&p->pdev->dev, "registration failed\n");
-		goto err2;
+		goto err3;
 	}
 	p->cs_enabled = false;
 
 	ret = setup_irq(irq, &p->irqaction);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
-		goto err2;
+		goto err3;
 	}
 
 	platform_set_drvdata(pdev, p);
 
 	return 0;
-err2:
+err3:
 	clk_put(p->clk);
-
+err2:
+	iounmap(p->mapbase_str);
 err1:
 	iounmap(p->mapbase);
 err0:
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 1b04b7e..44c4fff 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -13,6 +13,19 @@
  *
  * Timer 0 is used as free-running clocksource, while timer 1 is
  * used as clock_event_device.
+ *
+ * ---
+ * Clocksource driver for Armada 370 and Armada XP SoC.
+ * This driver implements one compatible string for each SoC, given
+ * each has its own characteristics:
+ *
+ *   * Armada 370 has no 25 MHz fixed timer.
+ *
+ *   * Armada XP cannot work properly without such 25 MHz fixed timer as
+ *     doing otherwise leads to using a clocksource whose frequency varies
+ *     when doing cpufreq frequency changes.
+ *
+ * See Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
  */
 
 #include <linux/init.h>
@@ -35,13 +48,13 @@
  * Timer block registers.
  */
 #define TIMER_CTRL_OFF		0x0000
-#define  TIMER0_EN		 0x0001
-#define  TIMER0_RELOAD_EN	 0x0002
-#define  TIMER0_25MHZ            0x0800
+#define  TIMER0_EN		 BIT(0)
+#define  TIMER0_RELOAD_EN	 BIT(1)
+#define  TIMER0_25MHZ            BIT(11)
 #define  TIMER0_DIV(div)         ((div) << 19)
-#define  TIMER1_EN		 0x0004
-#define  TIMER1_RELOAD_EN	 0x0008
-#define  TIMER1_25MHZ            0x1000
+#define  TIMER1_EN		 BIT(2)
+#define  TIMER1_RELOAD_EN	 BIT(3)
+#define  TIMER1_25MHZ            BIT(12)
 #define  TIMER1_DIV(div)         ((div) << 22)
 #define TIMER_EVENTS_STATUS	0x0004
 #define  TIMER0_CLR_MASK         (~0x1)
@@ -71,6 +84,18 @@ static u32 ticks_per_jiffy;
 
 static struct clock_event_device __percpu **percpu_armada_370_xp_evt;
 
+static void timer_ctrl_clrset(u32 clr, u32 set)
+{
+	writel((readl(timer_base + TIMER_CTRL_OFF) & ~clr) | set,
+		timer_base + TIMER_CTRL_OFF);
+}
+
+static void local_timer_ctrl_clrset(u32 clr, u32 set)
+{
+	writel((readl(local_base + TIMER_CTRL_OFF) & ~clr) | set,
+		local_base + TIMER_CTRL_OFF);
+}
+
 static u32 notrace armada_370_xp_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL_OFF);
@@ -83,7 +108,6 @@ static int
 armada_370_xp_clkevt_next_event(unsigned long delta,
 				struct clock_event_device *dev)
 {
-	u32 u;
 	/*
 	 * Clear clockevent timer interrupt.
 	 */
@@ -97,11 +121,8 @@ armada_370_xp_clkevt_next_event(unsigned long delta,
 	/*
 	 * Enable the timer.
 	 */
-	u = readl(local_base + TIMER_CTRL_OFF);
-	u = ((u & ~TIMER0_RELOAD_EN) | TIMER0_EN |
-	     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
-	writel(u, local_base + TIMER_CTRL_OFF);
-
+	local_timer_ctrl_clrset(TIMER0_RELOAD_EN,
+				TIMER0_EN | TIMER0_DIV(TIMER_DIVIDER_SHIFT));
 	return 0;
 }
 
@@ -109,8 +130,6 @@ static void
 armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 			  struct clock_event_device *dev)
 {
-	u32 u;
-
 	if (mode == CLOCK_EVT_MODE_PERIODIC) {
 
 		/*
@@ -122,18 +141,14 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 		/*
 		 * Enable timer.
 		 */
-
-		u = readl(local_base + TIMER_CTRL_OFF);
-
-		writel((u | TIMER0_EN | TIMER0_RELOAD_EN |
-			TIMER0_DIV(TIMER_DIVIDER_SHIFT)),
-			local_base + TIMER_CTRL_OFF);
+		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN |
+					   TIMER0_EN |
+					   TIMER0_DIV(TIMER_DIVIDER_SHIFT));
 	} else {
 		/*
 		 * Disable timer.
 		 */
-		u = readl(local_base + TIMER_CTRL_OFF);
-		writel(u & ~TIMER0_EN, local_base + TIMER_CTRL_OFF);
+		local_timer_ctrl_clrset(TIMER0_EN, 0);
 
 		/*
 		 * ACK pending timer interrupt.
@@ -169,18 +184,18 @@ static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
  */
 static int armada_370_xp_timer_setup(struct clock_event_device *evt)
 {
-	u32 u;
+	u32 clr = 0, set = 0;
 	int cpu = smp_processor_id();
 
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
 		return 0;
 
-	u = readl(local_base + TIMER_CTRL_OFF);
 	if (timer25Mhz)
-		writel(u | TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
+		set = TIMER0_25MHZ;
 	else
-		writel(u & ~TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
+		clr = TIMER0_25MHZ;
+	local_timer_ctrl_clrset(clr, set);
 
 	evt->name		= armada_370_xp_clkevt.name;
 	evt->irq		= armada_370_xp_clkevt.irq;
@@ -210,42 +225,21 @@ static struct local_timer_ops armada_370_xp_local_timer_ops = {
 	.stop	=  armada_370_xp_timer_stop,
 };
 
-void __init armada_370_xp_timer_init(void)
+static void __init armada_370_xp_timer_common_init(struct device_node *np)
 {
-	u32 u;
-	struct device_node *np;
+	u32 clr = 0, set = 0;
 	int res;
 
-	np = of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-timer");
 	timer_base = of_iomap(np, 0);
 	WARN_ON(!timer_base);
 	local_base = of_iomap(np, 1);
 
-	if (of_find_property(np, "marvell,timer-25Mhz", NULL)) {
-		/* The fixed 25MHz timer is available so let's use it */
-		u = readl(local_base + TIMER_CTRL_OFF);
-		writel(u | TIMER0_25MHZ,
-		       local_base + TIMER_CTRL_OFF);
-		u = readl(timer_base + TIMER_CTRL_OFF);
-		writel(u | TIMER0_25MHZ,
-		       timer_base + TIMER_CTRL_OFF);
-		timer_clk = 25000000;
-	} else {
-		unsigned long rate = 0;
-		struct clk *clk = of_clk_get(np, 0);
-		WARN_ON(IS_ERR(clk));
-		rate =  clk_get_rate(clk);
-		u = readl(local_base + TIMER_CTRL_OFF);
-		writel(u & ~(TIMER0_25MHZ),
-		       local_base + TIMER_CTRL_OFF);
-
-		u = readl(timer_base + TIMER_CTRL_OFF);
-		writel(u & ~(TIMER0_25MHZ),
-		       timer_base + TIMER_CTRL_OFF);
-
-		timer_clk = rate / TIMER_DIVIDER;
-		timer25Mhz = false;
-	}
+	if (timer25Mhz)
+		set = TIMER0_25MHZ;
+	else
+		clr = TIMER0_25MHZ;
+	timer_ctrl_clrset(clr, set);
+	local_timer_ctrl_clrset(clr, set);
 
 	/*
 	 * We use timer 0 as clocksource, and private(local) timer 0
@@ -267,10 +261,8 @@ void __init armada_370_xp_timer_init(void)
 	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
 	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
 
-	u = readl(timer_base + TIMER_CTRL_OFF);
-
-	writel((u | TIMER0_EN | TIMER0_RELOAD_EN |
-		TIMER0_DIV(TIMER_DIVIDER_SHIFT)), timer_base + TIMER_CTRL_OFF);
+	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
+			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
 
 	clocksource_mmio_init(timer_base + TIMER0_VAL_OFF,
 			      "armada_370_xp_clocksource",
@@ -299,3 +291,29 @@ void __init armada_370_xp_timer_init(void)
 #endif
 	}
 }
+
+static void __init armada_xp_timer_init(struct device_node *np)
+{
+	struct clk *clk = of_clk_get_by_name(np, "fixed");
+
+	/* The 25Mhz fixed clock is mandatory, and must always be available */
+	BUG_ON(IS_ERR(clk));
+	timer_clk = clk_get_rate(clk);
+
+	armada_370_xp_timer_common_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(armada_xp, "marvell,armada-xp-timer",
+		       armada_xp_timer_init);
+
+static void __init armada_370_timer_init(struct device_node *np)
+{
+	struct clk *clk = of_clk_get(np, 0);
+
+	BUG_ON(IS_ERR(clk));
+	timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
+	timer25Mhz = false;
+
+	armada_370_xp_timer_common_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(armada_370, "marvell,armada-370-timer",
+		       armada_370_timer_init);
diff --git a/include/linux/time-armada-370-xp.h b/include/linux/time-armada-370-xp.h
deleted file mode 100644
index dfdfdc0..0000000
--- a/include/linux/time-armada-370-xp.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Marvell Armada 370/XP SoC timer handling.
- *
- * Copyright (C) 2012 Marvell
- *
- * Lior Amsalem <alior@marvell.com>
- * Gregory CLEMENT <gregory.clement@free-electrons.com>
- * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
- *
- */
-#ifndef __TIME_ARMADA_370_XPPRCMU_H
-#define __TIME_ARMADA_370_XPPRCMU_H
-
-#include <linux/init.h>
-
-void __init armada_370_xp_timer_init(void);
-
-#endif
