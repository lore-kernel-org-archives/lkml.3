Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3ILXub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:50:31 -0400
Received: from [213.199.154.251] ([213.199.154.251]:58241 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756859Ab3ILXu1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:50:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Thu, 12 Sep 2013 16:48:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com>
 <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <54e79f60-d0c4-4897-ab16-ecd50ae7ec0d@DB9EHSMHS019.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, Sep 12, 2013 at 10:30:15PM +0200, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Soren Brinkmann wrote:
> > From: Stephen Boyd <sboyd@codeaurora.org>
> > 
> > On most ARM systems the per-cpu clockevents are truly per-cpu in
> > the sense that they can't be controlled on any other CPU besides
> > the CPU that they interrupt. If one of these clockevents were to
> > become a broadcast source we will run into a lot of trouble
> > because the broadcast source is enabled on the first CPU to go
> > into deep idle (if that CPU suffers from FEAT_C3_STOP) and that
> > could be a different CPU than what the clockevent is interrupting
> > (or even worse the CPU that the clockevent interrupts could be
> > offline).
> > 
> > Theoretically it's possible to support per-cpu clockevents as the
> > broadcast source but so far we haven't needed this and supporting
> > it is rather complicated. Let's just deny the possibility for now
> > until this becomes a reality (let's hope it never does!).
> 
> Well, we can't do it this way. There are globally accessible clock
> event devices which deliver only to cpu0. So the mask check might be
> causing failure here.
> 
> Just add a feature flag CLOCK_EVT_FEAT_PERCPU to the clock event
> device and check for it.

I gave it a shot. Is this what you imagine:
diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index b66c1f3..c639b1a 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -169,7 +169,8 @@ static int gt_clockevents_init(struct clock_event_device *clk)
        int cpu = smp_processor_id();
 
        clk->name = "arm_global_timer";
-       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
+               CLOCK_EVT_FEAT_PERCPU;
        clk->set_mode = gt_clockevent_set_mode;
        clk->set_next_event = gt_clockevent_set_next_event;
        clk->cpumask = cpumask_of(cpu);
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 0857922..493aa02 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -60,6 +60,7 @@ enum clock_event_mode {
  * Core shall set the interrupt affinity dynamically in broadcast mode
  */
 #define CLOCK_EVT_FEAT_DYNIRQ          0x000020
+#define CLOCK_EVT_FEAT_PERCPU          0x000040
 
 /**
  * struct clock_event_device - clock event device descriptor
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index d3539e5..de4c5d8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -70,16 +70,14 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
                                        struct clock_event_device *newdev)
 {
        if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
-           (newdev->features & CLOCK_EVT_FEAT_C3STOP))
+           (newdev->features & CLOCK_EVT_FEAT_C3STOP) ||
+           (newdev->features & CLOCK_EVT_FEAT_PERCPU))
                return false;
 
        if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT &&
            !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
                return false;
 
-       if (cpumask_equal(newdev->cpumask, cpumask_of(smp_processor_id())))
-               return false;
-
        return !curdev || newdev->rating > curdev->rating;
 }

If this is the way to go, I can prepare this in a v2.

	Thanks,
	Sören


