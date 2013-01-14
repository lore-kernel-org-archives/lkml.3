Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3ANOpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:45:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:46229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab3ANOpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:45:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="scan'208";a="246386997"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 3/3] ACPI: create Lynxpoint clocks if LPSS devices are found during scan
Date: Mon, 14 Jan 2013 16:46:28 +0200
Message-Id: <1358174788-24439-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we don't want to create the Lynxpoint LPSS clock tree on a machines
where no LPSS exists at all we look for the Lynxpoint device ACPI HIDs
during ACPI namespace scan and if a known device is seen we assume that it
is safe to create the LPSS clocks.

Therefore we allow init function to be passed via acpi_platform_device_ids[]
table which is called whenever the corresponding device is found.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/scan.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6a12702..8d9965e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/dmi.h>
 #include <linux/nls.h>
+#include <linux/platform_device.h>
 
 #include <acpi/acpi_drivers.h>
 
@@ -29,6 +30,15 @@ extern struct acpi_device *acpi_root;
 
 static const char *dummy_hid = "device";
 
+static void lpt_lpss_init_once(void)
+{
+	static struct platform_device *pdev;
+
+	/* Lynxpoint LPSS clocks */
+	if (!pdev)
+		pdev = platform_device_register_simple("clk-lpt", -1, NULL, 0);
+}
+
 /*
  * The following ACPI IDs are known to be suitable for representing as
  * platform devices.
@@ -38,14 +48,14 @@ static const struct acpi_device_id acpi_platform_device_ids[] = {
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
+	{ "INT33C0", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C1", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C2", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C3", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C4", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C5", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C6", (kernel_ulong_t)lpt_lpss_init_once },
+	{ "INT33C7", (kernel_ulong_t)lpt_lpss_init_once },
 
 	{ }
 };
@@ -1580,6 +1590,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
 					  void *not_used, void **ret_not_used)
 {
+	const struct acpi_device_id *id;
 	acpi_status status = AE_OK;
 	struct acpi_device *device;
 	unsigned long long sta_not_used;
@@ -1595,7 +1606,14 @@ static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
-	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+	id = __acpi_match_device(device, acpi_platform_device_ids);
+	if (id) {
+		void (*init)(void) = (void (*)(void))id->driver_data;
+
+		/* Run any initialization if required */
+		if (init)
+			init();
+
 		/* This is a known good platform device. */
 		acpi_create_platform_device(device);
 	} else if (device_attach(&device->dev) < 0) {
-- 
1.7.10.4

