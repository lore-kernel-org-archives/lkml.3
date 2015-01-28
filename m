Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbbA1WDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:03:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:50867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743AbbA1UXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269441"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [Patch v2 22/22] x86/irq, ACPI: Implement ACPI driver to support IOAPIC hotplug
Date: Wed, 28 Jan 2015 18:57:40 +0800
Message-Id: <1422442660-455-23-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support of IOAPIC hotplug by:
1) reintroducing ACPI based IOAPIC driver
2) enhance pci_root driver to hook hotplug events

The ACPI IOAPIC driver is always enabled if all of ACPI, PCI and IOAPIC
are enabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1414387308-27148-19-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/Kconfig    |    6 ++
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/internal.h |    7 ++
 drivers/acpi/ioapic.c   |  229 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/pci_root.c |    3 +
 5 files changed, 246 insertions(+)
 create mode 100644 drivers/acpi/ioapic.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8951cefb0a96..e6c3ddd92665 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -315,6 +315,12 @@ config ACPI_HOTPLUG_MEMORY
 	  To compile this driver as a module, choose M here:
 	  the module will be called acpi_memhotplug.
 
+config ACPI_HOTPLUG_IOAPIC
+	bool
+	depends on PCI
+	depends on X86_IO_APIC
+	default y
+
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index f74317cc1ca9..e59494c90402 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
 obj-y				+= acpi_memhotplug.o
+obj-$(CONFIG_ACPI_HOTPLUG_IOAPIC) += ioapic.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 163e82f536fa..caca2805536d 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -35,6 +35,13 @@ void acpi_int340x_thermal_init(void);
 int acpi_sysfs_init(void);
 void acpi_container_init(void);
 void acpi_memory_hotplug_init(void);
+#ifdef	CONFIG_ACPI_HOTPLUG_IOAPIC
+int acpi_ioapic_add(struct acpi_pci_root *root);
+int acpi_ioapic_remove(struct acpi_pci_root *root);
+#else
+static inline int acpi_ioapic_add(struct acpi_pci_root *root) { return 0; }
+static inline int acpi_ioapic_remove(struct acpi_pci_root *root) { return 0; }
+#endif
 #ifdef CONFIG_ACPI_DOCK
 void register_dock_dependent_device(struct acpi_device *adev,
 				    acpi_handle dshandle);
diff --git a/drivers/acpi/ioapic.c b/drivers/acpi/ioapic.c
new file mode 100644
index 000000000000..ccdc8db16bb8
--- /dev/null
+++ b/drivers/acpi/ioapic.c
@@ -0,0 +1,229 @@
+/*
+ * IOAPIC/IOxAPIC/IOSAPIC driver
+ *
+ * Copyright (C) 2009 Fujitsu Limited.
+ * (c) Copyright 2009 Hewlett-Packard Development Company, L.P.
+ *
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on original drivers/pci/ioapic.c
+ *	Yinghai Lu <yinghai@kernel.org>
+ *	Jiang Liu <jiang.liu@intel.com>
+ */
+
+/*
+ * This driver manages I/O APICs added by hotplug after boot.
+ * We try to claim all I/O APIC devices, but those present at boot were
+ * registered when we parsed the ACPI MADT.
+ */
+
+#define pr_fmt(fmt) "ACPI : IOAPIC: " fmt
+
+#include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+#include <acpi/acpi.h>
+
+struct acpi_pci_ioapic {
+	acpi_handle	root_handle;
+	acpi_handle	handle;
+	u32		gsi_base;
+	struct resource	res;
+	struct pci_dev	*pdev;
+	struct list_head list;
+};
+
+static LIST_HEAD(ioapic_list);
+static DEFINE_MUTEX(ioapic_list_lock);
+
+static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
+{
+	struct resource *res = data;
+	struct resource_win win;
+
+	res->flags = 0;
+	if (acpi_dev_filter_resource_type(acpi_res, IORESOURCE_MEM) == 0)
+		return AE_OK;
+
+	if (!acpi_dev_resource_memory(acpi_res, res)) {
+		if (acpi_dev_resource_address_space(acpi_res, &win) ||
+		    acpi_dev_resource_ext_address_space(acpi_res, &win))
+			*res = win.res;
+	}
+	if ((res->flags & IORESOURCE_PREFETCH) ||
+	    (res->flags & IORESOURCE_DISABLED))
+		res->flags = 0;
+
+	return AE_CTRL_TERMINATE;
+}
+
+static bool acpi_is_ioapic(acpi_handle handle, char **type)
+{
+	acpi_status status;
+	struct acpi_device_info *info;
+	char *hid = NULL;
+	bool match = false;
+
+	if (!acpi_has_method(handle, "_GSB"))
+		return false;
+
+	status = acpi_get_object_info(handle, &info);
+	if (ACPI_SUCCESS(status)) {
+		if (info->valid & ACPI_VALID_HID)
+			hid = info->hardware_id.string;
+		if (hid) {
+			if (strcmp(hid, "ACPI0009") == 0) {
+				*type = "IOxAPIC";
+				match = true;
+			} else if (strcmp(hid, "ACPI000A") == 0) {
+				*type = "IOAPIC";
+				match = true;
+			}
+		}
+		kfree(info);
+	}
+
+	return match;
+}
+
+static acpi_status handle_ioapic_add(acpi_handle handle, u32 lvl,
+				     void *context, void **rv)
+{
+	acpi_status status;
+	unsigned long long gsi_base;
+	struct acpi_pci_ioapic *ioapic;
+	struct pci_dev *dev = NULL;
+	struct resource *res = NULL;
+	char *type = NULL;
+
+	if (!acpi_is_ioapic(handle, &type))
+		return AE_OK;
+
+	mutex_lock(&ioapic_list_lock);
+	list_for_each_entry(ioapic, &ioapic_list, list)
+		if (ioapic->handle == handle) {
+			mutex_unlock(&ioapic_list_lock);
+			return AE_OK;
+		}
+
+	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsi_base);
+	if (ACPI_FAILURE(status)) {
+		acpi_handle_warn(handle, "failed to evaluate _GSB method\n");
+		goto exit;
+	}
+
+	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
+	if (!ioapic) {
+		pr_err("cannot allocate memory for new IOAPIC\n");
+		goto exit;
+	} else {
+		ioapic->root_handle = (acpi_handle)context;
+		ioapic->handle = handle;
+		ioapic->gsi_base = (u32)gsi_base;
+		INIT_LIST_HEAD(&ioapic->list);
+	}
+
+	if (acpi_ioapic_registered(handle, (u32)gsi_base))
+		goto done;
+
+	dev = acpi_get_pci_dev(handle);
+	if (dev && pci_resource_len(dev, 0)) {
+		if (pci_enable_device(dev) < 0)
+			goto exit_put;
+		pci_set_master(dev);
+		if (pci_request_region(dev, 0, type))
+			goto exit_disable;
+		res = &dev->resource[0];
+		ioapic->pdev = dev;
+	} else {
+		pci_dev_put(dev);
+		dev = NULL;
+
+		res = &ioapic->res;
+		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
+		if (res->flags == 0) {
+			acpi_handle_warn(handle, "failed to get resource\n");
+			goto exit_free;
+		} else if (request_resource(&iomem_resource, res)) {
+			acpi_handle_warn(handle, "failed to insert resource\n");
+			goto exit_free;
+		}
+	}
+
+	if (acpi_register_ioapic(handle, res->start, (u32)gsi_base)) {
+		acpi_handle_warn(handle, "failed to register IOAPIC\n");
+		goto exit_release;
+	}
+done:
+	list_add(&ioapic->list, &ioapic_list);
+	mutex_unlock(&ioapic_list_lock);
+
+	if (dev)
+		dev_info(&dev->dev, "%s at %pR, GSI %u\n",
+			 type, res, (u32)gsi_base);
+	else
+		acpi_handle_info(handle, "%s at %pR, GSI %u\n",
+				 type, res, (u32)gsi_base);
+
+	return AE_OK;
+
+exit_release:
+	if (dev)
+		pci_release_region(dev, 0);
+	else
+		release_resource(res);
+exit_disable:
+	if (dev)
+		pci_disable_device(dev);
+exit_put:
+	pci_dev_put(dev);
+exit_free:
+	kfree(ioapic);
+exit:
+	mutex_unlock(&ioapic_list_lock);
+	*(acpi_status *)rv = AE_ERROR;
+	return AE_OK;
+}
+
+int acpi_ioapic_add(struct acpi_pci_root *root)
+{
+	acpi_status status, retval = AE_OK;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle,
+				     UINT_MAX, handle_ioapic_add, NULL,
+				     root->device->handle, (void **)&retval);
+
+	return ACPI_SUCCESS(status) && ACPI_SUCCESS(retval) ? 0 : -ENODEV;
+}
+
+int acpi_ioapic_remove(struct acpi_pci_root *root)
+{
+	int retval = 0;
+	struct acpi_pci_ioapic *ioapic, *tmp;
+
+	mutex_lock(&ioapic_list_lock);
+	list_for_each_entry_safe(ioapic, tmp, &ioapic_list, list) {
+		if (root->device->handle != ioapic->root_handle)
+			continue;
+
+		if (acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base))
+			retval = -EBUSY;
+
+		if (ioapic->pdev) {
+			pci_release_region(ioapic->pdev, 0);
+			pci_disable_device(ioapic->pdev);
+			pci_dev_put(ioapic->pdev);
+		} else if (ioapic->res.flags && ioapic->res.parent) {
+			release_resource(&ioapic->res);
+		}
+		list_del(&ioapic->list);
+		kfree(ioapic);
+	}
+	mutex_unlock(&ioapic_list_lock);
+
+	return retval;
+}
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index e53e0f659204..68a5f712cd19 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -621,6 +621,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (hotadd) {
 		pcibios_resource_survey_bus(root->bus);
 		pci_assign_unassigned_root_bus_resources(root->bus);
+		acpi_ioapic_add(root);
 	}
 
 	pci_lock_rescan_remove();
@@ -644,6 +645,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_stop_root_bus(root->bus);
 
+	WARN_ON(acpi_ioapic_remove(root));
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
-- 
1.7.10.4

