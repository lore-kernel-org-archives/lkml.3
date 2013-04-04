Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587Ab3DDXvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:51:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43400 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764941Ab3DDXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 06/22] x86, ACPI: Split acpi_initrd_override to find/copy two functions
Date: Thu,  4 Apr 2013 16:46:10 -0700
Message-Id: <1365119186-23487-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

While a dummy version of acpi_initrd_override() was defined when
!CONFIG_ACPI_INITRD_TABLE_OVERRIDE, the prototype and dummy version
were conditionalized inside CONFIG_ACPI.  This forced setup_arch() to
have its own #ifdefs around acpi_initrd_override() as otherwise build
would fail when !CONFIG_ACPI.  Move the prototypes and dummy
implementations of the newly split functions below CONFIG_ACPI block
in acpi.h so that we can do away with #ifdefs in its user.

-v2: Split one patch out according to tj.
     also don't pass table_nr around.
-v3: Add Tj's changelog about moving down to #idef in acpi.h to
     avoid #idef in setup.c

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup.c |  6 +++---
 drivers/acpi/osl.c      | 18 +++++++++++++-----
 include/linux/acpi.h    | 16 ++++++++--------
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
index a5a9346..21714fb 100644
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
@@ -652,9 +658,11 @@ void __init acpi_initrd_override(void *data, size_t size)
 	 * tables one time, we will hit the limit. Need to map table
 	 * one by one during copying.
 	 */
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
1.8.1.4

