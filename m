Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765548Ab3DDXuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:50:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43407 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765130Ab3DDXr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 05/22] x86, ACPI: Increase override tables number limit
Date: Thu,  4 Apr 2013 16:46:09 -0700
Message-Id: <1365119186-23487-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current acpi tables in initrd is limited to 10, that is too small.
64 should be good enough as we have 35 sigs and could have several
SSDT.

Two problems in current code prevent us from increasing limit:
1. that cpio file info array is put in stack, as every element is 32
   bytes, could run out of stack if we have that array size to 64.
   We can move it out from stack, and make it as global and put it in
   __initdata section.
2. early_ioremap only can remap 256k one time. Current code is mapping
   10 tables one time. If we increase that limit, whole size could be
   more than 256k, early_ioremap will fail with that.
   We can map table one by one during copying, instead of mapping
   all them one time.

-v2: According to tj, split it out to separated patch, also
     rename array name to acpi_initrd_files.
-v3: Add some comments about mapping table one by one during copying
     per tj.

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/acpi/osl.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index c08cdb6..a5a9346 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -569,8 +569,8 @@ static const char * const table_sigs[] = {
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
-/* Must not increase 10 or needs code modification below */
-#define ACPI_OVERRIDE_TABLES 10
+#define ACPI_OVERRIDE_TABLES 64
+static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
 
 void __init acpi_initrd_override(void *data, size_t size)
 {
@@ -579,7 +579,6 @@ void __init acpi_initrd_override(void *data, size_t size)
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
 	struct cpio_data file;
-	struct cpio_data early_initrd_files[ACPI_OVERRIDE_TABLES];
 	char *p;
 
 	if (data == NULL || size == 0)
@@ -617,8 +616,8 @@ void __init acpi_initrd_override(void *data, size_t size)
 			table->signature, cpio_path, file.name, table->length);
 
 		all_tables_size += table->length;
-		early_initrd_files[table_nr].data = file.data;
-		early_initrd_files[table_nr].size = file.size;
+		acpi_initrd_files[table_nr].data = file.data;
+		acpi_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
 	if (table_nr == 0)
@@ -648,14 +647,19 @@ void __init acpi_initrd_override(void *data, size_t size)
 	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
-	p = early_ioremap(acpi_tables_addr, all_tables_size);
-
+	/*
+	 * early_ioremap only can remap 256k one time. If we map all
+	 * tables one time, we will hit the limit. Need to map table
+	 * one by one during copying.
+	 */
 	for (no = 0; no < table_nr; no++) {
-		memcpy(p + total_offset, early_initrd_files[no].data,
-		       early_initrd_files[no].size);
-		total_offset += early_initrd_files[no].size;
+		phys_addr_t size = acpi_initrd_files[no].size;
+
+		p = early_ioremap(acpi_tables_addr + total_offset, size);
+		memcpy(p, acpi_initrd_files[no].data, size);
+		early_iounmap(p, size);
+		total_offset += size;
 	}
-	early_iounmap(p, all_tables_size);
 }
 #endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
 
-- 
1.8.1.4

