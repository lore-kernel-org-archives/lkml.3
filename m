Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaCQHwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:52:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:4804 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbaCQHuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:50:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,668,1389772800"; 
   d="scan'208";a="473949679"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V4 05/11] ACPI: check and enumerate CMOS RTC devices explicitly
Date: Mon, 17 Mar 2014 15:49:34 +0800
Message-Id: <1395042580-3344-6-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395042580-3344-1-git-send-email-rui.zhang@intel.com>
References: <1395042580-3344-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For CMOS RTC devices, the acpi pnp scan handler does not work because
there is already a cmos rtc scan handler installed, thus we need to
check those devices and enumerate them to PNP bus explicitly.
Plus, the cmos rtc scan handler needs to return 1 so that it will not
be enumerated to platform bus.

Note: the CMOS RTC device id is not removed from ACPI pnp scan handler
      id list, thus, if cmos rtc scan handler is compiled out, the ACPI
      pnp scan handler will be attached to the CMOS RTC devices instead,
      to prevent these devices from being created to platform bus.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_cmos_rtc.c |    2 +-
 drivers/acpi/acpi_pnp.c      |   22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_cmos_rtc.c b/drivers/acpi/acpi_cmos_rtc.c
index 84190ed..a19b0b3 100644
--- a/drivers/acpi/acpi_cmos_rtc.c
+++ b/drivers/acpi/acpi_cmos_rtc.c
@@ -70,7 +70,7 @@ static int acpi_install_cmos_rtc_space_handler(struct acpi_device *adev,
 		return -ENODEV;
 	}
 
-	return 0;
+	return 1;
 }
 
 static void acpi_remove_cmos_rtc_space_handler(struct acpi_device *adev)
diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 8cf7d9d..387b150 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -349,9 +349,29 @@ static struct acpi_scan_handler acpi_pnp_handler = {
 	.attach = acpi_pnp_scan_handler_attach,
 };
 
+/*
+ * For CMOS RTC devices, the acpi pnp spcan handler does not work because
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
 bool acpi_is_pnp_device(struct acpi_device *device)
 {
-	return device->handler == &acpi_pnp_handler;
+	if (device->handler == &acpi_pnp_handler)
+		return true;
+	if (is_cmos_rtc_device(device))
+		return true;
+	return false;
 }
 EXPORT_SYMBOL_GPL(acpi_is_pnp_device);
 
-- 
1.7.9.5

