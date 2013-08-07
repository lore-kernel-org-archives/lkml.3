Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3HGK6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:58:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab3HGKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144151"
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
Subject: [PATCH v3 11/25] x86, acpi: Split acpi_table_init() into two parts.
Date: Wed, 7 Aug 2013 18:52:02 +0800
Message-Id: <1375872736-4822-12-git-send-email-tangchen@cn.fujitsu.com>
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

This patch splits acpi_table_init() into two steps.

Since acpi_table_init() is used not just in x86, also used in ia64,
we introduce two new functions:
    acpi_table_init_firmware() and acpi_table_init_override(),
which work just the same as acpi_table_init() if they are called
in sequence. This will keep acpi_table_init() works as before on
other platforms, and we only call these new functions in Linux.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/tables.c |   26 ++++++++++++++++++++------
 include/linux/acpi.h  |    2 ++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index c8f2d01..4913a85 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -336,6 +336,23 @@ static void __init check_multiple_madt(void)
 	return;
 }
 
+int __init acpi_table_init_firmware(void)
+{
+	acpi_status status;
+
+	status = acpi_initialize_tables_firmware(initial_tables,
+						 ACPI_MAX_TABLES, 0);
+	if (ACPI_FAILURE(status))
+		return 1;
+
+	return 0;
+}
+
+void __init acpi_table_init_override(void)
+{
+	acpi_initialize_tables_override();
+}
+
 /*
  * acpi_table_init()
  *
@@ -347,16 +364,13 @@ static void __init check_multiple_madt(void)
 
 int __init acpi_table_init(void)
 {
-	acpi_status status;
-
-	status = acpi_initialize_tables_firmware(initial_tables,
-						 ACPI_MAX_TABLES, 0);
-	if (ACPI_FAILURE(status))
+	if (acpi_table_init_firmware())
 		return 1;
 
-	acpi_initialize_tables_override();
+	acpi_table_init_override();
 
 	check_multiple_madt();
+
 	return 0;
 }
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 353ba25..9704179 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -95,6 +95,8 @@ void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
 
+int acpi_table_init_firmware(void);
+void acpi_table_init_override(void);
 int acpi_table_init (void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
-- 
1.7.1

