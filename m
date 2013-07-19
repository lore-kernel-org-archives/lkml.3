Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3GSIBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:01:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759776Ab3GSIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947429"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: [PATCH 08/21] x86, acpi: Also initialize signature and length when parsing root table.
Date: Fri, 19 Jul 2013 15:59:21 +0800
Message-Id: <1374220774-29974-9-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:43,
	Serialize complete at 2013/07/19 15:58:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides the phys addr of the acpi tables, it will be very convenient if
we also have the signature of each table in acpi_gbl_root_table_list at
early time. We can find SRAT easily by comparing the signature.

This patch alse record signature and some other info in
acpi_gbl_root_table_list at early time.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbutils.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 9d68ffc..37cc5e4 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -514,6 +514,7 @@ acpi_tb_install_table(acpi_physical_address address,
 	 * fully mapped later (in verify table). In any case, we must
 	 * unmap the header that was mapped above.
 	 */
+	table_desc = &acpi_gbl_root_table_list.tables[table_index];
 	final_table = acpi_tb_table_override(table, table_desc);
 	if (!final_table) {
 		final_table = table;	/* There was no override */
@@ -627,6 +628,7 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	u32 i;
 	u32 table_count;
 	struct acpi_table_header *table;
+	struct acpi_table_desc *table_desc;
 	acpi_physical_address address;
 	acpi_physical_address uninitialized_var(rsdt_address);
 	u32 length;
@@ -766,6 +768,27 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 	 */
 	acpi_os_unmap_memory(table, length);
 
+	/*
+	 * Also initialize the table entries here, so that later we can use them
+	 * to find SRAT at very eraly time to reserve hotpluggable memory.
+	 */
+	for (i = 2; i < table_count; i++) {
+		table = acpi_os_map_memory(
+				acpi_gbl_root_table_list.tables[i].address,
+				sizeof(struct acpi_table_header));
+		if (!table)
+			return_ACPI_STATUS(AE_NO_MEMORY);
+
+		table_desc = &acpi_gbl_root_table_list.tables[i];
+
+		table_desc->pointer = NULL;
+		table_desc->length = table->length;
+		table_desc->flags = ACPI_TABLE_ORIGIN_MAPPED;
+		ACPI_MOVE_32_TO_32(table_desc->signature.ascii, table->signature);
+
+		acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+	}
+
 	return_ACPI_STATUS(AE_OK);
 }
 
-- 
1.7.1

