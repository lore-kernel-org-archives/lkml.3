Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3IMP0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:26:40 -0400
Received: from [65.55.88.12] ([65.55.88.12]:50987 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab3IMP0j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:26:39 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Fri, 13 Sep 2013 08:25:19 -0700
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
 <54e79f60-d0c4-4897-ab16-ecd50ae7ec0d@DB9EHSMHS019.ehs.local>
 <alpine.DEB.2.02.1309131643500.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309131643500.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <53ddc00f-1033-481b-be37-978bd4410c10@TX2EHSMHS034.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 04:45:12PM +0200, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Sören Brinkmann wrote:
> > On Thu, Sep 12, 2013 at 10:30:15PM +0200, Thomas Gleixner wrote:
> > I gave it a shot. Is this what you imagine:
> > diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
> > index b66c1f3..c639b1a 100644
> > --- a/drivers/clocksource/arm_global_timer.c
> > +++ b/drivers/clocksource/arm_global_timer.c
> > @@ -169,7 +169,8 @@ static int gt_clockevents_init(struct clock_event_device *clk)
> >         int cpu = smp_processor_id();
> >  
> >         clk->name = "arm_global_timer";
> > -       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> > +       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
> > +               CLOCK_EVT_FEAT_PERCPU;
> >         clk->set_mode = gt_clockevent_set_mode;
> >         clk->set_next_event = gt_clockevent_set_next_event;
> >         clk->cpumask = cpumask_of(cpu);
> > diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> > index 0857922..493aa02 100644
> > --- a/include/linux/clockchips.h
> > +++ b/include/linux/clockchips.h
> > @@ -60,6 +60,7 @@ enum clock_event_mode {
> >   * Core shall set the interrupt affinity dynamically in broadcast mode
> >   */
> >  #define CLOCK_EVT_FEAT_DYNIRQ          0x000020
> > +#define CLOCK_EVT_FEAT_PERCPU          0x000040
> >  
> >  /**
> >   * struct clock_event_device - clock event device descriptor
> > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> > index d3539e5..de4c5d8 100644
> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -70,16 +70,14 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
> >                                         struct clock_event_device *newdev)
> >  {
> >         if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
> > -           (newdev->features & CLOCK_EVT_FEAT_C3STOP))
> > +           (newdev->features & CLOCK_EVT_FEAT_C3STOP) ||
> > +           (newdev->features & CLOCK_EVT_FEAT_PERCPU))
> >                 return false;
> >  
> >         if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT &&
> >             !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
> >                 return false;
> >  
> > -       if (cpumask_equal(newdev->cpumask, cpumask_of(smp_processor_id())))
> > -               return false;
> > -
> >         return !curdev || newdev->rating > curdev->rating;
> >  }
> > 
> > If this is the way to go, I can prepare this in a v2.
> 
> Looks good to me. The last junk of the patch won't apply on mainline,
> but thats the least of my worries. :)

Of course. I'll split this into smaller chunks and send out a v2.

	Thanks,
	Sören


