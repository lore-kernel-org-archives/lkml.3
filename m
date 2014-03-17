Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaCQHwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:52:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:22608 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbaCQHuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:50:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,668,1389772800"; 
   d="scan'208";a="473949718"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V4 06/11] ACPI: introduce platform_id flag
Date: Mon, 17 Mar 2014 15:49:35 +0800
Message-Id: <1395042580-3344-7-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395042580-3344-1-git-send-email-rui.zhang@intel.com>
References: <1395042580-3344-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only certain kind of ACPI device objects can be enumerated to platform bus.
These ACPI device objects include
1. ACPI device objects that have _HID control method.
2. some ACPI device objects that have Linux specified HID strings.

In order to distinguish those device objects from the others, a new flag
platform_id and a new function acpi_add_platform_id() are introduced
in this patch.

Currently, only devices with _HID method have this flag set.
If you want platform devices to be created for device objects without _HID,
use acpi_add_platform_id() when adding artificial Linux-specific ID strings
to them.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c     |    9 ++++++++-
 include/acpi/acpi_bus.h |    3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 399257e..e41b5e6 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1679,6 +1679,13 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
 	pnp->type.hardware_id = 1;
 }
 
+static void acpi_add_platform_id(struct acpi_device_pnp *pnp,
+				 const char *dev_id)
+{
+	acpi_add_id(pnp, dev_id);
+	pnp->type.platform_id = 1;
+}
+
 /*
  * Old IBM workstations have a DSDT bug wherein the SMBus object
  * lacks the SMBUS01 HID and the methods do not have the necessary "_"
@@ -1729,7 +1736,7 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 		}
 
 		if (info->valid & ACPI_VALID_HID)
-			acpi_add_id(pnp, info->hardware_id.string);
+			acpi_add_platform_id(pnp, info->hardware_id.string);
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
 			for (i = 0; i < cid_list->count; i++)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 8c5e235..f998746 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -217,7 +217,8 @@ struct acpi_hardware_id {
 struct acpi_pnp_type {
 	u32 hardware_id:1;
 	u32 bus_address:1;
-	u32 reserved:30;
+	u32 platform_id:1;
+	u32 reserved:29;
 };
 
 struct acpi_device_pnp {
-- 
1.7.9.5

