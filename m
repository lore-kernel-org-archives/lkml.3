Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaE3CQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:16:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54379 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754467AbaE3COb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:31 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 7/10] ACPI / scan: always register container scan handler
Date: Fri, 30 May 2014 04:28:20 +0200
Message-ID: <1675270.ytJvVT7ZzR@vostro.rjw.lan>
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

Prevent platform devices from being created for ACPI containers
if CONFIG_ACPI_CONTAINER is unset by compiling out the container
scan handler's callbacks only in that case and still compiling
its device ID list in and registering the scan handler in either
case.

This change is based on a prototype from Zhang Rui.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
drivers/acpi/Makefile    |  2 +-
 drivers/acpi/Makefile    |    2 +-
 drivers/acpi/container.c |   15 +++++++++++++++
 drivers/acpi/internal.h  |    4 ----
 3 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -64,7 +64,7 @@ obj-$(CONFIG_ACPI_FAN)		+= fan.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
-obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
+obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
 obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -41,6 +41,8 @@ static const struct acpi_device_id conta
 	{"", 0},
 };
 
+#ifdef CONFIG_ACPI_CONTAINER
+
 static int acpi_container_offline(struct container_dev *cdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&cdev->dev);
@@ -109,5 +111,18 @@ static struct acpi_scan_handler containe
 
 void __init acpi_container_init(void)
 {
+	acpi_scan_add_handler(&container_handler);
+}
+
+#else
+
+static struct acpi_scan_handler container_handler = {
+	.ids = container_device_ids,
+};
+
+void __init acpi_container_init(void)
+{
 	acpi_scan_add_handler_with_hotplug(&container_handler, "container");
 }
+
+#endif /* CONFIG_ACPI_CONTAINER */
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -32,11 +32,7 @@ void acpi_processor_init(void);
 void acpi_platform_init(void);
 void acpi_pnp_init(void);
 int acpi_sysfs_init(void);
-#ifdef CONFIG_ACPI_CONTAINER
 void acpi_container_init(void);
-#else
-static inline void acpi_container_init(void) {}
-#endif
 #ifdef CONFIG_ACPI_DOCK
 void register_dock_dependent_device(struct acpi_device *adev,
 				    acpi_handle dshandle);

