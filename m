Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3CJGql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19026 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3CJGqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 06/20] x86, ACPI: Store override acpi tables phys addr in cpio files info array
Date: Sat,  9 Mar 2013 22:44:33 -0800
Message-Id: <1362897887-30808-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 32bit we will find table with phys address during 32bit flat mode
in head_32.S, because at that time we don't need set page table to
access initrd.

For copying we could use early_ioremap() with phys directly before mem mapping
is set.

To keep 32bit and 64bit consistent, use phys_addr for all.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index d66ae0e..54bcc37 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -615,7 +615,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 			table->signature, cpio_path, file.name, table->length);
 
 		all_tables_size += table->length;
-		acpi_initrd_files[table_nr].data = file.data;
+		acpi_initrd_files[table_nr].data = (void *)__pa(file.data);
 		acpi_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
@@ -624,7 +624,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 void __init acpi_initrd_override_copy(void)
 {
 	int no, total_offset = 0;
-	char *p;
+	char *p, *q;
 
 	if (!all_tables_size)
 		return;
@@ -654,12 +654,20 @@ void __init acpi_initrd_override_copy(void)
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+		/*
+		 * have to use unsigned long, otherwise 32bit spit warning
+		 * and it is ok to unsigned long, as bootloader would not
+		 * load initrd above 4G for 32bit kernel.
+		 */
+		unsigned long addr = (unsigned long)acpi_initrd_files[no].data;
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
1.7.10.4

