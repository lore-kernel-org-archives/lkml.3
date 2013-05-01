Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3EAUdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:33:06 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:6852 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3EAUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:33:03 -0400
Message-ID: <1367439612.16154.166.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3/3 RFC] ACPI / hotplug: Use device offline/online for
 graceful hot-removal
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Wed, 01 May 2013 14:20:12 -0600
In-Reply-To: <1513537.Pdbg9h7lkq@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <2740694.MNypEzdXxd@vostro.rjw.lan>
	 <1367365778.16154.144.camel@misato.fc.hp.com>
	 <1513537.Pdbg9h7lkq@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 17:05 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 30, 2013 05:49:38 PM Toshi Kani wrote:
> > On Mon, 2013-04-29 at 14:29 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Modify the generic ACPI hotplug code to be able to check if devices
> > > scheduled for hot-removal may be gracefully removed from the system
> > > using the device offline/online mechanism introduced previously.
> > > 
> > > Namely, make acpi_scan_hot_remove() which handles device hot-removal
> > > call device_offline() for all physical companions of the ACPI device
> > > nodes involved in the operation and check the results.  If any of
> > > the device_offline() calls fails, the function will not progress to
> > > the removal phase (which cannot be aborted), unless its (new) force
> > > argument is set (in case of a failing offline it will put the devices
> > > offlined by it back online).
> > > 
> > > In support of the 'forced' hot-removal, add a new sysfs attribute
> > > 'force_remove' that will reside in every ACPI hotplug profile
> > > present under /sys/firmware/acpi/hotplug/.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-firmware-acpi |    9 +-
> > >  drivers/acpi/internal.h                       |    2 
> > >  drivers/acpi/scan.c                           |   97 ++++++++++++++++++++++++--
> > >  drivers/acpi/sysfs.c                          |   27 +++++++
> > >  include/acpi/acpi_bus.h                       |    3 
> > >  5 files changed, 131 insertions(+), 7 deletions(-)
> > > 
> >  :
> > > Index: linux-pm/drivers/acpi/scan.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/acpi/scan.c
> > > +++ linux-pm/drivers/acpi/scan.c
> > > @@ -120,7 +120,61 @@ acpi_device_modalias_show(struct device
> > >  }
> > >  static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> > >  
> > > -static int acpi_scan_hot_remove(struct acpi_device *device)
> > > +static acpi_status acpi_bus_offline_companions(acpi_handle handle, u32 lvl,
> > > +					       void *data, void **ret_p)
> > > +{
> > > +	struct acpi_device *device = NULL;
> > > +	struct acpi_device_physical_node *pn;
> > > +	bool force = *((bool *)data);
> > > +	acpi_status status = AE_OK;
> > > +
> > > +	if (acpi_bus_get_device(handle, &device))
> > > +		return AE_OK;
> > > +
> > > +	mutex_lock(&device->physical_node_lock);
> > > +
> > > +	list_for_each_entry(pn, &device->physical_node_list, node) {
> > 
> > I do not think physical_node_list is set for ACPI processor devices, so
> > this code is NOP at this point.  I think properly initializing
> > physical_node_list for CPU and memblk is one of the key items in this
> > approach.
> 
> It surely is. :-)
> 
> I've almost done that for CPUs, but that still requires some more work.
> Hopefully, it'll be mostly done later this week.

Cool!

> Memory will take some more time I guess, though.

Yes, memory has an ordering issue when using glue.c.
https://lkml.org/lkml/2013/3/26/398

Thanks,
-Toshi

