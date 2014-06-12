Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaFLNp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:45:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44958 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaFLNpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:45:24 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Thu, 12 Jun 2014 14:45:20 +0100
To: Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v3 4/7] thermal: introduce the Power Actor API
Message-ID: <20140612134520.GA2763@e104805>
References: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
 <1401790715-5630-5-git-send-email-javi.merino@arm.com>
 <20140611113254.GA6961@developer>
MIME-Version: 1.0
In-Reply-To: <20140611113254.GA6961@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Jun 2014 13:45:15.0649 (UTC) FILETIME=[8A7EAF10:01CF8644]
X-MC-Unique: 114061214452203401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:32:54PM +0100, Eduardo Valentin wrote:
> Hello Javi,
> 
> On Tue, Jun 03, 2014 at 11:18:32AM +0100, Javi Merino wrote:
> > This patch introduces the Power Actor API in the thermal framework.
> > With it, devices that can report their power consumption and control
> > it can be registered.  This base interface is meant to be used to
> > derive specific power actors, such as a cpu power actor.
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > ---
> >  Documentation/thermal/power_actor.txt     | 38 ++++++++++++++++++
> >  drivers/thermal/Kconfig                   |  3 ++
> >  drivers/thermal/Makefile                  |  2 +
> >  drivers/thermal/power_actor/Makefile      |  5 +++
> >  drivers/thermal/power_actor/power_actor.c | 64 +++++++++++++++++++++++++++++++
> >  drivers/thermal/power_actor/power_actor.h | 64 +++++++++++++++++++++++++++++++
> 
> Do you think this API may have other users other than thermal?
> 
> If yes, I propose moving it somewhere else, such as driver/base/power.
> 

It could be used by others, but I think we should move it when those
other users appear.

> >  6 files changed, 176 insertions(+)
> >  create mode 100644 Documentation/thermal/power_actor.txt
> >  create mode 100644 drivers/thermal/power_actor/Makefile
> >  create mode 100644 drivers/thermal/power_actor/power_actor.c
> >  create mode 100644 drivers/thermal/power_actor/power_actor.h
> > 
> > diff --git a/Documentation/thermal/power_actor.txt b/Documentation/thermal/power_actor.txt
> > new file mode 100644
> > index 000000000000..5a61f32ec143
> > --- /dev/null
> > +++ b/Documentation/thermal/power_actor.txt
> > @@ -0,0 +1,38 @@
> > +
> > +Power Actor API
> > +===============
> > +
> > +The base power actor API is meant to be used to derive specific power
> 
> 
> How about having a deeper explanation? Maybe including one or two
> paragraphs explaning why and when using this API makes sense.
> 
> One or two scenario explanation also would help.

Ok, I'll add it.

> An explanation of the difference to cooling API is also good to have.
> 
> > +actors, such as a cpu power actor.  When registering, they should call
> > +`power_actor_register()` with a unique `enum power_actor_types`.  When
> 
> Why this enum? Maybe it is a design copy of PM QoS?

To be able to tell different power actors apart.  I haven't looked
into PM QoS.

> But to me this is bound to struct device, no?

You're suggesting that we should add this as a field to struct device?
Could do.

> > +unregistering, the power actor should call `power_actor_unregister()`
> > +with the `struct power_actor *` received in the call to
> > +`power_actor_register()`.
> > +
> > +Callbacks
> > +---------
> > +
> > +1. u32 get_req_power(struct power_actor *actor)
> > +@actor: a valid `struct power_actor *` registered with
> > +        `power_actor_register()`
> > +
> > +`get_req_power()` returns the current requested power in milliwatts.
> > +
> > +2. u32 get_max_power(struct power_actor *actor)
> > +@actor: a valid `struct power_actor *` registered with
> > +        `power_actor_register()`
> > +
> > +`get_max_power()` returns the maximum power that the device could
> > +consume if it was fully utilized.  It's a function as some devices'
> > +maximum power consumption can change due to external factors such as
> > +temperature.
> > +
> > +3. int set_power(struct power_actor *actor, u32 power)
> > +@actor: a valid `struct power_actor *` registered with
> > +        `power_actor_register()`
> > +@power: power in milliwatts
> > +
> > +`set_power()` should configure the device to consume @power
> > +milliwatts.
> > +
> > +Returns 0 on success, -E* on error.
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index 2d51912a6e40..47e2f15537ca 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -89,6 +89,9 @@ config THERMAL_GOV_USER_SPACE
> >  	help
> >  	  Enable this to let the user space manage the platform thermals.
> >  
> > +config THERMAL_POWER_ACTOR
> > +	bool
> > +
> 
> Why empty description/help?

Because it's not an option that users can select.

> >  config CPU_THERMAL
> >  	bool "generic cpu cooling support"
> >  	depends on CPU_FREQ
> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> > index 54e4ec9eb5df..878a02cab7d1 100644
> > --- a/drivers/thermal/Makefile
> > +++ b/drivers/thermal/Makefile
> > @@ -14,6 +14,8 @@ thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
> >  thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
> >  thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
> >  
> > +obj-$(CONFIG_THERMAL_POWER_ACTOR) += power_actor/
> > +
> >  # cpufreq cooling
> >  thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
> >  
> > diff --git a/drivers/thermal/power_actor/Makefile b/drivers/thermal/power_actor/Makefile
> > new file mode 100644
> > index 000000000000..46478f4928be
> > --- /dev/null
> > +++ b/drivers/thermal/power_actor/Makefile
> > @@ -0,0 +1,5 @@
> > +#
> > +# Makefile for the power actors
> > +#
> > +
> > +obj-y += power_actor.o
> 
> Why a new directory? Maybe using parent dir is enough?

Ok, I'll move it to the parent directory.

> > diff --git a/drivers/thermal/power_actor/power_actor.c b/drivers/thermal/power_actor/power_actor.c
> > new file mode 100644
> > index 000000000000..d891deb0e2a1
> > --- /dev/null
> > +++ b/drivers/thermal/power_actor/power_actor.c
> > @@ -0,0 +1,64 @@
> > +/*
> > + * Basic interface for power actors
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
> > +#define pr_fmt(fmt) "Power actor: " fmt
> > +
> > +#include <linux/err.h>
> > +#include <linux/list.h>
> > +#include <linux/slab.h>
> > +
> > +#include "power_actor.h"
> > +
> > +LIST_HEAD(actor_list);
> > +
> > +/**
> > + * power_actor_register - Register an actor in the power actor API
> > + * @type:	actor type
> > + * @ops:	struct power_actor_ops for this actor
> > + * @privdata:	pointer to private data related to the actor
> > + *
> > + * Returns the struct power_actor * on success, ERR_PTR() on failure
> > + */
> > +struct power_actor *power_actor_register(enum power_actor_types type,
> > +					struct power_actor_ops *ops,
> > +					void *privdata)
> > +{
> > +	struct power_actor *actor;
> > +
> > +	if (!ops->get_req_power || !ops->get_max_power || !ops->set_power)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	actor = kzalloc(sizeof(*actor), GFP_KERNEL);
> 
> devm_?

I can't, there's no device.

> > +	if (!actor)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	actor->type = type;
> > +	actor->ops = ops;
> > +	actor->data = privdata;
> > +
> > +	list_add(&actor->actor_node, &actor_list);
> > +
> 
> Do you need to protect this one?

Yes, it needs protection.

> > +	return actor;
> > +}
> > +
> > +/**
> > + * power_actor_unregister - Unregister an actor
> > + * @actor:	the actor to unregister
> > + */
> > +void power_actor_unregister(struct power_actor *actor)
> > +{
> > +	list_del(&actor->actor_node);
> > +	kfree(actor);
> > +}
> > diff --git a/drivers/thermal/power_actor/power_actor.h b/drivers/thermal/power_actor/power_actor.h
> > new file mode 100644
> > index 000000000000..28098f43630b
> > --- /dev/null
> > +++ b/drivers/thermal/power_actor/power_actor.h
> > @@ -0,0 +1,64 @@
> > +/*
> > + * Copyright (C) 2014 ARM Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef __POWER_ACTOR_H__
> > +#define __POWER_ACTOR_H__
> > +
> > +#include <linux/list.h>
> > +
> > +#define MAX_NUM_ACTORS 8
> > +
> 
> unused define

True, it's a left over, I'll delete it.

> > +enum power_actor_types {
> > +};
> 
> I still don't get this enum.

You will when you look at the next patch ;)

Cheers,
Javi

