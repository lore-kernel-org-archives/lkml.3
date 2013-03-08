Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3CHFDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:03:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab3CHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH 03/14] x86, ACPI: store override acpi tables phys addr
Date: Thu,  7 Mar 2013 20:58:29 -0800
Message-Id: <1362718720-27048-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As later 32bit only find table with phys address during 32bit flat mode
in head_32.S.

To keep 32bit and 64 bit consistent, use phys_addr for all.

Use early_ioremap to access during copying.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index b9d2ff0..60317ea 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -616,7 +616,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 			table->signature, cpio_path, file.name, table->length);
 
 		all_tables_size += table->length;
-		early_initrd_files[table_nr].data = file.data;
+		early_initrd_files[table_nr].data = (void *)__pa(file.data);
 		early_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
@@ -625,7 +625,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 void __init acpi_initrd_override_copy(void)
 {
 	int no, total_offset = 0;
-	char *p;
+	char *p, *q;
 
 	if (!table_nr)
 		return;
@@ -654,10 +654,13 @@ void __init acpi_initrd_override_copy(void)
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	for (no = 0; no < table_nr; no++) {
-		size_t size = early_initrd_files[no].size;
+		unsigned long size = early_initrd_files[no].size;
 
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
-		memcpy(p, early_initrd_files[no].data, size);
+		q = early_ioremap((unsigned long)early_initrd_files[no].data,
+					 size);
+		memcpy(p, q, size);
+		early_iounmap(q, size);
 		early_iounmap(p, size);
 		total_offset += size;
 	}
-- 
1.7.10.4

