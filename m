Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3FNVbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:31:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3FNVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:31:47 -0400
Date: Fri, 14 Jun 2013 14:31:31 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-7a309b8608958c40bb7f82ac83532a44b09deae2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de, rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-6-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-6-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI:
  Increase acpi initrd override tables number limit
Git-Commit-ID: 7a309b8608958c40bb7f82ac83532a44b09deae2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a309b8608958c40bb7f82ac83532a44b09deae2
Gitweb:     http://git.kernel.org/tip/7a309b8608958c40bb7f82ac83532a44b09deae2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:52 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:03:57 -0700

x86, ACPI: Increase acpi initrd override tables number limit

Current number of acpi tables in initrd is limited to 10, which is
too small. 64 would be good enough as we have 35 sigs and could
have several SSDTs.

Two problems in current code prevent us from increasing the 10 tables limit:
1. cpio file info array is put in stack, as every element is 32 bytes, we
   could run out of stack if we increase the array size to 64.
   So we can move it out from stack, and make it global and put it in
   __initdata section.
2. early_ioremap only can remap 256kb one time. Current code is mapping
   10 tables one time. If we increase that limit, the whole size could be
   more than 256kb, and early_ioremap will fail.
   So we can map the tables one by one during copying, instead of mapping
   all of them at one time.

-v2: According to tj, split it out to separated patch, also
     rename array name to acpi_initrd_files.
-v3: Add some comments about mapping table one by one during copying
     per tj.

Signed-off-by: Yinghai <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-6-git-send-email-tangchen@cn.fujitsu.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/acpi/osl.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 42c48fc..53dd490 100644
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
 	memblock_reserve(acpi_tables_addr, all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
-	p = early_ioremap(acpi_tables_addr, all_tables_size);
-
+	/*
+	 * early_ioremap can only remap 256KB at one time. If we map all the
+	 * tables at one time, we will hit the limit. So we need to map tables
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
 
