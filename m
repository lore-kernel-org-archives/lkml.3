Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaHUMJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:09:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:46453 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaHUMI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="579848251"
Message-ID: <1408622934.3315.8.camel@rzhang1-toshiba>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device
 objects
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Thu, 21 Aug 2014 20:08:54 +0800
In-Reply-To: <5487060.QsgluucUH4@vostro.rjw.lan>
References: <5487060.QsgluucUH4@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael,

On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> We generally don't allow ACPI drivers to bind to ACPI device objects
> that companion "physical" device objects are created for to avoid
> situations in which two different drivers may attempt to handle one
> device at the same time.

Yes, and I think we should not break this rule.

>   Recent ACPI device enumeration rework
> extended that approach to ACPI PNP devices by starting to use a scan
> handler for enumerating them.  However, we previously allowed ACPI
> drivers to bind to ACPI device objects with existing PNP device
> companions and changing that led to functional regressions on some
> systems.
> 
Question: except the PNP0C01/PNP0C02 case, if we have an device have two
ids that matches two different drivers, should we allow both drivers
probe successfully?
I think the answer is no.
In the PNP0C01/PNP0C02 case, I think we can fix the issue by the
following patch instead.

Note that I've just tested on my machine and it works well.
I still need the bug reporter to check if the patch fixes bug 81511 or not.

>From c6c388728d08a6368f21dab61d6f0a940e0ea13a Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 21 Aug 2014 13:39:47 +0800
Subject: [RFC PATCH] ACPI: introduce motherboard resource management

ACPI Devices with _HID/_CID PNP0C01/PNP0C02 represents that
they have some motherboard resources that needs to be reserved.

We used to enumerated those devices to PNP bus and rely on
PNP system driver to do resource reservation.
But this mechanism does not work well nowadays as many devices
not only represent motherboard resources, but also represent
physical devices that need native drivers other than PNP system
driver for the device to work. For example,
1) https://bugzilla.kernel.org/show_bug.cgi?id=46741,
    Device (NIPM)
    {
        Name (_HID, EisaId ("IPI0001"))  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0C01"))  // _CID: Compatible ID
   the NIPM device has _CID PNP0C01 but it is an IPMI device.
   PNP system driver blocks the PNP IPMI driver to probe.
2) https://bugzilla.kernel.org/show_bug.cgi?id=81511
        Device (IFFS)
        {
            Name (_HID, EisaId ("INT3392"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
   the IFFS device has _CID PNP0C02, but it is an intel rapid start
   device, which already has an ACPI driver at
   drivers/platform/x86/intel-rst.c
3) a couple of machines, including the on in
   https://bugzilla.kernel.org/show_bug.cgi?id=81511, has the AML code
   like following
        Device (PTID)
        {
            Name (_HID, EisaId ("INT340E"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
   the PTID device has _CID PNP0C02, but it is also represents an
   INT340E device, there is a platform bus driver for this device
   which will be introduced by myself soon.

In any of the above cases, the current code for managing PNP0C01/PNP0C02
resources in Linux kernel is broken, because it either blocks the physical
device driver on the same bus, or results in multiple drivers loaded for
the same ACPI device node, which may also has some potential risks.

Thus, IMO, we need a clean way to handle those motherboard resources.
Given that PNP0C01/PNP0C02 is more like an indicator for reserving the
resources, this patch
1. does the resource reservation in ACPI code directly, with the same logic
   and time point in drivers/pnp/quirks.c and drivers/pnp/system.c.
2. makes PNP0C01/PNP0C02 PNP id transparent to Linux devices and drivers,
   thus PNP system driver becomes a no-op for ACPI enumerated devices.

This is just a draft patch, and I'd like to see if this is
the right direction to go. Any comments are welcome.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_pnp.c |   3 -
 drivers/acpi/scan.c     | 208 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 204 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 1f8b204..a7deae5 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -134,9 +134,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	{"FUJ02bf"},
 	{"FUJ02B1"},
 	{"FUJ02E3"},
-	/* system */
-	{"PNP0c02"},		/* General ID for reserving resources */
-	{"PNP0c01"},		/* memory controller */
 	/* rtc_cmos */
 	{"PNP0b00"},
 	{"PNP0b01"},
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 0a817ad..674518b 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/dmi.h>
 #include <linux/nls.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 
@@ -1781,12 +1782,201 @@ static bool acpi_object_is_system_bus(acpi_handle handle)
 	return false;
 }
 
+static bool acpi_is_motherboard_resource(char *id)
+{
+	return !(strncmp(id, "PNP0C01", sizeof("PNP0C01")) &&
+		 strncmp(id, "PNP0C02", sizeof("PNP0C02")));
+}
+
+static LIST_HEAD(acpi_motherboard_resource_list);
+
+struct acpi_motherboard_resource {
+	acpi_handle handle;
+	struct list_head node;
+};
+
+static void acpi_record_motherboard_resource(acpi_handle handle)
+{
+	struct acpi_motherboard_resource *res;
+
+	res = kzalloc(sizeof(struct acpi_motherboard_resource), GFP_KERNEL);
+	if (!res)
+		return;
+	res->handle = handle;
+	list_add(&res->node, &acpi_motherboard_resource_list);
+}
+
+static void reserve_range(struct acpi_device *device, struct resource *r, int port)
+{
+	char *regionid;
+	resource_size_t start = r->start, end = r->end;
+	struct resource *res;
+	int result;
+
+	regionid = kmalloc(20, GFP_KERNEL);
+	if (!regionid)
+		return;
+
+	snprintf(regionid, 20, "ACPI %s", dev_name(&device->dev));
+		
+	if (port)
+		res = request_region(start, end - start + 1, regionid);
+	else
+		res = request_mem_region(start, end - start + 1, regionid);
+	if (res)
+		res->flags &= ~IORESOURCE_BUSY;
+	else
+		kfree(regionid);
+
+	dev_info(&device->dev, "%pR %s reserved\n", r,
+			res ? "has been" : "could not be");
+}
+
+static int is_pci_reserved(struct resource *res)
+{
+	struct pci_dev *pdev = NULL;
+	resource_size_t acpi_start, acpi_end, pci_start, pci_end;
+	int i;
+
+	/*
+	 * Some BIOSes have motherboard devices with resources that
+	 * partially overlap PCI BARs.
+	 * Those resources should not be reserved, or else, it will
+	 * prevent the normal PCI driver from requesting them later.
+	 */
+	for_each_pci_dev(pdev) {
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			unsigned long type;
+
+			type = pci_resource_flags(pdev, i) & res->flags
+			       & (IORESOURCE_IO | IORESOURCE_MEM);
+			if (!type || pci_resource_len(pdev, i) == 0)
+				continue;
+
+			pci_start = pci_resource_start(pdev, i);
+			pci_end = pci_resource_end(pdev, i);
+
+			if (res->start == 0 && res->end == 0)
+				continue;
+
+			acpi_start = res->start;
+			acpi_end = res->end;
+
+			/*
+			 * If the ACPI region doesn't overlap the PCI
+			 * region at all, there's no problem.
+			 */
+			if (acpi_end < pci_start || acpi_start > pci_end)
+				continue;
+
+			/*
+			 * If the PNP region completely encloses (or is
+			 * at least as large as) the PCI region, that's
+			 * also OK.  For example, this happens when the
+			 * PNP device describes a bridge with PCI
+			 * behind it.
+			 */
+			if (acpi_start <= pci_start && acpi_end >= pci_end)
+				continue;
+
+			/*
+			 * Otherwise, the ACPI region overlaps *part* of
+			 * the PCI region, and that might prevent a PCI
+			 * driver from requesting its resources.
+			 */
+			return true;
+		}
+	}
+	return false;
+}
+
+static acpi_status __init __acpi_reserve_motherboard_resource(struct acpi_resource *res,
+							void *data)
+{
+	struct resource r = {0};
+	acpi_handle handle = data;
+	struct acpi_device *device;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	if (result)
+		return AE_OK;
+
+	if (!device->status.present)
+		return AE_OK;
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		if (!acpi_dev_resource_memory(res, &r))
+			return AE_OK;
+		break;
+	case ACPI_RESOURCE_TYPE_IO:
+	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		if (!acpi_dev_resource_io(res, &r))
+			return AE_OK;
+		break;
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		if (!acpi_dev_resource_address_space(res, &r))
+			return AE_OK;
+		break;
+	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
+		if (!acpi_dev_resource_ext_address_space(res, &r))
+			return AE_OK;
+		break;
+	default:
+		return AE_OK;
+	}
+
+	if (r.flags & IORESOURCE_DISABLED)
+		return AE_OK;
+
+	if (is_pci_reserved(&r))
+		return AE_OK;
+
+	if (r.flags & IORESOURCE_IO) {
+		if (r.start < 0x100)
+		/*
+		 * Below 0x100 is only standard PC hardware
+		 * (pics, kbd, timer, dma, ...)
+		 * We should not get resource conflicts there,
+		 * and the kernel reserves these anyway
+		 * (see arch/i386/kernel/setup.c).
+		 * So, do nothing
+		 */
+			return AE_OK;
+		if (r.end < r.start)
+			return AE_OK;       /* invalid */
+                reserve_range(device, &r, 1);
+        } else if (r.flags & IORESOURCE_MEM) {
+                reserve_range(device, &r, 0);
+        }
+
+	return AE_OK;
+}
+
+static int __init acpi_reserve_motherboard_resource(void)
+{
+	struct acpi_motherboard_resource *res;
+
+	list_for_each_entry(res, &acpi_motherboard_resource_list, node)
+		acpi_walk_resources(res->handle, METHOD_NAME__CRS,
+			__acpi_reserve_motherboard_resource, res->handle);
+
+	return 0;
+}
+fs_initcall(acpi_reserve_motherboard_resource);
+
 static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 				int device_type)
 {
 	acpi_status status;
 	struct acpi_device_info *info;
 	struct acpi_pnp_device_id_list *cid_list;
+	int is_mb_resource = 0;
 	int i;
 
 	switch (device_type) {
@@ -1804,13 +1994,20 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 		}
 
 		if (info->valid & ACPI_VALID_HID) {
-			acpi_add_id(pnp, info->hardware_id.string);
-			pnp->type.platform_id = 1;
+			if (!acpi_is_motherboard_resource(info->hardware_id.string)) {
+				acpi_add_id(pnp, info->hardware_id.string);
+				pnp->type.platform_id = 1;
+			} else
+				is_mb_resource = 1;
 		}
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
-			for (i = 0; i < cid_list->count; i++)
-				acpi_add_id(pnp, cid_list->ids[i].string);
+			for (i = 0; i < cid_list->count; i++) {
+				if (!acpi_is_motherboard_resource(cid_list->ids[i].string))
+					acpi_add_id(pnp, cid_list->ids[i].string);
+				else
+					is_mb_resource = 1;
+			}
 		}
 		if (info->valid & ACPI_VALID_ADR) {
 			pnp->bus_address = info->address;
@@ -1822,6 +2019,9 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 
 		kfree(info);
 
+		if (is_mb_resource)
+			acpi_record_motherboard_resource(handle);
+
 		/*
 		 * Some devices don't reliably have _HIDs & _CIDs, so add
 		 * synthetic HIDs to make sure drivers can find them.
-- 
1.8.3.2



