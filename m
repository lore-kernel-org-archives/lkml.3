Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaE0R3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:29:10 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54410 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaE0R3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:29:04 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 5/6] ACPICA: Hardware: Enable firmware waking vector for both 32-bit and 64-bit FACS.
Date: Wed, 28 May 2014 01:28:50 +0800
Message-Id: <5556407bb3e7c8a3a34a400451fa820eb7635107.1401210685.git.lv.zheng@intel.com>
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
cause 2.

There is no handshaking mechanism can be used by OSPM to tell BIOS which
FACS is currently used. Thus the FACS reported by "FIRMWARE_CTRL" may still
be used by BIOS and the 0 value of the 32-bit firmware waking vector might
trigger such failure.

This patch enables the firmware waking vectors for both 32bit/64bit FACS
tables in order to ensure we can exclude the cases that trigger the bugs
caused by the root cause 2. The exclusion is split into 2 commits so that
if it turns out not to be necessary, this single commit can be reverted
without affecting the useful one. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-by: Oswald Buddenhagen <ossi@kde.org>
Cc: Oswald Buddenhagen <ossi@kde.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acglobal.h  |    2 ++
 drivers/acpi/acpica/hwxfsleep.c |   72 ++++++++++++++++++++++++++++++++-------
 drivers/acpi/acpica/tbutils.c   |   14 ++++----
 3 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 115eedc..11b39d9 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -61,6 +61,8 @@ ACPI_GLOBAL(struct acpi_table_header, acpi_gbl_original_dsdt_header);
 
 #if (!ACPI_REDUCED_HARDWARE)
 ACPI_GLOBAL(struct acpi_table_facs *, acpi_gbl_FACS);
+ACPI_GLOBAL(struct acpi_table_facs *, acpi_gbl_facs32);
+ACPI_GLOBAL(struct acpi_table_facs *, acpi_gbl_facs64);
 
 #endif				/* !ACPI_REDUCED_HARDWARE */
 
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 2b988d5..e29ee67 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -50,6 +50,11 @@
 ACPI_MODULE_NAME("hwxfsleep")
 
 /* Local prototypes */
+static acpi_status
+acpi_hw_set_firmware_waking_vector(struct acpi_table_facs *facs,
+				   acpi_physical_address physical_address,
+				   acpi_physical_address physical_address64);
+
 static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id);
 
 /*
@@ -79,9 +84,10 @@ static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
 #if (!ACPI_REDUCED_HARDWARE)
 /*******************************************************************************
  *
- * FUNCTION:    acpi_set_firmware_waking_vector
+ * FUNCTION:    acpi_hw_set_firmware_waking_vector
  *
- * PARAMETERS:  physical_address    - 32-bit physical address of ACPI real mode
+ * PARAMETERS:  facs                - Pointer to FACS table
+ *              physical_address    - 32-bit physical address of ACPI real mode
  *                                    entry point
  *              physical_address64  - 64-bit physical address of ACPI protected
  *                                    entry point
@@ -92,11 +98,12 @@ static struct acpi_sleep_functions acpi_sleep_dispatch[] = {
  *
  ******************************************************************************/
 
-acpi_status
-acpi_set_firmware_waking_vector(acpi_physical_address physical_address,
-				acpi_physical_address physical_address64)
+static acpi_status
+acpi_hw_set_firmware_waking_vector(struct acpi_table_facs *facs,
+				   acpi_physical_address physical_address,
+				   acpi_physical_address physical_address64)
 {
-	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
+	ACPI_FUNCTION_TRACE(acpi_hw_set_firmware_waking_vector);
 
 
 	/*
@@ -109,25 +116,66 @@ acpi_set_firmware_waking_vector(acpi_physical_address physical_address,
 
 	/* Set the 32-bit vector */
 
-	acpi_gbl_FACS->firmware_waking_vector = (u32)physical_address;
+	facs->firmware_waking_vector = (u32)physical_address;
 
-	if (acpi_gbl_FACS->length > 32) {
-		if (acpi_gbl_FACS->version >= 1) {
+	if (facs->length > 32) {
+		if (facs->version >= 1) {
 
 			/* Set the 64-bit vector */
 
-			acpi_gbl_FACS->xfirmware_waking_vector =
-			    physical_address64;
+			facs->xfirmware_waking_vector = physical_address64;
 		} else {
 			/* Clear the 64-bit vector if it exists */
 
-			acpi_gbl_FACS->xfirmware_waking_vector = 0;
+			facs->xfirmware_waking_vector = 0;
 		}
 	}
 
 	return_ACPI_STATUS(AE_OK);
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_set_firmware_waking_vector
+ *
+ * PARAMETERS:  physical_address    - 32-bit physical address of ACPI real mode
+ *                                    entry point
+ *              physical_address64  - 64-bit physical address of ACPI protected
+ *                                    entry point
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Sets the firmware_waking_vector fields of the FACS
+ *
+ ******************************************************************************/
+
+acpi_status
+acpi_set_firmware_waking_vector(acpi_physical_address physical_address,
+				acpi_physical_address physical_address64)
+{
+
+	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector);
+
+	/* If Hardware Reduced flag is set, there is no FACS */
+
+	if (acpi_gbl_reduced_hardware) {
+		return (AE_OK);
+	}
+
+	if (acpi_gbl_facs32) {
+		(void)acpi_hw_set_firmware_waking_vector(acpi_gbl_facs32,
+							 physical_address,
+							 physical_address64);
+	}
+	if (acpi_gbl_facs64) {
+		(void)acpi_hw_set_firmware_waking_vector(acpi_gbl_facs64,
+							 physical_address,
+							 physical_address64);
+	}
+
+	return_ACPI_STATUS(AE_OK);
+}
+
 ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector)
 
 /*******************************************************************************
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index d4552e8..5e8df70 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -68,8 +68,6 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size);
 
 acpi_status acpi_tb_initialize_facs(void)
 {
-	struct acpi_table_facs *facs32;
-	struct acpi_table_facs *facs64;
 
 	/* If Hardware Reduced flag is set, there is no FACS */
 
@@ -81,19 +79,21 @@ acpi_status acpi_tb_initialize_facs(void)
 	(void)acpi_get_table_by_index(ACPI_TABLE_INDEX_FACS,
 				      ACPI_CAST_INDIRECT_PTR(struct
 							     acpi_table_header,
-							     &facs32));
+							     &acpi_gbl_facs32));
 	(void)acpi_get_table_by_index(ACPI_TABLE_INDEX_X_FACS,
 				      ACPI_CAST_INDIRECT_PTR(struct
 							     acpi_table_header,
-							     &facs64));
-	if (!facs32 && !facs64) {
+							     &acpi_gbl_facs64));
+	if (!acpi_gbl_facs32 && !acpi_gbl_facs64) {
 		return (AE_NO_MEMORY);
 	}
 
 	if (acpi_gbl_use32_bit_facs_addresses) {
-		acpi_gbl_FACS = facs32 ? facs32 : facs64;
+		acpi_gbl_FACS =
+		    acpi_gbl_facs32 ? acpi_gbl_facs32 : acpi_gbl_facs64;
 	} else {
-		acpi_gbl_FACS = facs64 ? facs64 : facs32;
+		acpi_gbl_FACS =
+		    acpi_gbl_facs64 ? acpi_gbl_facs64 : acpi_gbl_facs32;
 	}
 
 	return (AE_OK);
-- 
1.7.10

