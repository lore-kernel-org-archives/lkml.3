Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3IMOp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:45:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:36937 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab3IMOpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:45:25 -0400
Date: Fri, 13 Sep 2013 16:45:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
In-Reply-To: <54e79f60-d0c4-4897-ab16-ecd50ae7ec0d@DB9EHSMHS019.ehs.local>
Message-ID: <alpine.DEB.2.02.1309131643500.4089@ionos.tec.linutronix.de>
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com> <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
 <54e79f60-d0c4-4897-ab16-ecd50ae7ec0d@DB9EHSMHS019.ehs.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-581853902-1379083513=:4089"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-581853902-1379083513=:4089
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Sep 2013, Sören Brinkmann wrote:
> On Thu, Sep 12, 2013 at 10:30:15PM +0200, Thomas Gleixner wrote:
> I gave it a shot. Is this what you imagine:
> diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
> index b66c1f3..c639b1a 100644
> --- a/drivers/clocksource/arm_global_timer.c
> +++ b/drivers/clocksource/arm_global_timer.c
> @@ -169,7 +169,8 @@ static int gt_clockevents_init(struct clock_event_device *clk)
>         int cpu = smp_processor_id();
>  
>         clk->name = "arm_global_timer";
> -       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> +       clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
> +               CLOCK_EVT_FEAT_PERCPU;
>         clk->set_mode = gt_clockevent_set_mode;
>         clk->set_next_event = gt_clockevent_set_next_event;
>         clk->cpumask = cpumask_of(cpu);
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 0857922..493aa02 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -60,6 +60,7 @@ enum clock_event_mode {
>   * Core shall set the interrupt affinity dynamically in broadcast mode
>   */
>  #define CLOCK_EVT_FEAT_DYNIRQ          0x000020
> +#define CLOCK_EVT_FEAT_PERCPU          0x000040
>  
>  /**
>   * struct clock_event_device - clock event device descriptor
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index d3539e5..de4c5d8 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -70,16 +70,14 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
>                                         struct clock_event_device *newdev)
>  {
>         if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
> -           (newdev->features & CLOCK_EVT_FEAT_C3STOP))
> +           (newdev->features & CLOCK_EVT_FEAT_C3STOP) ||
> +           (newdev->features & CLOCK_EVT_FEAT_PERCPU))
>                 return false;
>  
>         if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT &&
>             !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
>                 return false;
>  
> -       if (cpumask_equal(newdev->cpumask, cpumask_of(smp_processor_id())))
> -               return false;
> -
>         return !curdev || newdev->rating > curdev->rating;
>  }
> 
> If this is the way to go, I can prepare this in a v2.

Looks good to me. The last junk of the patch won't apply on mainline,
but thats the least of my worries. :)

Thanks,

	tglx
--8323329-581853902-1379083513=:4089--
