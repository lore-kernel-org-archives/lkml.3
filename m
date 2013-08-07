Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3HGK71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:59:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab3HGKxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:44 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144146"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v3 05/25] acpi, acpica: Split acpi_tb_install_table() into two parts.
Date: Wed, 7 Aug 2013 18:51:56 +0800
Message-Id: <1375872736-4822-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:17,
	Serialize complete at 2013/08/07 18:52:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ACPI, SRAT(System Resource Affinity Table) contains NUMA info.
The memory affinities in SRAT record every memory range in the
system, and also, flags specifying if the memory range is
hotpluggable.
(Please refer to ACPI spec 5.0 5.2.16)

memblock starts to work at very early time, and SRAT has not been
parsed. So we don't know which memory is hotpluggable. In order
to use memblock to reserve hotpluggable memory, we need to obtain
SRAT memory affinity info earlier.

In the current kernel, the acpica code iterates acpi_gbl_root_table_list,
and install all the acpi tables into it at boot time. First, it
tries to find if there is any override table in global list
acpi_tables_addr. If any, use the override table. Otherwise, it
will install the tables provided by firmware. Like the following:

setup_arch()
 |->acpi_initrd_override()                        /* Initialize acpi_tables_addr with all override table. */
 |...
 |->acpi_boot_table_init()
    |->acpi_table_init()
       |->acpi_initialize_tables()
          |->acpi_tb_parse_root_table()           /* Parse RSDT or XSDT, find all tables in firmware */
             |->for (each item in acpi_gbl_root_table_list)
                |->acpi_tb_install_table()
                   |->   ......                   /* Install one single table */
                   |->acpi_tb_table_override()    /* Override one single table */

It does the table installation one by one.

In order to find SRAT at earlier time, we want to initialize
acpi_gbl_root_table_list earlier. But at the same time, keep
ACPI_INITRD_TABLE_OVERRIDE procedure works as well.

The basic idea is, split the acpi_gbl_root_table_list initialization
procedure into two steps:
1. Install all tables from firmware, not one by one.
2. Override any table if necessary, not one by one.

After this patch-set, it will work like this:

setup_arch()
 |->     ......                                   /* Install all tables from firmware (Step 1) */
 |->     ......                                   /* Try to find if any override SRAT in initrd file, if yes, use it */
 |->     ......                                   /* Use the SRAT from firmware */
 |->     ......                                   /* memblock starts to work */
 |->     ......
 |->acpi_initrd_override()                        /* Initialize acpi_tables_addr with all override table. */
 |...
 |->     ......                                   /* Do the table override work for all tables (Step 2) */


In order to achieve this goal, we have to split all the following functions:

ACPICA:
    acpi_tb_install_table()
    acpi_tb_parse_root_table()
    acpi_initialize_tables()

acpi:
    acpi_table_init()
    acpi_boot_table_init()

Since ACPICA code is not just used by the Linux, so we should keep the ACPICA
side interfaces unmodified, and introduce new functions used in Linux.


This patch split acpi_tb_install_table() into two steps, and introduce two new
functions:
    acpi_tb_install_table_firmware() and acpi_tb_install_table_override(),
which will be used later in Linux.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbutils.c |  118 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 103 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index bffdfc7..2db068c 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -249,28 +249,25 @@ struct acpi_table_header *acpi_tb_copy_dsdt(u32 table_index)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_tb_install_table
+ * FUNCTION:    acpi_tb_install_table_firmware
  *
- * PARAMETERS:  address                 - Physical address of DSDT or FACS
+ * PARAMETERS:  address                 - Physical address of the table to be
+ *                                        installed
  *              signature               - Table signature, NULL if no need to
  *                                        match
  *              table_index             - Index into root table array
  *
  * RETURN:      None
  *
- * DESCRIPTION: Install an ACPI table into the global data structure. The
- *              table override mechanism is called to allow the host
- *              OS to replace any table before it is installed in the root
- *              table array.
+ * DESCRIPTION: Install an ACPI table into the global data structure.
  *
  ******************************************************************************/
 
 void
-acpi_tb_install_table(acpi_physical_address address,
-		      char *signature, u32 table_index)
+acpi_tb_install_table_firmware(acpi_physical_address address,
+			       char *signature, u32 table_index)
 {
 	struct acpi_table_header *table;
-	struct acpi_table_header *final_table;
 	struct acpi_table_desc *table_desc;
 
 	if (!address) {
@@ -312,6 +309,74 @@ acpi_tb_install_table(acpi_physical_address address,
 	table_desc->flags = ACPI_TABLE_ORIGIN_MAPPED;
 	ACPI_MOVE_32_TO_32(table_desc->signature.ascii, table->signature);
 
+	acpi_tb_print_table_header(table_desc->address, table);
+
+	/* Set the global integer width (based upon revision of the DSDT) */
+
+	if (table_index == ACPI_TABLE_INDEX_DSDT) {
+		acpi_ut_set_integer_width(table->revision);
+	}
+
+      unmap_and_exit:
+
+	/* Always unmap the table header that we mapped above */
+
+	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_tb_install_table_override
+ *
+ * PARAMETERS:  address                 - Physical address of the table to be
+ *                                        installed
+ *              signature               - Table signature, NULL if no need to
+ *                                        match
+ *              table_index             - Index into root table array
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Override an ACPI table in the global data structure.
+ *
+ ******************************************************************************/
+
+void
+acpi_tb_install_table_override(acpi_physical_address address,
+			       char *signature, u32 table_index)
+{
+	struct acpi_table_header *table;
+	struct acpi_table_header *final_table;
+	struct acpi_table_desc *table_desc;
+
+	if (!address) {
+		ACPI_ERROR((AE_INFO,
+			    "Null physical address for ACPI table [%s]",
+			    signature));
+		return;
+	}
+
+	/* Map just the table header */
+
+	table = acpi_os_map_memory(address, sizeof(struct acpi_table_header));
+	if (!table) {
+		ACPI_ERROR((AE_INFO,
+			    "Could not map memory for table [%s] at %p",
+			    signature, ACPI_CAST_PTR(void, address)));
+		return;
+	}
+
+	/* If a particular signature is expected (DSDT/FACS), it must match */
+
+	if (signature && !ACPI_COMPARE_NAME(table->signature, signature)) {
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "Invalid signature 0x%X for ACPI table, expected [%s]",
+				 *ACPI_CAST_PTR(u32, table->signature),
+				 signature));
+		goto unmap_and_exit;
+	}
+
+	table_desc = &acpi_gbl_root_table_list.tables[table_index];
+
 	/*
 	 * ACPI Table Override:
 	 *
@@ -332,12 +397,6 @@ acpi_tb_install_table(acpi_physical_address address,
 
 	acpi_tb_print_table_header(table_desc->address, final_table);
 
-	/* Set the global integer width (based upon revision of the DSDT) */
-
-	if (table_index == ACPI_TABLE_INDEX_DSDT) {
-		acpi_ut_set_integer_width(final_table->revision);
-	}
-
 	/*
 	 * If we have a physical override during this early loading of the ACPI
 	 * tables, unmap the table for now. It will be mapped again later when
@@ -359,6 +418,35 @@ acpi_tb_install_table(acpi_physical_address address,
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_tb_install_table
+ *
+ * PARAMETERS:  address                 - Physical address of DSDT or FACS
+ *              signature               - Table signature, NULL if no need to
+ *                                        match
+ *              table_index             - Index into root table array
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Install an ACPI table into the global data structure. The
+ *              table override mechanism is called to allow the host
+ *              OS to replace any table which has been installed in the root
+ *              table array.
+ *
+ ******************************************************************************/
+
+void
+acpi_tb_install_table(acpi_physical_address address,
+		      char *signature, u32 table_index)
+{
+	/* Install a table from firmware into acpi_gbl_root_table_list. */
+	acpi_tb_install_table_firmware(address, signature, table_index);
+
+	/* Override an installed table. */
+	acpi_tb_install_table_override(address, signature, table_index);
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_tb_get_root_table_entry
  *
  * PARAMETERS:  table_entry         - Pointer to the RSDT/XSDT table entry
-- 
1.7.1

