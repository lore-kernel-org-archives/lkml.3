Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaD3CGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:06:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:30998 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbaD3CGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523497180"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Zhao Yakui <yakui.zhao@intel.com>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 23/27] ACPICA: Tables: Remove old mechanism to validate if XSDT contains NULL entries.
Date: Wed, 30 Apr 2014 10:06:02 +0800
Message-Id: <6dcea27ee505707b2debab1c7ea793f24b68eb4b.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the NULL entry sanity check implemented, the XSDT validation is
useless because:
1. If XSDT contains NULL entries, it can be bypassed by the new sanity
   check mechanism;
2. If RSDP contains a bad XSDT address, invoking XSDT validation will still
   lead to a kernel crash.

This patch deletes the old XSDT validation solution and thus enables the
new NULL entry sanity check solution.

Note that if there are reports reporting regressions caused by the enabling
of the new feature and disabling of the old feature, this commit should be
bisected and reverted. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
Buglink: https://bugs.archlinux.org/task/39811
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/tbutils.c |  105 -----------------------------------------
 1 file changed, 105 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 801d196..e37a103 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -49,8 +49,6 @@
 ACPI_MODULE_NAME("tbutils")
 
 /* Local prototypes */
-static acpi_status acpi_tb_validate_xsdt(acpi_physical_address address);
-
 static acpi_physical_address
 acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size);
 
@@ -251,87 +249,6 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_tb_validate_xsdt
- *
- * PARAMETERS:  address             - Physical address of the XSDT (from RSDP)
- *
- * RETURN:      Status. AE_OK if the table appears to be valid.
- *
- * DESCRIPTION: Validate an XSDT to ensure that it is of minimum size and does
- *              not contain any NULL entries. A problem that is seen in the
- *              field is that the XSDT exists, but is actually useless because
- *              of one or more (or all) NULL entries.
- *
- ******************************************************************************/
-
-static acpi_status acpi_tb_validate_xsdt(acpi_physical_address xsdt_address)
-{
-	struct acpi_table_header *table;
-	u8 *next_entry;
-	acpi_physical_address address;
-	u32 length;
-	u32 entry_count;
-	acpi_status status;
-	u32 i;
-
-	/* Get the XSDT length */
-
-	table =
-	    acpi_os_map_memory(xsdt_address, sizeof(struct acpi_table_header));
-	if (!table) {
-		return (AE_NO_MEMORY);
-	}
-
-	length = table->length;
-	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
-
-	/*
-	 * Minimum XSDT length is the size of the standard ACPI header
-	 * plus one physical address entry
-	 */
-	if (length < (sizeof(struct acpi_table_header) + ACPI_XSDT_ENTRY_SIZE)) {
-		return (AE_INVALID_TABLE_LENGTH);
-	}
-
-	/* Map the entire XSDT */
-
-	table = acpi_os_map_memory(xsdt_address, length);
-	if (!table) {
-		return (AE_NO_MEMORY);
-	}
-
-	/* Get the number of entries and pointer to first entry */
-
-	status = AE_OK;
-	next_entry = ACPI_ADD_PTR(u8, table, sizeof(struct acpi_table_header));
-	entry_count = (u32)((table->length - sizeof(struct acpi_table_header)) /
-			    ACPI_XSDT_ENTRY_SIZE);
-
-	/* Validate each entry (physical address) within the XSDT */
-
-	for (i = 0; i < entry_count; i++) {
-		address =
-		    acpi_tb_get_root_table_entry(next_entry,
-						 ACPI_XSDT_ENTRY_SIZE);
-		if (!address) {
-
-			/* Detected a NULL entry, XSDT is invalid */
-
-			status = AE_NULL_ENTRY;
-			break;
-		}
-
-		next_entry += ACPI_XSDT_ENTRY_SIZE;
-	}
-
-	/* Unmap table */
-
-	acpi_os_unmap_memory(table, length);
-	return (status);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_tb_parse_root_table
  *
  * PARAMETERS:  rsdp                    - Pointer to the RSDP
@@ -355,7 +272,6 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	u32 table_count;
 	struct acpi_table_header *table;
 	acpi_physical_address address;
-	acpi_physical_address rsdt_address;
 	u32 length;
 	u8 *table_entry;
 	acpi_status status;
@@ -384,14 +300,11 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 		 * as per the ACPI specification.
 		 */
 		address = (acpi_physical_address) rsdp->xsdt_physical_address;
-		rsdt_address =
-		    (acpi_physical_address) rsdp->rsdt_physical_address;
 		table_entry_size = ACPI_XSDT_ENTRY_SIZE;
 	} else {
 		/* Root table is an RSDT (32-bit physical addresses) */
 
 		address = (acpi_physical_address) rsdp->rsdt_physical_address;
-		rsdt_address = address;
 		table_entry_size = ACPI_RSDT_ENTRY_SIZE;
 	}
 
@@ -401,24 +314,6 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	 */
 	acpi_os_unmap_memory(rsdp, sizeof(struct acpi_table_rsdp));
 
-	/*
-	 * If it is present and used, validate the XSDT for access/size
-	 * and ensure that all table entries are at least non-NULL
-	 */
-	if (table_entry_size == ACPI_XSDT_ENTRY_SIZE) {
-		status = acpi_tb_validate_xsdt(address);
-		if (ACPI_FAILURE(status)) {
-			ACPI_BIOS_WARNING((AE_INFO,
-					   "XSDT is invalid (%s), using RSDT",
-					   acpi_format_exception(status)));
-
-			/* Fall back to the RSDT */
-
-			address = rsdt_address;
-			table_entry_size = ACPI_RSDT_ENTRY_SIZE;
-		}
-	}
-
 	/* Map the RSDT/XSDT table header to get the full table length */
 
 	table = acpi_os_map_memory(address, sizeof(struct acpi_table_header));
-- 
1.7.10

