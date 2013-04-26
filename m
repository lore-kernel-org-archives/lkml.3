Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3DZMOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:14:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57469 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3DZMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:14:36 -0400
Date: Fri, 26 Apr 2013 14:14:34 +0200
From: Pavel Machek <pavel@denx.de>
To: dinguyen@altera.com, wd@denx.de, jamie@jamieiles.com,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net, arnd@arndb.de,
        johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>
Subject: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130426121433.GA16249@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems we made a mistake when creating dw_apb_timer_of.c:
picoxcell sched_clock parts were not related to dw_apb_timer, yet
we moved them to dw_apb_timer_of, and tried to use them on socfpga.
    
This results in system where user/system time is not measured properly,
as demonstrated by
    
    time dd if=/dev/urandom of=/dev/zero bs=100000 count=100
    
    .
    
So this patch:
    
    1) moves picoxcell sched_clock parts back to picoxcell
    
    2) adds support to use dw_apb_timer s as sched_clock. Picoxcell could
    consider switching to these
    
    3) adds missing of_node_put() in dw_apb_timer_init().
    
Tested on socfpga, soc-next (3.9-rc6) based tree.
    
Signed-off-by: Pavel Machek <pavel@denx.de>
Tested-by: Dinh Nguyen <dinguyen@altera.com>

---

I think this is ready to go to soc-next tree. Please apply,
									Pavel


diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index 70b441a..22759f5 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -84,11 +84,39 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
 	}
 }
 
+static const struct of_device_id picochip_rtc_ids[] __initconst = {
+        { .compatible = "picochip,pc3x2-rtc" },
+        { /* Sentinel */ },
+};
+
+static void __iomem *sched_io_base;
+
+static u32 read_sched_clock(void)
+{
+        return __raw_readl(sched_io_base);
+}
+
+static void __init timer_init(void)
+{
+	u32 rate;
+
+	dw_apb_timer_init(0);
+
+	sched_timer = of_find_matching_node(timer, osctimer_ids);
+	if (!sched_timer)
+		panic("No suitable timer for scheduler clock\n");
+
+	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
+	of_node_put(sched_timer);
+
+	setup_sched_clock(read_sched_clock, 32, rate);
+}
+
 DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
 	.map_io		= picoxcell_map_io,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= irqchip_init,
-	.init_time	= dw_apb_timer_init,
+	.init_time	= timer_init,
 	.init_machine	= picoxcell_init_machine,
 	.dt_compat	= picoxcell_dt_match,
 	.restart	= picoxcell_wdt_restart,
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index 46a0513..3a030e5 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -116,11 +116,17 @@ static const char *altera_dt_match[] = {
 	NULL
 };
 
+static void __init timer_init(void)
+{
+	dw_apb_timer_init(1);
+}
+
+
 DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
 	.smp		= smp_ops(socfpga_smp_ops),
 	.map_io		= socfpga_map_io,
 	.init_irq	= socfpga_init_irq,
-	.init_time	= dw_apb_timer_init,
+	.init_time	= timer_init,
 	.init_machine	= socfpga_cyclone5_init,
 	.restart	= socfpga_cyclone5_restart,
 	.dt_compat	= altera_dt_match,
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 8c2a35f..460ac99 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -21,12 +21,6 @@
 #define APBT_MIN_PERIOD			4
 #define APBT_MIN_DELTA_USEC		200
 
-#define APBTMR_N_LOAD_COUNT		0x00
-#define APBTMR_N_CURRENT_VALUE		0x04
-#define APBTMR_N_CONTROL		0x08
-#define APBTMR_N_EOI			0x0c
-#define APBTMR_N_INT_STATUS		0x10
-
 #define APBTMRS_INT_STATUS		0xa0
 #define APBTMRS_EOI			0xa4
 #define APBTMRS_RAW_INT_STATUS		0xa8
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index ab09ed3..ac4ea00 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -57,7 +57,16 @@ static void add_clockevent(struct device_node *event_timer)
 	dw_apb_clockevent_register(ced);
 }
 
-static void add_clocksource(struct device_node *source_timer)
+static void __iomem *sched_io_base;
+
+/* This is actually same as __apbt_read_clocksource(), but with
+   different interface */
+static u32 read_sched_clock_sptimer(void)
+{
+	return ~__raw_readl(sched_io_base + APBTMR_N_CURRENT_VALUE);
+}
+
+static void add_clocksource(struct device_node *source_timer, int use_as_scheduler)
 {
 	void __iomem *iobase;
 	struct dw_apb_clocksource *cs;
@@ -71,45 +80,33 @@ static void add_clocksource(struct device_node *source_timer)
 
 	dw_apb_clocksource_start(cs);
 	dw_apb_clocksource_register(cs);
-}
 
-static void __iomem *sched_io_base;
-
-static u32 read_sched_clock(void)
-{
-	return __raw_readl(sched_io_base);
+	if (use_as_scheduler) {
+		sched_io_base = iobase;
+		setup_sched_clock(read_sched_clock_sptimer, 32, rate);
+	}
 }
 
-static const struct of_device_id sptimer_ids[] __initconst = {
-	{ .compatible = "picochip,pc3x2-rtc" },
+static const struct of_device_id osctimer_ids[] __initconst = {
+	{ .compatible = "picochip,pc3x2-timer" },
+	{ .compatible = "snps,dw-apb-timer-osc" },
 	{ .compatible = "snps,dw-apb-timer-sp" },
-	{ /* Sentinel */ },
+	{  /* Sentinel */ },
 };
 
-static void init_sched_clock(void)
-{
-	struct device_node *sched_timer;
-	u32 rate;
-
-	sched_timer = of_find_matching_node(NULL, sptimer_ids);
-	if (!sched_timer)
-		panic("No RTC for sched clock to use");
-
-	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
-	of_node_put(sched_timer);
+/*
+   You don't have to use dw_apb_timer for scheduler clock,
+   this should also work fine on arm:
 
-	setup_sched_clock(read_sched_clock, 32, rate);
-}
+  twd_local_timer_of_register();
+  arch_timer_of_register();                 
+  arch_timer_sched_clock_init();
+*/
 
-static const struct of_device_id osctimer_ids[] __initconst = {
-	{ .compatible = "picochip,pc3x2-timer" },
-	{ .compatible = "snps,dw-apb-timer-osc" },
-	{},
-};
 
-void __init dw_apb_timer_init(void)
+void __init dw_apb_timer_init(int use_as_scheduler)
 {
 	struct device_node *event_timer, *source_timer;
 
 	event_timer = of_find_matching_node(NULL, osctimer_ids);
 	if (!event_timer)
@@ -119,9 +117,8 @@ void __init dw_apb_timer_init(void)
 	source_timer = of_find_matching_node(event_timer, osctimer_ids);
 	if (!source_timer)
 		panic("No timer for clocksource");
-	add_clocksource(source_timer);
+	add_clocksource(source_timer, use_as_scheduler);
 
+	of_node_put(event_timer);
 	of_node_put(source_timer);
-
-	init_sched_clock();
 }
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index dd755ce..d503245 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -17,6 +17,12 @@
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
 
+#define APBTMR_N_LOAD_COUNT		0x00
+#define APBTMR_N_CURRENT_VALUE		0x04
+#define APBTMR_N_CONTROL		0x08
+#define APBTMR_N_EOI			0x0c
+#define APBTMR_N_INT_STATUS		0x10
+
 #define APBTMRS_REG_SIZE       0x14
 
 struct dw_apb_timer {
@@ -53,5 +59,5 @@ void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
-extern void dw_apb_timer_init(void);
+extern void dw_apb_timer_init(int);
 #endif /* __DW_APB_TIMER_H__ */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
