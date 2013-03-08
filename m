Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3CHFBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:01:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760202Ab3CHE7r (ORCPT
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
Subject: [PATCH 04/14] x86, ACPI: make acpi override finding work with 32bit flat mode
Date: Thu,  7 Mar 2013 20:58:30 -0800
Message-Id: <1362718720-27048-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will find acpi tables in initrd during head_32.S in 32bit flat mode.

So need acpi_initrd_override_find could take phys directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/kernel/setup.c |    2 +-
 drivers/acpi/osl.c      |   84 +++++++++++++++++++++++++++++++----------------
 include/linux/acpi.h    |    4 +--
 3 files changed, 58 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e2913e9..668e658 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1093,7 +1093,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 	acpi_initrd_override_find((void *)initrd_start,
-					initrd_end - initrd_start);
+					initrd_end - initrd_start, false);
 	acpi_initrd_override_copy();
 
 	reserve_crashkernel();
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 60317ea..b375159 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -552,38 +552,47 @@ u8 __init acpi_table_checksum(u8 *buffer, u32 length)
 	return sum;
 }
 
-/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
-static const char * const table_sigs[] = {
-	ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
-	ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
-	ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
-	ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
-	ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
-	ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
-	ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
-	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
-	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
-
 /* Non-fatal errors: Affected tables/files are ignored */
 #define INVALID_TABLE(x, path, name)					\
-	{ pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
+	do { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); } while (0)
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
 #define ACPI_OVERRIDE_TABLES 64
 static struct cpio_data __initdata early_initrd_files[ACPI_OVERRIDE_TABLES];
 
-void __init acpi_initrd_override_find(void *data, size_t size)
+void __init acpi_initrd_override_find(void *data, size_t size, bool is_phys)
 {
 	int sig, no;
 	long offset = 0;
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
 	struct cpio_data file;
+	struct cpio_data *files = early_initrd_files;
+	int *all_tables_size_p = &all_tables_size;
+	int *table_nr_p = &table_nr;
+
+	/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
+	char *table_sigs[] = {
+		ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
+		ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
+		ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
+		ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
+		ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
+		ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
+		ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
+		ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
+		ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
 
 	if (data == NULL || size == 0)
 		return;
 
+	if (is_phys) {
+		files = (struct cpio_data *)__pa_symbol(early_initrd_files);
+		all_tables_size_p = (int *)__pa_symbol(&all_tables_size);
+		table_nr_p = (int *)__pa_symbol(&table_nr);
+	}
+
 	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
 		file = find_cpio_data(cpio_path, data, size, &offset);
 		if (!file.data)
@@ -592,9 +601,12 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 		data += offset;
 		size -= offset;
 
-		if (file.size < sizeof(struct acpi_table_header))
-			INVALID_TABLE("Table smaller than ACPI header",
+		if (file.size < sizeof(struct acpi_table_header)) {
+			if (!is_phys)
+				INVALID_TABLE("Table smaller than ACPI header",
 				      cpio_path, file.name);
+			continue;
+		}
 
 		table = file.data;
 
@@ -602,23 +614,34 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 			if (!memcmp(table->signature, table_sigs[sig], 4))
 				break;
 
-		if (!table_sigs[sig])
-			INVALID_TABLE("Unknown signature",
+		if (!table_sigs[sig]) {
+			if (!is_phys)
+				 INVALID_TABLE("Unknown signature",
 				      cpio_path, file.name);
-		if (file.size != table->length)
-			INVALID_TABLE("File length does not match table length",
+			continue;
+		}
+		if (file.size != table->length) {
+			if (!is_phys)
+				INVALID_TABLE("File length does not match table length",
 				      cpio_path, file.name);
-		if (acpi_table_checksum(file.data, table->length))
-			INVALID_TABLE("Bad table checksum",
+			continue;
+		}
+		if (acpi_table_checksum(file.data, table->length)) {
+			if (!is_phys)
+				INVALID_TABLE("Bad table checksum",
 				      cpio_path, file.name);
+			continue;
+		}
 
-		pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
+		if (!is_phys)
+			pr_info("%4.4s ACPI table found in initrd [%s%s][0x%x]\n",
 			table->signature, cpio_path, file.name, table->length);
 
-		all_tables_size += table->length;
-		early_initrd_files[table_nr].data = (void *)__pa(file.data);
-		early_initrd_files[table_nr].size = file.size;
-		table_nr++;
+		(*all_tables_size_p) += table->length;
+		files[*table_nr_p].data = is_phys ?
+					    file.data : (void *)__pa(file.data);
+		files[*table_nr_p].size = file.size;
+		(*table_nr_p)++;
 	}
 }
 
@@ -654,11 +677,14 @@ void __init acpi_initrd_override_copy(void)
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	for (no = 0; no < table_nr; no++) {
+		unsigned long phys_addr = (unsigned long)early_initrd_files[no].data;
 		unsigned long size = early_initrd_files[no].size;
 
+		q = early_ioremap(phys_addr, size);
+		pr_info("%4.4s ACPI table found in initrd [%#010lx-%#010lx]\n",
+				((struct acpi_table_header *)q)->signature,
+				phys_addr, phys_addr + size - 1);
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
-		q = early_ioremap((unsigned long)early_initrd_files[no].data,
-					 size);
 		memcpy(p, q, size);
 		early_iounmap(q, size);
 		early_iounmap(p, size);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1654a241..46a8a89 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -478,10 +478,10 @@ static inline bool acpi_driver_match_device(struct device *dev,
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
-void acpi_initrd_override_find(void *data, size_t size);
+void acpi_initrd_override_find(void *data, size_t size, bool is_phys);
 void acpi_initrd_override_copy(void);
 #else
-static inline void acpi_initrd_override_find(void *data, size_t size) { }
+static inline void acpi_initrd_override_find(void *data, size_t size, bool is_phys) { }
 static inline void acpi_initrd_override_copy(void) { }
 #endif
 
-- 
1.7.10.4

