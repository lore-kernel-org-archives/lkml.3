Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaHSQDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:03:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47541 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaHSQC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:02:58 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Tue, 19 Aug 2014 17:02:54 +0100
To: Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v5 08/10] thermal: introduce the Power Allocator
 governor
Message-ID: <20140819160254.GA16982@e104805>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
 <1405001928-12697-9-git-send-email-javi.merino@arm.com>
 <20140819134552.GB4628@developer>
MIME-Version: 1.0
In-Reply-To: <20140819134552.GB4628@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 19 Aug 2014 16:02:54.0638 (UTC) FILETIME=[095364E0:01CFBBC7]
X-MC-Unique: 114081917025606701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:45:52PM +0100, Eduardo Valentin wrote:
> Javi,

Hi Eduardo,

> On Thu, Jul 10, 2014 at 03:18:46PM +0100, Javi Merino wrote:
> > The power allocator governor is a thermal governor that controls system
> > and device power allocation to control temperature.  Conceptually, the
> > implementation divides the sustainable power of a thermal zone among
> > all the heat sources in that zone.
> >
> > This governor relies on "power actors", entities that represent heat
> > sources.  They can report current and maximum power consumption and
> > can set a given maximum power consumption, usually via a cooling
> > device.
> >
> > The governor uses a Proportional Integral Derivative (PID) controller
> > driven by the temperature of the thermal zone.  The output of the
> > controller is a power budget that is then allocated to each power
> > actor that can have bearing on the temperature we are trying to
> > control.  It decides how much power to give each cooling device based
> > on the performance they are requesting.  The PID controller ensures
> > that the total power budget does not exceed the control temperature.
> >
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > ---
> >  Documentation/thermal/power_allocator.txt |  61 ++++
> >  drivers/thermal/Kconfig                   |  15 +
> >  drivers/thermal/Makefile                  |   1 +
> >  drivers/thermal/power_allocator.c         | 467 ++++++++++++++++++++++++++++++
> >  drivers/thermal/thermal_core.c            |   7 +-
> >  drivers/thermal/thermal_core.h            |   8 +
> >  include/linux/thermal.h                   |   8 +
> >  7 files changed, 566 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/thermal/power_allocator.txt
> >  create mode 100644 drivers/thermal/power_allocator.c
> >
> > diff --git a/Documentation/thermal/power_allocator.txt b/Documentation/thermal/power_allocator.txt
> > new file mode 100644
> > index 000000000000..1859074dadcb
> > --- /dev/null
> > +++ b/Documentation/thermal/power_allocator.txt
> > @@ -0,0 +1,61 @@
> > +Integration of the power_allocator governor in a platform
> > +=========================================================
> > +
> > +Registering thermal_zone_device
> > +-------------------------------
> > +
> > +An estimate of the sustainable dissipatable power (in mW) should be
> > +provided while registering the thermal zone.  This is the maximum
> > +sustained power for allocation at the desired maximum temperature.
> > +This number can vary for different conditions, but the closed-loop of
> > +the controller should take care of those variations, the
> > +`sustainable_power` should be an estimation of it.  Register your
> > +thermal zone with `thermal_zone_params` that have a
> > +`sustainable_power`.  If you weren't passing any
> > +`thermal_zone_params`, then something like this will do:
> > +
> > +     static const struct thermal_zone_params tz_params = {
> > +             .sustainable_power = 3500,
> > +     };
> > +
> > +and then pass `tz_params` as the 5th parameter to
> > +`thermal_zone_device_register()`
> > +
> > +Trip points
> > +-----------
> > +
> > +The governor requires the following two trip points:
> > +
> > +1.  "switch on" trip point: temperature above which the governor
> > +    control loop starts operating
> > +2.  "desired temperature" trip point: it should be higher than the
> > +    "switch on" trip point. It is the target temperature the governor
> > +    is controlling for.
> > +
> > +The trip points can be either active or passive.
> > +
> 
> I would prefer, for the sake of keeping the right concept in use, you
> state here that they are passive trip points.

Sure, I've also changed the function that checks this condition
accordingly.

> > +Power actors
> > +------------
> > +
> > +Devices controlled by this governor must be registered with the power
> > +actor API.  Read `power_actor.txt` for more information about them.
> > +
> > +Limitations of the power allocator governor
> > +===========================================
> > +
> > +The power allocator governor can't work with cooling devices directly.
> > +A power actor can be created to interface between the governor and the
> > +cooling device (see cpu_actor.c for an example).  Otherwise, if you
> > +have power actors and cooling devices that are next to the same
> > +thermal sensor create two thermal zones, one for each type.  Use the
> > +power allocator governor for the power actor thermal zone with the
> > +power actors and any other governor for the one with cooling devices.
> > +
> > +The power allocator governor's PID controller is highly dependent on a
> > +periodic tick.  If you have a driver that calls
> > +`thermal_zone_device_update()` (or anything that ends up calling the
> > +governor's `throttle()` function) repetitively, the governor response
> > +won't be very good.  Note that this is not particular to this
> > +governor, step-wise will also misbehave if you call its throttle()
> > +faster than the normal thermal framework tick (due to interrupts for
> > +example) as it will overreact.
> 
> I would recommend rephrasing the paragraph above, as I mentioned in
> other email, looks like a documented bug. Mentioning that the governor
> is still dependent on polling_delay active_delay is still worth it.
> Also, the coexistance of interrupt driven thermal zones with polling
> driven framework requires the interrupt firing to be configure to
> something meaneanful, such as, an event outside the temperature range
> the current trip is.

Ok, I'll rephrase it to clarify the point.

> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index 249b196deffd..0e76c0dab5f3 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -71,6 +71,14 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
> >         Select this if you want to let the user space manage the
> >         platform thermals.
> >
> > +config THERMAL_DEFAULT_GOV_POWER_ALLOCATOR
> > +     bool "power_allocator"
> > +     select THERMAL_GOV_POWER_ALLOCATOR
> > +     help
> > +       Select this if you want to control temperature based on
> > +       system and device power allocation. This governor relies on
> > +       power actors to operate.
> > +
> >  endchoice
> >
> >  config THERMAL_GOV_FAIR_SHARE
> > @@ -89,6 +97,13 @@ config THERMAL_GOV_USER_SPACE
> >       help
> >         Enable this to let the user space manage the platform thermals.
> >
> > +config THERMAL_GOV_POWER_ALLOCATOR
> > +     bool "Power allocator thermal governor"
> > +     select THERMAL_POWER_ACTOR
> > +     help
> > +       Enable this to manage platform thermals by dynamically
> > +       allocating and limiting power to devices.
> > +
> >  config THERMAL_POWER_ACTOR
> >       bool
> >
> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> > index 74f97c90a46c..e74d57d0fe61 100644
> > --- a/drivers/thermal/Makefile
> > +++ b/drivers/thermal/Makefile
> > @@ -13,6 +13,7 @@ thermal_sys-$(CONFIG_THERMAL_OF)            += of-thermal.o
> >  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE) += fair_share.o
> >  thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)  += step_wise.o
> >  thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE) += user_space.o
> > +thermal_sys-$(CONFIG_THERMAL_GOV_POWER_ALLOCATOR)    += power_allocator.o
> >
> >  # power actors
> >  obj-$(CONFIG_THERMAL_POWER_ACTOR) += power_actor.o
> > diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
> > new file mode 100644
> > index 000000000000..eb1797cd859b
> > --- /dev/null
> > +++ b/drivers/thermal/power_allocator.c
> > @@ -0,0 +1,467 @@
> > +/*
> > + * A power allocator to manage temperature
> > + *
> > + * Copyright (C) 2014 ARM Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> > + * kind, whether express or implied; without even the implied warranty
> > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#define pr_fmt(fmt) "Power allocator: " fmt
> > +
> > +#include <linux/power_actor.h>
> > +#include <linux/rculist.h>
> > +#include <linux/slab.h>
> > +#include <linux/thermal.h>
> > +
> > +#include "thermal_core.h"
> > +
> > +#define FRAC_BITS 8
> > +#define int_to_frac(x) ((x) << FRAC_BITS)
> > +#define frac_to_int(x) ((x) >> FRAC_BITS)
> > +
> > +/**
> > + * mul_frac() - multiply two fixed-point numbers
> > + * @x:       first multiplicand
> > + * @y:       second multiplicand
> > + *
> > + * Return: the result of multiplying two fixed-point numbers.  The
> > + * result is also a fixed-point number.
> > + */
> > +static inline s64 mul_frac(s64 x, s64 y)
> > +{
> > +     return (x * y) >> FRAC_BITS;
> > +}
> > +
> > +enum power_allocator_trip_levels {
> > +     TRIP_SWITCH_ON = 0,     /* Switch on PID controller */
> > +     TRIP_MAX_DESIRED_TEMPERATURE, /* Temperature we are controlling for */
> > +};
> > +
> > +/**
> > + * struct power_allocator_params - parameters for the power allocator governor
> > + * @k_po:    Proportional parameter of the PID controller when overshooting
> > + *           (i.e., when temperature is below the target)
> > + * @k_pi:    Proportional parameter of the PID controller when undershooting
> > + * @k_i:     Integral parameter of the PID controller
> > + * @k_d:     Derivative parameter of the PID controller
> 
> Po, Pi, i, and d were not documented in your document above. Did you
> miss them?
> 
> Given that they are core part of the governor behavior, I'd suggest
> having a section in its document about how to fine tune the constants.
> Explain, for instance, if it is enough to fine tune per platform, and
> if having constants defined at compilation time or at runtime are good
> point to be documented.

We need to provide a way for platforms to specify these constants.
Currently they are fixed because I thought that some heuristic would
be good enough to cover all the platforms.  It turns out that it's not
realistic so we will provide a mechanism for platforms to change them,
we will export them in debugfs and document them in the next series.

Cheers,
Javi

