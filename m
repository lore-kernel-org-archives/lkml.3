Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaEWOVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:21:15 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:35117 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaEWOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:21:13 -0400
Date: Fri, 23 May 2014 09:44:51 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi@e104805.cambridge.arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH] thermal: document struct thermal_zone_device and
 thermal_governor
Message-ID: <20140523134451.GA3399@developer>
References: <1400238968-8816-1-git-send-email-javi.merino@arm.com>
 <20140522152730.GB5246@developer>
 <20140523093552.GB4723@e104805>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523093552.GB4723@e104805>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javi,

On Fri, May 23, 2014 at 10:35:52AM +0100, Javi Merino wrote:
> On Thu, May 22, 2014 at 04:27:30PM +0100, Eduardo Valentin wrote:
> > Hello Javi,
> > 
> > On Fri, May 16, 2014 at 12:16:08PM +0100, Javi Merino wrote:
> > 
> > > Document struct struct thermal_zone_device and struct thermal_governor
> > > fields and their use by the thermal framework code.
> > > 
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> > > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > > 
> > > ---
> > > 
> > > Hi linux-pm,
> > > 
> > > I have some patches that add new fields to these structures but I
> > > don't have a good place to describe those fields as these structs are
> > > mostly undocumented so I thought I'd document them.
> > > 
> > > I'm unsure about some of the descriptions, specially for passive and
> > > forced_passive so please review them.
> > > 
> > >  include/linux/thermal.h |   44 ++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 42 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > index f7e11c7ea7d9..af928c667dba 100644
> > > --- a/include/linux/thermal.h
> > > +++ b/include/linux/thermal.h
> > > @@ -158,6 +158,40 @@ struct thermal_attr {
> > >  	char name[THERMAL_NAME_LENGTH];
> > >  };
> > >  
> > > +/**
> > > + * struct thermal_zone_device - structure for a thermal zone
> > > + * @id:		unique id number for each thermal zone
> > > + * @type:	the thermal zone device type
> > > + * @device:	struct device for this thermal zone
> > > + * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
> > > + * @trip_type_attrs:	attributes for trip points for sysfs: trip type
> > > + * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> > > + * @devdata:	private pointer for device private data
> > > + * @trips:	number of trip points the thermal zone supports
> > > + * @passive_delay:	number of milliseconds to wait between polls when
> > > + *			performing passive cooling.  Only used by the step-wise
> > 
> > I don't think this parameter is specific to step-wise.
> 
> It's only used by step-wise, all the other governors always poll at
> polling_delay.

Agreed, but the fact we have only one governor using it, it does not
imply it is a specific concept for that governor. The concept can and
should be reused by other governors. Idea is simple, you have different
temporal / thermal evolution when idle, when monitoring passive cooling actions. And this fact won't change, no matter the policy you apply.

> 
> While we are at it, can we change the name so that it's more generic and
> can be reused by other governors?  Something like idle_poll and
> active_poll?  I'm open to suggestions for a better name.
> 

active_poll means when cooling devices are active? which kind of cooling
devices?

> > > + *			governor
> > > + * @polling_delay:	number of milliseconds to wait between polls when
> > > + *			checking whether trip points have been crossed (0 for
> > > + *			interrupt driven systems)
> > > + * @temperature:	current temperature.  This is only for core code,
> > > + *			drivers should use thermal_zone_get_temp() to get the
> > > + *			current temperature
> > > + * @last_temperature:	previous temperature read
> > > + * @emul_temperature:	emulated temperature when using CONFIG_THERMAL_EMULATION
> > > + * @passive:	step-wise specific parameter.  1 if you've crossed a passive
> > > + *		trip point, 0 otherwise
> > 
> > ditto.
> 
> ditto, no other governor changes passive and it can't be changed from
> sysfs.
> 
> > > + * @forced_passive:	step-wise specific parameter.  If > 0, temperature at
> > > + *			which to switch on all cpufreq cooling devices.
> > 
> > ditto.
> 
> Again, this is step-wise specific.  You can change it from sysfs, but
> the other governors (userspace and fair-share) will happily ignore
> you.
> 
> > Also, governors are not aware of specific cooling devices. 
> 
> I didn't say that governors are aware of specific cooling devices.  I
> said that if forced_passive is greater than 0, then only cpufreq
> cooling devices are switched on.  It's wrong, it's not cpufreq cooling
> devices, it's ACPI Processor cooling devices.
> 

I mean, we don't have only cpufreq cooling devices. 

> Cheers,
> Javi
