Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3IJDRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:17:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:28801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3IJDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,875,1371106800"; 
   d="scan'208";a="393371111"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, bhelgaas@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] PCI/ACPI: Convert ACPI PCI Hot Plug core debug fuction to dynamic debug function
Date: Mon,  9 Sep 2013 23:17:15 -0400
Message-Id: <1378783035-15681-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378783035-15681-1-git-send-email-tianyu.lan@intel.com>
References: <1378783035-15681-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

This patch is to use pr_debug/info/warn/err to replace acpiphp debug
functions and remove module's debug param.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      | 10 ----------
 drivers/pci/hotplug/acpiphp_core.c | 35 +++++++++++++++++------------------
 drivers/pci/hotplug/acpiphp_glue.c | 23 ++++++++++++-----------
 3 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index f4e0289..26100f5 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -39,16 +39,6 @@
 #include <linux/mutex.h>
 #include <linux/pci_hotplug.h>
 
-#define dbg(format, arg...)					\
-	do {							\
-		if (acpiphp_debug)				\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
-
 struct acpiphp_context;
 struct acpiphp_bridge;
 struct acpiphp_slot;
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index bf2203e..a56ae79 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) "acpiphp: " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -43,12 +45,9 @@
 #include <linux/smp.h>
 #include "acpiphp.h"
 
-#define MY_NAME	"acpiphp"
-
 /* name size which is used for entries in pcihpfs */
 #define SLOT_NAME_SIZE  21              /* {_SUN} */
 
-bool acpiphp_debug;
 bool acpiphp_disabled;
 
 /* local variables */
@@ -61,9 +60,7 @@ static struct acpiphp_attention_info *attention_info;
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
-MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(disable, "disable acpiphp driver");
-module_param_named(debug, acpiphp_debug, bool, 0644);
 module_param_named(disable, acpiphp_disabled, bool, 0444);
 
 /* export the attention callback registration methods */
@@ -139,7 +136,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* enable the specified slot */
 	return acpiphp_enable_slot(slot->acpi_slot);
@@ -156,7 +153,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* disable the specified slot */
 	return acpiphp_disable_and_eject_slot(slot->acpi_slot);
@@ -176,7 +173,8 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
  {
 	int retval = -ENODEV;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
+	pr_debug("%s - physical_slot = %s\n", __func__,
+		hotplug_slot_name(hotplug_slot));
  
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->set_attn(hotplug_slot, status);
@@ -199,7 +197,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_power_status(slot->acpi_slot);
 
@@ -221,7 +219,8 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	int retval = -EINVAL;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
+	pr_debug("%s - physical_slot = %s\n", __func__,
+		hotplug_slot_name(hotplug_slot));
 
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->get_attn(hotplug_slot, value);
@@ -244,7 +243,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_latch_status(slot->acpi_slot);
 
@@ -264,7 +263,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_adapter_status(slot->acpi_slot);
 
@@ -279,7 +278,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot);
 	kfree(slot);
@@ -322,11 +321,11 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot,
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {
-		err("pci_hp_register failed with error %d\n", retval);
+		pr_err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
  	}
 
-	info("Slot [%s] registered\n", slot_name(slot));
+	pr_info("Slot [%s] registered\n", slot_name(slot));
 
 	return 0;
 error_hpslot:
@@ -343,17 +342,17 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	struct slot *slot = acpiphp_slot->slot;
 	int retval = 0;
 
-	info("Slot [%s] unregistered\n", slot_name(slot));
+	pr_info("Slot [%s] unregistered\n", slot_name(slot));
 
 	retval = pci_hp_deregister(slot->hotplug_slot);
 	if (retval)
-		err("pci_hp_deregister failed with error %d\n", retval);
+		pr_err("pci_hp_deregister failed with error %d\n", retval);
 }
 
 
 void __init acpiphp_init(void)
 {
-	info(DRIVER_DESC " version: " DRIVER_VERSION "%s\n",
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "%s\n",
 		acpiphp_disabled ? ", disabled by user; please report a bug"
 				 : "");
 }
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 0b7d23b..6557702 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -39,6 +39,8 @@
  *    bus. It loses the refcount when the the driver unloads.
  */
 
+#define pr_fmt(fmt) "acpiphp_glue: " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -58,8 +60,6 @@ static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 static DEFINE_MUTEX(acpiphp_context_lock);
 
-#define MY_NAME "acpiphp_glue"
-
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
@@ -335,7 +335,7 @@ static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
 		if (ACPI_FAILURE(status))
 			sun = bridge->nr_slots;
 
-		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
+		pr_debug("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
 		    sun, pci_domain_nr(pbus), pbus->number, device);
 
 		retval = acpiphp_register_hotplug_slot(slot, sun);
@@ -343,10 +343,10 @@ static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
 			slot->slot = NULL;
 			bridge->nr_slots--;
 			if (retval == -EBUSY)
-				warn("Slot %llu already registered by another "
+				pr_warn("Slot %llu already registered by another "
 					"hotplug driver\n", sun);
 			else
-				warn("acpiphp_register_hotplug_slot failed "
+				pr_warn("acpiphp_register_hotplug_slot failed "
 					"(err code = 0x%x)\n", retval);
 		}
 		/* Even if the slot registration fails, we can still use it. */
@@ -369,7 +369,7 @@ static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
 		if (register_hotplug_dock_device(handle,
 			&acpiphp_dock_ops, context,
 			acpiphp_dock_init, acpiphp_dock_release))
-			dbg("failed to register dock device\n");
+			pr_debug("failed to register dock device\n");
 	}
 
 	/* install notify handler */
@@ -427,7 +427,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 							ACPI_SYSTEM_NOTIFY,
 							handle_hotplug_event);
 				if (ACPI_FAILURE(status))
-					err("failed to remove notify handler\n");
+					pr_err("failed to remove notify handler\n");
 			}
 		}
 		if (slot->slot)
@@ -830,8 +830,9 @@ static void hotplug_event(acpi_handle handle, u32 type, void *data)
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
-		dbg("%s: Bus check notify on %s\n", __func__, objname);
-		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
+		pr_debug("%s: Bus check notify on %s\n", __func__, objname);
+		pr_debug("%s: re-enumerating slots under %s\n",
+			 __func__, objname);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
 		} else {
@@ -845,7 +846,7 @@ static void hotplug_event(acpi_handle handle, u32 type, void *data)
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check */
-		dbg("%s: Device check notify on %s\n", __func__, objname);
+		pr_debug("%s: Device check notify on %s\n", __func__, objname);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
 		} else {
@@ -866,7 +867,7 @@ static void hotplug_event(acpi_handle handle, u32 type, void *data)
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
-		dbg("%s: Device eject notify on %s\n", __func__, objname);
+		pr_debug("%s: Device eject notify on %s\n", __func__, objname);
 		acpiphp_disable_and_eject_slot(func->slot);
 		break;
 	}
-- 
1.8.2.1

