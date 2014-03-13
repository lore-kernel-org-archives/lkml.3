Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaCMQSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:18:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:65316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbaCMQSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:18:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="471738736"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 06/13] ACPI: introduce enumerable_id flag
Date: Fri, 14 Mar 2014 00:16:46 +0800
Message-Id: <1394727413-3587-7-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only certain kind of ACPI device objects can be enumerated via ACPI.
These ACPI device objects include
1. ACPI device objects that have _HID control method.
2. some ACPI device objects that have Linux specified HID strings.

In order to distinguish those device objects from the others, a new flag
enumerable_id and a new function acpi_add_eid() are introduced in this patch.

Currently, only devices with _HID method have this flag set.
And in the future, if a device that has Linux specified HID strings
wants to be enumerated to platform bus, acpi_add_eid() should be used
instead of acpi_add_id() when adding its Linux specified HID string.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c     |    8 +++++++-
 include/acpi/acpi_bus.h |    3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 399257e..768f81d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1679,6 +1679,12 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
 	pnp->type.hardware_id = 1;
 }
 
+static void acpi_add_eid(struct acpi_device_pnp *pnp, const char *dev_id)
+{
+	acpi_add_id(pnp, dev_id);
+	pnp->type.enumerable_id = 1;
+}
+
 /*
  * Old IBM workstations have a DSDT bug wherein the SMBus object
  * lacks the SMBUS01 HID and the methods do not have the necessary "_"
@@ -1729,7 +1735,7 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 		}
 
 		if (info->valid & ACPI_VALID_HID)
-			acpi_add_id(pnp, info->hardware_id.string);
+			acpi_add_eid(pnp, info->hardware_id.string);
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
 			for (i = 0; i < cid_list->count; i++)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 8c5e235..688ca44 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -217,7 +217,8 @@ struct acpi_hardware_id {
 struct acpi_pnp_type {
 	u32 hardware_id:1;
 	u32 bus_address:1;
-	u32 reserved:30;
+	u32 enumerable_id:1;
+	u32 reserved:29;
 };
 
 struct acpi_device_pnp {
-- 
1.7.9.5

