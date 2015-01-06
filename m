Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbbAFOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:50:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56003 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbAFOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:50:53 -0500
Date: Tue, 6 Jan 2015 14:50:43 +0000
From: Javi Merino <javi.merino@arm.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 7/9] thermal: introduce the Power Allocator
 governor
Message-ID: <20150106145043.GI2885@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-8-git-send-email-javi.merino@arm.com>
 <20150102154617.GB10683@developer>
 <20150106132341.GF2885@e104805>
 <20150106141830.GA6107@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150106141830.GA6107@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Tue, Jan 06, 2015 at 02:18:36PM +0000, Eduardo Valentin wrote:
> On Tue, Jan 06, 2015 at 01:23:42PM +0000, Javi Merino wrote:
> > On Fri, Jan 02, 2015 at 03:46:24PM +0000, Eduardo Valentin wrote:
> > > On Fri, Dec 05, 2014 at 07:04:18PM +0000, Javi Merino wrote:
> > > > diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
> > > > new file mode 100644
> > > > index 000000000000..09e98991efbb
> > > > --- /dev/null
> > > > +++ b/drivers/thermal/power_allocator.c
> > > > @@ -0,0 +1,511 @@
> > > > +/*
> > > > + * A power allocator to manage temperature
> > > > + *
> > > > + * Copyright (C) 2014 ARM Ltd.
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License version 2 as
> > > > + * published by the Free Software Foundation.
> > > > + *
> > > > + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> > > > + * kind, whether express or implied; without even the implied warranty
> > > > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > > > + * GNU General Public License for more details.
> > > > + */
> > > > +
> > > > +#define pr_fmt(fmt) "Power allocator: " fmt
> > > > +
> > > > +#include <linux/rculist.h>
> > > > +#include <linux/slab.h>
> > > > +#include <linux/thermal.h>
> > > > +
> > > > +#include "thermal_core.h"
> > > > +
> > > > +#define FRAC_BITS 10
> > > > +#define int_to_frac(x) ((x) << FRAC_BITS)
> > > > +#define frac_to_int(x) ((x) >> FRAC_BITS)
> > > > +
> > > > +/**
> > > > + * mul_frac() - multiply two fixed-point numbers
> > > > + * @x:	first multiplicand
> > > > + * @y:	second multiplicand
> > > > + *
> > > 
> > > If it is a kernel doc, needs a description.
> > 
> > Other parts of the kernel are more liberal in this regard,
> > specially fro trivial functions like this.  Also, kernel-doc creates a
> > documentation just fine:
> > 
> > $ scripts/kernel-doc -function mul_frac drivers/thermal/power_allocator.c | nroff -man
> > mul_frac(9)                 Kernel Hacker's Manual                 mul_frac(9)
> > 
> > 
> > 
> > NAME
> >        mul_frac - multiply two fixed-point numbers
> > 
> > SYNOPSIS
> >        s64 mul_frac (s64 x, s64 y);
> > 
> > ARGUMENTS
> >        x           first multiplicand
> > 
> >        y           second multiplicand
> > 
> > RETURN
> >        the  result of multiplying two fixed-point numbers.  The result is also
> >        a fixed-point number.
> > 
> > 
> > 
> > January 2015                       mul_frac                        mul_frac(9)
> > 
> > 
> > I'll add the long description if you want to, but this is not a
> > warning.
> > 
> 
> 
> As long as there is no kerneldoc warning/errors, I am fine taking it. I
> must confess I haven't run kerneldoc script in your patch as I got it
> with encoding scrambled, so I was just pointing the missing entries.

Ok, I'll make sure kernel-doc doesn't scream.

> > > > + * Return: the result of multiplying two fixed-point numbers.  The
> > > > + * result is also a fixed-point number.
> > > > + */
> > > > +static inline s64 mul_frac(s64 x, s64 y)
> > > > +{
> > > > +	return (x * y) >> FRAC_BITS;
> > > > +}
> > > > +
> > > > +enum power_allocator_trip_levels {
> > > > +	TRIP_SWITCH_ON = 0,	/* Switch on PID controller */
> > > > +	TRIP_MAX_DESIRED_TEMPERATURE, /* Temperature we are controlling for */
> > > > +
> > > > +	THERMAL_TRIP_NUM,
> > > > +};
> > > > +
> > > > +/**
> > > > + * struct power_allocator_params - parameters for the power allocator governor
> > > > + * @k_po:	Proportional parameter of the PID controller when overshooting
> > > > + *		(i.e., when temperature is below the target)
> > > > + * @k_pu:	Proportional parameter of the PID controller when undershooting
> > > > + * @k_i:	Integral parameter of the PID controller
> > > > + * @k_d:	Derivative parameter of the PID controller
> > > > + * @integral_cutoff:	threshold below which the error is no longer accumulated
> > > > +			in the PID controller
> > > > + * @err_integral:	accumulated error in the PID controller.
> > > > + * @prev_err:	error in the previous iteration of the PID controller.
> > > > + *		Used to calculate the derivative term.
> > > > + */
> > > > +struct power_allocator_params {
> > > > +	s32 k_po;
> > > > +	s32 k_pu;
> > > > +	s32 k_i;
> > > > +	s32 k_d;
> > > > +	s32 integral_cutoff;
> > > > +	s64 err_integral;
> > > > +	s32 prev_err;
> > > > +};
> > > > +
> > > > +/**
> > > > + * get_actor_weight() - get the weight for the power actor
> > > > + * @tz:		thermal zone we are operating in
> > > > + * @actor:	the power actor
> > > > + *
> > > 
> > > 
> > > ditto
> > > 
> > > > + * Returns: The weight inside the thermal binding parameters of the
> > > 
> > > s/Returns:/Return:/g
> > 
> > Yep.
> > 
> > > Please run the kernel doc script on your patches and avoid adding
> > > warnings / errors.
> > 
> > Actually, kernel-doc doesn't complain about Returns vs Return and it
> > doesn't really care if there is no description in a function as I said
> > before.
> > 
> > Is there a better way than running "scripts/kernel-doc -function
> > $FUNCTION $FILE" ?  It would be great if scripts/check-patch.pl
> > checked this as well.
> 
> I usually run 
> $ ./scripts/kernel-doc -text -v drivers/thermal/thermal_core.c > /dev/null
> 
> to see what it complain.

I'll do that from now on.

> as for checkpatch.pl, well, I agree. But as it is not there, I have its
> execution in my own internal scripts that I run on top of patches I
> receive.
> 
> > 
[...]
> > > > +/**
> > > > + * divvy_up_power() - divvy the allocated power between the actors
> > > > + * @req_power:	each actor's requested power
> > > > + * @max_power:	each actor's maximum available power
> > > > + * @num_actors:	size of the @req_power, @max_power and @granted_power's array
> > > > + * @total_req_power: sum of @req_power
> > > > + * @power_range:	total allocated power
> > > > + * @granted_power:	output array: each actor's granted power
> > > > + *
> > > > + * This function divides the total allocated power (@power_range)
> > > > + * fairly between the actors.  It first tries to give each actor a
> > > > + * share of the @power_range according to how much power it requested
> > > > + * compared to the rest of the actors.  For example, if only one actor
> > > > + * requests power, then it receives all the @power_range.  If
> > > > + * three actors each requests 1mW, each receives a third of the
> > > > + * @power_range.
> > > > + *
> > > > + * If any actor received more than their maximum power, then that
> > > > + * surplus is re-divvied among the actors based on how far they are
> > > > + * from their respective maximums.
> > > > + *
> > > > + * Granted power for each actor is written to @granted_power, which
> > > > + * should've been allocated by the calling function.
> > > > + */
> > > > +static void divvy_up_power(u32 *req_power, u32 *max_power, int num_actors,
> > > > +			u32 total_req_power, u32 power_range,
> > > > +			u32 *granted_power)
> > > > +{
> > > > +	u32 extra_power, capped_extra_power, extra_actor_power[num_actors];
> > > > +	int i;
> > > > +
> > > > +	if (!total_req_power) {
> > > > +		/*
> > > > +		 * Nobody requested anything, so just give everybody
> > > > +		 * the maximum power
> > > > +		 */
> > > > +		for (i = 0; i < num_actors; i++)
> > > > +			granted_power[i] = max_power[i];
> > > > +
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	capped_extra_power = 0;
> > > > +	extra_power = 0;
> > > > +	for (i = 0; i < num_actors; i++) {
> > > > +		u64 req_range = req_power[i] * power_range;
> > > > +
> > > > +		granted_power[i] = div_u64(req_range, total_req_power);
> > > > +
> > > > +		if (granted_power[i] > max_power[i]) {
> > > > +			extra_power += granted_power[i] - max_power[i];
> > > > +			granted_power[i] = max_power[i];
> > > 
> > > shouldn't we continue here?
> > 
> > No, you would leave the extra_actor_power[i] uninitialized.
> > 
> > > > +		}
> > > > +
> > > > +		extra_actor_power[i] = max_power[i] - granted_power[i];
> > > 
> > > Do we care when max_power[i] < granted_power[i]?
> > 
> > That can't happen, the above "if" prevents it.
> > 
> > > What happens to (overflowed) extra_actor_power[i]?
> > 
> > extra_actor_power[i] can't overflow, it's a u32 and is asigned the
> > result of substracting two u32s.  The code make sure that the minuend is
> > bigger or equal than the sustraend.
> > 
> 
> I see now. Maybe I need extra coffee :-)

:)

[...]
> > > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > > index 1155457caf52..b23e019b1761 100644
> > > > --- a/include/linux/thermal.h
> > > > +++ b/include/linux/thermal.h
> > > > @@ -61,6 +61,8 @@
> > > >  #define DEFAULT_THERMAL_GOVERNOR       "fair_share"
> > > >  #elif defined(CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE)
> > > >  #define DEFAULT_THERMAL_GOVERNOR       "user_space"
> > > > +#elif defined(CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR)
> > > > +#define DEFAULT_THERMAL_GOVERNOR       "power_allocator"
> > > >  #endif
> > > >  
> > > >  struct thermal_zone_device;
> > > > @@ -255,9 +257,14 @@ struct thermal_bind_params {
> > > >  
> > > >  	/*
> > > >  	 * This is a measure of 'how effectively these devices can
> > > > -	 * cool 'this' thermal zone. The shall be determined by platform
> > > > -	 * characterization. This is on a 'percentage' scale.
> > > > -	 * See Documentation/thermal/sysfs-api.txt for more information.
> > > > +	 * cool 'this' thermal zone. The shall be determined by
> > > > +	 * platform characterization. For the fair-share governor,
> > > > +	 * this is on a 'percentage' scale.  See
> > > > +	 * Documentation/thermal/sysfs-api.txt for more
> > > > +	 * information. For the power_allocator governor, they are
> > > > +	 * relative to each other, see
> > > > +	 * Documentation/thermal/power_allocator.txt for more
> > > > +	 * information.
> > > 
> > > What happens if we register a thermal zone with relative weights, at
> > > fist the user uses power allocator, but then wants to, for some reason,
> > > use fair share? (or vice-versa).
> > > 
> > > Can't power allocator use percentages too?
> > 
> > The problem with percentages is that they are hard to use as they
> > depend on each other.  For example, you need to know how many cooling
> > devices there are and that number needs to remain fixed.  You can't
> > add a new cooling device without changing the weights of all the other
> > existing cooling devices.  If the thermal zone is already created it's
> > hard to change the weights so you really can't add or remove cooling
> > devices.
> > 
> > We were talking in another thread of ignoring a cooling device on some
> > error.  How do you do that if the percentages must add to a hundred?
> > 
> > I thought that we could reuse the "weight" parameter but if you think
> > we are abusing by making it mean different things for different
> > governors we can create a new one instead.
> > 
> 
> yeah, I am concerned about the inconsistence. If you can make both
> governor to use the data standardized with same unit (percentage or
> relative values), then I am fine with that. Either way: (a) make power
> allocator to use percentage; or (b) make fair share to use relative
> values.

Ok, I'll send a path for (b) then.

Cheers,
Javi
