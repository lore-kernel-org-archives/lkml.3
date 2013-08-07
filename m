Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3HGKxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:53:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932515Ab3HGKxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144145"
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
Subject: [PATCH v3 09/25] acpi, acpica: Split acpi_initialize_tables() into two parts.
Date: Wed, 7 Aug 2013 18:52:00 +0800
Message-Id: <1375872736-4822-10-git-send-email-tangchen@cn.fujitsu.com>
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

This patch splits acpi_initialize_tables() into two steps, and
introduces two new functions:
    acpi_initialize_tables_firmware() and acpi_tb_root_table_override(),
which work just the same as acpi_initialize_tables() if they are called
in sequence.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbxface.c |   64 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 98e4cad..ecaa5e1 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -72,8 +72,7 @@ acpi_status acpi_allocate_root_table(u32 initial_table_count)
 }
 
 /*******************************************************************************
- *
- * FUNCTION:    acpi_initialize_tables
+ * FUNCTION:    acpi_initialize_tables_firmware
  *
  * PARAMETERS:  initial_table_array - Pointer to an array of pre-allocated
  *                                    struct acpi_table_desc structures. If NULL, the
@@ -86,8 +85,6 @@ acpi_status acpi_allocate_root_table(u32 initial_table_count)
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Initialize the table manager, get the RSDP and RSDT/XSDT.
- *
  * NOTE:        Allows static allocation of the initial table array in order
  *              to avoid the use of dynamic memory in confined environments
  *              such as the kernel boot sequence where it may not be available.
@@ -98,8 +95,8 @@ acpi_status acpi_allocate_root_table(u32 initial_table_count)
  ******************************************************************************/
 
 acpi_status __init
-acpi_initialize_tables(struct acpi_table_desc * initial_table_array,
-		       u32 initial_table_count, u8 allow_resize)
+acpi_initialize_tables_firmware(struct acpi_table_desc * initial_table_array,
+				u32 initial_table_count, u8 allow_resize)
 {
 	acpi_physical_address rsdp_address;
 	acpi_status status;
@@ -144,10 +141,63 @@ acpi_initialize_tables(struct acpi_table_desc * initial_table_array,
 	 * in a common, more useable format.
 	 */
 	status = acpi_tb_root_table_install(rsdp_address);
+
+	return_ACPI_STATUS(status);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_initialize_tables
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Allow host OS to replace any table installed in global root
+ *              table list.
+ *
+ ******************************************************************************/
+
+void acpi_initialize_tables_override(void)
+{
+	acpi_tb_root_table_override();
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_initialize_tables
+ *
+ * PARAMETERS:  initial_table_array - Pointer to an array of pre-allocated
+ *                                    struct acpi_table_desc structures. If NULL, the
+ *                                    array is dynamically allocated.
+ *              initial_table_count - Size of initial_table_array, in number of
+ *                                    struct acpi_table_desc structures
+ *              allow_resize        - Flag to tell Table Manager if resize of
+ *                                    pre-allocated array is allowed. Ignored
+ *                                    if initial_table_array is NULL.
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Initialize the table manager, get the RSDP and RSDT/XSDT.
+ *
+ ******************************************************************************/
+
+acpi_status __init
+acpi_initialize_tables(struct acpi_table_desc * initial_table_array,
+		       u32 initial_table_count, u8 allow_resize)
+{
+	acpi_status status;
+
+	status = acpi_initialize_tables_firmware(initial_table_array,
+					initial_table_count, allow_resize);
 	if (ACPI_FAILURE(status))
 		return_ACPI_STATUS(status);
 
-	acpi_tb_root_table_override();
+	/*
+	 * Allow host OS to replace any table installed in global root
+	 * table list.
+	 */
+	acpi_initialize_tables_override();
 
 	return_ACPI_STATUS(AE_OK);
 }
-- 
1.7.1

