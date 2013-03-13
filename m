Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab3CMTkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:40:45 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6794 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232Ab3CMTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:40:44 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Verify device status after eject
Date: Wed, 13 Mar 2013 13:29:26 -0600
Message-Id: <1363202966-28436-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI spec states that the OS evaluates _STA after calling _EJ0
in order to verify if eject was successful.  Added a check to
verify if the enabled bit of the status value is cleared after
_EJ0.

Note, the present bit is not checked since some FW implementations
do not clear the present bit until the hardware is physically
removed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---

This patch is based on linux-pm.git/bleeding-edge.

---
 drivers/acpi/scan.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 4f2265e..31d1242 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -127,6 +127,7 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status;
+	unsigned long long sta;
 
 	/* If there is no handle, the device node has been unregistered. */
 	if (!handle) {
@@ -164,10 +165,25 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 		if (status == AE_NOT_FOUND) {
 			return -ENODEV;
 		} else {
-			acpi_handle_warn(handle, "Eject failed\n");
+			acpi_handle_warn(handle, "Eject failed (0x%x)\n",
+								status);
 			return -EIO;
 		}
 	}
+
+	/*
+	 * Verify if eject was indeed successful.  If not, log an error
+	 * message.  No need to call _OST since _EJ0 call was made OK.
+	 */
+	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+	if (ACPI_FAILURE(status)) {
+		acpi_handle_warn(handle,
+			"Status check after eject failed (0x%x)\n", status);
+	} else if (sta & ACPI_STA_DEVICE_ENABLED) {
+		acpi_handle_warn(handle,
+			"Eject incomplete - status 0x%llx\n", sta);
+	}
+
 	return 0;
 }
 
