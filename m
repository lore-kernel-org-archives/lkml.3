Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3HKCuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:50:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34926 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3HKCtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 27/28] PCI, x86, ACPI: Enable ioapic hotplug support with acpi host bridge.
Date: Sat, 10 Aug 2013 19:48:13 -0700
Message-Id: <1376189294-32022-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to have ioapic setup before normal pci drivers.
otherwise other pci driver can not setup irq.

So we should not treat them as normal pci devices.
Also we will need to support ioapic hotplug without pci device around.

We need to call ioapic add/remove during host-bridge add/remove.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c  |   4 ++
 drivers/pci/ioapic.c     | 147 ++++++++++++++++++++++++++++++-----------------
 include/linux/pci-acpi.h |   8 +++
 3 files changed, 106 insertions(+), 53 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5917839..7577175 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -532,6 +532,8 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		pci_enable_bridges(root->bus);
 	}
 
+	acpi_pci_ioapic_add(root);
+
 	pci_bus_add_devices(root->bus);
 	return 1;
 
@@ -546,6 +548,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_stop_root_bus(root->bus);
 
+	acpi_pci_ioapic_remove(root);
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 7d6b157..60351b2 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -22,101 +22,142 @@
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
-
-	/*
-	 * The previous code in acpiphp evaluated _MAT if _GSB failed, but
-	 * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
-	 */
+	if (ACPI_FAILURE(status) || !gsb)
+		return;
 
-	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
-	if (!ioapic)
-		return -ENOMEM;
+	dev = acpi_get_pci_dev(handle);
+	if (!dev)
+		return;
 
-	ioapic->handle = handle;
-	ioapic->gsi_base = (u32) gsb;
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
-	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
-		type = "IOAPIC";
-	else
-		type = "IOxAPIC";
+	gsi_base = gsb;
+	type = "IOxAPIC";
 
 	ret = pci_enable_device(dev);
 	if (ret < 0)
-		goto exit_free;
+		goto exit_put;
 
 	pci_set_master(dev);
 
+	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
+		type = "IOAPIC";
+
 	if (pci_request_region(dev, 0, type))
 		goto exit_disable;
 
 	res = &dev->resource[0];
-	if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
+
+	if (acpi_register_ioapic(handle, res->start, gsi_base))
 		goto exit_release;
 
-	pci_set_drvdata(dev, ioapic);
-	dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
-	return 0;
+	pr_info("%s %s %s at %pR, GSI %u\n",
+		dev_name(&dev->dev), objname, type,
+		res, gsi_base);
+
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
 
-static void ioapic_remove(struct pci_dev *dev)
+static void handle_ioapic_remove(acpi_handle handle, struct pci_dev *dev,
+				  u32 gsi_base)
 {
-	struct ioapic *ioapic = pci_get_drvdata(dev);
+	acpi_unregister_ioapic(handle, gsi_base);
 
-	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
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
+
+	mutex_lock(&ioapic_list_lock);
+	list_add(&ioapic->list, &ioapic_list);
+	mutex_unlock(&ioapic_list_lock);
+
+	return AE_OK;
+}
 
-static int __init ioapic_init(void)
+void acpi_pci_ioapic_add(struct acpi_pci_root *root)
 {
-	return pci_register_driver(&ioapic_driver);
+	acpi_status status;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle,
+				     (u32)1, register_ioapic, NULL,
+				     root->device->handle,
+				     NULL);
+	if (ACPI_FAILURE(status))
+		pr_err("%s: register_ioapic failure - %d", __func__, status);
 }
-module_init(ioapic_init);
 
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
index 1704479..b2a2ced 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -69,6 +69,14 @@ static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
 static inline void acpiphp_check_host_bridge(acpi_handle handle) { }
 #endif
 
+#ifdef CONFIG_PCI_IOAPIC
+void acpi_pci_ioapic_add(struct acpi_pci_root *root);
+void acpi_pci_ioapic_remove(struct acpi_pci_root *root);
+#else
+static inline void acpi_pci_ioapic_add(struct acpi_pci_root *root) { }
+static inline void acpi_pci_ioapic_remove(struct acpi_pci_root *root) { }
+#endif
+
 #else	/* CONFIG_ACPI */
 static inline void acpi_pci_add_bus(struct pci_bus *bus) { }
 static inline void acpi_pci_remove_bus(struct pci_bus *bus) { }
-- 
1.8.1.4

