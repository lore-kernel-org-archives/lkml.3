Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaEVSDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:03:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:43912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbaEVSDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516172157"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 10/11] ACPI: use platform bus as the default bus for _HID enumeration
Date: Fri, 23 May 2014 02:02:32 +0800
Message-Id: <1400781753-2682-11-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the growing demand for enumerating ACPI devices to
platform bus, this patch changes the code to enumerate ACPI
devices to platform bus by default, if the device
1. has _HID.
2. does not have a scan handler attached.
3. is not SPB slave device, which should be enumerated by its parent.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_platform.c | 28 ----------------------------
 drivers/acpi/scan.c          | 43 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index dbfe49e..33376a9 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -22,24 +22,6 @@
 
 ACPI_MODULE_NAME("platform");
 
-/*
- * The following ACPI IDs are known to be suitable for representing as
- * platform devices.
- */
-static const struct acpi_device_id acpi_platform_device_ids[] = {
-
-	{ "PNP0D40" },
-	{ "ACPI0003" },
-	{ "VPC2004" },
-	{ "BCM4752" },
-
-	/* Intel Smart Sound Technology */
-	{ "INT33C8" },
-	{ "80860F28" },
-
-	{ }
-};
-
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
@@ -125,13 +107,3 @@ int acpi_create_platform_device(struct acpi_device *adev,
 	kfree(resources);
 	return 1;
 }
-
-static struct acpi_scan_handler platform_handler = {
-	.ids = acpi_platform_device_ids,
-	.attach = acpi_create_platform_device,
-};
-
-void __init acpi_platform_init(void)
-{
-	acpi_scan_add_handler(&platform_handler);
-}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6d50916..c061284 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2079,6 +2079,45 @@ static int acpi_scan_handler_dummy_attach(struct acpi_device *device,
 	return 1;
 }
 
+static int acpi_check_spb_slave(struct acpi_resource *ares, void *data)
+{
+	int *is_spb_slave = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		*is_spb_slave = 1;
+		/* no need to do more checking */
+		return -1;
+	}
+	return 1;
+}
+
+static void acpi_do_default_enumeration(struct acpi_device *device)
+{
+	struct list_head resource_list;
+	int is_spb_slave = 0;
+
+	/* Do not do enumeration for device object w/o platform_id */
+	if (!device->pnp.type.platform_id)
+		return;
+
+	/* Do not do enumeration for device object with scan handler attached */
+	if (device->handler)
+		return;
+
+	/*
+	 * Do not do enemeration for SPB slaves
+	 * as they will be enuerated by their parents
+	 */
+	INIT_LIST_HEAD(&resource_list);
+	acpi_dev_get_resources(device, &resource_list,
+				acpi_check_spb_slave, &is_spb_slave);
+	acpi_dev_free_resource_list(&resource_list);
+	if (is_spb_slave)
+		return;
+
+	acpi_create_platform_device(device, NULL);
+}
+
 static int acpi_scan_attach_handler(struct acpi_device *device)
 {
 	struct acpi_hardware_id *hwid;
@@ -2103,6 +2142,9 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 				break;
 		}
 	}
+
+	acpi_do_default_enumeration(device);
+
 	return ret;
 }
 
@@ -2262,7 +2304,6 @@ int __init acpi_scan_init(void)
 	acpi_pci_root_init();
 	acpi_pci_link_init();
 	acpi_processor_init();
-	acpi_platform_init();
 	acpi_lpss_init();
 	acpi_cmos_rtc_init();
 	acpi_container_init();
-- 
1.8.3.2

