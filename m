Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3HHDlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 23:41:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3HHDlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 23:41:06 -0400
X-IronPort-AV: E=Sophos;i="4.89,836,1367942400"; 
   d="scan'208";a="8150465"
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
Subject: [PATCH part1 4/5] acpi, acpica: Call two new functions instead of acpi_tb_parse_root_table() in acpi_initialize_tables().
Date: Thu, 8 Aug 2013 11:39:35 +0800
Message-Id: <1375933176-15003-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375933176-15003-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375933176-15003-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 11:39:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 11:39:40,
	Serialize complete at 2013/08/08 11:39:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch introduces two new functions:
    acpi_tb_root_table_install() and acpi_tb_root_table_override(),
which work just the same as acpi_tb_parse_root_table() if they are
called in sequence.

In order to split acpi_initialize_tables(), call thes two functions
in acpi_initialize_tables(). This will keep acpi_initialize_tables()
works as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/acpica/actables.h |    2 ++
 drivers/acpi/acpica/tbxface.c  |    9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/actables.h b/drivers/acpi/acpica/actables.h
index 7755e91..641796e 100644
--- a/drivers/acpi/acpica/actables.h
+++ b/drivers/acpi/acpica/actables.h
@@ -120,6 +120,8 @@ void
 acpi_tb_install_table(acpi_physical_address address,
 		      char *signature, u32 table_index);
 
+acpi_status acpi_tb_root_table_install(acpi_physical_address rsdp_address);
+void acpi_tb_root_table_override(void);
 acpi_status acpi_tb_parse_root_table(acpi_physical_address rsdp_address);
 
 #endif				/* __ACTABLES_H__ */
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index ad11162..98e4cad 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -143,8 +143,13 @@ acpi_initialize_tables(struct acpi_table_desc * initial_table_array,
 	 * Root Table Array. This array contains the information of the RSDT/XSDT
 	 * in a common, more useable format.
 	 */
-	status = acpi_tb_parse_root_table(rsdp_address);
-	return_ACPI_STATUS(status);
+	status = acpi_tb_root_table_install(rsdp_address);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
+	acpi_tb_root_table_override();
+
+	return_ACPI_STATUS(AE_OK);
 }
 
 /*******************************************************************************
-- 
1.7.1

