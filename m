Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3ARNp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:45:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:47197 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab3ARNpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:45:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,492,1355126400"; 
   d="scan'208";a="273788103"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 3/3] ACPI / platform: create LPSS clocks if Lynxpoint devices are found during scan
Date: Fri, 18 Jan 2013 15:46:01 +0200
Message-Id: <1358516761-20981-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Lynxpoint LPSS peripheral drivers depend on LPSS clock tree being
created in order to function properly. The clock tree is exposed as a
platform driver that binds to a device named 'clk-lpt'.

To support this we modify the acpi_create_platform_device() to take one
additional parameter called flags. This is passed from
acpi_platform_device_ids[] array when acpi_create_platform_device() is
called.

We then introduce a new flag ACPI_PLATFORM_CLK which is used to tell
acpi_create_platform_device() to create the platform clocks as well.

Finally we set the ACPI_PLATFORM_CLK flags for all the Lynxpoint LPSS
devices and make sure that when this flag is set we create the
corresponding clock tree platform device.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/acpi_platform.c |   25 ++++++++++++++++++++++++-
 drivers/acpi/internal.h      |    6 +++++-
 drivers/acpi/scan.c          |   22 ++++++++++++----------
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index db129b9..114fbca 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -13,6 +13,7 @@
 
 #include <linux/acpi.h>
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -21,9 +22,25 @@
 
 ACPI_MODULE_NAME("platform");
 
+static int acpi_create_platform_clks(struct acpi_device *adev)
+{
+	static struct platform_device *pdev;
+
+	/* Create Lynxpoint LPSS clocks */
+	if (!pdev && !strncmp(acpi_device_hid(adev), "INT33C", 6)) {
+		pdev = platform_device_register_simple("clk-lpt", -1, NULL, 0);
+		if (IS_ERR(pdev))
+			return PTR_ERR(pdev);
+	}
+
+	return 0;
+}
+
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
+ * @flags: ACPI_PLATFORM_* flags that affect the creation of the platform
+ *	   devices.
  *
  * Check if the given @adev can be represented as a platform device and, if
  * that's the case, create and register a platform device, populate its common
@@ -31,7 +48,8 @@ ACPI_MODULE_NAME("platform");
  *
  * The platform device's name will be taken from the @adev's _HID and _UID.
  */
-struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
+struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
+						    unsigned long flags)
 {
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
@@ -41,6 +59,11 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
 	struct resource *resources;
 	int count;
 
+	if ((flags & ACPI_PLATFORM_CLK) && acpi_create_platform_clks(adev)) {
+		dev_err(&adev->dev, "failed to create clocks\n");
+		return NULL;
+	}
+
 	/* If the ACPI node already has a physical device attached, skip it. */
 	if (adev->physical_node_count)
 		return NULL;
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 1d6b392..68bc5e3 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -117,6 +117,10 @@ static inline void suspend_nvs_restore(void) {}
   -------------------------------------------------------------------------- */
 struct platform_device;
 
-struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
+/* Flags for acpi_create_platform_device */
+#define ACPI_PLATFORM_CLK	BIT(0)
+
+struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
+						    unsigned long flags);
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7705f8f..1059565 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -38,14 +38,14 @@ static const struct acpi_device_id acpi_platform_device_ids[] = {
 	{ "PNP0D40" },
 
 	/* Haswell LPSS devices */
-	{ "INT33C0", 0 },
-	{ "INT33C1", 0 },
-	{ "INT33C2", 0 },
-	{ "INT33C3", 0 },
-	{ "INT33C4", 0 },
-	{ "INT33C5", 0 },
-	{ "INT33C6", 0 },
-	{ "INT33C7", 0 },
+	{ "INT33C0", ACPI_PLATFORM_CLK },
+	{ "INT33C1", ACPI_PLATFORM_CLK },
+	{ "INT33C2", ACPI_PLATFORM_CLK },
+	{ "INT33C3", ACPI_PLATFORM_CLK },
+	{ "INT33C4", ACPI_PLATFORM_CLK },
+	{ "INT33C5", ACPI_PLATFORM_CLK },
+	{ "INT33C6", ACPI_PLATFORM_CLK },
+	{ "INT33C7", ACPI_PLATFORM_CLK },
 
 	{ }
 };
@@ -1580,6 +1580,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
 					  void *not_used, void **ret_not_used)
 {
+	const struct acpi_device_id *id;
 	acpi_status status = AE_OK;
 	struct acpi_device *device;
 	unsigned long long sta_not_used;
@@ -1595,9 +1596,10 @@ static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
-	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+	id = __acpi_match_device(device, acpi_platform_device_ids);
+	if (id) {
 		/* This is a known good platform device. */
-		acpi_create_platform_device(device);
+		acpi_create_platform_device(device, id->driver_data);
 	} else if (device_attach(&device->dev) < 0) {
 		status = AE_CTRL_DEPTH;
 	}
-- 
1.7.10.4

