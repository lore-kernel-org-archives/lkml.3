Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbaEKXzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:55:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54691 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757991AbaEKXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:55:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Lv Zheng <lv.zheng@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [PATCH] ACPICA: Revert "ACPICA: Add option to favor 32-bit FADT addresses."
Date: Mon, 12 May 2014 02:11:48 +0200
Message-ID: <38907770.bupFXhytsS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Revert commit 0249ed2444d6 (ACPICA: Add option to favor 32-bit FADT
addresses.) that breaks resume from system suspend on the Intel DP45SG
board.

Fixes: 0249ed2444d6 (ACPICA: Add option to favor 32-bit FADT addresses.)
References: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-and-tested-by: Oswald Buddenhagen <ossi@kde.org>
Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/acglobal.h |  10 --
 drivers/acpi/acpica/tbfadt.c   | 335 +++++++++++++++++++----------------------
 include/acpi/acpixf.h          |   1 -
 3 files changed, 152 insertions(+), 194 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 49bbc71fad54..72578a4b8212 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -136,16 +136,6 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_copy_dsdt_locally, FALSE);
 ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
 
 /*
- * Optionally use 32-bit FADT addresses if and when there is a conflict
- * (address mismatch) between the 32-bit and 64-bit versions of the
- * address. Although ACPICA adheres to the ACPI specification which
- * requires the use of the corresponding 64-bit address if it is non-zero,
- * some machines have been found to have a corrupted non-zero 64-bit
- * address. Default is FALSE, do not favor the 32-bit addresses.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, FALSE);
-
-/*
  * Optionally truncate I/O addresses to 16 bits. Provides compatibility
  * with other ACPI implementations. NOTE: During ACPICA initialization,
  * this value is set to TRUE if any Windows OSI strings have been
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index ec14588254d4..6dd5c590e0bb 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -56,10 +56,9 @@ acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 
 static void acpi_tb_convert_fadt(void);
 
-static void acpi_tb_setup_fadt_registers(void);
+static void acpi_tb_validate_fadt(void);
 
-static u64
-acpi_tb_select_address(char *register_name, u32 address32, u64 address64);
+static void acpi_tb_setup_fadt_registers(void);
 
 /* Table for conversion of FADT to common internal format and FADT validation */
 
@@ -176,7 +175,6 @@ static struct acpi_fadt_pm_info fadt_pm_info_table[] = {
  *              space_id            - ACPI Space ID for this register
  *              byte_width          - Width of this register
  *              address             - Address of the register
- *              register_name       - ASCII name of the ACPI register
  *
  * RETURN:      None
  *
@@ -222,68 +220,6 @@ acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_tb_select_address
- *
- * PARAMETERS:  register_name       - ASCII name of the ACPI register
- *              address32           - 32-bit address of the register
- *              address64           - 64-bit address of the register
- *
- * RETURN:      The resolved 64-bit address
- *
- * DESCRIPTION: Select between 32-bit and 64-bit versions of addresses within
- *              the FADT. Used for the FACS and DSDT addresses.
- *
- * NOTES:
- *
- * Check for FACS and DSDT address mismatches. An address mismatch between
- * the 32-bit and 64-bit address fields (FIRMWARE_CTRL/X_FIRMWARE_CTRL and
- * DSDT/X_DSDT) could be a corrupted address field or it might indicate
- * the presence of two FACS or two DSDT tables.
- *
- * November 2013:
- * By default, as per the ACPICA specification, a valid 64-bit address is
- * used regardless of the value of the 32-bit address. However, this
- * behavior can be overridden via the acpi_gbl_use32_bit_fadt_addresses flag.
- *
- ******************************************************************************/
-
-static u64
-acpi_tb_select_address(char *register_name, u32 address32, u64 address64)
-{
-
-	if (!address64) {
-
-		/* 64-bit address is zero, use 32-bit address */
-
-		return ((u64)address32);
-	}
-
-	if (address32 && (address64 != (u64)address32)) {
-
-		/* Address mismatch between 32-bit and 64-bit versions */
-
-		ACPI_BIOS_WARNING((AE_INFO,
-				   "32/64X %s address mismatch in FADT: "
-				   "0x%8.8X/0x%8.8X%8.8X, using %u-bit address",
-				   register_name, address32,
-				   ACPI_FORMAT_UINT64(address64),
-				   acpi_gbl_use32_bit_fadt_addresses ? 32 :
-				   64));
-
-		/* 32-bit address override */
-
-		if (acpi_gbl_use32_bit_fadt_addresses) {
-			return ((u64)address32);
-		}
-	}
-
-	/* Default is to use the 64-bit address */
-
-	return (address64);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_tb_parse_fadt
  *
  * PARAMETERS:  table_index         - Index for the FADT
@@ -395,6 +331,10 @@ void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 
 	acpi_tb_convert_fadt();
 
+	/* Validate FADT values now, before we make any changes */
+
+	acpi_tb_validate_fadt();
+
 	/* Initialize the global ACPI register structures */
 
 	acpi_tb_setup_fadt_registers();
@@ -404,55 +344,66 @@ void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
  *
  * FUNCTION:    acpi_tb_convert_fadt
  *
- * PARAMETERS:  none - acpi_gbl_FADT is used.
+ * PARAMETERS:  None, uses acpi_gbl_FADT
  *
  * RETURN:      None
  *
  * DESCRIPTION: Converts all versions of the FADT to a common internal format.
- *              Expand 32-bit addresses to 64-bit as necessary. Also validate
- *              important fields within the FADT.
+ *              Expand 32-bit addresses to 64-bit as necessary.
  *
- * NOTE:        acpi_gbl_FADT must be of size (struct acpi_table_fadt), and must
- *              contain a copy of the actual BIOS-provided FADT.
+ * NOTE:        acpi_gbl_FADT must be of size (struct acpi_table_fadt),
+ *              and must contain a copy of the actual FADT.
  *
  * Notes on 64-bit register addresses:
  *
  * After this FADT conversion, later ACPICA code will only use the 64-bit "X"
  * fields of the FADT for all ACPI register addresses.
  *
- * The 64-bit X fields are optional extensions to the original 32-bit FADT
+ * The 64-bit "X" fields are optional extensions to the original 32-bit FADT
  * V1.0 fields. Even if they are present in the FADT, they are optional and
  * are unused if the BIOS sets them to zero. Therefore, we must copy/expand
- * 32-bit V1.0 fields to the 64-bit X fields if the the 64-bit X field is
- * originally zero.
+ * 32-bit V1.0 fields if the corresponding X field is zero.
  *
- * For ACPI 1.0 FADTs (that contain no 64-bit addresses), all 32-bit address
- * fields are expanded to the corresponding 64-bit X fields in the internal
- * common FADT.
+ * For ACPI 1.0 FADTs, all 32-bit address fields are expanded to the
+ * corresponding "X" fields in the internal FADT.
  *
  * For ACPI 2.0+ FADTs, all valid (non-zero) 32-bit address fields are expanded
- * to the corresponding 64-bit X fields, if the 64-bit field is originally
- * zero. Adhering to the ACPI specification, we completely ignore the 32-bit
- * field if the 64-bit field is valid, regardless of whether the host OS is
- * 32-bit or 64-bit.
- *
- * Possible additional checks:
- *  (acpi_gbl_FADT.pm1_event_length >= 4)
- *  (acpi_gbl_FADT.pm1_control_length >= 2)
- *  (acpi_gbl_FADT.pm_timer_length >= 4)
- *  Gpe block lengths must be multiple of 2
+ * to the corresponding 64-bit X fields. For compatibility with other ACPI
+ * implementations, we ignore the 64-bit field if the 32-bit field is valid,
+ * regardless of whether the host OS is 32-bit or 64-bit.
  *
  ******************************************************************************/
 
 static void acpi_tb_convert_fadt(void)
 {
-	char *name;
 	struct acpi_generic_address *address64;
 	u32 address32;
-	u8 length;
 	u32 i;
 
 	/*
+	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
+	 * Later code will always use the X 64-bit field. Also, check for an
+	 * address mismatch between the 32-bit and 64-bit address fields
+	 * (FIRMWARE_CTRL/X_FIRMWARE_CTRL, DSDT/X_DSDT) which would indicate
+	 * the presence of two FACS or two DSDT tables.
+	 */
+	if (!acpi_gbl_FADT.Xfacs) {
+		acpi_gbl_FADT.Xfacs = (u64) acpi_gbl_FADT.facs;
+	} else if (acpi_gbl_FADT.facs &&
+		   (acpi_gbl_FADT.Xfacs != (u64) acpi_gbl_FADT.facs)) {
+		ACPI_WARNING((AE_INFO,
+		    "32/64 FACS address mismatch in FADT - two FACS tables!"));
+	}
+
+	if (!acpi_gbl_FADT.Xdsdt) {
+		acpi_gbl_FADT.Xdsdt = (u64) acpi_gbl_FADT.dsdt;
+	} else if (acpi_gbl_FADT.dsdt &&
+		   (acpi_gbl_FADT.Xdsdt != (u64) acpi_gbl_FADT.dsdt)) {
+		ACPI_WARNING((AE_INFO,
+		    "32/64 DSDT address mismatch in FADT - two DSDT tables!"));
+	}
+
+	/*
 	 * For ACPI 1.0 FADTs (revision 1 or 2), ensure that reserved fields which
 	 * should be zero are indeed zero. This will workaround BIOSs that
 	 * inadvertently place values in these fields.
@@ -470,24 +421,119 @@ static void acpi_tb_convert_fadt(void)
 		acpi_gbl_FADT.boot_flags = 0;
 	}
 
+	/* Update the local FADT table header length */
+
+	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
+
 	/*
-	 * Now we can update the local FADT length to the length of the
-	 * current FADT version as defined by the ACPI specification.
-	 * Thus, we will have a common FADT internally.
+	 * Expand the ACPI 1.0 32-bit addresses to the ACPI 2.0 64-bit "X"
+	 * generic address structures as necessary. Later code will always use
+	 * the 64-bit address structures.
+	 *
+	 * March 2009:
+	 * We now always use the 32-bit address if it is valid (non-null). This
+	 * is not in accordance with the ACPI specification which states that
+	 * the 64-bit address supersedes the 32-bit version, but we do this for
+	 * compatibility with other ACPI implementations. Most notably, in the
+	 * case where both the 32 and 64 versions are non-null, we use the 32-bit
+	 * version. This is the only address that is guaranteed to have been
+	 * tested by the BIOS manufacturer.
 	 */
-	acpi_gbl_FADT.header.length = sizeof(struct acpi_table_fadt);
+	for (i = 0; i < ACPI_FADT_INFO_ENTRIES; i++) {
+		address32 = *ACPI_ADD_PTR(u32,
+					  &acpi_gbl_FADT,
+					  fadt_info_table[i].address32);
+
+		address64 = ACPI_ADD_PTR(struct acpi_generic_address,
+					 &acpi_gbl_FADT,
+					 fadt_info_table[i].address64);
+
+		/*
+		 * If both 32- and 64-bit addresses are valid (non-zero),
+		 * they must match.
+		 */
+		if (address64->address && address32 &&
+		    (address64->address != (u64)address32)) {
+			ACPI_BIOS_ERROR((AE_INFO,
+					 "32/64X address mismatch in FADT/%s: "
+					 "0x%8.8X/0x%8.8X%8.8X, using 32",
+					 fadt_info_table[i].name, address32,
+					 ACPI_FORMAT_UINT64(address64->
+							    address)));
+		}
+
+		/* Always use 32-bit address if it is valid (non-null) */
+
+		if (address32) {
+			/*
+			 * Copy the 32-bit address to the 64-bit GAS structure. The
+			 * Space ID is always I/O for 32-bit legacy address fields
+			*/
+			acpi_tb_init_generic_address(address64,
+						     ACPI_ADR_SPACE_SYSTEM_IO,
+						     *ACPI_ADD_PTR(u8,
+								   &acpi_gbl_FADT,
+								   fadt_info_table
+								   [i].length),
+						     (u64) address32,
+						     fadt_info_table[i].name);
+		}
+	}
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_tb_validate_fadt
+ *
+ * PARAMETERS:  table           - Pointer to the FADT to be validated
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Validate various important fields within the FADT. If a problem
+ *              is found, issue a message, but no status is returned.
+ *              Used by both the table manager and the disassembler.
+ *
+ * Possible additional checks:
+ * (acpi_gbl_FADT.pm1_event_length >= 4)
+ * (acpi_gbl_FADT.pm1_control_length >= 2)
+ * (acpi_gbl_FADT.pm_timer_length >= 4)
+ * Gpe block lengths must be multiple of 2
+ *
+ ******************************************************************************/
+
+static void acpi_tb_validate_fadt(void)
+{
+	char *name;
+	struct acpi_generic_address *address64;
+	u8 length;
+	u32 i;
 
 	/*
-	 * Expand the 32-bit FACS and DSDT addresses to 64-bit as necessary.
-	 * Later ACPICA code will always use the X 64-bit field.
+	 * Check for FACS and DSDT address mismatches. An address mismatch between
+	 * the 32-bit and 64-bit address fields (FIRMWARE_CTRL/X_FIRMWARE_CTRL and
+	 * DSDT/X_DSDT) would indicate the presence of two FACS or two DSDT tables.
 	 */
-	acpi_gbl_FADT.Xfacs = acpi_tb_select_address("FACS",
-						     acpi_gbl_FADT.facs,
-						     acpi_gbl_FADT.Xfacs);
+	if (acpi_gbl_FADT.facs &&
+	    (acpi_gbl_FADT.Xfacs != (u64)acpi_gbl_FADT.facs)) {
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "32/64X FACS address mismatch in FADT - "
+				   "0x%8.8X/0x%8.8X%8.8X, using 32",
+				   acpi_gbl_FADT.facs,
+				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xfacs)));
+
+		acpi_gbl_FADT.Xfacs = (u64)acpi_gbl_FADT.facs;
+	}
+
+	if (acpi_gbl_FADT.dsdt &&
+	    (acpi_gbl_FADT.Xdsdt != (u64)acpi_gbl_FADT.dsdt)) {
+		ACPI_BIOS_WARNING((AE_INFO,
+				   "32/64X DSDT address mismatch in FADT - "
+				   "0x%8.8X/0x%8.8X%8.8X, using 32",
+				   acpi_gbl_FADT.dsdt,
+				   ACPI_FORMAT_UINT64(acpi_gbl_FADT.Xdsdt)));
 
-	acpi_gbl_FADT.Xdsdt = acpi_tb_select_address("DSDT",
-						     acpi_gbl_FADT.dsdt,
-						     acpi_gbl_FADT.Xdsdt);
+		acpi_gbl_FADT.Xdsdt = (u64)acpi_gbl_FADT.dsdt;
+	}
 
 	/* If Hardware Reduced flag is set, we are all done */
 
@@ -499,95 +545,18 @@ static void acpi_tb_convert_fadt(void)
 
 	for (i = 0; i < ACPI_FADT_INFO_ENTRIES; i++) {
 		/*
-		 * Get the 32-bit and 64-bit addresses, as well as the register
-		 * length and register name.
+		 * Generate pointer to the 64-bit address, get the register
+		 * length (width) and the register name
 		 */
-		address32 = *ACPI_ADD_PTR(u32,
-					  &acpi_gbl_FADT,
-					  fadt_info_table[i].address32);
-
 		address64 = ACPI_ADD_PTR(struct acpi_generic_address,
 					 &acpi_gbl_FADT,
 					 fadt_info_table[i].address64);
-
-		length = *ACPI_ADD_PTR(u8,
-				       &acpi_gbl_FADT,
-				       fadt_info_table[i].length);
-
+		length =
+		    *ACPI_ADD_PTR(u8, &acpi_gbl_FADT,
+				  fadt_info_table[i].length);
 		name = fadt_info_table[i].name;
 
 		/*
-		 * Expand the ACPI 1.0 32-bit addresses to the ACPI 2.0 64-bit "X"
-		 * generic address structures as necessary. Later code will always use
-		 * the 64-bit address structures.
-		 *
-		 * November 2013:
-		 * Now always use the 64-bit address if it is valid (non-zero), in
-		 * accordance with the ACPI specification which states that a 64-bit
-		 * address supersedes the 32-bit version. This behavior can be
-		 * overridden by the acpi_gbl_use32_bit_fadt_addresses flag.
-		 *
-		 * During 64-bit address construction and verification,
-		 * these cases are handled:
-		 *
-		 * Address32 zero, Address64 [don't care]   - Use Address64
-		 *
-		 * Address32 non-zero, Address64 zero       - Copy/use Address32
-		 * Address32 non-zero == Address64 non-zero - Use Address64
-		 * Address32 non-zero != Address64 non-zero - Warning, use Address64
-		 *
-		 * Override: if acpi_gbl_use32_bit_fadt_addresses is TRUE, and:
-		 * Address32 non-zero != Address64 non-zero - Warning, copy/use Address32
-		 *
-		 * Note: space_id is always I/O for 32-bit legacy address fields
-		 */
-		if (address32) {
-			if (!address64->address) {
-
-				/* 64-bit address is zero, use 32-bit address */
-
-				acpi_tb_init_generic_address(address64,
-							     ACPI_ADR_SPACE_SYSTEM_IO,
-							     *ACPI_ADD_PTR(u8,
-									   &acpi_gbl_FADT,
-									   fadt_info_table
-									   [i].
-									   length),
-							     (u64)address32,
-							     name);
-			} else if (address64->address != (u64)address32) {
-
-				/* Address mismatch */
-
-				ACPI_BIOS_WARNING((AE_INFO,
-						   "32/64X address mismatch in FADT/%s: "
-						   "0x%8.8X/0x%8.8X%8.8X, using %u-bit address",
-						   name, address32,
-						   ACPI_FORMAT_UINT64
-						   (address64->address),
-						   acpi_gbl_use32_bit_fadt_addresses
-						   ? 32 : 64));
-
-				if (acpi_gbl_use32_bit_fadt_addresses) {
-
-					/* 32-bit address override */
-
-					acpi_tb_init_generic_address(address64,
-								     ACPI_ADR_SPACE_SYSTEM_IO,
-								     *ACPI_ADD_PTR
-								     (u8,
-								      &acpi_gbl_FADT,
-								      fadt_info_table
-								      [i].
-								      length),
-								     (u64)
-								     address32,
-								     name);
-				}
-			}
-		}
-
-		/*
 		 * For each extended field, check for length mismatch between the
 		 * legacy length field and the corresponding 64-bit X length field.
 		 * Note: If the legacy length field is > 0xFF bits, ignore this
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 44f5e9749601..40d1bc88cc14 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -82,7 +82,6 @@ extern u8 acpi_gbl_enable_interpreter_slack;
 extern u32 acpi_gbl_trace_flags;
 extern acpi_name acpi_gbl_trace_method_name;
 extern u8 acpi_gbl_truncate_io_addresses;
-extern u8 acpi_gbl_use32_bit_fadt_addresses;
 extern u8 acpi_gbl_use_default_register_widths;
 
 /*
-- 
1.8.4.5


