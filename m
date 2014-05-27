Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaE0R2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:28:50 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45356 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0R2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:28:45 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 4/6] ACPICA: Tables: Enable both 32-bit and 64-bit FACS.
Date: Wed, 28 May 2014 01:28:29 +0800
Message-Id: <90363720a34ec0d7508882a0452aa5ac27ce5a09.1401210685.git.lv.zheng@intel.com>
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

This patch tries to favor 32bit FACS address in another way where both the
FACS reported by "FIRMWARE_CTRL" and the FACS reported by "X_FIRMWARE_CTRL"
are loaded so that further commit can set firmware waking vector in the
both tables to ensure we can exclude the cases that trigger the bugs caused
by the root cause 2. The exclusion is split into 2 commits as this commit
is also useful for dumping more ACPI tables, it won't get reverted when
such exclusion is no longer necessary. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-by: Oswald Buddenhagen <ossi@kde.org>
Cc: Oswald Buddenhagen <ossi@kde.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/aclocal.h  |    1 +
 drivers/acpi/acpica/tbfadt.c   |   21 +++++++++++++--------
 drivers/acpi/acpica/tbutils.c  |   37 ++++++++++++++++++++++++++-----------
 drivers/acpi/acpica/tbxfload.c |    3 ++-
 include/acpi/acpixf.h          |    9 +++++++++
 5 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 91f801a..c78761d 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -213,6 +213,7 @@ struct acpi_table_list {
 
 #define ACPI_TABLE_INDEX_DSDT           (0)
 #define ACPI_TABLE_INDEX_FACS           (1)
+#define ACPI_TABLE_INDEX_X_FACS         (2)
 
 struct acpi_find_context {
 	char *search_for;
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 41519a9..dfa3f36 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -350,9 +350,18 @@ void acpi_tb_parse_fadt(u32 table_index)
 	/* If Hardware Reduced flag is set, there is no FACS */
 
 	if (!acpi_gbl_reduced_hardware) {
-		acpi_tb_install_fixed_table((acpi_physical_address)
-					    acpi_gbl_FADT.Xfacs, ACPI_SIG_FACS,
-					    ACPI_TABLE_INDEX_FACS);
+		if (acpi_gbl_FADT.facs) {
+			acpi_tb_install_fixed_table((acpi_physical_address)
+						    acpi_gbl_FADT.facs,
+						    ACPI_SIG_FACS,
+						    ACPI_TABLE_INDEX_FACS);
+		}
+		if (acpi_gbl_FADT.Xfacs) {
+			acpi_tb_install_fixed_table((acpi_physical_address)
+						    acpi_gbl_FADT.Xfacs,
+						    ACPI_SIG_FACS,
+						    ACPI_TABLE_INDEX_X_FACS);
+		}
 	}
 }
 
@@ -491,13 +500,9 @@ static void acpi_tb_convert_fadt(void)
 	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
 
 	/*
-	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
+	 * Expand the 32-bit DSDT addresses to 64-bit as necessary.
 	 * Later ACPICA code will always use the X 64-bit field.
 	 */
-	acpi_gbl_FADT.Xfacs = acpi_tb_select_address("FACS",
-						     acpi_gbl_FADT.facs,
-						     acpi_gbl_FADT.Xfacs);
-
 	acpi_gbl_FADT.Xdsdt = acpi_tb_select_address("DSDT",
 						     acpi_gbl_FADT.dsdt,
 						     acpi_gbl_FADT.Xdsdt);
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index e37a103..d4552e8 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -68,7 +68,8 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size);
 
 acpi_status acpi_tb_initialize_facs(void)
 {
-	acpi_status status;
+	struct acpi_table_facs *facs32;
+	struct acpi_table_facs *facs64;
 
 	/* If Hardware Reduced flag is set, there is no FACS */
 
@@ -77,11 +78,25 @@ acpi_status acpi_tb_initialize_facs(void)
 		return (AE_OK);
 	}
 
-	status = acpi_get_table_by_index(ACPI_TABLE_INDEX_FACS,
-					 ACPI_CAST_INDIRECT_PTR(struct
-								acpi_table_header,
-								&acpi_gbl_FACS));
-	return (status);
+	(void)acpi_get_table_by_index(ACPI_TABLE_INDEX_FACS,
+				      ACPI_CAST_INDIRECT_PTR(struct
+							     acpi_table_header,
+							     &facs32));
+	(void)acpi_get_table_by_index(ACPI_TABLE_INDEX_X_FACS,
+				      ACPI_CAST_INDIRECT_PTR(struct
+							     acpi_table_header,
+							     &facs64));
+	if (!facs32 && !facs64) {
+		return (AE_NO_MEMORY);
+	}
+
+	if (acpi_gbl_use32_bit_facs_addresses) {
+		acpi_gbl_FACS = facs32 ? facs32 : facs64;
+	} else {
+		acpi_gbl_FACS = facs64 ? facs64 : facs32;
+	}
+
+	return (AE_OK);
 }
 #endif				/* !ACPI_REDUCED_HARDWARE */
 
@@ -101,7 +116,7 @@ acpi_status acpi_tb_initialize_facs(void)
 u8 acpi_tb_tables_loaded(void)
 {
 
-	if (acpi_gbl_root_table_list.current_table_count >= 3) {
+	if (acpi_gbl_root_table_list.current_table_count >= 4) {
 		return (TRUE);
 	}
 
@@ -357,11 +372,11 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	table_entry = ACPI_ADD_PTR(u8, table, sizeof(struct acpi_table_header));
 
 	/*
-	 * First two entries in the table array are reserved for the DSDT
-	 * and FACS, which are not actually present in the RSDT/XSDT - they
-	 * come from the FADT
+	 * First three entries in the table array are reserved for the DSDT
+	 * and 32bit/64bit FACS, which are not actually present in the
+	 * RSDT/XSDT - they come from the FADT
 	 */
-	acpi_gbl_root_table_list.current_table_count = 2;
+	acpi_gbl_root_table_list.current_table_count = 3;
 
 	/* Initialize the root table array from the RSDT/XSDT */
 
diff --git a/drivers/acpi/acpica/tbxfload.c b/drivers/acpi/acpica/tbxfload.c
index ab5308b..435f716 100644
--- a/drivers/acpi/acpica/tbxfload.c
+++ b/drivers/acpi/acpica/tbxfload.c
@@ -166,7 +166,8 @@ static acpi_status acpi_tb_load_namespace(void)
 
 	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
 	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i) {
-		if ((!ACPI_COMPARE_NAME
+		if (!acpi_gbl_root_table_list.tables[i].address ||
+		    (!ACPI_COMPARE_NAME
 		     (&(acpi_gbl_root_table_list.tables[i].signature),
 		      ACPI_SIG_SSDT)
 		     &&
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index cfa8782..0f79659 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -193,6 +193,15 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
 ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, TRUE);
 
 /*
+ * Optionally use 32-bit FACS table addresses.
+ * It is reported that some platforms fail to resume from system suspending
+ * if 64-bit FACS table address is selected:
+ * https://bugzilla.kernel.org/show_bug.cgi?id=74021
+ * Default is TRUE, favor the 32-bit addresses.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_facs_addresses, TRUE);
+
+/*
  * Optionally truncate I/O addresses to 16 bits. Provides compatibility
  * with other ACPI implementations. NOTE: During ACPICA initialization,
  * this value is set to TRUE if any Windows OSI strings have been
-- 
1.7.10

