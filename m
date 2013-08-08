Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3HHFGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:06:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48426 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab3HHFFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:05:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,836,1367942400"; 
   d="scan'208";a="8151106"
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
Subject: [PATCH part2 4/4] acpi: Introduce acpi_verify_initrd() to check if a table is invalid.
Date: Thu, 8 Aug 2013 13:03:59 +0800
Message-Id: <1375938239-18769-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 13:03:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 13:04:06,
	Serialize complete at 2013/08/08 13:04:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_initrd_override(), it checks several things to ensure the
table it found is valid. In later patches, we need to do these check
somewhere else. So this patch introduces a common function
acpi_verify_table() to do all these checks, and reuse it in different
places. The function will be used in the subsequent patches.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/osl.c |   86 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3b8bab2..0043e9f 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -572,9 +572,68 @@ static const char * const table_sigs[] = {
 /* Must not increase 10 or needs code modification below */
 #define ACPI_OVERRIDE_TABLES 10
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_verify_table
+ *
+ * PARAMETERS:  File               - The initrd file
+ *              Path               - Path to acpi overriding tables in cpio file
+ *              Signature          - Signature of the table
+ *
+ * RETURN:      0 if it passes all the checks, -EINVAL if any check fails.
+ *
+ * DESCRIPTION: Check if an acpi table found in initrd is invalid.
+ *              @signature can be NULL. If it is NULL, the function will check
+ *              if the table signature matches any signature in table_sigs[].
+ *
+ ******************************************************************************/
+int __init acpi_verify_table(struct cpio_data *file,
+			      const char *path, const char *signature)
+{
+	int idx;
+	struct acpi_table_header *table = file->data;
+
+	if (file->size < sizeof(struct acpi_table_header)) {
+		ACPI_INVALID_TABLE("Table smaller than ACPI header",
+			      path, file->name);
+		return -EINVAL;
+	}
+
+	if (signature) {
+		if (memcmp(table->signature, signature, 4)) {
+			ACPI_INVALID_TABLE("Table signature does not match",
+				      path, file->name);
+			return -EINVAL;
+		}
+	} else {
+		for (idx = 0; table_sigs[idx]; idx++)
+			if (!memcmp(table->signature, table_sigs[idx], 4))
+				break;
+
+		if (!table_sigs[idx]) {
+			ACPI_INVALID_TABLE("Unknown signature", path, file->name);
+			return -EINVAL;
+		}
+	}
+
+	if (file->size != table->length) {
+		ACPI_INVALID_TABLE("File length does not match table length",
+			      path, file->name);
+		return -EINVAL;
+	}
+
+	if (acpi_table_checksum(file->data, table->length)) {
+		ACPI_INVALID_TABLE("Bad table checksum",
+			      path, file->name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 void __init acpi_initrd_override(void *data, size_t size)
 {
-	int sig, no, table_nr = 0, total_offset = 0;
+	int no, table_nr = 0, total_offset = 0;
 	long offset = 0;
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
@@ -593,33 +652,10 @@ void __init acpi_initrd_override(void *data, size_t size)
 		data += offset;
 		size -= offset;
 
-		if (file.size < sizeof(struct acpi_table_header)) {
-			ACPI_INVALID_TABLE("Table smaller than ACPI header",
-				      cpio_path, file.name);
-			continue;
-		}
-
 		table = file.data;
 
-		for (sig = 0; table_sigs[sig]; sig++)
-			if (!memcmp(table->signature, table_sigs[sig], 4))
-				break;
-
-		if (!table_sigs[sig]) {
-			ACPI_INVALID_TABLE("Unknown signature",
-				      cpio_path, file.name);
+		if (acpi_verify_table(&file, cpio_path, NULL))
 			continue;
-		}
-		if (file.size != table->length) {
-			ACPI_INVALID_TABLE("File length does not match table length",
-				      cpio_path, file.name);
-			continue;
-		}
-		if (acpi_table_checksum(file.data, table->length)) {
-			ACPI_INVALID_TABLE("Bad table checksum",
-				      cpio_path, file.name);
-			continue;
-		}
 
 		pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
 			table->signature, cpio_path, file.name, table->length);
-- 
1.7.1

