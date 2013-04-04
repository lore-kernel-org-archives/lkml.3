Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765622Ab3DDXw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:52:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43394 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765042Ab3DDXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 07/22] x86, ACPI: Store override acpi tables phys addr in cpio files info array
Date: Thu,  4 Apr 2013 16:46:11 -0700
Message-Id: <1365119186-23487-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 32bit we will find table with phys address during 32bit flat mode
in head_32.S, because at that time we don't need set page table to
access initrd.

For copying we could use early_ioremap() with phys directly before mem mapping
is set.

To keep 32bit and 64bit consistent, use phys_addr for all.

-v2: introduce file_pos to save phys address instead of abusing cpio_data
	that tj is not happy with.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 21714fb..ee5c531 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -570,7 +570,11 @@ static const char * const table_sigs[] = {
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
 #define ACPI_OVERRIDE_TABLES 64
-static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
+struct file_pos {
+	phys_addr_t data;
+	phys_addr_t size;
+};
+static struct file_pos __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
 
 void __init acpi_initrd_override_find(void *data, size_t size)
 {
@@ -615,7 +619,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 			table->signature, cpio_path, file.name, table->length);
 
 		all_tables_size += table->length;
-		acpi_initrd_files[table_nr].data = file.data;
+		acpi_initrd_files[table_nr].data = __pa_nodebug(file.data);
 		acpi_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
@@ -624,7 +628,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 void __init acpi_initrd_override_copy(void)
 {
 	int no, total_offset = 0;
-	char *p;
+	char *p, *q;
 
 	if (!all_tables_size)
 		return;
@@ -659,12 +663,15 @@ void __init acpi_initrd_override_copy(void)
 	 * one by one during copying.
 	 */
 	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+		phys_addr_t addr = acpi_initrd_files[no].data;
 		phys_addr_t size = acpi_initrd_files[no].size;
 
 		if (!size)
 			break;
+		q = early_ioremap(addr, size);
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
-		memcpy(p, acpi_initrd_files[no].data, size);
+		memcpy(p, q, size);
+		early_iounmap(q, size);
 		early_iounmap(p, size);
 		total_offset += size;
 	}
-- 
1.8.1.4

