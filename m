Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3A2XND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:13:03 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59577 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3A2XM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:12:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ACPI / scan: Introduce struct acpi_scan_handler
Date: Wed, 30 Jan 2013 00:19:09 +0100
Message-ID: <3143588.b2lxVgXVDr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359500230.15120.58.camel@misato.fc.hp.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <12270898.1ejuD0aCLg@vostro.rjw.lan> <1359500230.15120.58.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 03:57:10 PM Toshi Kani wrote:
> On Tue, 2013-01-29 at 22:32 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, January 29, 2013 07:50:43 AM Toshi Kani wrote:
> > > On Tue, 2013-01-29 at 12:28 +0100, Rafael J. Wysocki wrote:
> > > > On Monday, January 28, 2013 07:35:39 PM Toshi Kani wrote:
> > > > > On Mon, 2013-01-28 at 13:59 +0100, Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > 
> > > > > > Introduce struct acpi_scan_handler for representing objects that
> > > > > > will do configuration tasks depending on ACPI device nodes'
> > > > > > hardware IDs (HIDs).
> > > > > > 
> > > > > > Currently, those tasks are done either directly by the ACPI namespace
> > > > > > scanning code or by ACPI device drivers designed specifically for
> > > > > > this purpose.  None of the above is desirable, however, because
> > > > > > doing that directly in the namespace scanning code makes that code
> > > > > > overly complicated and difficult to follow and doing that in
> > > > > > "special" device drivers leads to a great deal of confusion about
> > > > > > their role and to confusing interactions with the driver core (for
> > > > > > example, sysfs directories are created for those drivers, but they
> > > > > > are completely unnecessary and only increase the kernel's memory
> > > > > > footprint in vain).
> > > > > > 
> > > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > ---
> > > > > >  Documentation/acpi/scan_handlers.txt |   77 +++++++++++++++++++++++++++++++++++
> > > > > >  drivers/acpi/scan.c                  |   60 ++++++++++++++++++++++++---
> > > > > >  include/acpi/acpi_bus.h              |   14 ++++++
> > > > > >  3 files changed, 144 insertions(+), 7 deletions(-)
> > > > > > 
> > > > > > Index: test/include/acpi/acpi_bus.h
> > > > > > ===================================================================
> > > > > > --- test.orig/include/acpi/acpi_bus.h
> > > > > > +++ test/include/acpi/acpi_bus.h
> > > > > > @@ -84,6 +84,18 @@ struct acpi_driver;
> > > > > >  struct acpi_device;
> > > > > >  
> > > > > >  /*
> > > > > > + * ACPI Scan Handler
> > > > > > + * -----------------
> > > > > > + */
> > > > > > +
> > > > > > +struct acpi_scan_handler {
> > > > > > +	const struct acpi_device_id *ids;
> > > > > > +	struct list_head list_node;
> > > > > > +	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
> > > > > > +	void (*detach)(struct acpi_device *dev);
> > > > > > +};
> > > > > > +
> > > > > > +/*
> > > > > >   * ACPI Driver
> > > > > >   * -----------
> > > > > >   */
> > > > > > @@ -269,6 +281,7 @@ struct acpi_device {
> > > > > >  	struct acpi_device_wakeup wakeup;
> > > > > >  	struct acpi_device_perf performance;
> > > > > >  	struct acpi_device_dir dir;
> > > > > > +	struct acpi_scan_handler *handler;
> > > > > >  	struct acpi_driver *driver;
> > > > > >  	void *driver_data;
> > > > > >  	struct device dev;
> > > > > > @@ -382,6 +395,7 @@ int acpi_bus_receive_event(struct acpi_b
> > > > > >  static inline int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data)
> > > > > >  	{ return 0; }
> > > > > >  #endif
> > > > > > +int acpi_scan_add_handler(struct acpi_scan_handler *handler);
> > > > > >  int acpi_bus_register_driver(struct acpi_driver *driver);
> > > > > >  void acpi_bus_unregister_driver(struct acpi_driver *driver);
> > > > > >  int acpi_bus_scan(acpi_handle handle);
> > > > > > Index: test/drivers/acpi/scan.c
> > > > > > ===================================================================
> > > > > > --- test.orig/drivers/acpi/scan.c
> > > > > > +++ test/drivers/acpi/scan.c
> > > > > > @@ -53,6 +53,7 @@ static const struct acpi_device_id acpi_
> > > > > >  static LIST_HEAD(acpi_device_list);
> > > > > >  static LIST_HEAD(acpi_bus_id_list);
> > > > > >  static DEFINE_MUTEX(acpi_scan_lock);
> > > > > > +static LIST_HEAD(acpi_scan_handlers_list);
> > > > > >  DEFINE_MUTEX(acpi_device_lock);
> > > > > >  LIST_HEAD(acpi_wakeup_device_list);
> > > > > >  
> > > > > > @@ -62,6 +63,15 @@ struct acpi_device_bus_id{
> > > > > >  	struct list_head node;
> > > > > >  };
> > > > > >  
> > > > > > +int acpi_scan_add_handler(struct acpi_scan_handler *handler)
> > > > > > +{
> > > > > > +	if (!handler || !handler->attach)
> > > > > > +		return -EINVAL;
> > > > > > +
> > > > > > +	list_add_tail(&handler->list_node, &acpi_scan_handlers_list);
> > > > > > +	return 0;
> > > > > > +}
> > > > > > +
> > > > > >  /*
> > > > > >   * Creates hid/cid(s) string needed for modalias and uevent
> > > > > >   * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
> > > > > > @@ -1570,20 +1580,42 @@ static acpi_status acpi_bus_check_add(ac
> > > > > >  	return AE_OK;
> > > > > >  }
> > > > > >  
> > > > > > +static int acpi_scan_attach_handler(struct acpi_device *device)
> > > > > > +{
> > > > > > +	struct acpi_scan_handler *handler;
> > > > > > +	int ret = 0;
> > > > > > +
> > > > > > +	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
> > > > > > +		const struct acpi_device_id *id;
> > > > > > +
> > > > > > +		id = __acpi_match_device(device, handler->ids);
> > > > > > +		if (!id)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		ret = handler->attach(device, id);
> > > > > > +		if (ret > 0) {
> > > > > > +			device->handler = handler;
> > > > > > +			break;
> > > > > > +		} else if (ret < 0) {
> > > > > > +			break;
> > > > > > +		}
> > > > > > +	}
> > > > > > +	return ret;
> > > > > > +}
> > > > > 
> > > > > Now that we have full control over the attach logic, it would be great
> > > > > if we can update it to match with the ACPI spec -- HID has priority over
> > > > > CIDs, and CIDs are also listed in their priority.  For example, Device-X
> > > > > has HID and CID.  In this case, this Device-X should be attached to
> > > > > Handler-A since it supports HID.  The current logic simply chooses a
> > > > > handler whichever registered before.  
> > > > > 
> > > > > Device-X: HID PNPID-A, CID PNPID-B
> > > > > Handler-A: PNPID-A
> > > > > Handler-B: PNPID-B
> > > > > 
> > > > > So, the attach logic should be something like:
> > > > > 
> > > > > list_for_each_entry(hwid, acpi_device->pnp.ids,) {
> > > > > 	list_for_each_entry(,&acpi_scan_handlers_list,)
> > > > > 		check if this handler supports a given hwid
> > > > > }
> > > > 
> > > > OK, I see the problem, but I think it's better to address it in a separate
> > > > patch on top of the current series.
> > > 
> > > I agree.
> > > 
> > > > I'm not sure what approach is best, though.  Do you think there should be two
> > > > passes the first of which will check HIDs only and the second one will check
> > > > CIDs?  Or do you have something different in mind?
> > > 
> > > HID and CIDs are already listed in their priority order in
> > > acpi_device->pnp.ids.  So, the single pass like I described above should
> > > work.
> > 
> > Well, I'm not sure if I understand you correctly.
> > 
> > The device is given and we need to find a handler for it.  So, it looks like
> > we first should check if any handler matches the HID.  This has to be a pass
> > through all handlers.  If there's no match, we need to check if any handler
> > matches any of the device IDs.  That will be the second pass, won't it?
> 
> acpi_device->pnp.ids has a list of HID->CID[0]->CID[1]..CID[n] since
> acpi_device_set_id() checks HID before CIDs.  So, the first pass is to
> check with the first entry of pnp.ids.  If no handler is found, then
> check the second entry, and so on.

I'd prefer to check HID and then all CIDs at once in accordance with the
following rule:
1) Use the first handler that matches HID exactly.  If there's none:
2) Use the first handler compatible with the given device.

> > The difficulty is that the first item in pnp.ids need not be *the* HID.
> > It only will be the HID if ACPI_VALID_HID is set in the device info in
> > acpi_device_set_id().  So perhaps we need to add a hid_valid bit in
> > device->flags and only do the "HID pass" if that is set?
> 
> I do not think such bit is necessary for this.  _HID is required (unless
> it has _ADR), but _CID is optional.  So, the valid cases are that a
> device object has HID only, has both HID and CID(s), or has none of them
> (i.e. _ADR device).  If there is a device with CID only, this is a FW
> bug and we just have to check with CID then.

In addition to that there's a number of objects that we assign artificial HIDs.
I think we should treat them as CIDs rather than as real HIDs in this regard.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
