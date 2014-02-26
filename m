Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaBZJLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:11:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:52394 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaBZJLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:11:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="488297882"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH 5/8] PNPACPI: check and enumerate CMOS RTC devices explicitly
Date: Wed, 26 Feb 2014 17:11:11 +0800
Message-Id: <1393405874-3266-6-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For CMOS RTC devices, the pnpacpi scan handler does not work because
there is already a cmos rtc scan handler installed, thus we need to
check those devices and enumerate them to PNP bus explicitly.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/pnp/pnpacpi/core.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 36dda39..1ee7eb7 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -176,10 +176,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
 	/* system */
 	{"PNP0c02"}, /* General ID for reserving resources */
 	{"PNP0c01"}, /* memory controller */
-	/* rtc_cmos */
-	{"PNP0b00"},
-	{"PNP0b01"},
-	{"PNP0b02"},
 	/* c6xdigio */
         {"PNP0400"}, /* Standard LPT Printer Port */
         {"PNP0401"}, /* ECP Printer Port */
@@ -669,6 +665,22 @@ void __init acpi_pnp_init(void)
 	acpi_scan_add_handler(&pnpacpi_handler);
 }
 
+/*
+ * For CMOS RTC devices, the pnpacpi scan handler does not work because
+ * there is already a cmos rtc scan handler installed, thus we need to
+ * check those devices and enumerate them to PNP bus explicitly.
+ */
+static int is_cmos_rtc_device(struct acpi_device *adev)
+{
+	struct acpi_device_id ids[] = {
+		{ "PNP0B00" },
+		{ "PNP0B01" },
+		{ "PNP0B02" },
+		{""},
+	};
+	return !acpi_match_device_ids(adev, ids);
+}
+
 static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
 						     u32 lvl, void *context,
 						     void **rv)
@@ -677,7 +689,7 @@ static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
 
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
-	if (device->handler == &pnpacpi_handler)
+	if (device->handler == &pnpacpi_handler || is_cmos_rtc_device(device))
 		pnpacpi_add_device(device);
 	return AE_OK;
 }
-- 
1.7.9.5

