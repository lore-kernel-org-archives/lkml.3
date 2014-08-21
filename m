Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaHUQwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:52:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60405 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752170AbaHUQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:52:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Thu, 21 Aug 2014 19:10:55 +0200
Message-ID: <2188871.Tr0Kbz91aK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408622934.3315.8.camel@rzhang1-toshiba>
References: <5487060.QsgluucUH4@vostro.rjw.lan> <1408622934.3315.8.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 08:08:54 PM Zhang Rui wrote:
> Hi, Rafael,
> 
> On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[cut]

> Note that I've just tested on my machine and it works well.
> I still need the bug reporter to check if the patch fixes bug 81511 or not.

The FUJ02B1 and FUJ02E3 devices in bug 81971 have the same problem and
they aren't motherboard devices.  Yes, we need to convert that driver
to use a PNP driver structure or a platform device, but (1) we need a
-stable fix *first* and (2) the cases we already know about may not be
the only broken ones.

> From c6c388728d08a6368f21dab61d6f0a940e0ea13a Mon Sep 17 00:00:00 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Thu, 21 Aug 2014 13:39:47 +0800
> Subject: [RFC PATCH] ACPI: introduce motherboard resource management
> 
> ACPI Devices with _HID/_CID PNP0C01/PNP0C02 represents that
> they have some motherboard resources that needs to be reserved.
> 
> We used to enumerated those devices to PNP bus and rely on
> PNP system driver to do resource reservation.
> But this mechanism does not work well nowadays as many devices
> not only represent motherboard resources, but also represent
> physical devices that need native drivers other than PNP system
> driver for the device to work. For example,
> 1) https://bugzilla.kernel.org/show_bug.cgi?id=46741,
>     Device (NIPM)
>     {
>         Name (_HID, EisaId ("IPI0001"))  // _HID: Hardware ID
>         Name (_CID, EisaId ("PNP0C01"))  // _CID: Compatible ID
>    the NIPM device has _CID PNP0C01 but it is an IPMI device.
>    PNP system driver blocks the PNP IPMI driver to probe.

That is a good reason for PNP0C01 to be dropped from acpi_pnp_device_ids[].

> 2) https://bugzilla.kernel.org/show_bug.cgi?id=81511
>         Device (IFFS)
>         {
>             Name (_HID, EisaId ("INT3392"))  // _HID: Hardware ID
>             Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
>    the IFFS device has _CID PNP0C02, but it is an intel rapid start
>    device, which already has an ACPI driver at
>    drivers/platform/x86/intel-rst.c

And which should be a platform driver really.

> 3) a couple of machines, including the on in
>    https://bugzilla.kernel.org/show_bug.cgi?id=81511, has the AML code
>    like following
>         Device (PTID)
>         {
>             Name (_HID, EisaId ("INT340E"))  // _HID: Hardware ID
>             Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
>    the PTID device has _CID PNP0C02, but it is also represents an
>    INT340E device, there is a platform bus driver for this device
>    which will be introduced by myself soon.

Again, that's a good reason for dropping PNP0C02 from acpi_pnp_device_ids[].

> In any of the above cases, the current code for managing PNP0C01/PNP0C02
> resources in Linux kernel is broken, because it either blocks the physical
> device driver on the same bus, or results in multiple drivers loaded for
> the same ACPI device node, which may also has some potential risks.
> 
> Thus, IMO, we need a clean way to handle those motherboard resources.
> Given that PNP0C01/PNP0C02 is more like an indicator for reserving the
> resources, this patch
> 1. does the resource reservation in ACPI code directly, with the same logic
>    and time point in drivers/pnp/quirks.c and drivers/pnp/system.c.
> 2. makes PNP0C01/PNP0C02 PNP id transparent to Linux devices and drivers,
>    thus PNP system driver becomes a no-op for ACPI enumerated devices.
> 
> This is just a draft patch, and I'd like to see if this is
> the right direction to go. Any comments are welcome.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/acpi_pnp.c |   3 -
>  drivers/acpi/scan.c     | 208 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 204 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> index 1f8b204..a7deae5 100644
> --- a/drivers/acpi/acpi_pnp.c
> +++ b/drivers/acpi/acpi_pnp.c
> @@ -134,9 +134,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
>  	{"FUJ02bf"},
>  	{"FUJ02B1"},
>  	{"FUJ02E3"},
> -	/* system */
> -	{"PNP0c02"},		/* General ID for reserving resources */
> -	{"PNP0c01"},		/* memory controller */
>  	/* rtc_cmos */
>  	{"PNP0b00"},
>  	{"PNP0b01"},
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 0a817ad..674518b 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -11,6 +11,7 @@
>  #include <linux/kthread.h>
>  #include <linux/dmi.h>
>  #include <linux/nls.h>
> +#include <linux/pci.h>
>  
>  #include <asm/pgtable.h>
>  
> @@ -1781,12 +1782,201 @@ static bool acpi_object_is_system_bus(acpi_handle handle)
>  	return false;
>  }
>  
> +static bool acpi_is_motherboard_resource(char *id)
> +{
> +	return !(strncmp(id, "PNP0C01", sizeof("PNP0C01")) &&
> +		 strncmp(id, "PNP0C02", sizeof("PNP0C02")));
> +}

Can we use __acpi_match_device() for that?

> +
> +static LIST_HEAD(acpi_motherboard_resource_list);
> +
> +struct acpi_motherboard_resource {
> +	acpi_handle handle;
> +	struct list_head node;
> +};
> +
> +static void acpi_record_motherboard_resource(acpi_handle handle)
> +{
> +	struct acpi_motherboard_resource *res;
> +
> +	res = kzalloc(sizeof(struct acpi_motherboard_resource), GFP_KERNEL);
> +	if (!res)
> +		return;
> +	res->handle = handle;
> +	list_add(&res->node, &acpi_motherboard_resource_list);
> +}
> +
> +static void reserve_range(struct acpi_device *device, struct resource *r, int port)
> +{
> +	char *regionid;
> +	resource_size_t start = r->start, end = r->end;
> +	struct resource *res;
> +	int result;
> +
> +	regionid = kmalloc(20, GFP_KERNEL);
> +	if (!regionid)
> +		return;
> +
> +	snprintf(regionid, 20, "ACPI %s", dev_name(&device->dev));
> +		
> +	if (port)
> +		res = request_region(start, end - start + 1, regionid);
> +	else
> +		res = request_mem_region(start, end - start + 1, regionid);
> +	if (res)
> +		res->flags &= ~IORESOURCE_BUSY;
> +	else
> +		kfree(regionid);
> +
> +	dev_info(&device->dev, "%pR %s reserved\n", r,
> +			res ? "has been" : "could not be");
> +}
> +

The routine below should go into the PCI core.

> +static int is_pci_reserved(struct resource *res)
> +{
> +	struct pci_dev *pdev = NULL;
> +	resource_size_t acpi_start, acpi_end, pci_start, pci_end;
> +	int i;
> +
> +	/*
> +	 * Some BIOSes have motherboard devices with resources that
> +	 * partially overlap PCI BARs.
> +	 * Those resources should not be reserved, or else, it will
> +	 * prevent the normal PCI driver from requesting them later.
> +	 */
> +	for_each_pci_dev(pdev) {
> +		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +			unsigned long type;
> +
> +			type = pci_resource_flags(pdev, i) & res->flags
> +			       & (IORESOURCE_IO | IORESOURCE_MEM);
> +			if (!type || pci_resource_len(pdev, i) == 0)
> +				continue;
> +
> +			pci_start = pci_resource_start(pdev, i);
> +			pci_end = pci_resource_end(pdev, i);
> +
> +			if (res->start == 0 && res->end == 0)
> +				continue;
> +
> +			acpi_start = res->start;
> +			acpi_end = res->end;
> +
> +			/*
> +			 * If the ACPI region doesn't overlap the PCI
> +			 * region at all, there's no problem.
> +			 */
> +			if (acpi_end < pci_start || acpi_start > pci_end)
> +				continue;
> +
> +			/*
> +			 * If the PNP region completely encloses (or is
> +			 * at least as large as) the PCI region, that's
> +			 * also OK.  For example, this happens when the
> +			 * PNP device describes a bridge with PCI
> +			 * behind it.
> +			 */
> +			if (acpi_start <= pci_start && acpi_end >= pci_end)
> +				continue;
> +
> +			/*
> +			 * Otherwise, the ACPI region overlaps *part* of
> +			 * the PCI region, and that might prevent a PCI
> +			 * driver from requesting its resources.
> +			 */
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +

The routine below should go into resource.c.

> +static acpi_status __init __acpi_reserve_motherboard_resource(struct acpi_resource *res,
> +							void *data)
> +{
> +	struct resource r = {0};
> +	acpi_handle handle = data;
> +	struct acpi_device *device;
> +	int result;
> +
> +	result = acpi_bus_get_device(handle, &device);
> +	if (result)
> +		return AE_OK;
> +
> +	if (!device->status.present)
> +		return AE_OK;
> +
> +	switch (res->type) {
> +	case ACPI_RESOURCE_TYPE_MEMORY24:
> +	case ACPI_RESOURCE_TYPE_MEMORY32:
> +	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +		if (!acpi_dev_resource_memory(res, &r))
> +			return AE_OK;
> +		break;
> +	case ACPI_RESOURCE_TYPE_IO:
> +	case ACPI_RESOURCE_TYPE_FIXED_IO:
> +		if (!acpi_dev_resource_io(res, &r))
> +			return AE_OK;
> +		break;
> +	case ACPI_RESOURCE_TYPE_ADDRESS16:
> +	case ACPI_RESOURCE_TYPE_ADDRESS32:
> +	case ACPI_RESOURCE_TYPE_ADDRESS64:
> +		if (!acpi_dev_resource_address_space(res, &r))
> +			return AE_OK;
> +		break;
> +	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
> +		if (!acpi_dev_resource_ext_address_space(res, &r))
> +			return AE_OK;
> +		break;
> +	default:
> +		return AE_OK;
> +	}
> +
> +	if (r.flags & IORESOURCE_DISABLED)
> +		return AE_OK;
> +
> +	if (is_pci_reserved(&r))
> +		return AE_OK;
> +
> +	if (r.flags & IORESOURCE_IO) {
> +		if (r.start < 0x100)
> +		/*
> +		 * Below 0x100 is only standard PC hardware
> +		 * (pics, kbd, timer, dma, ...)
> +		 * We should not get resource conflicts there,
> +		 * and the kernel reserves these anyway
> +		 * (see arch/i386/kernel/setup.c).
> +		 * So, do nothing
> +		 */
> +			return AE_OK;
> +		if (r.end < r.start)
> +			return AE_OK;       /* invalid */
> +                reserve_range(device, &r, 1);
> +        } else if (r.flags & IORESOURCE_MEM) {
> +                reserve_range(device, &r, 0);
> +        }
> +
> +	return AE_OK;
> +}
> +
> +static int __init acpi_reserve_motherboard_resource(void)
> +{
> +	struct acpi_motherboard_resource *res;
> +
> +	list_for_each_entry(res, &acpi_motherboard_resource_list, node)
> +		acpi_walk_resources(res->handle, METHOD_NAME__CRS,
> +			__acpi_reserve_motherboard_resource, res->handle);
> +
> +	return 0;
> +}
> +fs_initcall(acpi_reserve_motherboard_resource);

Why don't we call that directly from acpi_scan_init() and do we need the
acpi_motherboard_resource_list list to be present any more after calling
this function?

> +
>  static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
>  				int device_type)
>  {
>  	acpi_status status;
>  	struct acpi_device_info *info;
>  	struct acpi_pnp_device_id_list *cid_list;
> +	int is_mb_resource = 0;
>  	int i;
>  
>  	switch (device_type) {
> @@ -1804,13 +1994,20 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
>  		}
>  
>  		if (info->valid & ACPI_VALID_HID) {
> -			acpi_add_id(pnp, info->hardware_id.string);
> -			pnp->type.platform_id = 1;
> +			if (!acpi_is_motherboard_resource(info->hardware_id.string)) {

I would reverse the check.  That is, do

			if (!acpi_is_motherboard_resource(info->hardware_id.string)) {
				is_mb_resource = 1;
			} else { ...

Also, don't we really want to create platform devices for the ACPI device objects
in question?

> +				acpi_add_id(pnp, info->hardware_id.string);
> +				pnp->type.platform_id = 1;
> +			} else
> +				is_mb_resource = 1;
>  		}
>  		if (info->valid & ACPI_VALID_CID) {
>  			cid_list = &info->compatible_id_list;
> -			for (i = 0; i < cid_list->count; i++)
> -				acpi_add_id(pnp, cid_list->ids[i].string);
> +			for (i = 0; i < cid_list->count; i++) {
> +				if (!acpi_is_motherboard_resource(cid_list->ids[i].string))
> +					acpi_add_id(pnp, cid_list->ids[i].string);
> +				else
> +					is_mb_resource = 1;
> +			}
>  		}
>  		if (info->valid & ACPI_VALID_ADR) {
>  			pnp->bus_address = info->address;
> @@ -1822,6 +2019,9 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
>  
>  		kfree(info);
>  
> +		if (is_mb_resource)
> +			acpi_record_motherboard_resource(handle);
> +
>  		/*
>  		 * Some devices don't reliably have _HIDs & _CIDs, so add
>  		 * synthetic HIDs to make sure drivers can find them.
> 

Overall, it looks reasonable, but it can't be a replacement for the $subject
patch.

I also should mention that I don't want the special case for PNP devices to
stay there forever, but in my opinion we do need it at the moment for a couple
of reasons.

Rafael

