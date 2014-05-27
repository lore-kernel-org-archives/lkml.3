Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaE0R2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:28:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64445 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaE0R2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:28:04 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 2/6] ACPICA: Hardware: Enable 64-bit firmware waking vector for selected FACS.
Date: Wed, 28 May 2014 01:27:51 +0800
Message-Id: <bfc148ab11693d189ff347d523637cd383a76967.1401210685.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1401210684.git.lv.zheng@intel.com>
References: <38907770.bupFXhytsS@vostro.rjw.lan> <cover.1401210684.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

The root cause of the reported bug might be one of the followings:
1. BIOS may favor the 64-bit firmware waking vector address when the
   version of the FACS is greater than 0 and Linux currently only supports
   resuming from the real mode, so the 64-bit firmware waking vector has
   never been set and might be invalid to BIOS while the commit enables
   higher version FACS.
2. BIOS may favor the FACS reported via the "FIRMWARE_CTRL" field in the
   FADT while the commit doesn't set the firmware waking vector address of
   the FACS reported by "FIRMWARE_CTRL", it only sets the firware waking
   vector address of the FACS reported by "X_FIRMWARE_CTRL".

This patch excludes the cases that can trigger the bugs caused by the root
cause 1.

ACPI specification says:
A. 32-bit FACS address (FIRMWARE_CTRL field in FADT):
   Physical memory address of the FACS, where OSPM and firmware exchange
   control information.
   If the X_FIRMWARE_CTRL field contains a non zero value then this field
   must be zero.
   A zero value indicates that no FACS is specified by this field.
B. 64-bit FACS address (X_FIRMWARE_CTRL field in FADT):
   64bit physical memory address of the FACS.
   This field is used when the physical address of the FACS is above 4GB.
   If the FIRMWARE_CTRL field contains a non zero value then this field
   must be zero.
   A zero value indicates that no FACS is specified by this field.
Thus the 32bit and 64bit firmware waking vector should indicate completely
different resuming environment - real mode (1MB addressable) and non real
mode (4GB+ addressable) and currently Linux only supports resuming from
real mode.

This patch enables 64-bit firmware waking vector for selected FACS via
acpi_set_firmware_waking_vector() so that it's up to OSPMs to determine which
resuming mode should be used by BIOS and ACPICA changes won't trigger the
bugs caused by the root cause 1. For example, Linux can pass
physical_address64=0 as the parameter of acpi_set_firmware_waking_vector() to
indicate no 64bit waking vector support. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-by: Oswald Buddenhagen <ossi@kde.org>
Cc: Oswald Buddenhagen <ossi@kde.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/hwxfsleep.c |   61 ++++++++++++---------------------------
 include/acpi/acpixf.h           |   11 +++----
 2 files changed, 23 insertions(+), 49 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 103d9a7..2b988d5 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -73,7 +73,6 @@ static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
 /*
  * These functions are removed for the ACPI_REDUCED_HARDWARE case:
  *      acpi_set_firmware_waking_vector
- *      acpi_set_firmware_waking_vector64
  *      acpi_enter_sleep_state_s4bios
  */
 
@@ -83,15 +82,19 @@ static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
  * FUNCTION:    acpi_set_firmware_waking_vector
  *
  * PARAMETERS:  physical_address    - 32-bit physical address of ACPI real mode
- *                                    entry point.
+ *                                    entry point
+ *              physical_address64  - 64-bit physical address of ACPI protected
+ *                                    entry point
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Sets the 32-bit firmware_waking_vector field of the FACS
+ * DESCRIPTION: Sets the firmware_waking_vector fields of the FACS
  *
  ******************************************************************************/
 
-acpi_status acpi_set_firmware_waking_vector(u32 physical_address)
+acpi_status
+acpi_set_firmware_waking_vector(acpi_physical_address physical_address,
+				acpi_physical_address physical_address64)
 {
 	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
 
@@ -106,53 +109,27 @@ acpi_status acpi_set_firmware_waking_vector(u32 physical_address)
 
 	/* Set the 32-bit vector */
 
-	acpi_gbl_FACS->firmware_waking_vector = physical_address;
+	acpi_gbl_FACS->firmware_waking_vector = (u32)physical_address;
 
-	/* Clear the 64-bit vector if it exists */
+	if (acpi_gbl_FACS->length > 32) {
+		if (acpi_gbl_FACS->version >= 1) {
 
-	if ((acpi_gbl_FACS->length > 32) && (acpi_gbl_FACS->version >= 1)) {
-		acpi_gbl_FACS->xfirmware_waking_vector = 0;
-	}
-
-	return_ACPI_STATUS(AE_OK);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector)
-
-#if ACPI_MACHINE_WIDTH == 64
-/*******************************************************************************
- *
- * FUNCTION:    acpi_set_firmware_waking_vector64
- *
- * PARAMETERS:  physical_address    - 64-bit physical address of ACPI protected
- *                                    mode entry point.
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Sets the 64-bit X_firmware_waking_vector field of the FACS, if
- *              it exists in the table. This function is intended for use with
- *              64-bit host operating systems.
- *
- ******************************************************************************/
-acpi_status acpi_set_firmware_waking_vector64(u64 physical_address)
-{
-	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector64);
+			/* Set the 64-bit vector */
 
-	/* Determine if the 64-bit vector actually exists */
+			acpi_gbl_FACS->xfirmware_waking_vector =
+			    physical_address64;
+		} else {
+			/* Clear the 64-bit vector if it exists */
 
-	if ((acpi_gbl_FACS->length <= 32) || (acpi_gbl_FACS->version < 1)) {
-		return_ACPI_STATUS(AE_NOT_EXIST);
+			acpi_gbl_FACS->xfirmware_waking_vector = 0;
+		}
 	}
 
-	/* Clear 32-bit vector, set the 64-bit X_ vector */
-
-	acpi_gbl_FACS->firmware_waking_vector = 0;
-	acpi_gbl_FACS->xfirmware_waking_vector = physical_address;
 	return_ACPI_STATUS(AE_OK);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector64)
-#endif
+ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector)
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enter_sleep_state_s4bios
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index b5f7132..cfa8782 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -777,13 +777,10 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_leave_sleep_state(u8 sleep_state))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				acpi_set_firmware_waking_vector(u32
-								physical_address))
-#if ACPI_MACHINE_WIDTH == 64
-ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				acpi_set_firmware_waking_vector64(u64
-								  physical_address))
-#endif
+				acpi_set_firmware_waking_vector
+				(acpi_physical_address physical_address,
+				 acpi_physical_address physical_address64))
+
 /*
  * ACPI Timer interfaces
  */
-- 
1.7.10

