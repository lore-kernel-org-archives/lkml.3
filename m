Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381Ab3EAO5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:57:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53385 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab3EAO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:57:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 3/3 RFC] ACPI / hotplug: Use device offline/online for graceful hot-removal
Date: Wed, 01 May 2013 17:05:59 +0200
Message-ID: <1513537.Pdbg9h7lkq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367365778.16154.144.camel@misato.fc.hp.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <2740694.MNypEzdXxd@vostro.rjw.lan> <1367365778.16154.144.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 05:49:38 PM Toshi Kani wrote:
> On Mon, 2013-04-29 at 14:29 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Modify the generic ACPI hotplug code to be able to check if devices
> > scheduled for hot-removal may be gracefully removed from the system
> > using the device offline/online mechanism introduced previously.
> > 
> > Namely, make acpi_scan_hot_remove() which handles device hot-removal
> > call device_offline() for all physical companions of the ACPI device
> > nodes involved in the operation and check the results.  If any of
> > the device_offline() calls fails, the function will not progress to
> > the removal phase (which cannot be aborted), unless its (new) force
> > argument is set (in case of a failing offline it will put the devices
> > offlined by it back online).
> > 
> > In support of the 'forced' hot-removal, add a new sysfs attribute
> > 'force_remove' that will reside in every ACPI hotplug profile
> > present under /sys/firmware/acpi/hotplug/.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-acpi |    9 +-
> >  drivers/acpi/internal.h                       |    2 
> >  drivers/acpi/scan.c                           |   97 ++++++++++++++++++++++++--
> >  drivers/acpi/sysfs.c                          |   27 +++++++
> >  include/acpi/acpi_bus.h                       |    3 
> >  5 files changed, 131 insertions(+), 7 deletions(-)
> > 
>  :
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -120,7 +120,61 @@ acpi_device_modalias_show(struct device
> >  }
> >  static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >  
> > -static int acpi_scan_hot_remove(struct acpi_device *device)
> > +static acpi_status acpi_bus_offline_companions(acpi_handle handle, u32 lvl,
> > +					       void *data, void **ret_p)
> > +{
> > +	struct acpi_device *device = NULL;
> > +	struct acpi_device_physical_node *pn;
> > +	bool force = *((bool *)data);
> > +	acpi_status status = AE_OK;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_OK;
> > +
> > +	mutex_lock(&device->physical_node_lock);
> > +
> > +	list_for_each_entry(pn, &device->physical_node_list, node) {
> 
> I do not think physical_node_list is set for ACPI processor devices, so
> this code is NOP at this point.  I think properly initializing
> physical_node_list for CPU and memblk is one of the key items in this
> approach.

It surely is. :-)

I've almost done that for CPUs, but that still requires some more work.
Hopefully, it'll be mostly done later this week.

Memory will take some more time I guess, though.

> > +		int ret;
> > +
> > +		ret = device_offline(pn->dev);
> > +		if (force)
> > +			continue;
> > +
> > +		if (ret < 0) {
> > +			status = AE_ERROR;
> > +			break;
> > +		}
> > +		pn->put_online = !ret;
> > +	}
> > +
> > +	mutex_unlock(&device->physical_node_lock);
> > +
> > +	return status;
> > +}
> > +
> > +static acpi_status acpi_bus_online_companions(acpi_handle handle, u32 lvl,
> > +					      void *data, void **ret_p)
> > +{
> > +	struct acpi_device *device = NULL;
> > +	struct acpi_device_physical_node *pn;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_OK;
> > +
> > +	mutex_lock(&device->physical_node_lock);
> > +
> > +	list_for_each_entry(pn, &device->physical_node_list, node)
> > +		if (pn->put_online) {
> > +			device_online(pn->dev);
> > +			pn->put_online = false;
> > +		}
> > +
> > +	mutex_unlock(&device->physical_node_lock);
> > +
> > +	return AE_OK;
> > +}
> > +
> > +static int acpi_scan_hot_remove(struct acpi_device *device, bool force)
> >  {
> >  	acpi_handle handle = device->handle;
> >  	acpi_handle not_used;
> > @@ -136,10 +190,30 @@ static int acpi_scan_hot_remove(struct a
> >  		return -EINVAL;
> >  	}
> >  
> > +	lock_device_offline();
> > +
> > +	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > +				     NULL, acpi_bus_offline_companions, &force,
> > +				     NULL);
> > +	if (ACPI_SUCCESS(status) || force)
> > +		status = acpi_bus_offline_companions(handle, 0, &force, NULL);
> > +
> > +	if (ACPI_FAILURE(status) && !force) {
> > +		acpi_bus_online_companions(handle, 0, NULL, NULL);
> > +		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > +				    acpi_bus_online_companions, NULL, NULL,
> > +				    NULL);
> > +		unlock_device_offline();
> 
> Don't we need put_device(&device->dev) here?

Yes, we do.  Thanks for spotting that!

Thanks for the comments.  I'll reply to your other messages later today
or tomorrow.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
