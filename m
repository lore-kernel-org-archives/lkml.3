Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3CJGqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48116 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3CJGq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 05/20] x86, ACPI: Split acpi_initrd_override to find/copy two functions
Date: Sat,  9 Mar 2013 22:44:32 -0800
Message-Id: <1362897887-30808-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To parse srat early, we need to move acpi table probing early.
acpi_initrd_table_override is before acpi table probing. So we need to
move it early too.

Current code acpi_initrd_table_override is after init_mem_mapping and
relocate_initrd(), so it can scan initrd and copy acpi tables with kernel
virtual address of initrd.
Copying need to be after memblock is ready, because it need to allocate
buffer for new acpi tables.

So we have to split that function to find and copy two functions.
Find should be as early as possible. Copy should be after memblock is ready.

Finding could be done in head_32.S and head64.c, just like microcode
early scanning. In head_32.S, it is 32bit flat mode, we don't
need to set page table to access it. In head64.c, #PF set page table
could help us access initrd with kernel low mapping address.

Copying could be done just after memblock is ready and before probing
acpi tables, and we need to early_ioremap to access source and target
range, as init_mem_mapping is not called yet.

Also move down two functions declaration to avoid #ifdef in setup.c

ACPI_INITRD_TABLE_OVERRIDE depends one ACPI and BLK_DEV_INITRD.
So could move declaration out from #ifdef CONFIG_ACPI protection.

-v2: Split one patch out according to tj.
     also don't pass table_nr around.

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/kernel/setup.c |    6 +++---
 drivers/acpi/osl.c      |   18 +++++++++++++-----
 include/linux/acpi.h    |   16 ++++++++--------
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e75c6e6..d0cc176 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1092,9 +1092,9 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
-	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
-#endif
+	acpi_initrd_override_find((void *)initrd_start,
+					initrd_end - initrd_start);
+	acpi_initrd_override_copy();
 
 	reserve_crashkernel();
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 8aaf721..d66ae0e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -572,14 +572,13 @@ static const char * const table_sigs[] = {
 #define ACPI_OVERRIDE_TABLES 64
 static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
 
-void __init acpi_initrd_override(void *data, size_t size)
+void __init acpi_initrd_override_find(void *data, size_t size)
 {
-	int sig, no, table_nr = 0, total_offset = 0;
+	int sig, no, table_nr = 0;
 	long offset = 0;
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
 	struct cpio_data file;
-	char *p;
 
 	if (data == NULL || size == 0)
 		return;
@@ -620,7 +619,14 @@ void __init acpi_initrd_override(void *data, size_t size)
 		acpi_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
-	if (table_nr == 0)
+}
+
+void __init acpi_initrd_override_copy(void)
+{
+	int no, total_offset = 0;
+	char *p;
+
+	if (!all_tables_size)
 		return;
 
 	/* under 4G at first, then above 4G */
@@ -647,9 +653,11 @@ void __init acpi_initrd_override(void *data, size_t size)
 	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
-	for (no = 0; no < table_nr; no++) {
+	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
 		phys_addr_t size = acpi_initrd_files[no].size;
 
+		if (!size)
+			break;
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
 		memcpy(p, acpi_initrd_files[no].data, size);
 		early_iounmap(p, size);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index bcbdd74..1654a241 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -79,14 +79,6 @@ typedef int (*acpi_tbl_table_handler)(struct acpi_table_header *table);
 typedef int (*acpi_tbl_entry_handler)(struct acpi_subtable_header *header,
 				      const unsigned long end);
 
-#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
-void acpi_initrd_override(void *data, size_t size);
-#else
-static inline void acpi_initrd_override(void *data, size_t size)
-{
-}
-#endif
-
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
@@ -485,6 +477,14 @@ static inline bool acpi_driver_match_device(struct device *dev,
 
 #endif	/* !CONFIG_ACPI */
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+void acpi_initrd_override_find(void *data, size_t size);
+void acpi_initrd_override_copy(void);
+#else
+static inline void acpi_initrd_override_find(void *data, size_t size) { }
+static inline void acpi_initrd_override_copy(void) { }
+#endif
+
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
-- 
1.7.10.4

