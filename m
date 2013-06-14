Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3FNVcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3FNVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:15 -0400
Date: Fri, 14 Jun 2013 14:31:57 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-56cb257fee5a6e381452bc11fe47357b04cd085e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, trenn@suse.de, tglx@linutronix.de,
        hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, tglx@linutronix.de, trenn@suse.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-9-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-9-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI:
  Make acpi_initrd_override_find work with 32bit flat mode
Git-Commit-ID: 56cb257fee5a6e381452bc11fe47357b04cd085e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:32:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56cb257fee5a6e381452bc11fe47357b04cd085e
Gitweb:     http://git.kernel.org/tip/56cb257fee5a6e381452bc11fe47357b04cd085e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:55 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:04:06 -0700

x86, ACPI: Make acpi_initrd_override_find work with 32bit flat mode

For finding procedure, it would be easy to access initrd in 32bit flat
mode, as we don't need to setup page table. That is from head_32.S, and
microcode updating already use this trick.

This patch does the following:

1. Change acpi_initrd_override_find to use phys to access global variables.

2. Pass a bool parameter "is_phys" to acpi_initrd_override_find() because
   we cannot tell if it is a pa or a va through the address itself with
   32bit. Boot loader could load initrd above max_low_pfn.

3. Put table_sigs[] on stack, otherwise it is too messy to change string
   array to physaddr and still keep offset calculating correct. The size is
   about 36x4 bytes, and it is small to settle in stack.

4. Also rewrite the MACRO INVALID_TABLE to be in a do {...} while(0) loop
   so that it is more readable.

NOTE: Don't call printk as it uses global variables, so delay print
      during copying.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-9-git-send-email-tangchen@cn.fujitsu.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c |  2 +-
 drivers/acpi/osl.c      | 85 ++++++++++++++++++++++++++++++++++---------------
 include/linux/acpi.h    |  5 +--
 3 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 42f584c..142e042 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1120,7 +1120,7 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 	acpi_initrd_override_find((void *)initrd_start,
-					initrd_end - initrd_start);
+					initrd_end - initrd_start, false);
 	acpi_initrd_override_copy();
 
 	reserve_crashkernel();
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 42f79e3..23578e8 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -551,21 +551,9 @@ u8 __init acpi_table_checksum(u8 *buffer, u32 length)
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
 
@@ -576,17 +564,45 @@ struct file_pos {
 };
 static struct file_pos __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
 
-void __init acpi_initrd_override_find(void *data, size_t size)
+/*
+ * acpi_initrd_override_find() is called from head_32.S and head64.c.
+ * head_32.S calling path is with 32bit flat mode, so we can access
+ * initrd early without setting pagetable or relocating initrd. For
+ * global variables accessing, we need to use phys address instead of
+ * kernel virtual address, try to put table_sigs string array in stack,
+ * so avoid switching for it.
+ * Also don't call printk as it uses global variables.
+ */
+void __init acpi_initrd_override_find(void *data, size_t size, bool is_phys)
 {
 	int sig, no, table_nr = 0;
 	long offset = 0;
 	struct acpi_table_header *table;
 	char cpio_path[32] = "kernel/firmware/acpi/";
 	struct cpio_data file;
+	struct file_pos *files = acpi_initrd_files;
+	int *all_tables_size_p = &all_tables_size;
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
+		files = (struct file_pos *)__pa_symbol(acpi_initrd_files);
+		all_tables_size_p = (int *)__pa_symbol(&all_tables_size);
+	}
+
 	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
 		file = find_cpio_data(cpio_path, data, size, &offset);
 		if (!file.data)
@@ -595,9 +611,12 @@ void __init acpi_initrd_override_find(void *data, size_t size)
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
 
@@ -605,22 +624,33 @@ void __init acpi_initrd_override_find(void *data, size_t size)
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
-		acpi_initrd_files[table_nr].data = __pa_nodebug(file.data);
-		acpi_initrd_files[table_nr].size = file.size;
+		(*all_tables_size_p) += table->length;
+		files[table_nr].data = is_phys ? (phys_addr_t)file.data :
+						  __pa_nodebug(file.data);
+		files[table_nr].size = file.size;
 		table_nr++;
 	}
 }
@@ -670,6 +700,9 @@ void __init acpi_initrd_override_copy(void)
 			break;
 		q = early_ioremap(addr, size);
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
+		pr_info("%4.4s ACPI table found in initrd [%#010llx-%#010llx]\n",
+				((struct acpi_table_header *)q)->signature,
+				(u64)addr, (u64)(addr + size - 1));
 		memcpy(p, q, size);
 		early_iounmap(q, size);
 		early_iounmap(p, size);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 8dd917b..4e3731b 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -469,10 +469,11 @@ static inline bool acpi_driver_match_device(struct device *dev,
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
-void acpi_initrd_override_find(void *data, size_t size);
+void acpi_initrd_override_find(void *data, size_t size, bool is_phys);
 void acpi_initrd_override_copy(void);
 #else
-static inline void acpi_initrd_override_find(void *data, size_t size) { }
+static inline void acpi_initrd_override_find(void *data, size_t size,
+						 bool is_phys) { }
 static inline void acpi_initrd_override_copy(void) { }
 #endif
 
