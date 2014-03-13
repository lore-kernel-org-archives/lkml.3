Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaCMQSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:18:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:65316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbaCMQSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="471738890"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH V2 11/13] ACPI: create both PNP and Platform device nodes for PNP0C01/PNP0C02
Date: Fri, 14 Mar 2014 00:16:51 +0800
Message-Id: <1394727413-3587-12-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI devices with id "PNP0C01/PNP0C02" means that we need to
protect their resources from being allocated by others.

Currently, this is done in drivers/pnp/system.c.

But the problem is that, there are some devices with extra ids besides
PNP0C01/PNP0C02, and for these devices,
1) PNP0C01/PNP0C02 suggest that resource reservation is still needed.
2) the other ids suggest that we should enumerate them to platform bus

To reserve resources for those devices, we should either use the current code
by exporting the device to PNP bus, or introduce resource reservation support
in platform bus/ACPI.

This patch follows the first way by enumerating an ACPI device to platform bus
AND pnp bus at the same time.
Its PNP device node will be probed by drivers/pnp/system.c and do
everything as we do today.
Its platform device node will also be created so that a platform bus
driver can be probed.

The advantage is that, it brings little change to the current code,
the patch itself looks safe and clear.
The disadvantage is that
1) we create two physical device nodes for the same ACPI node,
   this is against our effort that has been doing recently.
2) we still depend on PNP bus to do this (resouce reservation) for us,
   which is still a problem we need to fix sooner or later.

An alternative proposal is to remove the depedency of PNP bus and
do resource management in ACPI for all PNP0C01/PNP0C02 devices instead,
no matter what bus they are enumerated to.
To do this, we need to
1) introduce a fs_initcall() in ACPI, to reserve all PNP0C01/PNP0C02 resources
in ACPI, something like we did via drivers/acpi/motherboard.c before
(but the code needs to follow drivers/pnp/quirks.c and system.c strictly).
This initcall will be run after PCI claiming BARs and before PCI assigning
resources for uninitialized devices.
2) skip drivers/pnp/quirks.c and drivers/pnp/system.c for ACPI
   enumerted PNP devices, by checking pnp_device->protocal.
3) remove PNP0C01/PNP0C02 from PNPACPI white list.

By doing this, we can remove the depedency of PNP bus, but this requires
a lot of code duplication(need to copy quirks.c and system.c logic into ACPI),
which does not look good neither.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_pnp.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 6fa482a..ad84f4e 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -132,9 +132,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
 	{"FUJ02bf"},
 	{"FUJ02B1"},
 	{"FUJ02E3"},
-	/* system */
-	{"PNP0c02"}, /* General ID for reserving resources */
-	{"PNP0c01"}, /* memory controller */
 	/* rtc_cmos */
 	{"PNP0b00"},
 	{"PNP0b01"},
@@ -365,12 +362,28 @@ static int is_cmos_rtc_device(struct acpi_device *adev)
 	return !acpi_match_device_ids(adev, ids);
 }
 
+/*
+ * For devices with id "PNP0C01"/"PNP0C02", they will be enumerated
+ * to PNP bus anyway to do resource reservation.
+ */
+static int is_system_device(struct acpi_device *adev)
+{
+	struct acpi_device_id ids[] = {
+		{"PNP0C02"},
+		{"PNP0C01"},
+		{""},
+	};
+	return !acpi_match_device_ids(adev, ids);
+}
+
 bool acpi_is_pnp_device(struct acpi_device *device)
 {
 	if (device->handler == &acpi_pnp_handler)
 		return true;
 	if (is_cmos_rtc_device(device))
 		return true;
+	if (is_system_device(device))
+		return true;
 	return false;
 }
 EXPORT_SYMBOL_GPL(acpi_is_pnp_device);
-- 
1.7.9.5

