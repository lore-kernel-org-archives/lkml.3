Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaEOGpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:45:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:40282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbaEOGpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238425"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 10/11] ACPI: use platform bus as the default bus for _HID enumeration
Date: Thu, 15 May 2014 14:44:15 +0800
Message-Id: <1400136256-2218-11-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the growing demand for enumerating ACPI devices to
platform bus, this patch changes the code to enumerate ACPI
devices to platform bus by default, if the device
1. has _HID.
2. does not have a scan handler attached.
3. will not be enumerated by its parent.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_platform.c | 28 ----------------------------
 drivers/acpi/scan.c          | 25 ++++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 29 deletions(-)

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
index 451e7d9..756977e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2073,6 +2073,27 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 	return AE_OK;
 }
 
+static void acpi_do_default_enumeration(struct acpi_device *device)
+{
+	/*
+	 * Do not do enumeration for device object that has been/will be
+	 * enumerated by its parent.
+	 */
+	if (device->parent && device->parent->flags.is_master_device)
+		return;
+
+	/* Do not do enumeration for device object with scan handler attached */
+	if (device->handler)
+		return;
+
+	/* Do not do enumeration for device object w/o platform_id */
+	if (!device->pnp.type.platform_id)
+		return;
+
+	acpi_create_platform_device(device, NULL);
+}
+
+
 static int acpi_scan_attach_handler(struct acpi_device *device)
 {
 	struct acpi_hardware_id *hwid;
@@ -2094,6 +2115,9 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 				break;
 		}
 	}
+
+	acpi_do_default_enumeration(device);
+
 	return ret;
 }
 
@@ -2253,7 +2277,6 @@ int __init acpi_scan_init(void)
 	acpi_pci_root_init();
 	acpi_pci_link_init();
 	acpi_processor_init();
-	acpi_platform_init();
 	acpi_lpss_init();
 	acpi_cmos_rtc_init();
 	acpi_container_init();
-- 
1.8.3.2

