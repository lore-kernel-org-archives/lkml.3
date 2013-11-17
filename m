Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3KQQ20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:28:26 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54789 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754371Ab3KQQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:50 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 6/10] ACPI / hotplug: Make ACPI PCI root hotplug use common hotplug code
Date: Sun, 17 Nov 2013 17:35:15 +0100
Message-ID: <1535723.J3Y97ex7F5@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework the common ACPI device hotplug code so that it is suitable
for PCI host bridge hotplug and switch the PCI host bridge scan
handler to using the common hotplug code.

This allows quite a few lines of code that are not necessary any more
to be dropped from the PCI host bridge scan handler and removes
arbitrary differences in behavior between PCI host bridge hotplug
and ACPI-based hotplug of other components, like CPUs and memory.

Also acpi_device_hotplug() can be static now.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 
 drivers/acpi/pci_root.c |  126 ++++--------------------------------------------
 drivers/acpi/scan.c     |   40 +++++++++------
 include/acpi/acpi_bus.h |    1 
 4 files changed, 38 insertions(+), 131 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -101,6 +101,7 @@ struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
 	enum acpi_hotplug_mode mode;
+	int (*scan_dependent)(struct acpi_device *adev);
 };
 
 static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -283,17 +283,6 @@ static int acpi_scan_device_check(struct
 {
 	int error;
 
-	/*
-	 * This function is only called for device objects for which matching
-	 * scan handlers exist.  The only situation in which the scan handler is
-	 * not attached to this device object yet is when the device has just
-	 * appeared (either it wasn't present at all before or it was removed
-	 * and then added again).
-	 */
-	if (adev->handler) {
-		dev_warn(&adev->dev, "Already enumerated\n");
-		return -EBUSY;
-	}
 	error = acpi_bus_scan(adev->handle);
 	if (error) {
 		dev_warn(&adev->dev, "Namespace scan failure\n");
@@ -309,10 +298,11 @@ static int acpi_scan_device_check(struct
 	return 0;
 }
 
-void acpi_device_hotplug(void *data, u32 src)
+static void acpi_device_hotplug(void *data, u32 src)
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_device *adev = data;
+	struct acpi_scan_handler *handler;
 	int error;
 
 	lock_device_hotplug();
@@ -326,12 +316,32 @@ void acpi_device_hotplug(void *data, u32
 	if (adev->handle == INVALID_ACPI_HANDLE)
 		goto out;
 
+	handler = adev->handler;
+
 	switch (src) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		error = acpi_bus_scan(adev->handle);
+		if (handler) {
+			error = handler->hotplug.scan_dependent ?
+					handler->hotplug.scan_dependent(adev) :
+					acpi_bus_scan(adev->handle);
+		} else {
+			error = acpi_scan_device_check(adev);
+		}
 		break;
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		error = acpi_scan_device_check(adev);
+		/*
+		 * This code is only run for device objects for which matching
+		 * scan handlers exist.  The only situation in which the scan
+		 * handler is not attached to this device object yet is when the
+		 * device has just appeared (either it wasn't present at all
+		 * before or it was removed and then added again).
+		 */
+		if (adev->handler) {
+			dev_warn(&adev->dev, "Already enumerated\n");
+			error = -EBUSY;
+		} else {
+			error = acpi_scan_device_check(adev);
+		}
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 	case ACPI_OST_EC_OSPM_EJECT:
@@ -2081,8 +2091,6 @@ int __init acpi_scan_init(void)
 
 	acpi_update_all_gpes();
 
-	acpi_pci_root_hp_init();
-
  out:
 	mutex_unlock(&acpi_scan_lock);
 	return result;
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -51,6 +51,12 @@ static int acpi_pci_root_add(struct acpi
 			     const struct acpi_device_id *not_used);
 static void acpi_pci_root_remove(struct acpi_device *device);
 
+static int acpi_pci_root_scan_dependent(struct acpi_device *adev)
+{
+	acpiphp_check_host_bridge(adev->handle);
+	return 0;
+}
+
 #define ACPI_PCIE_REQ_SUPPORT (OSC_PCI_EXT_CONFIG_SUPPORT \
 				| OSC_PCI_ASPM_SUPPORT \
 				| OSC_PCI_CLOCK_PM_SUPPORT \
@@ -65,6 +71,10 @@ static struct acpi_scan_handler pci_root
 	.ids = root_device_ids,
 	.attach = acpi_pci_root_add,
 	.detach = acpi_pci_root_remove,
+	.hotplug = {
+		.enabled = true,
+		.scan_dependent = acpi_pci_root_scan_dependent,
+	},
 };
 
 static DEFINE_MUTEX(osc_lock);
@@ -621,119 +631,9 @@ static void acpi_pci_root_remove(struct
 void __init acpi_pci_root_init(void)
 {
 	acpi_hest_init();
-
-	if (!acpi_pci_disabled) {
-		pci_acpi_crs_quirks();
-		acpi_scan_add_handler(&pci_root_handler);
-	}
-}
-/* Support root bridge hotplug */
-
-static void handle_root_bridge_insertion(acpi_handle handle)
-{
-	struct acpi_device *device = NULL;
-
-	acpi_bus_get_device(handle, &device);
-	if (acpi_device_enumerated(device)) {
-		dev_printk(KERN_DEBUG, &device->dev,
-			   "acpi device already exists; ignoring notify\n");
-		return;
-	}
-
-	if (acpi_bus_scan(handle))
-		acpi_handle_err(handle, "cannot add bridge to acpi list\n");
-}
-
-static void hotplug_event_root(void *data, u32 type)
-{
-	acpi_handle handle = data;
-	struct acpi_pci_root *root;
-
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
-			acpiphp_check_host_bridge(handle);
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
-		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
-					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-		get_device(&root->device->dev);
-
-		acpi_scan_lock_release();
-
-		acpi_device_hotplug(root->device, ACPI_NOTIFY_EJECT_REQUEST);
+	if (acpi_pci_disabled)
 		return;
-	default:
-		acpi_handle_warn(handle,
-				 "notify_handler: unknown event type 0x%x\n",
-				 type);
-		break;
-	}
-
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
 
-	printk(KERN_DEBUG "Found %d acpi root devices\n", num);
+	pci_acpi_crs_quirks();
+	acpi_scan_add_handler_with_hotplug(&pci_root_handler, "pci_root");
 }
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -28,7 +28,6 @@ int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 void acpi_pci_root_init(void);
 void acpi_pci_link_init(void);
-void acpi_pci_root_hp_init(void);
 void acpi_processor_init(void);
 void acpi_platform_init(void);
 int acpi_sysfs_init(void);
@@ -89,7 +88,6 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
-void acpi_device_hotplug(void *data, u32 ost_src);
 bool acpi_device_is_present(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------

