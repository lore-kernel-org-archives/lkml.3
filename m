Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbbAHS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:56:34 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58749 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAHS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:56:33 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 3/8] efi: split off remapping code from efi_config_init()
Date: Thu,  8 Jan 2015 18:48:29 +0000
Message-Id: <1420742914-2404-4-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split of the remapping code from efi_config_init() so that the caller
can perform its own remapping. This is necessary to correctly handle
virtually remapped UEFI memory regions under kexec, as efi.systab will
have been updated to a virtual address.

Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 56 ++++++++++++++++++++++++++--------------------
 include/linux/efi.h        |  2 ++
 2 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b74d58..b7ba9d8ec4b0 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -293,29 +293,15 @@ static __init int match_config_table(efi_guid_t *guid,
 	return 0;
 }
 
-int __init efi_config_init(efi_config_table_type_t *arch_tables)
+int __init efi_config_parse_tables(void *config_tables, int count, int sz,
+				   efi_config_table_type_t *arch_tables)
 {
-	void *config_tables, *tablep;
-	int i, sz;
-
-	if (efi_enabled(EFI_64BIT))
-		sz = sizeof(efi_config_table_64_t);
-	else
-		sz = sizeof(efi_config_table_32_t);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = early_memremap(efi.systab->tables,
-				       efi.systab->nr_tables * sz);
-	if (config_tables == NULL) {
-		pr_err("Could not map Configuration table!\n");
-		return -ENOMEM;
-	}
+	void *tablep;
+	int i;
 
 	tablep = config_tables;
 	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
+	for (i = 0; i < count; i++) {
 		efi_guid_t guid;
 		unsigned long table;
 
@@ -328,8 +314,6 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_memunmap(config_tables,
-					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
 #endif
@@ -344,13 +328,37 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_memunmap(config_tables, efi.systab->nr_tables * sz);
-
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
-
 	return 0;
 }
 
+int __init efi_config_init(efi_config_table_type_t *arch_tables)
+{
+	void *config_tables;
+	int sz, ret;
+
+	if (efi_enabled(EFI_64BIT))
+		sz = sizeof(efi_config_table_64_t);
+	else
+		sz = sizeof(efi_config_table_32_t);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = early_memremap(efi.systab->tables,
+				       efi.systab->nr_tables * sz);
+	if (config_tables == NULL) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
+
+	ret = efi_config_parse_tables(config_tables, efi.systab->nr_tables, sz,
+				      arch_tables);
+
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
+	return ret;
+}
+
 #ifdef CONFIG_EFI_VARS_MODULE
 static int __init efi_load_efivars(void)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0238d612750e..5ffe5115951f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -875,6 +875,8 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
+extern int efi_config_parse_tables(void *config_tables, int count, int sz,
+				   efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
-- 
1.8.3.2

