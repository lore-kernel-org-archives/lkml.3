Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaEVSDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:03:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:43912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaEVSDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:03:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516171800"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 07/11] ACPI: always register memory hotplug scan handler even if CONFIG_ACPI_HOTPLUG_MEMORY is cleared
Date: Fri, 23 May 2014 02:02:29 +0800
Message-Id: <1400781753-2682-8-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ACPI device enumeration mechanism, which will be introduced
in a later patch, will enumerate the _HID devices w/o any scan
handler attached to platform bus.
This means that, for the devices that are attached to a configurable
scan handler, we should make sure no platform devices would be
created for them even if the scan handler is compiled out.

Fix this problem for memory hotplug devices by always register the
memery hotplug scan handler, but with meaningful callbacks
only when CONFIG_ACPI_HOTPLUG_MEMORY is set.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile          |  2 +-
 drivers/acpi/acpi_memhotplug.c | 46 ++++++++++++++++++++++--------------------
 drivers/acpi/internal.h        |  6 +-----
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 5611a07..171efc2 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -65,7 +65,7 @@ obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
+obj-y				+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index b67be85..c54f824 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -44,15 +44,6 @@
 
 ACPI_MODULE_NAME("acpi_memhotplug");
 
-/* Memory Device States */
-#define MEMORY_INVALID_STATE	0
-#define MEMORY_POWER_ON_STATE	1
-#define MEMORY_POWER_OFF_STATE	2
-
-static int acpi_memory_device_add(struct acpi_device *device,
-				  const struct acpi_device_id *not_used);
-static void acpi_memory_device_remove(struct acpi_device *device);
-
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
 	{"", 0},
@@ -60,13 +51,15 @@ static const struct acpi_device_id memory_device_ids[] = {
 
 static struct acpi_scan_handler memory_device_handler = {
 	.ids = memory_device_ids,
-	.attach = acpi_memory_device_add,
-	.detach = acpi_memory_device_remove,
-	.hotplug = {
-		.enabled = true,
-	},
 };
 
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+
+/* Memory Device States */
+#define MEMORY_INVALID_STATE	0
+#define MEMORY_POWER_ON_STATE	1
+#define MEMORY_POWER_OFF_STATE	2
+
 struct acpi_memory_info {
 	struct list_head list;
 	u64 start_addr;		/* Memory Range start physical addr */
@@ -362,17 +355,26 @@ static void acpi_memory_device_remove(struct acpi_device *device)
 
 static bool __initdata acpi_no_memhotplug;
 
-void __init acpi_memory_hotplug_init(void)
-{
-	if (acpi_no_memhotplug)
-		return;
-
-	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
-}
-
 static int __init disable_acpi_memory_hotplug(char *str)
 {
 	acpi_no_memhotplug = true;
 	return 1;
 }
 __setup("acpi_no_memhotplug", disable_acpi_memory_hotplug);
+
+#endif
+
+void __init acpi_memory_hotplug_init(void)
+{
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+	if (!acpi_no_memhotplug) {
+		memory_device_handler.attach = acpi_memory_device_add;
+		memory_device_handler.detach = acpi_memory_device_remove;
+		memory_device_handler.hotplug.enabled = true;
+		acpi_scan_add_handler_with_hotplug(&memory_device_handler,
+						"memory");
+		return;
+	}
+#endif
+	acpi_scan_add_handler(&memory_device_handler);
+}
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 499908e..4a9e999 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -33,6 +33,7 @@ void acpi_platform_init(void);
 void acpi_pnp_init(void);
 int acpi_sysfs_init(void);
 void acpi_container_init(void);
+void acpi_memory_hotplug_init(void);
 #ifdef CONFIG_ACPI_DOCK
 void register_dock_dependent_device(struct acpi_device *adev,
 				    acpi_handle dshandle);
@@ -44,11 +45,6 @@ static inline void register_dock_dependent_device(struct acpi_device *adev,
 static inline int dock_notify(struct acpi_device *adev, u32 event) { return -ENODEV; }
 static inline void acpi_dock_add(struct acpi_device *adev) {}
 #endif
-#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
-void acpi_memory_hotplug_init(void);
-#else
-static inline void acpi_memory_hotplug_init(void) {}
-#endif
 #ifdef CONFIG_X86
 void acpi_cmos_rtc_init(void);
 #else
-- 
1.8.3.2

