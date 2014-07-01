Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbaGAJfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757768AbaGAJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 10/14] AT91: PIT: (Almost) remove the global variables
Date: Tue,  1 Jul 2014 11:33:23 +0200
Message-Id: <1404207208-14513-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer driver is using some global variables to define some variables it has
to use in most of its functions, like the base address.

Use some container_of calls to have a single dynamic (and local) variable to
hold this content.

The only exception is in the !DT case, where the call chain to
at91sam926x_ioremap_pit and then at91sam926x_pit_init as init_time makes it
hard for the moment to pass the physical address of the timer.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 179 ++++++++++++++++++++--------------
 1 file changed, 108 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index e476474cb05e..9abb289dce72 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -20,6 +20,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/slab.h>
 
 #include <mach/hardware.h>
 
@@ -39,19 +40,35 @@
 #define PIT_CPIV(x)	((x) & AT91_PIT_CPIV)
 #define PIT_PICNT(x)	(((x) & AT91_PIT_PICNT) >> 20)
 
-static u32 pit_cycle;		/* write-once */
-static u32 pit_cnt;		/* access only w/system irq blocked */
-static void __iomem *pit_base_addr __read_mostly;
-static struct clk *mck;
+struct pit_data {
+	struct clock_event_device	clkevt;
+	struct clocksource		clksrc;
 
-static inline unsigned int pit_read(unsigned int reg_offset)
+	void __iomem	*base;
+	u32		cycle;
+	u32		cnt;
+	unsigned int	irq;
+	struct clk	*mck;
+};
+
+static inline struct pit_data *clksrc_to_pit_data(struct clocksource *clksrc)
 {
-	return __raw_readl(pit_base_addr + reg_offset);
+	return container_of(clksrc, struct pit_data, clksrc);
 }
 
-static inline void pit_write(unsigned int reg_offset, unsigned long value)
+static inline struct pit_data *clkevt_to_pit_data(struct clock_event_device *clkevt)
 {
-	__raw_writel(value, pit_base_addr + reg_offset);
+	return container_of(clkevt, struct pit_data, clkevt);
+}
+
+static inline unsigned int pit_read(void __iomem *base, unsigned int reg_offset)
+{
+	return __raw_readl(base + reg_offset);
+}
+
+static inline void pit_write(void __iomem *base, unsigned int reg_offset, unsigned long value)
+{
+	__raw_writel(value, base + reg_offset);
 }
 
 /*
@@ -60,40 +77,35 @@ static inline void pit_write(unsigned int reg_offset, unsigned long value)
  */
 static cycle_t read_pit_clk(struct clocksource *cs)
 {
+	struct pit_data *data = clksrc_to_pit_data(cs);
 	unsigned long flags;
 	u32 elapsed;
 	u32 t;
 
 	raw_local_irq_save(flags);
-	elapsed = pit_cnt;
-	t = pit_read(AT91_PIT_PIIR);
+	elapsed = data->cnt;
+	t = pit_read(data->base, AT91_PIT_PIIR);
 	raw_local_irq_restore(flags);
 
-	elapsed += PIT_PICNT(t) * pit_cycle;
+	elapsed += PIT_PICNT(t) * data->cycle;
 	elapsed += PIT_CPIV(t);
 	return elapsed;
 }
 
-static struct clocksource pit_clk = {
-	.name		= "pit",
-	.rating		= 175,
-	.read		= read_pit_clk,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-
 /*
  * Clockevent device:  interrupts every 1/HZ (== pit_cycles * MCK/16)
  */
 static void
 pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 {
+	struct pit_data *data = clkevt_to_pit_data(dev);
+
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* update clocksource counter */
-		pit_cnt += pit_cycle * PIT_PICNT(pit_read(AT91_PIT_PIVR));
-		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN
-				| AT91_PIT_PITIEN);
+		data->cnt += data->cycle * PIT_PICNT(pit_read(data->base, AT91_PIT_PIVR));
+		pit_write(data->base, AT91_PIT_MR,
+			  (data->cycle - 1) | AT91_PIT_PITEN | AT91_PIT_PITIEN);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		BUG();
@@ -101,7 +113,8 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
 		/* disable irq, leaving the clocksource active */
-		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
+		pit_write(data->base, AT91_PIT_MR,
+			  (data->cycle - 1) | AT91_PIT_PITEN);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		break;
@@ -110,44 +123,40 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 
 static void at91sam926x_pit_suspend(struct clock_event_device *cedev)
 {
+	struct pit_data *data = clkevt_to_pit_data(cedev);
+
 	/* Disable timer */
-	pit_write(AT91_PIT_MR, 0);
+	pit_write(data->base, AT91_PIT_MR, 0);
 }
 
-static void at91sam926x_pit_reset(void)
+static void at91sam926x_pit_reset(struct pit_data *data)
 {
 	/* Disable timer and irqs */
-	pit_write(AT91_PIT_MR, 0);
+	pit_write(data->base, AT91_PIT_MR, 0);
 
 	/* Clear any pending interrupts, wait for PIT to stop counting */
-	while (PIT_CPIV(pit_read(AT91_PIT_PIVR)) != 0)
+	while (PIT_CPIV(pit_read(data->base, AT91_PIT_PIVR)) != 0)
 		cpu_relax();
 
 	/* Start PIT but don't enable IRQ */
-	pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
+	pit_write(data->base, AT91_PIT_MR,
+		  (data->cycle - 1) | AT91_PIT_PITEN);
 }
 
 static void at91sam926x_pit_resume(struct clock_event_device *cedev)
 {
-	at91sam926x_pit_reset();
-}
-
-static struct clock_event_device pit_clkevt = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC,
-	.shift		= 32,
-	.rating		= 100,
-	.set_mode	= pit_clkevt_mode,
-	.suspend	= at91sam926x_pit_suspend,
-	.resume		= at91sam926x_pit_resume,
-};
+	struct pit_data *data = clkevt_to_pit_data(cedev);
 
+	at91sam926x_pit_reset(data);
+}
 
 /*
  * IRQ handler for the timer.
  */
 static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 {
+	struct pit_data *data = dev_id;
+
 	/*
 	 * irqs should be disabled here, but as the irq is shared they are only
 	 * guaranteed to be off if the timer irq is registered first.
@@ -155,15 +164,15 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	/* The PIT interrupt may be disabled, and is shared */
-	if ((pit_clkevt.mode == CLOCK_EVT_MODE_PERIODIC)
-			&& (pit_read(AT91_PIT_SR) & AT91_PIT_PITS)) {
+	if ((data->clkevt.mode == CLOCK_EVT_MODE_PERIODIC) &&
+	    (pit_read(data->base, AT91_PIT_SR) & AT91_PIT_PITS)) {
 		unsigned nr_ticks;
 
 		/* Get number of ticks performed before irq, and ack it */
-		nr_ticks = PIT_PICNT(pit_read(AT91_PIT_PIVR));
+		nr_ticks = PIT_PICNT(pit_read(data->base, AT91_PIT_PIVR));
 		do {
-			pit_cnt += pit_cycle;
-			pit_clkevt.event_handler(&pit_clkevt);
+			data->cnt += data->cycle;
+			data->clkevt.event_handler(&data->clkevt);
 			nr_ticks--;
 		} while (nr_ticks);
 
@@ -176,7 +185,7 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
 /*
  * Set up both clocksource and clockevent support.
  */
-static void __init at91sam926x_pit_common_init(unsigned int pit_irq)
+static void __init at91sam926x_pit_common_init(struct pit_data *data)
 {
 	unsigned long	pit_rate;
 	unsigned	bits;
@@ -186,67 +195,95 @@ static void __init at91sam926x_pit_common_init(unsigned int pit_irq)
 	 * Use our actual MCK to figure out how many MCK/16 ticks per
 	 * 1/HZ period (instead of a compile-time constant LATCH).
 	 */
-	pit_rate = clk_get_rate(mck) / 16;
-	pit_cycle = DIV_ROUND_CLOSEST(pit_rate, HZ);
-	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) != 0);
+	pit_rate = clk_get_rate(data->mck) / 16;
+	data->cycle = DIV_ROUND_CLOSEST(pit_rate, HZ);
+	WARN_ON(((data->cycle - 1) & ~AT91_PIT_PIV) != 0);
 
 	/* Initialize and enable the timer */
-	at91sam926x_pit_reset();
+	at91sam926x_pit_reset(data);
 
 	/*
 	 * Register clocksource.  The high order bits of PIV are unused,
 	 * so this isn't a 32-bit counter unless we get clockevent irqs.
 	 */
-	bits = 12 /* PICNT */ + ilog2(pit_cycle) /* PIV */;
-	pit_clk.mask = CLOCKSOURCE_MASK(bits);
-	clocksource_register_hz(&pit_clk, pit_rate);
+	bits = 12 /* PICNT */ + ilog2(data->cycle) /* PIV */;
+	data->clksrc.mask = CLOCKSOURCE_MASK(bits);
+	data->clksrc.name = "pit";
+	data->clksrc.rating = 175;
+	data->clksrc.read = read_pit_clk,
+	data->clksrc.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+	clocksource_register_hz(&data->clksrc, pit_rate);
 
 	/* Set up irq handler */
-	ret = request_irq(pit_irq, at91sam926x_pit_interrupt,
+	ret = request_irq(data->irq, at91sam926x_pit_interrupt,
 			  IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
-			  "at91_tick", pit_base_addr);
+			  "at91_tick", data);
 	if (ret)
 		panic(pr_fmt("Unable to setup IRQ\n"));
 
 	/* Set up and register clockevents */
-	pit_clkevt.mult = div_sc(pit_rate, NSEC_PER_SEC, pit_clkevt.shift);
-	pit_clkevt.cpumask = cpumask_of(0);
-	clockevents_register_device(&pit_clkevt);
+	data->clkevt.name = "pit";
+	data->clkevt.features = CLOCK_EVT_FEAT_PERIODIC;
+	data->clkevt.shift = 32;
+	data->clkevt.mult = div_sc(pit_rate, NSEC_PER_SEC, data->clkevt.shift);
+	data->clkevt.rating = 100;
+	data->clkevt.cpumask = cpumask_of(0);
+
+	data->clkevt.set_mode = pit_clkevt_mode;
+	data->clkevt.resume = at91sam926x_pit_resume;
+	data->clkevt.suspend = at91sam926x_pit_suspend;
+	clockevents_register_device(&data->clkevt);
 }
 
 static void __init at91sam926x_pit_dt_init(struct device_node *node)
 {
-	unsigned int irq;
+	struct pit_data *data;
 
-	pit_base_addr = of_iomap(node, 0);
-	if (!pit_base_addr)
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		panic(pr_fmt("Unable to allocate memory\n"));
+
+	data->base = of_iomap(node, 0);
+	if (!data->base)
 		panic(pr_fmt("Could not map PIT address\n"));
 
-	mck = of_clk_get(node, 0);
-	if (IS_ERR(mck))
+	data->mck = of_clk_get(node, 0);
+	if (IS_ERR(data->mck))
 		/* Fallback on clkdev for !CCF-based boards */
-		mck = clk_get(NULL, "mck");
+		data->mck = clk_get(NULL, "mck");
 
-	if (IS_ERR(mck))
+	if (IS_ERR(data->mck))
 		panic(pr_fmt("Unable to get mck clk\n"));
 
 	/* Get the interrupts property */
-	irq = irq_of_parse_and_map(node, 0);
-	if (!irq)
+	data->irq = irq_of_parse_and_map(node, 0);
+	if (!data->irq)
 		panic(pr_fmt("Unable to get IRQ from DT\n"));
 
-	at91sam926x_pit_common_init(irq);
+	at91sam926x_pit_common_init(data);
 }
 CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
 		       at91sam926x_pit_dt_init);
 
+static void __iomem *pit_base_addr;
+
 void __init at91sam926x_pit_init(void)
 {
-	mck = clk_get(NULL, "mck");
-	if (IS_ERR(mck))
+	struct pit_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		panic(pr_fmt("Unable to allocate memory\n"));
+
+	data->base = pit_base_addr;
+
+	data->mck = clk_get(NULL, "mck");
+	if (IS_ERR(data->mck))
 		panic(pr_fmt("Unable to get mck clk\n"));
 
-	at91sam926x_pit_common_init(NR_IRQS_LEGACY + AT91_ID_SYS);
+	data->irq = NR_IRQS_LEGACY + AT91_ID_SYS;
+
+	at91sam926x_pit_common_init(data);
 }
 
 void __init at91sam926x_ioremap_pit(u32 addr)
-- 
2.0.0

