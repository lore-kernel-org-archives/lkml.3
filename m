Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947538Ab3BIA10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:27:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35691 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947333Ab3BIA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:27:25 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 26-4/26] PCI, x86, ACPI: get ioapic address from acpi device
Date: Fri,  8 Feb 2013 16:26:46 -0800
Message-Id: <1360369606-8416-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360369606-8416-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQVhmH_TGqEwxGPusKNn-6Q7QkS3UTitEriV3dX8sPbzFA@mail.gmail.com>
 <1360369606-8416-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ioapic controller does not show up on pci config space,
or pci device is there but no bar is used and is set by firmare in
other place.

We need to get ioapic address from ACPI0009's _CRS.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/ioapic.c |   92 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 74 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/pci/ioapic.c
===================================================================
--- linux-2.6.orig/drivers/pci/ioapic.c
+++ linux-2.6/drivers/pci/ioapic.c
@@ -32,6 +32,36 @@ struct acpi_pci_ioapic {
 static LIST_HEAD(ioapic_list);
 static DEFINE_MUTEX(ioapic_list_lock);
 
+static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
+{
+	struct resource *res;
+	struct acpi_resource_address64 addr;
+	acpi_status status;
+	unsigned long flags;
+	u64 start, end;
+
+	status = acpi_resource_to_address64(acpi_res, &addr);
+	if (!ACPI_SUCCESS(status))
+		return AE_OK;
+
+	if (addr.resource_type == ACPI_MEMORY_RANGE) {
+		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
+			return AE_OK;
+		flags = IORESOURCE_MEM;
+	} else
+		return AE_OK;
+
+	start = addr.minimum + addr.translation_offset;
+	end = addr.maximum + addr.translation_offset;
+
+	res = data;
+	res->flags = flags;
+	res->start = start;
+	res->end = end;
+
+	return AE_OK;
+}
+
 static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
 				 u32 *pgsi_base)
 {
@@ -54,33 +84,56 @@ static void handle_ioapic_add(acpi_handl
 		return;
 
 	dev = acpi_get_pci_dev(handle);
-	if (!dev)
-		return;
+	if (!dev || !pci_resource_len(dev, 0)) {
+		struct acpi_device_info *info;
+		char *hid = NULL;
+
+		status = acpi_get_object_info(handle, &info);
+		if (ACPI_FAILURE(status))
+			goto exit_put;
+		if (info->valid & ACPI_VALID_HID)
+			hid = info->hardware_id.string;
+		if (!hid || strcmp(hid, "ACPI0009")) {
+			kfree(info);
+			goto exit_put;
+		}
+		kfree(info);
+		memset(res, 0, sizeof(*res));
+		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
+		if (!res->flags)
+			goto exit_put;
+	}
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
 	gsi_base = gsb;
 	type = "IOxAPIC";
+	if (dev) {
+		ret = pci_enable_device(dev);
+		if (ret < 0)
+			goto exit_put;
+
+		pci_set_master(dev);
+
+		if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
+			type = "IOAPIC";
+
+		if (pci_resource_len(dev, 0)) {
+			if (pci_request_region(dev, 0, type))
+				goto exit_disable;
 
-	ret = pci_enable_device(dev);
-	if (ret < 0)
-		goto exit_put;
-
-	pci_set_master(dev);
-
-	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
-		type = "IOAPIC";
-
-	if (pci_request_region(dev, 0, type))
-		goto exit_disable;
-
-	res = &dev->resource[0];
+			res = &dev->resource[0];
+		}
+	}
 
-	if (acpi_register_ioapic(handle, res->start, gsi_base))
-		goto exit_release;
+	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
+		if (dev)
+			goto exit_release;
+		return;
+	}
 
 	pr_info("%s %s %s at %pR, GSI %u\n",
-		dev_name(&dev->dev), objname, type,
+		dev ? dev_name(&dev->dev) : "", objname, type,
 		res, gsi_base);
 
 	*pdev = dev;
@@ -111,6 +164,9 @@ static void handle_ioapic_remove(acpi_ha
 {
 	acpi_unregister_ioapic(handle, gsi_base);
 
+	if (!dev)
+		return;
+
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
 	/* need to disable it, otherwise remove/rescan will not work */
