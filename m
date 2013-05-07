Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3EGULg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:11:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57136 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3EGULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:11:34 -0400
Date: Tue, 7 May 2013 22:11:26 +0200
From: Pavel Machek <pavel@denx.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130507201126.GA8169@amd.pavel.ucw.cz>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <201305061545.22587.arnd@arndb.de>
 <20130506155304.GA6645@amd.pavel.ucw.cz>
 <201305062324.17080.arnd@arndb.de>
 <20130507135752.GA3500@amd.pavel.ucw.cz>
 <51892E5E.8090909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51892E5E.8090909@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>So I guess it should go through the timekeeping tree...?
> >>I would prefer that, but we can also take it through arm-soc, it doesn't
> >>really matter.
> >I see no response from timekeeping people... so if you could take it,
> >that would be great.
> 
> I don't think the original patch ever made it to my inbox.

For some reason, I cced johnstul@us.ibm.com. (I guess
get_maintainer.pl? But it seems to behave now.) Anyway, patch is
below...

It would be great if you could apply it... Thanks,
							Pavel

----

It seems we made a mistake when creating dw_apb_timer_of.c:
picoxcell sched_clock had parts that were not related to
dw_apb_timer, yet we moved them to dw_apb_timer_of, and tried to
use them on socfpga.

This results in system where user/system time is not measured
properly, as demonstrated by
    
    time dd if=/dev/urandom of=/dev/zero bs=100000 count=100
    
So this patch switches sched_clock to hardware that exists on both
platforms, and adds missing of_node_put() in dw_apb_timer_init().
    
Signed-off-by: Pavel Machek <pavel@denx.de>
Acked-by: Jamie Iles <jamie@jamieiles.com>

diff --git a/arch/arm/mach-picoxcell/common.h b/arch/arm/mach-picoxcell/common.h
index 481b42a..237fb3b 100644
--- a/arch/arm/mach-picoxcell/common.h
+++ b/arch/arm/mach-picoxcell/common.h
@@ -12,6 +12,4 @@
 
 #include <asm/mach/time.h>
 
-extern void dw_apb_timer_init(void);
-
 #endif /* __PICOXCELL_COMMON_H__ */
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
index ab09ed3..0fa3104 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -57,6 +57,15 @@ static void add_clockevent(struct device_node *event_timer)
 	dw_apb_clockevent_register(ced);
 }
 
+static void __iomem *sched_io_base;
+
+/* This is actually same as __apbt_read_clocksource(), but with
+   different interface */
+static u32 read_sched_clock_sptimer(void)
+{
+	return ~__raw_readl(sched_io_base + APBTMR_N_CURRENT_VALUE);
+}
+
 static void add_clocksource(struct device_node *source_timer)
 {
 	void __iomem *iobase;
@@ -71,41 +80,27 @@ static void add_clocksource(struct device_node *source_timer)
 
 	dw_apb_clocksource_start(cs);
 	dw_apb_clocksource_register(cs);
-}
 
-static void __iomem *sched_io_base;
-
-static u32 read_sched_clock(void)
-{
-	return __raw_readl(sched_io_base);
+	sched_io_base = iobase;
+	setup_sched_clock(read_sched_clock_sptimer, 32, rate);
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
+/*
+   You don't have to use dw_apb_timer for scheduler clock,
+   this should also work fine on arm:
 
-	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
-	of_node_put(sched_timer);
+  twd_local_timer_of_register();
+  arch_timer_of_register();                 
+  arch_timer_sched_clock_init();
+*/
 
-	setup_sched_clock(read_sched_clock, 32, rate);
-}
-
-static const struct of_device_id osctimer_ids[] __initconst = {
-	{ .compatible = "picochip,pc3x2-timer" },
-	{ .compatible = "snps,dw-apb-timer-osc" },
-	{},
-};
 
 void __init dw_apb_timer_init(void)
 {
@@ -121,7 +116,6 @@ void __init dw_apb_timer_init(void)
 		panic("No timer for clocksource");
 	add_clocksource(source_timer);
 
+	of_node_put(event_timer);
 	of_node_put(source_timer);
-
-	init_sched_clock();
 }
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index dd755ce..a64c987 100644
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


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

