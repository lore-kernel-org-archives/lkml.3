Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3DZVh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 17:37:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3DZVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 17:37:26 -0400
Date: Fri, 26 Apr 2013 23:37:23 +0200
From: Pavel Machek <pavel@denx.de>
To: Jamie Iles <jamie@jamieiles.com>
Cc: dinguyen@altera.com, wd@denx.de, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, arnd@arndb.de, johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130426213723.GA24891@amd.pavel.ucw.cz>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <20130426124128.GB6946@page>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426124128.GB6946@page>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Fri, Apr 26, 2013 at 02:14:34PM +0200, Pavel Machek wrote:
> > diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
> > index 70b441a..22759f5 100644
> > --- a/arch/arm/mach-picoxcell/common.c
> > +++ b/arch/arm/mach-picoxcell/common.c
> > @@ -84,11 +84,39 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
> >  	}
> >  }
> >  
> > +static const struct of_device_id picochip_rtc_ids[] __initconst = {
> > +        { .compatible = "picochip,pc3x2-rtc" },
> > +        { /* Sentinel */ },
> > +};
> > +
> > +static void __iomem *sched_io_base;
> > +
> > +static u32 read_sched_clock(void)
> > +{
> > +        return __raw_readl(sched_io_base);
> > +}
> > +
> > +static void __init timer_init(void)
> > +{
> > +	u32 rate;
> > +
> > +	dw_apb_timer_init(0);
> > +
> > +	sched_timer = of_find_matching_node(timer, osctimer_ids);
> > +	if (!sched_timer)
> > +		panic("No suitable timer for scheduler clock\n");
> > +
> > +	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
> > +	of_node_put(sched_timer);
> 
> This doesn't work as osctimer_ids is private to the dw_apb_timer files 
> as is timer_get_base_and_rate.  The other timer is unused in picoxcell 
> though so dw_apb_timer_init(1), something like the patch below on top of 
> yours.

That would still not compile due to common.h. ... _but_ it allows
some very nice simplification, with this on top:

I'll post merged-up patch in next mail.

Thanks,
									Pavel

diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index c027920..70b441a 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -84,16 +84,11 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
 	}
 }
 
-static void __init timer_init(void)
-{
-	dw_apb_timer_init(1);
-}
-
 DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
 	.map_io		= picoxcell_map_io,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= irqchip_init,
-	.init_time	= timer_init,
+	.init_time	= dw_apb_timer_init,
 	.init_machine	= picoxcell_init_machine,
 	.dt_compat	= picoxcell_dt_match,
 	.restart	= picoxcell_wdt_restart,
diff --git a/arch/arm/mach-picoxcell/common.h b/arch/arm/mach-picoxcell/common.h
index 481b42a..237fb3b 100644
--- a/arch/arm/mach-picoxcell/common.h
+++ b/arch/arm/mach-picoxcell/common.h
@@ -12,6 +12,4 @@
 
 #include <asm/mach/time.h>
 
-extern void dw_apb_timer_init(void);
-
 #endif /* __PICOXCELL_COMMON_H__ */
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index 6efbc12..81b8f1e 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -110,17 +110,11 @@ static const char *altera_dt_match[] = {
 	NULL
 };
 
-static void __init timer_init(void)
-{
-	dw_apb_timer_init(1);
-}
-
-
 DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
 	.smp		= smp_ops(socfpga_smp_ops),
 	.map_io		= socfpga_map_io,
 	.init_irq	= socfpga_init_irq,
-	.init_time	= timer_init,
+	.init_time	= dw_apb_timer_init,
 	.init_machine	= socfpga_cyclone5_init,
 	.restart	= socfpga_cyclone5_restart,
 	.dt_compat	= altera_dt_match,
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 872ce66..0fa3104 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -66,7 +66,7 @@ static u32 read_sched_clock_sptimer(void)
 	return ~__raw_readl(sched_io_base + APBTMR_N_CURRENT_VALUE);
 }
 
-static void add_clocksource(struct device_node *source_timer, int use_as_scheduler)
+static void add_clocksource(struct device_node *source_timer)
 {
 	void __iomem *iobase;
 	struct dw_apb_clocksource *cs;
@@ -81,10 +81,8 @@ static void add_clocksource(struct device_node *source_timer, int use_as_schedul
 	dw_apb_clocksource_start(cs);
 	dw_apb_clocksource_register(cs);
 
-	if (use_as_scheduler) {
-		sched_io_base = iobase;
-		setup_sched_clock(read_sched_clock_sptimer, 32, rate);
-	}
+	sched_io_base = iobase;
+	setup_sched_clock(read_sched_clock_sptimer, 32, rate);
 }
 
 static const struct of_device_id osctimer_ids[] __initconst = {
@@ -104,7 +102,7 @@ static const struct of_device_id osctimer_ids[] __initconst = {
 */
 
 
-void __init dw_apb_timer_init(int use_as_scheduler)
+void __init dw_apb_timer_init(void)
 {
 	struct device_node *event_timer, *source_timer;
 
@@ -116,7 +114,7 @@ void __init dw_apb_timer_init(int use_as_scheduler)
 	source_timer = of_find_matching_node(event_timer, osctimer_ids);
 	if (!source_timer)
 		panic("No timer for clocksource");
-	add_clocksource(source_timer, use_as_scheduler);
+	add_clocksource(source_timer);
 
 	of_node_put(event_timer);
 	of_node_put(source_timer);
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index d503245..a64c987 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -59,5 +59,5 @@ void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
-extern void dw_apb_timer_init(int);
+extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
