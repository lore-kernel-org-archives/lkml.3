Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaGIQLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:11:22 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:58179
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbaGIQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:11:20 -0400
Date: Wed, 9 Jul 2014 09:11:16 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: timers & suspend
References: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl>
 <2489e9cb-51c2-4901-9ab5-c952877d8a9d@BL2FFO11FD057.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2489e9cb-51c2-4901-9ab5-c952877d8a9d@BL2FFO11FD057.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <380dd2ef-160a-4683-9783-ea4f964ca730@BL2FFO11FD037.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(51704005)(377424004)(24454002)(102836001)(1496007)(70736001)(104016002)(23676002)(46102001)(4396001)(81542001)(85306003)(53416004)(54356999)(107046002)(74316001)(85852003)(50986999)(6806004)(33646001)(21056001)(92726001)(44976005)(85202003)(86362001)(76482001)(92566001)(19580395003)(99396002)(575784001)(87936001)(74502001)(83072002)(83506001)(83322001)(64706001)(79102001)(80022001)(31696002)(74662001)(77982001)(77096002)(81342001)(76176999)(95666004)(50466002)(31966008)(47776003)(20776003)(85182001)(106466001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB022;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0267E514F9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 04:50PM -0700, Sören Brinkmann wrote:
> Let me extend the audience a bit.
> 
> On Mon, 2014-06-30 at 11:39AM -0700, Sören Brinkmann wrote:
> > Hi,
> > 
> > I'm currently working on suspend for Zynq and try to track down some
> > spurious wakes. It looks like the spurious wakes are caused by timers,
> > hence I was wondering whether there are any special requirements for
> > timer drivers when it comes to suspend support or if I just missed
> > something.
> > 
> > Zynq sets the 'IRQCHIP_MASK_ON_SUSPEND' flag, which should mask all
> > interrupts but the wake source. Reading through kernel/irq/pm.c
> > indicates, that timer interrupts get some special treatment though.
> > Therefore I implemented some suspend/resume callbacks for the
> > cadence_ttc which disable and clear the timer's interrupts when going
> > into suspend. That seems to mitigate the issue quite a bit, but I still
> > saw spurious wakes - just a lot less often.
> > Digging a little deeper revealed, the spurious wakes are caused by the
> > ARM's smp_twd timer now. Given that that driver is probably used by a few
> > more ARM platforms, I get the feeling that I'm missing something.
> > 
> > It's probably worth mentioning that the suspend state in Zynq does not
> > power off the CPU cores. It just asserts the resets on secondary cores
> > and the primary one waits in wfi.
> 
> I think I found the issue. When going into suspend, all device
> interrupts get disabled, but timers are kept running until very late.
> Then in kernel/power/suspend.c:
>  - arch_suspend_disable_irqs() disables interrupts (locally)
>  - syscore_suspend is called, which disables timers through
>    tick_suspend()
> 
> I think what happens is: The interrupts get disabled locally, but the
> timers are still running and generating interrupts.
> Such an interrupt happens and stays pending since interrupts are already
> disabled and no longer handled.
> Then, since Zynq does not power off but only goes into wfi, it
> immediately resumes due to a pending timer IRQ.
> 
> Especially with the TTC this can happen quite often since it is only
> 16 bit wide. But I also see spurious wakes caused by the twd.
> 
> Does that sound like a possible scenario?

As another data point: I don't see any spurious wakes with the changes
below.

	Sören

---------------8<------------------8<-----------------8<----------------8<------
diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index e0a81327e10c..3abe2d7031ed 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -321,6 +321,19 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void ttc_ce_suspend(struct clock_event_device *ce)
+{
+	struct ttc_timer_clockevent *ttcce = to_ttc_timer_clkevent(ce);
+
+	readl_relaxed(ttcce->ttc.base_addr + TTC_ISR_OFFSET);
+	disable_irq(ce->irq);
+}
+
+static void ttc_ce_resume(struct clock_event_device *ce)
+{
+	enable_irq(ce->irq);
+}
+
 static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 {
 	struct ttc_timer_clocksource *ttccs;
@@ -428,6 +441,8 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	ttcce->ce.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	ttcce->ce.set_next_event = ttc_set_next_event;
 	ttcce->ce.set_mode = ttc_set_mode;
+	ttcce->ce.suspend = ttc_ce_suspend;
+	ttcce->ce.resume = ttc_ce_resume;
 	ttcce->ce.rating = 200;
 	ttcce->ce.irq = irq;
 	ttcce->ce.cpumask = cpu_possible_mask;
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 6591e26fc13f..956d40d9281f 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -264,6 +264,18 @@ static void twd_get_clock(struct device_node *np)
 	twd_timer_rate = clk_get_rate(twd_clk);
 }
 
+static void twd_suspend(struct clock_event_device *ce)
+{
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	disable_percpu_irq(clk->irq);
+}
+
+static void twd_resume(struct clock_event_device *ce)
+{
+	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	enable_percpu_irq(clk->irq, 0);
+}
+
 /*
  * Setup the local clock events for a CPU.
  */
@@ -300,6 +312,8 @@ static void twd_timer_setup(void)
 	clk->set_next_event = twd_set_next_event;
 	clk->irq = twd_ppi;
 	clk->cpumask = cpumask_of(cpu);
+	clk->suspend = twd_suspend;
+	clk->resume = twd_resume;
 
 	clockevents_config_and_register(clk, twd_timer_rate,
 					0xf, 0xffffffff);
