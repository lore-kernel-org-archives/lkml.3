Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3HGK6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:58:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932586Ab3HGKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144152"
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
Subject: [PATCH v3 07/25] acpi, acpica: Split acpi_tb_parse_root_table() into two parts.
Date: Wed, 7 Aug 2013 18:51:58 +0800
Message-Id: <1375872736-4822-8-git-send-email-tangchen@cn.fujitsu.com>
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

This patch splits acpi_tb_parse_root_table() into two steps, and
introduces two new functions:
    acpi_tb_root_table_install() and acpi_tb_root_table_override().

They are just the same as acpi_tb_parse_root_table() if they are
called in sequence.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbutils.c |   57 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 9bef44b..8ed9b9a 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -503,14 +503,16 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_tb_parse_root_table
+ * FUNCTION:    acpi_tb_root_table_install
  *
  * PARAMETERS:  rsdp                    - Pointer to the RSDP
  *
  * RETURN:      Status
  *
  * DESCRIPTION: This function is called to parse the Root System Description
- *              Table (RSDT or XSDT)
+ *              Table (RSDT or XSDT), and install all the system description
+ *              tables defined in the root table into the global root table
+ *              list.
  *
  * NOTE:        Tables are mapped (not copied) for efficiency. The FACS must
  *              be mapped and cannot be copied because it contains the actual
@@ -519,7 +521,7 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
  ******************************************************************************/
 
 acpi_status __init
-acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
+acpi_tb_root_table_install(acpi_physical_address rsdp_address)
 {
 	struct acpi_table_rsdp *rsdp;
 	u32 table_entry_size;
@@ -673,7 +675,31 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 		/* Install tables in firmware into acpi_gbl_root_table_list */
 		acpi_tb_install_table_firmware(acpi_gbl_root_table_list.
 					       tables[i].address, NULL, i);
+	}
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_tb_root_table_override
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: This function is called to allow the host OS to replace any
+ *              table that has been installed into the global root table
+ *              list.
+ *
+ ******************************************************************************/
 
+void __init
+acpi_tb_root_table_override(void)
+{
+	int i;
+
+	for (i = 2; i < acpi_gbl_root_table_list.current_table_count; i++) {
 		/* Override the installed tables if any */
 		acpi_tb_install_table_override(acpi_gbl_root_table_list.
 					       tables[i].address, NULL, i);
@@ -686,6 +712,31 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 			acpi_tb_parse_fadt(i);
 		}
 	}
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_tb_parse_root_table
+ *
+ * PARAMETERS:  rsdp                    - Pointer to the RSDP
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This function is called to parse the Root System Description
+ *              Table (RSDT or XSDT)
+ *
+ ******************************************************************************/
+
+acpi_status __init
+acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
+{
+	acpi_status status;
+
+	status = acpi_tb_root_table_install(rsdp_address);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
+	acpi_tb_root_table_override();
 
 	return_ACPI_STATUS(AE_OK);
 }
-- 
1.7.1

