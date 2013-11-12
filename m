Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3KLVON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:14:13 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:33193
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756138Ab3KLVN7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:13:59 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z579ehzbb2dI98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Tue, 12 Nov 2013 13:13:39 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/7] clocksource/cadence_ttc: Overhaul clocksource
 frequency adjustment
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
 <1383945677-29674-6-git-send-email-soren.brinkmann@xilinx.com>
 <52827B11.5040308@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52827B11.5040308@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <49c3ad81-1370-4c56-b369-90b9d8cfe3d5@AM1EHSMHS004.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:01:37PM +0100, Daniel Lezcano wrote:
> On 11/08/2013 10:21 PM, Soren Brinkmann wrote:
> >The currently used method adjusting the clocksource to a changing input
> >frequency does not work on kernels from 3.11 on.
> >The new approach is to keep the timer frequency as constant as possible.
> >I.e.
> >  - due to the TTC's prescaler limitations, allow frequency changes
> >    only if the frequency scales by a power of 2
> >  - adjust the counter's divider on the fly when a frequency change
> >    occurs
> >
> >When suspending though, the driver should not prevent rate changes in
> >order to allow the system to enter its low power state. For that
> >reason a PM notifier is added so rate changes can be ignored during
> >suspend/resume.
> 
> It sounds very weird you have to add a PM notifier in this driver.
> 
> Have you been facing an issue or do you assume it could happen ?
Yes, I have problems without it, which are probably Zynq specific
though.
When we suspend on Zynq, we bypass and power down PLLs, which is a
re-parent operation in the clock framework. This happens in early suspend
and triggers the clock notifiers. Due to the restrictions the TTC's
clock notifier applies to frequency changes, it would prevent the
re-parent operation even though we do not have to care about it in
suspend. The timer's own suspend/resume callbacks are called to
late/early and the PM notifier seemed to be the solution. But I'm open
to alternative approaches.

> 
> >This limits cpufreq to scale by certain factors only.
> >But we may keep the time base somewhat constant, so that sleep() & co
> >keep working as expected, while supporting cpufreq and suspend.
> >
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >---
> >  drivers/clocksource/cadence_ttc_timer.c | 142 +++++++++++++++++++++++++++-----
> >  1 file changed, 122 insertions(+), 20 deletions(-)
> >
> >diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
> >index 68a336038d8f..421b942dd707 100644
> >--- a/drivers/clocksource/cadence_ttc_timer.c
> >+++ b/drivers/clocksource/cadence_ttc_timer.c
> >@@ -16,12 +16,14 @@
> >   */
> >
> >  #include <linux/clk.h>
> >+#include <linux/clk-provider.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/clockchips.h>
> >  #include <linux/of_address.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/slab.h>
> >  #include <linux/sched_clock.h>
> >+#include <linux/suspend.h>
> >
> >  /*
> >   * This driver configures the 2 16-bit count-up timers as follows:
> >@@ -52,6 +54,8 @@
> >  #define TTC_CNT_CNTRL_DISABLE_MASK	0x1
> >
> >  #define TTC_CLK_CNTRL_CSRC_MASK		(1 << 5)	/* clock source */
> >+#define TTC_CLK_CNTRL_PSV_MASK		0x1e
> >+#define TTC_CLK_CNTRL_PSV_SHIFT		1
> >
> >  /*
> >   * Setup the timers to use pre-scaling, using a fixed value for now that will
> >@@ -63,6 +67,8 @@
> >  #define CLK_CNTRL_PRESCALE_EN	1
> >  #define CNT_CNTRL_RESET		(1 << 4)
> >
> >+#define MAX_F_ERR 50
> >+
> >  /**
> >   * struct ttc_timer - This definition defines local timer structure
> >   *
> >@@ -82,8 +88,13 @@ struct ttc_timer {
> >  		container_of(x, struct ttc_timer, clk_rate_change_nb)
> >
> >  struct ttc_timer_clocksource {
> >+	int			scale_dir;
> >+	u32			scale_clk_ctrl_reg_old;
> >+	u32			scale_clk_ctrl_reg_new;
> >+	int			suspending;
> >  	struct ttc_timer	ttc;
> >  	struct clocksource	cs;
> >+	struct notifier_block	suspend_nb;
> >  };
> >
> >  #define to_ttc_timer_clksrc(x) \
> >@@ -228,33 +239,120 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
> >  	struct ttc_timer_clocksource *ttccs = container_of(ttc,
> >  			struct ttc_timer_clocksource, ttc);
> >
> >+	if (ttccs->suspending)
> >+		return NOTIFY_OK;
> 
> I don't see how it couldn't be racy. What prevents suspend to occur
> right after this check ?
Well, in our case there are two situations which could trigger this
notifier.
1. cpufreq
2. suspend
As long as cpufreq is doing its stuff things should be okay and fine.
And suspend triggers the PM and clock notifier in the correct order,
which solves the issue I described above. So, it is not really pretty,
but works for me.

	Sören


