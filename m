Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaARCsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 21:48:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:45829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaARCr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 21:47:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,677,1384329600"; 
   d="scan'208";a="460784121"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Patch v1 2/3] ACPI, PCI: reuse ACPI hotplug framework to support PCI host bridge hotplug
Date: Sat, 18 Jan 2014 10:48:16 +0800
Message-Id: <1390013297-23462-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com>
References: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse ACPI hotplug framework to support PCI host bridge hotplug, this
makes PCI host bridge hotplug implementation simpler and more clear.

It also fixes a bug in support of PCI host bridge hot-addition.
Currently pci_root driver fails to install notification handler for
PCI host bridge absent at boot time because acpi_is_root_bridge()
returns false if no ACPI device created for handle. So PCI host
bridge hot-addition event will just be ignored by system.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/internal.h |    1 -
 drivers/acpi/pci_root.c |  117 +++++++----------------------------------------
 drivers/acpi/scan.c     |    2 -
 3 files changed, 17 insertions(+), 103 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index a29739c..03efa56 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -28,7 +28,6 @@ int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 void acpi_pci_root_init(void);
 void acpi_pci_link_init(void);
-void acpi_pci_root_hp_init(void);
 void acpi_processor_init(void);
 void acpi_platform_init(void);
 int acpi_sysfs_init(void);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 20360e4..6f6e6c1 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -50,6 +50,7 @@ ACPI_MODULE_NAME("pci_root");
 static int acpi_pci_root_add(struct acpi_device *device,
 			     const struct acpi_device_id *not_used);
 static void acpi_pci_root_remove(struct acpi_device *device);
+static int handle_hotplug_event_root(acpi_handle handle, u32 type, void *ctx);
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_PCI_EXT_CONFIG_SUPPORT \
 				| OSC_PCI_ASPM_SUPPORT \
@@ -61,12 +62,14 @@ static const struct acpi_device_id root_device_ids[] = {
 	{"", 0},
 };
 
+
 static struct acpi_scan_handler pci_root_handler = {
 	.ids = root_device_ids,
+	.prepare = handle_hotplug_event_root,
 	.attach = acpi_pci_root_add,
 	.detach = acpi_pci_root_remove,
 	.hotplug = {
-		.ignore = true,
+		.enabled = true,
 	},
 };
 
@@ -627,113 +630,27 @@ void __init acpi_pci_root_init(void)
 
 	if (!acpi_pci_disabled) {
 		pci_acpi_crs_quirks();
-		acpi_scan_add_handler(&pci_root_handler);
-	}
-}
-/* Support root bridge hotplug */
-
-static void handle_root_bridge_insertion(acpi_handle handle)
-{
-	struct acpi_device *device;
-
-	if (!acpi_bus_get_device(handle, &device)) {
-		dev_printk(KERN_DEBUG, &device->dev,
-			   "acpi device already exists; ignoring notify\n");
-		return;
+		acpi_scan_add_handler_with_hotplug(&pci_root_handler,
+						   "pci_hostbridge");
 	}
-
-	if (acpi_bus_scan(handle))
-		acpi_handle_err(handle, "cannot add bridge to acpi list\n");
 }
 
-static void hotplug_event_root(void *data, u32 type)
+static int handle_hotplug_event_root(acpi_handle handle, u32 type, void *ctx)
 {
-	acpi_handle handle = data;
+	int ret = NOTIFY_OK;
 	struct acpi_pci_root *root;
 
-	acpi_scan_lock_acquire();
-
-	root = acpi_pci_find_root(handle);
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		/* bus enumerate */
-		acpi_handle_printk(KERN_DEBUG, handle,
-				   "Bus check notify on %s\n", __func__);
-		if (root)
+	if (type == ACPI_NOTIFY_BUS_CHECK) {
+		acpi_scan_lock_acquire();
+		root = acpi_pci_find_root(handle);
+		if (root) {
+			acpi_handle_printk(KERN_DEBUG, handle,
+				"Bus check notify on %s\n", __func__);
 			acpiphp_check_host_bridge(handle);
-		else
-			handle_root_bridge_insertion(handle);
-
-		break;
-
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		/* device check */
-		acpi_handle_printk(KERN_DEBUG, handle,
-				   "Device check notify on %s\n", __func__);
-		if (!root)
-			handle_root_bridge_insertion(handle);
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		/* request device eject */
-		acpi_handle_printk(KERN_DEBUG, handle,
-				   "Device eject notify on %s\n", __func__);
-		if (!root)
-			break;
-
-		get_device(&root->device->dev);
-
+			ret = NOTIFY_STOP;
+		}
 		acpi_scan_lock_release();
-
-		acpi_bus_device_eject(root->device, ACPI_NOTIFY_EJECT_REQUEST);
-		return;
-	default:
-		acpi_handle_warn(handle,
-				 "notify_handler: unknown event type 0x%x\n",
-				 type);
-		break;
 	}
 
-	acpi_scan_lock_release();
-}
-
-static void handle_hotplug_event_root(acpi_handle handle, u32 type,
-					void *context)
-{
-	acpi_hotplug_execute(hotplug_event_root, handle, type);
-}
-
-static acpi_status __init
-find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	acpi_status status;
-	int *count = (int *)context;
-
-	if (!acpi_is_root_bridge(handle))
-		return AE_OK;
-
-	(*count)++;
-
-	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					handle_hotplug_event_root, NULL);
-	if (ACPI_FAILURE(status))
-		acpi_handle_printk(KERN_DEBUG, handle,
-			"notify handler is not installed, exit status: %u\n",
-			 (unsigned int)status);
-	else
-		acpi_handle_printk(KERN_DEBUG, handle,
-				   "notify handler is installed\n");
-
-	return AE_OK;
-}
-
-void __init acpi_pci_root_hp_init(void)
-{
-	int num = 0;
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-		ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
-
-	printk(KERN_DEBUG "Found %d acpi root devices\n", num);
+	return ret;
 }
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6b0f419..d83e0ff 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2057,8 +2057,6 @@ int __init acpi_scan_init(void)
 
 	acpi_update_all_gpes();
 
-	acpi_pci_root_hp_init();
-
  out:
 	mutex_unlock(&acpi_scan_lock);
 	return result;
-- 
1.7.10.4

