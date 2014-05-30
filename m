Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaE3CRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:17:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51609 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754398AbaE3COa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 8/10] ACPI / scan: always register memory hotplug scan handler
Date: Fri, 30 May 2014 04:29:14 +0200
Message-ID: <3467205.0cf3CnYQpp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Prevent platform devices from being created for ACPI memory device
objects if CONFIG_ACPI_HOTPLUG_MEMORY is unset by compiling out the
memory hotplug scan handler's callbacks only in that case and still
compiling its device ID list in and registering the scan handler in
either case.

Also unset the memory hotplug scan handler's .attach() callback
if acpi_no_memhotplug is set, but still register the scan handler to
avoid creating platform devices for ACPI memory devices in that case
too.

This change is based on a prototype from Zhang Rui.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
drivers/acpi/Makefile          |  2 +-
 drivers/acpi/Makefile          |    2 +-
 drivers/acpi/acpi_memhotplug.c |   31 ++++++++++++++++++++++++-------
 drivers/acpi/internal.h        |    6 +-----
 3 files changed, 26 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -66,7 +66,7 @@ obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
+obj-y				+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -33,6 +33,7 @@ void acpi_platform_init(void);
 void acpi_pnp_init(void);
 int acpi_sysfs_init(void);
 void acpi_container_init(void);
+void acpi_memory_hotplug_init(void);
 #ifdef CONFIG_ACPI_DOCK
 void register_dock_dependent_device(struct acpi_device *adev,
 				    acpi_handle dshandle);
@@ -44,11 +45,6 @@ static inline void register_dock_depende
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
Index: linux-pm/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_memhotplug.c
+++ linux-pm/drivers/acpi/acpi_memhotplug.c
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
@@ -53,11 +60,6 @@ static int acpi_memory_device_add(struct
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
@@ -364,9 +366,11 @@ static bool __initdata acpi_no_memhotplu
 
 void __init acpi_memory_hotplug_init(void)
 {
-	if (acpi_no_memhotplug)
+	if (acpi_no_memhotplug) {
+		memory_device_handler.attach = NULL;
+		acpi_scan_add_handler(&memory_device_handler);
 		return;
-
+	}
 	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
 }
 
@@ -376,3 +380,16 @@ static int __init disable_acpi_memory_ho
 	return 1;
 }
 __setup("acpi_no_memhotplug", disable_acpi_memory_hotplug);
+
+#else
+
+static struct acpi_scan_handler memory_device_handler = {
+	.ids = memory_device_ids,
+};
+
+void __init acpi_memory_hotplug_init(void)
+{
+	acpi_scan_add_handler(&memory_device_handler);
+}
+
+#endif /* CONFIG_ACPI_HOTPLUG_MEMORY */

