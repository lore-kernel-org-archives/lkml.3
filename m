Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaEVSDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:03:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:51899 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaEVSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516171764"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 06/11] ACPI: always register container scan handler even if CONFIG_ACPI_CONTAINER is cleared
Date: Fri, 23 May 2014 02:02:28 +0800
Message-Id: <1400781753-2682-7-git-send-email-rui.zhang@intel.com>
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

Fix this problem for container devices by always registering the
container scan handler, but with meaningful callbacks
only when CONFIG_ACPI_CONTAINER is set.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile    |  2 +-
 drivers/acpi/container.c | 18 ++++++++++++------
 drivers/acpi/internal.h  |  4 ----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 9a43893..5611a07 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_ACPI_FAN)		+= fan.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
-obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
+obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
 obj-$(CONFIG_ACPI_HOTPLUG_MEMORY) += acpi_memhotplug.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 63119d0..b78f52e 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -41,6 +41,8 @@ static const struct acpi_device_id container_device_ids[] = {
 	{"", 0},
 };
 
+#ifdef CONFIG_ACPI_CONTAINER
+
 static int acpi_container_offline(struct container_dev *cdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&cdev->dev);
@@ -97,17 +99,21 @@ static void container_device_detach(struct acpi_device *adev)
 		device_unregister(dev);
 }
 
+#endif /* CONFIG_ACPI_CONTAINER */
+
 static struct acpi_scan_handler container_handler = {
 	.ids = container_device_ids,
-	.attach = container_device_attach,
-	.detach = container_device_detach,
-	.hotplug = {
-		.enabled = true,
-		.demand_offline = true,
-	},
 };
 
 void __init acpi_container_init(void)
 {
+#ifdef CONFIG_ACPI_CONTAINER
+	container_handler.attach = container_device_attach;
+	container_handler.detach = container_device_detach;
+	container_handler.hotplug.enabled = true;
+	container_handler.hotplug.demand_offline = true;
 	acpi_scan_add_handler_with_hotplug(&container_handler, "container");
+#else
+	acpi_scan_add_handler(&container_handler);
+#endif /* CONFIG_ACPI_CONTAINER */
 }
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 3a12866..499908e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
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
-- 
1.8.3.2

