Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3ECL5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:57:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56403 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab3ECL5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:57:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / processor: Use common hotplug infrastructure
Date: Fri, 03 May 2013 14:05:37 +0200
Message-ID: <8416995.PXoT3vbUMm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367536812.16154.178.camel@misato.fc.hp.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <4370898.CqFcWEhTiu@vostro.rjw.lan> <1367536812.16154.178.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 02, 2013 05:20:12 PM Toshi Kani wrote:
> On Thu, 2013-05-02 at 14:31 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Split the ACPI processor driver into two parts, one that is
> > non-modular, resides in the ACPI core and handles the enumeration
> > and hotplug of processors and one that implements the rest of the
> > existing processor driver functionality.
> > 
> > The non-modular part uses an ACPI scan handler object to enumerate
> > processors on the basis of information provided by the ACPI namespace
> > and to hook up with the common ACPI hotplug infrastructure.  It also
> > populates the ACPI handle of each processor device having a
> > corresponding object in the ACPI namespace, which allows the driver
> > proper to bind to those devices, and makes the driver bind to them
> > if it is readily available (i.e. loaded) when the scan handler's
> > .attach() routine is running.
> > 
> > There are a few reasons to make this change.
> > 
> > First, switching the ACPI processor driver to using the common ACPI
> > hotplug infrastructure reduces code duplication and size considerably,
> > even though a new file is created along with a header comment etc.
> > 
> > Second, since the common hotplug code attempts to offline devices
> > before starting the (non-reversible) removal procedure, it will abort
> > (and possibly roll back) hot-remove operations involving processors
> > if cpu_down() returns an error code for one of them instead of
> > continuing them blindly (if /sys/firmware/acpi/hotplug/force_remove
> > is unset).  That is a more desirable behavior than what the current
> > code does.
> > 
> > Finally, the separation of the scan/hotplug part from the driver
> > proper makes it possible to simplify the driver's .remove() routine,
> > because it doesn't need to worry about the possible cleanup related
> > to processor removal any more (the scan/hotplug part is responsible
> > for that now) and can handle device removal and driver removal
> > symmetricaly (i.e. as appropriate).
> > 
> > Some user-visible changes in sysfs are made (for example, the
> > 'sysdev' link from the ACPI device node to the processor device's
> > directory is gone and a 'physical_node' link is present instead,
> > a 'firmware_node' link is present in the processor device's
> > directory, the processor driver is now visible under
> > /sys/bus/cpu/drivers/ and bound to the processor device), but
> > that shouldn't affect the functionality that users care about
> > (frequency scaling, C-states and thermal management).
> 
> This looks very nice.  I have one question below.
> 
> > Tested on my venerable Toshiba Portege R500.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/Makefile           |    1 
> >  drivers/acpi/acpi_processor.c   |  473 +++++++++++++++++++++++
> >  drivers/acpi/glue.c             |    6 
> >  drivers/acpi/internal.h         |    3 
> >  drivers/acpi/processor_driver.c |  803 +++-------------------------------------
> >  drivers/acpi/scan.c             |    1 
> >  drivers/base/cpu.c              |   11 
> >  include/acpi/processor.h        |    5 
> >  8 files changed, 574 insertions(+), 729 deletions(-)
> 
>  :
> 
> > Index: linux-pm/drivers/base/cpu.c
> > ===================================================================
> > --- linux-pm.orig/drivers/base/cpu.c
> > +++ linux-pm/drivers/base/cpu.c
> > @@ -13,11 +13,21 @@
> >  #include <linux/gfp.h>
> >  #include <linux/slab.h>
> >  #include <linux/percpu.h>
> > +#include <linux/acpi.h>
> >  
> >  #include "base.h"
> >  
> >  static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
> >  
> > +static int cpu_subsys_match(struct device *dev, struct device_driver *drv)
> > +{
> > +	/* ACPI style match is the only one that may succeed. */
> > +	if (acpi_driver_match_device(dev, drv))
> 
> Can you explain why this change is needed?

This is the mechanism by which the driver core determines which driver to use
with a processor device passed to device_attach().

Basically, it walks the list of drivers whose bus type is cpu_subsys and
calls cpu_subsys->match(), which points to cpu_subsys_match(), for the device
and each of the drivers.  The result of that tell is whether or not to use
the given driver with the device.

Now, acpi_driver_match_device() returns 'true' if (a) the device has an ACPI
handle and (b) at least one of the IDs of the struct acpi_device associated
with that handle is in the driver's .acpi_match_table table.  Since the ACPI
processor's .acpi_match_table contains the same set of IDs as the table
of device IDs of processor_handler, this guarantees that the ACPI processor
driver will be used for the devices prepared by acpi_processor_add().

What it boils down to is that acpi_processor_start() is going to be called
for every device whose ACPI handle is populated by acpi_processor_add().

> Do CPU devices still behave the same on non-ACPI systems?

Yes, they do.  The whole driver matching/binding is irrelevant to them, because
the ACPI processor driver is the only one registering itself under cpu_subsys.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
