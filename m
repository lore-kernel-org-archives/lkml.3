Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763381Ab3ECTXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:23:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57065 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763031Ab3ECTXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:23:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / processor: Use common hotplug infrastructure
Date: Fri, 03 May 2013 21:31:50 +0200
Message-ID: <2355471.VAFinTCtRm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367605674.16154.198.camel@misato.fc.hp.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <8416995.PXoT3vbUMm@vostro.rjw.lan> <1367605674.16154.198.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 12:27:54 PM Toshi Kani wrote:
> On Fri, 2013-05-03 at 14:05 +0200, Rafael J. Wysocki wrote:
> > On Thursday, May 02, 2013 05:20:12 PM Toshi Kani wrote:
> > > On Thu, 2013-05-02 at 14:31 +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>  : 
> > > > Index: linux-pm/drivers/base/cpu.c
> > > > ===================================================================
> > > > --- linux-pm.orig/drivers/base/cpu.c
> > > > +++ linux-pm/drivers/base/cpu.c
> > > > @@ -13,11 +13,21 @@
> > > >  #include <linux/gfp.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/percpu.h>
> > > > +#include <linux/acpi.h>
> > > >  
> > > >  #include "base.h"
> > > >  
> > > >  static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
> > > >  
> > > > +static int cpu_subsys_match(struct device *dev, struct device_driver *drv)
> > > > +{
> > > > +	/* ACPI style match is the only one that may succeed. */
> > > > +	if (acpi_driver_match_device(dev, drv))
> > > 
> > > Can you explain why this change is needed?
> > 
> > This is the mechanism by which the driver core determines which driver to use
> > with a processor device passed to device_attach().
> > 
> > Basically, it walks the list of drivers whose bus type is cpu_subsys and
> > calls cpu_subsys->match(), which points to cpu_subsys_match(), for the device
> > and each of the drivers.  The result of that tell is whether or not to use
> > the given driver with the device.
> > 
> > Now, acpi_driver_match_device() returns 'true' if (a) the device has an ACPI
> > handle and (b) at least one of the IDs of the struct acpi_device associated
> > with that handle is in the driver's .acpi_match_table table.  Since the ACPI
> > processor's .acpi_match_table contains the same set of IDs as the table
> > of device IDs of processor_handler, this guarantees that the ACPI processor
> > driver will be used for the devices prepared by acpi_processor_add().
> > 
> > What it boils down to is that acpi_processor_start() is going to be called
> > for every device whose ACPI handle is populated by acpi_processor_add().
> > 
> > > Do CPU devices still behave the same on non-ACPI systems?
> > 
> > Yes, they do.  The whole driver matching/binding is irrelevant to them, because
> > the ACPI processor driver is the only one registering itself under cpu_subsys.
> 
> Thanks for the detailed explanation!  I missed that the new processor
> driver is registered to cpu_subsys.  I now see what you did.  This is
> clever.

Well, thanks! :-)

> One minor comment.
> 
> +static __cpuinit int __acpi_processor_start(struct acpi_device *device)
> >  {
> > -	struct acpi_device *device = per_cpu(processor_device_array,
> pr->id);
> > +	struct acpi_processor *pr = acpi_driver_data(device);
> > +	acpi_status status;
> >  	int result = 0;
> >  
> > +	if (!pr)
> > +		return -ENODEV;
> > +
> > +	if (pr->flags.need_hotplug_init)
> > +		return 0;
> > +
> 
> I felt the name of "need_hotplug_init" is a bit misleading since the
> func actually skips when the need-flag is set.  It may be nice to rename
> it to defer_online_init, offline or something like that.

I just wanted to avoid making too many non-essential changes in one patch.
We can change the name of that field at any time later.

> Otherwise the changes look very good. 
> 
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thank you!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
