Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaCMQSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:18:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:65376 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaCMQSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="471738926"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH V2 12/13] ACPI: introduce dummy container scan handler
Date: Fri, 14 Mar 2014 00:16:52 +0800
Message-Id: <1394727413-3587-13-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_ACPI_CONTAINER is cleared, platform devices would be
created for ACPI container objects.

Introduce a dummy container scan handler in this patch to prevent
these platform devices from being created.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile    |    2 +-
 drivers/acpi/container.c |   21 +++++++++++++++++++++
 drivers/acpi/internal.h  |    4 ----
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 2173e30..871d70d 100644
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
index 368f9dd..c2ec401 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -43,6 +43,8 @@ static const struct acpi_device_id container_device_ids[] = {
 	{"", 0},
 };
 
+#ifdef CONFIG_ACPI_CONTAINER
+
 static int acpi_container_offline(struct container_dev *cdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&cdev->dev);
@@ -110,3 +112,22 @@ void __init acpi_container_init(void)
 {
 	acpi_scan_add_handler_with_hotplug(&container_handler, "container");
 }
+
+#else
+
+static inline int container_device_attach(struct acpi_device *adev,
+			const struct acpi_device_id *not_used)
+{
+	return 1;
+}
+
+static struct acpi_scan_handler container_handler = {
+	.ids = container_device_ids,
+	.attach = container_device_attach,
+};
+
+void __init acpi_container_init(void)
+{
+	acpi_scan_add_handler(&container_handler);
+}
+#endif /* CONFIG_ACPI_CONTAINER */
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index a0c9368..253758a 100644
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
 void acpi_dock_init(void);
 #else
-- 
1.7.9.5

