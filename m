Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459Ab3BHT3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:29:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33366 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760394Ab3BHT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:29:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 26/26] PCI, x86, ACPI: Add ioapic hotplug support with acpi host bridge.
Date: Fri,  8 Feb 2013 11:28:23 -0800
Message-Id: <1360351703-20571-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to have ioapic setup before normal pci drivers.
otherwise other pci driver can not setup irq.

Make ioapic built-in, so can call add/remove during host-bridge add/remove
the same as the booting path.

Also need to make it depends on X86_IO_APIC.

Signed-off-by: <yinghai@kernel.org>
---
 arch/x86/kernel/acpi/boot.c |   10 +-
 drivers/acpi/pci_root.c     |    4 +
 drivers/pci/Kconfig         |    3 +-
 drivers/pci/ioapic.c        |  216 ++++++++++++++++++++++++++++++-------------
 include/linux/pci-acpi.h    |    8 ++
 5 files changed, 172 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 350879f..338163b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -697,16 +697,18 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	unsigned long long id = 0;
+
+	acpi_evaluate_integer(handle, "_UID", NULL, &id);
+
+	return	__mp_register_ioapic(id, phys_addr, gsi_base, true);
 }
 
 EXPORT_SYMBOL(acpi_register_ioapic);
 
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
+	return mp_unregister_ioapic(gsi_base);
 }
 
 EXPORT_SYMBOL(acpi_unregister_ioapic);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 417487a..54d61ce 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -587,6 +587,8 @@ static int acpi_pci_root_add(struct acpi_device *device)
 		pci_assign_unassigned_bus_resources(root->bus);
 	}
 
+	acpi_pci_ioapic_add(root);
+
 	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
@@ -626,6 +628,8 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 			driver->remove(root);
 	mutex_unlock(&acpi_pci_root_lock);
 
+	acpi_pci_ioapic_remove(root);
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 6d51aa6..720989f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -110,10 +110,11 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	tristate "PCI IO-APIC hotplug support" if X86
+	bool "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
 	depends on HOTPLUG
+	depends on X86_IO_APIC
 	default !X86
 
 config PCI_LABEL
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 8dacfd0..12e56c7 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -22,70 +22,128 @@
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
 
-struct ioapic {
-	acpi_handle	handle;
+struct acpi_pci_ioapic {
+	acpi_handle	root_handle;
 	u32		gsi_base;
+	struct pci_dev *pdev;
+	struct list_head list;
 };
 
-static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
+static LIST_HEAD(ioapic_list);
+static DEFINE_MUTEX(ioapic_list_lock);
+
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
+static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
+				 u32 *pgsi_base)
 {
-	acpi_handle handle;
 	acpi_status status;
 	unsigned long long gsb;
-	struct ioapic *ioapic;
+	struct pci_dev *dev;
+	u32 gsi_base;
 	int ret;
 	char *type;
-	struct resource *res;
+	struct resource r;
+	struct resource *res = &r;
+	char objname[64];
+	struct acpi_buffer buffer = {sizeof(objname), objname};
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	if (!handle)
-		return -EINVAL;
+	*pdev = NULL;
+	*pgsi_base = 0;
 
 	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
-	if (ACPI_FAILURE(status))
-		return -EINVAL;
+	if (ACPI_FAILURE(status) || !gsb)
+		return;
+
+	dev = acpi_get_pci_dev(handle);
+	if (!dev) {
+		struct acpi_device_info *info;
+		char *hid = NULL;
+
+		status = acpi_get_object_info(handle, &info);
+		if (ACPI_FAILURE(status))
+			return;
+		if (info->valid & ACPI_VALID_HID)
+			hid = info->hardware_id.string;
+		if (!hid || strcmp(hid, "ACPI0009")) {
+			kfree(info);
+			return;
+		}
+		kfree(info);
+		memset(res, 0, sizeof(*res));
+		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
+		if (!res->flags)
+			return;
+	}
 
-	/*
-	 * The previous code in acpiphp evaluated _MAT if _GSB failed, but
-	 * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
-	 */
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
-	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
-	if (!ioapic)
-		return -ENOMEM;
+	gsi_base = gsb;
+	type = "IOxAPIC";
+	if (dev) {
+		ret = pci_enable_device(dev);
+		if (ret < 0)
+			goto exit_put;
 
-	ioapic->handle = handle;
-	ioapic->gsi_base = (u32) gsb;
+		pci_set_master(dev);
 
-	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
-		type = "IOAPIC";
-	else
-		type = "IOxAPIC";
+		if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
+			type = "IOAPIC";
 
-	ret = pci_enable_device(dev);
-	if (ret < 0)
-		goto exit_free;
+		if (pci_request_region(dev, 0, type))
+			goto exit_disable;
 
-	pci_set_master(dev);
+		res = &dev->resource[0];
+	}
 
-	if (pci_request_region(dev, 0, type))
-		goto exit_disable;
+	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
+		if (dev)
+			goto exit_release;
+		return;
+	}
 
-	res = &dev->resource[0];
-	if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
-		goto exit_release;
+	pr_info("%s %s %s at %pR, GSI %u\n",
+		dev ? dev_name(&dev->dev) : "", objname, type,
+		res, gsi_base);
 
-	pci_set_drvdata(dev, ioapic);
-	dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
-	return 0;
+	*pdev = dev;
+	*pgsi_base = gsi_base;
+	return;
 
 exit_release:
 	pci_release_region(dev, 0);
 exit_disable:
 	pci_disable_device(dev);
-exit_free:
-	kfree(ioapic);
-	return -ENODEV;
+exit_put:
+	pci_dev_put(dev);
 }
 
 static void pci_disable_device_mem(struct pci_dev *dev)
@@ -99,44 +157,74 @@ static void pci_disable_device_mem(struct pci_dev *dev)
 	}
 }
 
-static void ioapic_remove(struct pci_dev *dev)
+static void handle_ioapic_remove(acpi_handle handle, struct pci_dev *dev,
+				  u32 gsi_base)
 {
-	struct ioapic *ioapic = pci_get_drvdata(dev);
+	acpi_unregister_ioapic(handle, gsi_base);
+
+	if (!dev)
+		return;
 
-	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
 	/* need to disable it, otherwise remove/rescan will not work */
 	pci_disable_device_mem(dev);
-	kfree(ioapic);
+	pci_dev_put(dev);
 }
 
+static acpi_status register_ioapic(acpi_handle handle, u32 lvl,
+					void *context, void **rv)
+{
+	acpi_handle root_handle = context;
+	struct pci_dev *pdev;
+	u32 gsi_base;
+	struct acpi_pci_ioapic *ioapic;
 
-static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, ioapic_devices);
+	handle_ioapic_add(handle, &pdev, &gsi_base);
+	if (!gsi_base)
+		return AE_OK;
 
-static struct pci_driver ioapic_driver = {
-	.name		= "ioapic",
-	.id_table	= ioapic_devices,
-	.probe		= ioapic_probe,
-	.remove		= ioapic_remove,
-};
+	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
+	if (!ioapic) {
+		pr_err("%s: cannot allocate memory\n", __func__);
+		handle_ioapic_remove(root_handle, pdev, gsi_base);
+		return AE_OK;
+	}
+	ioapic->root_handle = root_handle;
+	ioapic->pdev = pdev;
+	ioapic->gsi_base = gsi_base;
 
-static int __init ioapic_init(void)
-{
-	return pci_register_driver(&ioapic_driver);
+	mutex_lock(&ioapic_list_lock);
+	list_add(&ioapic->list, &ioapic_list);
+	mutex_unlock(&ioapic_list_lock);
+
+	return AE_OK;
 }
 
-static void __exit ioapic_exit(void)
+void acpi_pci_ioapic_add(struct acpi_pci_root *root)
 {
-	pci_unregister_driver(&ioapic_driver);
-}
+	acpi_status status;
 
-module_init(ioapic_init);
-module_exit(ioapic_exit);
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle,
+				     (u32)1, register_ioapic, NULL,
+				     root->device->handle,
+				     NULL);
+	if (ACPI_FAILURE(status))
+		pr_err("%s: register_ioapic failure - %d", __func__, status);
+}
 
-MODULE_LICENSE("GPL");
+void acpi_pci_ioapic_remove(struct acpi_pci_root *root)
+{
+	struct acpi_pci_ioapic *ioapic, *tmp;
+
+	mutex_lock(&ioapic_list_lock);
+	list_for_each_entry_safe(ioapic, tmp, &ioapic_list, list) {
+		if (root->device->handle != ioapic->root_handle)
+			continue;
+		list_del(&ioapic->list);
+		handle_ioapic_remove(ioapic->root_handle, ioapic->pdev,
+					ioapic->gsi_base);
+		kfree(ioapic);
+	}
+	mutex_unlock(&ioapic_list_lock);
+}
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 9a22b5e..6f83039 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -49,4 +49,12 @@ extern bool aer_acpi_firmware_first(void);
 static inline bool aer_acpi_firmware_first(void) { return false; }
 #endif
 
+#ifdef CONFIG_PCI_IOAPIC
+void acpi_pci_ioapic_add(struct acpi_pci_root *root);
+void acpi_pci_ioapic_remove(struct acpi_pci_root *root);
+#else
+static inline void acpi_pci_ioapic_add(struct acpi_pci_root *root) { }
+static inline void acpi_pci_ioapic_remove(struct acpi_pci_root *root) { }
+#endif
+
 #endif	/* _PCI_ACPI_H_ */
-- 
1.7.10.4

