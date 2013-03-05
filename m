Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3CELDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:03:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61370 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab3CELDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:03:11 -0500
Date: Tue, 5 Mar 2013 11:02:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: smp: Remove local timer API
Message-ID: <20130305110239.GC15661@e106331-lin.cambridge.arm.com>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
 <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
 <20130222111545.GA15020@e106331-lin.cambridge.arm.com>
 <20130222162458.GA19670@linux-sh.org>
 <20130225134041.GA22785@e106331-lin.cambridge.arm.com>
 <5135333E.6030305@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5135333E.6030305@codeaurora.org>
Thread-Topic: [PATCH 8/8] ARM: smp: Remove local timer API
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:50:22PM +0000, Stephen Boyd wrote:
> On 02/25/13 05:40, Mark Rutland wrote:
> > I've had a quick go at writing a generic timer driver. I've not had a chance to
> > test it, and there are a couple of things that are up for discussion (e.g. what
> > should the rating be) but I think we want something very close to this.
> >
> 
> This looks good to me. I only have some minor comments. What's the plan
> for merging? Get tglx to take this and provide a stable branch and then
> base my patches off that and get these patches taken through arm-soc?

Great.

That sounds about right, I don't really know what the best way would be.

> 
> > diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
> > new file mode 100644
> > index 0000000..bdaba34
> > --- /dev/null
> > +++ b/drivers/clocksource/dummy_timer.c
> > @@ -0,0 +1,67 @@
> > +/*
> > + *  linux/drivers/clocksource/dummy_timer.c
> > + *
> > + *  Copyright (C) 2013 ARM Ltd.
> > + *  All Rights Reserved
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +#include <linux/clockchips.h>
> > +#include <linux/cpu.h>
> > +#include <linux/init.h>
> > +#include <linux/percpu.h>
> > +
> > +DEFINE_PER_CPU(struct clock_event_device, dummy_evt);
> 
> static?

Oops. Added.

> 
> > +
> > +static void dummy_set_mode(enum clock_event_mode mode,
> > +			   struct clock_event_device *evt)
> > +{
> > +	/*
> > +	 * Core clockevents code will call this when exchanging timer devices.
> > +	 * We don't need to do anything here.
> > +	 */
> > +}
> > +
> > +static void __cpuinit dummy_setup(void)
> > +{
> > +	int cpu = smp_processor_id();
> > +	struct clock_event_device *evt = &per_cpu(dummy_evt, cpu);
> 
> Can we use __this_cpu_ptr()? I wonder if that makes the code generation
> better or worse. I didn't do it in my 8/8 patch because I wanted the
> code to be the same before and after to show code movement.

I did that originally, but thought as I needed the cpu value for the mask
anyway that there wasn't much point. I'm not that good at reading generated
assembly, so I can't really say if either's better.

> 
> > +
> > +	evt->name	= "dummy timer";
> > +	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
> > +			  CLOCK_EVT_FEAT_ONESHOT |
> > +			  CLOCK_EVT_FEAT_DUMMY;
> > +	evt->rating	= 100;
> > +	evt->set_mode	= dummy_set_mode;
> > +	evt->cpumask	= cpumask_of(cpu);
> > +
> > +	clockevents_register_device(evt);
> > +}
> > +
> > +static int __cpuinit dummy_cpu_notify(struct notifier_block *self,
> > +				      unsigned long action, void *hcpu)
> > +{
> > +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
> > +		dummy_setup();
> 
> There are already two dummy_setup() functions. Perhaps we can
> s/dummy/dummy_broadcast/ throughout this file?

I've done s/dummy/dummy_timer/ as suggested in your other reply.

Thanks,
Mark.
