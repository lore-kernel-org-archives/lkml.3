Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaEOGom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:44:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:46740 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbaEOGoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:44:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238297"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 06/11] ACPI: introduce dummy memory hotplug scan handler
Date: Thu, 15 May 2014 14:44:11 +0800
Message-Id: <1400136256-2218-7-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ACPI device enumeration mechanism, which will be introduced
in a later patch, will enumerate the _HID devices w/o any scan
handler attached to platform bus.
This means that, for the devices that are attached to a configurable
scan handler, we should make sure no platform devices would be
created for them even if the scan handler is compiled out.

Fix this problem for memory hotplug devuces by introducing a dummy
memory hotplug scan handler in this patch.

Plus, the dummy memory hotplug scan handler is also needed when
kernel parameter "acpi_no_memhotplug" is used.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile          |  2 +-
 drivers/acpi/acpi_memhotplug.c | 45 ++++++++++++++++++++++++++++++------------
 drivers/acpi/internal.h        |  6 +-----
 3 files changed, 34 insertions(+), 19 deletions(-)

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
index b67be85..ed2f6a7 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -44,6 +44,13 @@
 
 ACPI_MODULE_NAME("acpi_memhotplug");
 
+static const struct acpi_device_id memory_device_ids[] = {
+	{ACPI_MEMORY_DEVICE_HID, 0},
+	{"", 0},
+};
+
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+
 /* Memory Device States */
 #define MEMORY_INVALID_STATE	0
 #define MEMORY_POWER_ON_STATE	1
@@ -53,11 +60,6 @@ static int acpi_memory_device_add(struct acpi_device *device,
 				  const struct acpi_device_id *not_used);
 static void acpi_memory_device_remove(struct acpi_device *device);
 
-static const struct acpi_device_id memory_device_ids[] = {
-	{ACPI_MEMORY_DEVICE_HID, 0},
-	{"", 0},
-};
-
 static struct acpi_scan_handler memory_device_handler = {
 	.ids = memory_device_ids,
 	.attach = acpi_memory_device_add,
@@ -362,17 +364,34 @@ static void acpi_memory_device_remove(struct acpi_device *device)
 
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
+static int acpi_memory_dummy_add(struct acpi_device *device,
+				 const struct acpi_device_id *not_used)
+{
+	return 1;
+}
+
+static struct acpi_scan_handler memory_dummy_handler = {
+	.ids = memory_device_ids,
+	.attach = acpi_memory_dummy_add,
+};
+
+void __init acpi_memory_hotplug_init(void)
+{
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+	if (!acpi_no_memhotplug) {
+		acpi_scan_add_handler_with_hotplug(&memory_device_handler,
+						"memory");
+		return;
+	}
+#endif
+	acpi_scan_add_handler(&memory_dummy_handler);
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

