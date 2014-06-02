Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaFBSyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:54:24 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:42768 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaFBSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:54:21 -0400
Date: Mon, 2 Jun 2014 13:36:02 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: Amit Kachhap <amit.kachhap@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH v1 6/6] ACPI: thermal: processor: Use the generic cpufreq
 infrastructure
Message-ID: <20140602173602.GB5902@developer>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
 <1401351334-11210-7-git-send-email-amit.daniel@samsung.com>
 <20140529124248.GC2593@e104805>
 <CADGdYn7FZCjhzbFMtNPFtQV_naQhVk+nR1VFNH88M92_NQmfsA@mail.gmail.com>
 <20140602102047.GB2795@e104805>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602102047.GB2795@e104805>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit, Javi,

On Mon, Jun 02, 2014 at 11:20:48AM +0100, Javi Merino wrote:
> On Mon, Jun 02, 2014 at 10:21:48AM +0100, Amit Kachhap wrote:
> > Hi Javi,
> > 
> > On 5/29/14, Javi Merino <javi.merino@arm.com> wrote:
> > > Hi Amit,
> > >
> > > On Thu, May 29, 2014 at 09:15:34AM +0100, Amit Daniel Kachhap wrote:
> > >> This patch upgrades the ACPI cpufreq cooling portions to use the generic
> > >> cpufreq cooling infrastructure. There should not be any functionality
> > >> related changes as the same behaviour is provided by the generic
> > >> cpufreq APIs with the notifier mechanism.
> > >>
> > >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > >> ---
> > >>  drivers/acpi/processor_driver.c  |    6 +-
> > >>  drivers/acpi/processor_thermal.c |  235
> > >> ++++++++++++++++++--------------------
> > >>  include/acpi/processor.h         |    3 +-
> > >>  3 files changed, 115 insertions(+), 129 deletions(-)
> > >>
> > >> diff --git a/drivers/acpi/processor_driver.c
> > >> b/drivers/acpi/processor_driver.c
> > >> index 7f70f31..10aba4a 100644
> > >> --- a/drivers/acpi/processor_driver.c
> > >> +++ b/drivers/acpi/processor_driver.c
> > >> @@ -36,6 +36,7 @@
> > >>  #include <linux/cpuidle.h>
> > >>  #include <linux/slab.h>
> > >>  #include <linux/acpi.h>
> > >> +#include <linux/cpu_cooling.h>
> > >>
> > >>  #include <acpi/processor.h>
> > >>
> > >> @@ -178,8 +179,7 @@ static int __acpi_processor_start(struct acpi_device
> > >> *device)
> > >>         if (!cpuidle_get_driver() || cpuidle_get_driver() ==
> > >> &acpi_idle_driver)
> > >>                 acpi_processor_power_init(pr);
> > >>
> > >> -       pr->cdev = thermal_cooling_device_register("Processor", device,
> > >> -
> > >> &processor_cooling_ops);
> > >> +       pr->cdev = acpi_processor_cooling_register(device);
> > >
> > > With this you have removed the only cooling device whose type was
> > > "Processor".  There's special code for dealing with this cooling
> > > device in drivers/thermal/thermal_core.c:passive_store():
> > >
> > > 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
> > > 			if (!strncmp("Processor", cdev->type,
> > > 				     sizeof("Processor")))
> > > 				thermal_zone_bind_cooling_device(tz,
> > > 						THERMAL_TRIPS_NONE, cdev,
> > > 						THERMAL_NO_LIMIT,
> > > 						THERMAL_NO_LIMIT);
> > > 		}
> > > 		mutex_unlock(&thermal_list_lock);
> > > 		if (!tz->passive_delay)
> > >
> > > With your change, that code is now "dead" as it can't do anything.  No
> > > I don't know what should you do with it, either remove it or make it
> > > match the cpufreq cooling device.  But this patch should deal with
> > > that code as well.
> > nice catch. I somehow missed modifying this section.
> > I think the following changes should fix this,
> > -                       if (!strncmp("Processor", cdev->type,
> > -                                    sizeof("Processor")))
> > +                       if (!strncmp("thermal-cpufreq", cdev->type,
> > +                                    sizeof("thermal-cpufreq")))
> >                                 thermal_zone_bind_cooling_device(tz,
> > 
> 
> That should do it.  I don't really understand why this code is
> specifically looking for ACPI processor cooling devices but I guess
> that's the least disrupting change you can make.

Well, I suggest we move slightly carefuly here. The problem is that this
change actually breaks ABI. If so, we need to follow the kernel ABI
change rules. We should never break userspace.

Rui, Do you recall what users are aware of this sysfs entry?

Cheers,

> 
> Cheers,
> Javi
> 
