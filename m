Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaFMRBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:01:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40104 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaFMRBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:01:18 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Fri, 13 Jun 2014 18:01:15 +0100
To: Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v3 5/7] thermal: add a basic cpu power actor
Message-ID: <20140613170115.GC3504@e104805>
References: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
 <1401790715-5630-6-git-send-email-javi.merino@arm.com>
 <20140611120537.GA7230@developer>
 <20140612142650.GB2763@e104805>
MIME-Version: 1.0
In-Reply-To: <20140612142650.GB2763@e104805>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Jun 2014 17:01:09.0912 (UTC) FILETIME=[12FEA180:01CF8729]
X-MC-Unique: 114061318011608201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:26:50PM +0100, Javi Merino wrote:
> On Wed, Jun 11, 2014 at 01:05:37PM +0100, Eduardo Valentin wrote:
> > On Tue, Jun 03, 2014 at 11:18:33AM +0100, Javi Merino wrote:
> > > Introduce a power actor for cpus.  It has a basic power model to get
> > > the current power utilization and uses cpufreq cooling devices to set
> > > the desired power.  It uses the current frequency (as reported by
> > > cpufreq) as well as load and OPPs for the power calculations.  The
> > > cpus must have registered their OPPs in the OPP library.
> > >
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> > > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > > ---
> > >  Documentation/thermal/power_actor.txt     | 126 +++++++
> > >  drivers/thermal/Kconfig                   |   5 +
> > >  drivers/thermal/power_actor/Kconfig       |   9 +
> > >  drivers/thermal/power_actor/Makefile      |   2 +
> > >  drivers/thermal/power_actor/cpu_actor.c   | 601 ++++++++++++++++++++++++++++++
> > >  drivers/thermal/power_actor/power_actor.h |  41 ++
> > >  6 files changed, 784 insertions(+)
> > >  create mode 100644 drivers/thermal/power_actor/Kconfig
> > >  create mode 100644 drivers/thermal/power_actor/cpu_actor.c
> > >
[...]
> > > diff --git a/drivers/thermal/power_actor/Kconfig b/drivers/thermal/power_actor/Kconfig
> > > new file mode 100644
> > > index 000000000000..fa542ca99cdb
> > > --- /dev/null
> > > +++ b/drivers/thermal/power_actor/Kconfig
> > > @@ -0,0 +1,9 @@
> > > +#
> > > +# Thermal power actor configuration
> > > +#
> > > +
> > > +config THERMAL_POWER_ACTOR_CPU
> > > +     bool
> > > +     prompt "Simple power model for a CPU"
> > > +     help
> > > +       A simple CPU power model
> >
> > A better help is always welcome.
> 
> I guess I can repeat some of the text in the Documentation here.

I've been thinking about it and I'd rather remove the prompt
altogether.  There's no point in asking the user about this, drivers
that use this API can select THERMAL_POWER_ACTOR_CPU themselves.  So
I'll remove the help text.

[...]
> > > diff --git a/drivers/thermal/power_actor/power_actor.h b/drivers/thermal/power_actor/power_actor.h
> > > index 28098f43630b..230317c284b2 100644
> > > --- a/drivers/thermal/power_actor/power_actor.h
> > > +++ b/drivers/thermal/power_actor/power_actor.h
> > > @@ -17,11 +17,16 @@
> > >  #ifndef __POWER_ACTOR_H__
> > >  #define __POWER_ACTOR_H__
> > >
> > > +#include <linux/cpumask.h>
> > > +#include <linux/device.h>
> > > +#include <linux/err.h>
> > >  #include <linux/list.h>
> > > +#include <linux/thermal.h>
> > >
> > >  #define MAX_NUM_ACTORS 8
> > >
> > >  enum power_actor_types {
> > > +     POWER_ACTOR_CPU,
> >
> > Using struct device is more scalable no? What if we want to provide a
> > power actor for a specific bus, or device, or coprocessor? Are we going
> > to maintain this enum for every single new user?
> 
> The counterargument would be, does every single device need to carry
> this?  Anyway, I'll see if we can add the power actor to the "struct
> device".

I've decided to remove the only user of the power_actor_types enum and
remove this field as well.  It's simplifies things which is always
good.

Cheers,
Javi

