Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3CHFBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:01:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185Ab3CHE7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH 02/14] x86, ACPI: Split find/copy from acpi_initrd_override
Date: Thu,  7 Mar 2013 20:58:28 -0800
Message-Id: <1362718720-27048-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To parse srat early, we will need to move acpi table probing early.
and to keep acpi_initrd_table_override working, we need to move it
ahead.

But current that is called after init_mem_mapping and relocate_initrd().

Copying need to be after memblock is ready, because it need to allocate
some buffer for acpi tables.

Finding will be moved into head_32.S and head64.c, just like microcode
early scanning.

So split them at first.

Also move down functions declaration to avoid #ifdef in setup.c

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/kernel/setup.c |    6 +++---
 drivers/acpi/osl.c      |   32 +++++++++++++++++++-------------
 include/linux/acpi.h    |   16 ++++++++--------
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4dcaae7..e2913e9 100644
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
index c9e36d7..b9d2ff0 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -539,6 +539,7 @@ acpi_os_predefined_override(const struct acpi_predefined_names *init_val,
 
 static u64 acpi_tables_addr;
 static int all_tables_size;
+static int table_nr;
 
 /* Copied from acpica/tbutils.c:acpi_tb_checksum() */
 u8 __init acpi_table_checksum(u8 *buffer, u32 length)
@@ -569,18 +570,16 @@ static const char * const table_sigs[] = {
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
-/* Must not increase 10 or needs code modification below */
-#define ACPI_OVERRIDE_TABLES 10
+#define ACPI_OVERRIDE_TABLES 64
+static struct cpio_data __initdata early_initrd_files[ACPI_OVERRIDE_TABLES];
 
-void __init acpi_initrd_override(void *data, size_t size)
+void __init acpi_initrd_override_find(void *data, size_t size)
 {
-	int sig, no, table_nr = 0, total_offset = 0;
+	int sig, no;
 	long offset = 0;
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
 	struct cpio_data file;
-	struct cpio_data early_initrd_files[ACPI_OVERRIDE_TABLES];
-	char *p;
 
 	if (data == NULL || size == 0)
 		return;
@@ -621,7 +620,14 @@ void __init acpi_initrd_override(void *data, size_t size)
 		early_initrd_files[table_nr].size = file.size;
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
+	if (!table_nr)
 		return;
 
 	/* under 4G at first, then above 4G */
@@ -647,14 +653,14 @@ void __init acpi_initrd_override(void *data, size_t size)
 	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
-	p = early_ioremap(acpi_tables_addr, all_tables_size);
-
 	for (no = 0; no < table_nr; no++) {
-		memcpy(p + total_offset, early_initrd_files[no].data,
-		       early_initrd_files[no].size);
-		total_offset += early_initrd_files[no].size;
+		size_t size = early_initrd_files[no].size;
+
+		p = early_ioremap(acpi_tables_addr + total_offset, size);
+		memcpy(p, early_initrd_files[no].data, size);
+		early_iounmap(p, size);
+		total_offset += size;
 	}
-	early_iounmap(p, all_tables_size);
 }
 #endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
 
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

