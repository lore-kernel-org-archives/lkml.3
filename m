Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBQFC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:02:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:30601 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaBQFCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:02:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="341479400"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC Patch v1 6/6] ACPI: use device name LNXSYBUS.xx for ACPI \_SB and \_TZ objects
Date: Mon, 17 Feb 2014 13:02:53 +0800
Message-Id: <1392613373-11003-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com>
 <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device name "LNXSYBUS:xx" instead  of "device.xx" for ACPI objects
\_SB and \_TZ.

BTW, the original check of "handle == ACPI_ROOT_OBJECT" in statment
"else if (list_empty(&pnp->ids) && handle == ACPI_ROOT_OBJECT)"
is always false because of the code at the begin of that block.
                if (handle == ACPI_ROOT_OBJECT) {
                        acpi_add_id(pnp, ACPI_SYSTEM_HID);
                        break;
                }


Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/scan.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 57b053f..62ec4ba 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1706,6 +1706,20 @@ static bool acpi_ibm_smbus_match(acpi_handle handle)
 	return false;
 }
 
+static bool acpi_object_is_system_bus(acpi_handle handle)
+{
+	acpi_handle tmp;
+
+	if (ACPI_SUCCESS(acpi_get_handle(NULL, "\\_SB", &tmp)) &&
+	    tmp == handle)
+		return true;
+	if (ACPI_SUCCESS(acpi_get_handle(NULL, "\\_TZ", &tmp)) &&
+	    tmp == handle)
+		return true;
+
+	return false;
+}
+
 static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 				int device_type)
 {
@@ -1757,8 +1771,10 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 			acpi_add_id(pnp, ACPI_DOCK_HID);
 		else if (acpi_ibm_smbus_match(handle))
 			acpi_add_id(pnp, ACPI_SMBUS_IBM_HID);
-		else if (list_empty(&pnp->ids) && handle == ACPI_ROOT_OBJECT) {
-			acpi_add_id(pnp, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
+		else if (list_empty(&pnp->ids) &&
+			 acpi_object_is_system_bus(handle)) {
+			/* \_SB, \_TZ, LNXSYBUS */
+			acpi_add_id(pnp, ACPI_BUS_HID);
 			strcpy(pnp->device_name, ACPI_BUS_DEVICE_NAME);
 			strcpy(pnp->device_class, ACPI_BUS_CLASS);
 		}
-- 
1.7.10.4

