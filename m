Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850Ab3GSIBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:01:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759852Ab3GSIBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947437"
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
Subject: [PATCH 05/21] acpi: Introduce acpi_invalid_table() to check if a table is invalid.
Date: Fri, 19 Jul 2013 15:59:18 +0800
Message-Id: <1374220774-29974-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:45,
	Serialize complete at 2013/07/19 15:58:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_initrd_override(), it checks several things to ensure the
table it found is valid. In later patches, we need to do these check
somewhere else. So this patch introduces a common function
acpi_invalid_table() to do all these checks, and reuse it in different
places. The function will be used in the subsequent patches.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/osl.c |   82 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 91d9f54..4531920 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -572,9 +572,64 @@ static const char * const table_sigs[] = {
 /* Must not increase 10 or needs code modification below */
 #define ACPI_OVERRIDE_TABLES 10
 
+/**
+ * acpi_invalid_table - Check if an acpi table found in initrd is invalid.
+ * @file: The cpio file returned by find_cpio_data().
+ * @path: The path storing acpi overriding tables in cpio file.
+ * @signature: The table signature to be checked.
+ *
+ * @signature can be NULL. If it is NULL, the function will check if the
+ * table signature matches any signature in table_sigs[].
+ *
+ * Return 0 if it passes all the checks, -EINVAL if any check fails.
+ */
+int __init acpi_invalid_table(struct cpio_data *file,
+			      const char *path, const char *signature)
+{
+	int idx;
+	struct acpi_table_header *table = file->data;
+
+	if (file->size < sizeof(struct acpi_table_header)) {
+		INVALID_TABLE("Table smaller than ACPI header",
+			      path, file->name);
+		return -EINVAL;
+	}
+
+	if (signature) {
+		if (memcmp(table->signature, signature, 4)) {
+			INVALID_TABLE("Table signature does not match",
+				      path, file->name);
+			return -EINVAL;
+		}
+	} else {
+		for (idx = 0; table_sigs[idx]; idx++)
+			if (!memcmp(table->signature, table_sigs[idx], 4))
+				break;
+
+		if (!table_sigs[idx]) {
+			INVALID_TABLE("Unknown signature", path, file->name);
+			return -EINVAL;
+		}
+	}
+
+	if (file->size != table->length) {
+		INVALID_TABLE("File length does not match table length",
+			      path, file->name);
+		return -EINVAL;
+	}
+
+	if (acpi_table_checksum(file->data, table->length)) {
+		INVALID_TABLE("Bad table checksum",
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
@@ -593,33 +648,10 @@ void __init acpi_initrd_override(void *data, size_t size)
 		data += offset;
 		size -= offset;
 
-		if (file.size < sizeof(struct acpi_table_header)) {
-			INVALID_TABLE("Table smaller than ACPI header",
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
-			INVALID_TABLE("Unknown signature",
-				      cpio_path, file.name);
-			continue;
-		}
-		if (file.size != table->length) {
-			INVALID_TABLE("File length does not match table length",
-				      cpio_path, file.name);
-			continue;
-		}
-		if (acpi_table_checksum(file.data, table->length)) {
-			INVALID_TABLE("Bad table checksum",
-				      cpio_path, file.name);
+		if (acpi_invalid_table(&file, cpio_path, NULL))
 			continue;
-		}
 
 		pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
 			table->signature, cpio_path, file.name, table->length);
-- 
1.7.1

