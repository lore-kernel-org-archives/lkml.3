Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3IJDRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:17:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:13916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3IJDRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:17:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,875,1371106800"; 
   d="scan'208";a="399087060"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, bhelgaas@google.com, zubarev@us.ibm.com,
        vernux@us.ibm.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] PCI/ACPI: Convert ACPI PCI Hot Plug IBM Extension dbg/err() to pr_debug/pr_err()
Date: Mon,  9 Sep 2013 23:17:14 -0400
Message-Id: <1378783035-15681-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

This patch is to convert internal debug macros to dynamic debug function
and remove module's debug param.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/pci/hotplug/acpiphp_ibm.c | 56 ++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 2f5786c..32d1db6 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) "acpiphp_ibm: " fmt
+
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -43,23 +45,11 @@
 #define DRIVER_AUTHOR	"Irene Zubarev <zubarev@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>"
 #define DRIVER_DESC	"ACPI Hot Plug PCI Controller Driver IBM extension"
 
-static bool debug;
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
-module_param(debug, bool, 0644);
-MODULE_PARM_DESC(debug, " Debugging mode enabled or not");
-#define MY_NAME "acpiphp_ibm"
-
-#undef dbg
-#define dbg(format, arg...)				\
-do {							\
-	if (debug)					\
-		printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);	\
-} while (0)
 
 #define FOUND_APCI 0x61504349
 /* these are the names for the IBM ACPI pseudo-device */
@@ -189,7 +179,7 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status)
 
 	ibm_slot = ibm_slot_from_id(hpslot_to_sun(slot));
 
-	dbg("%s: set slot %d (%d) attention status to %d\n", __func__,
+	pr_debug("%s: set slot %d (%d) attention status to %d\n", __func__,
 			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
 			(status ? 1 : 0));
 
@@ -202,10 +192,10 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status)
 
 	stat = acpi_evaluate_integer(ibm_acpi_handle, "APLS", &params, &rc);
 	if (ACPI_FAILURE(stat)) {
-		err("APLS evaluation failed:  0x%08x\n", stat);
+		pr_err("APLS evaluation failed:  0x%08x\n", stat);
 		return -ENODEV;
 	} else if (!rc) {
-		err("APLS method failed:  0x%08llx\n", rc);
+		pr_err("APLS method failed:  0x%08llx\n", rc);
 		return -ERANGE;
 	}
 	return 0;
@@ -234,7 +224,7 @@ static int ibm_get_attention_status(struct hotplug_slot *slot, u8 *status)
 	else
 		*status = 0;
 
-	dbg("%s: get slot %d (%d) attention status is %d\n", __func__,
+	pr_debug("%s: get slot %d (%d) attention status is %d\n", __func__,
 			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
 			*status);
 
@@ -266,10 +256,10 @@ static void ibm_handle_events(acpi_handle handle, u32 event, void *context)
 	u8 subevent = event & 0xf0;
 	struct notification *note = context;
 
-	dbg("%s: Received notification %02x\n", __func__, event);
+	pr_debug("%s: Received notification %02x\n", __func__, event);
 
 	if (subevent == 0x80) {
-		dbg("%s: generationg bus event\n", __func__);
+		pr_debug("%s: generationg bus event\n", __func__);
 		acpi_bus_generate_netlink_event(note->device->pnp.device_class,
 						  dev_name(&note->device->dev),
 						  note->event, detail);
@@ -301,7 +291,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 
 	status = acpi_evaluate_object(ibm_acpi_handle, "APCI", NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  APCI evaluation failed\n", __func__);
+		pr_err("%s:  APCI evaluation failed\n", __func__);
 		return -ENODEV;
 	}
 
@@ -309,13 +299,13 @@ static int ibm_get_table_from_acpi(char **bufp)
 	if (!(package) ||
 			(package->type != ACPI_TYPE_PACKAGE) ||
 			!(package->package.elements)) {
-		err("%s:  Invalid APCI object\n", __func__);
+		pr_err("%s:  Invalid APCI object\n", __func__);
 		goto read_table_done;
 	}
 
 	for(size = 0, i = 0; i < package->package.count; i++) {
 		if (package->package.elements[i].type != ACPI_TYPE_BUFFER) {
-			err("%s:  Invalid APCI element %d\n", __func__, i);
+			pr_err("%s:  Invalid APCI element %d\n", __func__, i);
 			goto read_table_done;
 		}
 		size += package->package.elements[i].buffer.length;
@@ -325,7 +315,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 		goto read_table_done;
 
 	lbuf = kzalloc(size, GFP_KERNEL);
-	dbg("%s: element count: %i, ASL table size: %i, &table = 0x%p\n",
+	pr_debug("%s: element count: %i, ASL table size: %i, &table = 0x%p\n",
 			__func__, package->package.count, size, lbuf);
 
 	if (lbuf) {
@@ -371,7 +361,7 @@ static ssize_t ibm_read_apci_table(struct file *filp, struct kobject *kobj,
 	int bytes_read = -EINVAL;
 	char *table = NULL;
 	
-	dbg("%s: pos = %d, size = %zd\n", __func__, (int)pos, size);
+	pr_debug("%s: pos = %d, size = %zd\n", __func__, (int)pos, size);
 
 	if (pos == 0) {
 		bytes_read = ibm_get_table_from_acpi(&table);
@@ -403,7 +393,7 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 
 	status = acpi_get_object_info(handle, &info);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  Failed to get device information status=0x%x\n",
+		pr_err("%s:  Failed to get device information status=0x%x\n",
 			__func__, status);
 		return retval;
 	}
@@ -411,7 +401,7 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 	if (info->current_status && (info->valid & ACPI_VALID_HID) &&
 			(!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
 			 !strcmp(info->hardware_id.string, IBM_HARDWARE_ID2))) {
-		dbg("found hardware: %s, handle: %p\n",
+		pr_debug("found hardware: %s, handle: %p\n",
 			info->hardware_id.string, handle);
 		*phandle = handle;
 		/* returning non-zero causes the search to stop
@@ -432,18 +422,18 @@ static int __init ibm_acpiphp_init(void)
 	struct acpi_device *device;
 	struct kobject *sysdir = &pci_slots_kset->kobj;
 
-	dbg("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			ACPI_UINT32_MAX, ibm_find_acpi_device, NULL,
 			&ibm_acpi_handle, NULL) != FOUND_APCI) {
-		err("%s: acpi_walk_namespace failed\n", __func__);
+		pr_err("%s: acpi_walk_namespace failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
-	dbg("%s: found IBM aPCI device\n", __func__);
+	pr_debug("%s: found IBM aPCI device\n", __func__);
 	if (acpi_bus_get_device(ibm_acpi_handle, &device)) {
-		err("%s: acpi_bus_get_device failed\n", __func__);
+		pr_err("%s: acpi_bus_get_device failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
@@ -457,7 +447,7 @@ static int __init ibm_acpiphp_init(void)
 			ACPI_DEVICE_NOTIFY, ibm_handle_events,
 			&ibm_note);
 	if (ACPI_FAILURE(status)) {
-		err("%s: Failed to register notification handler\n",
+		pr_err("%s: Failed to register notification handler\n",
 				__func__);
 		retval = -EBUSY;
 		goto init_cleanup;
@@ -479,17 +469,17 @@ static void __exit ibm_acpiphp_exit(void)
 	acpi_status status;
 	struct kobject *sysdir = &pci_slots_kset->kobj;
 
-	dbg("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (acpiphp_unregister_attention(&ibm_attention_info))
-		err("%s: attention info deregistration failed", __func__);
+		pr_err("%s: attention info deregistration failed", __func__);
 
 	status = acpi_remove_notify_handler(
 			   ibm_acpi_handle,
 			   ACPI_DEVICE_NOTIFY,
 			   ibm_handle_events);
 	if (ACPI_FAILURE(status))
-		err("%s: Notification handler removal failed\n", __func__);
+		pr_err("%s: Notification handler removal failed\n", __func__);
 	/* remove the /sys entries */
 	sysfs_remove_bin_file(sysdir, &ibm_apci_table_attr);
 }
-- 
1.8.2.1

