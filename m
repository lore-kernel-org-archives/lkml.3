Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaIMSh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:37:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaIMSh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897157"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 1/6] x86/efi: find mem descriptor from phys address
Date: Sat, 13 Sep 2014 11:36:11 -0700
Message-Id: <1410633376-8822-2-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several functions (efi_mem_type, efi_mem_attributes,
efi_lookup_mapped_addr) scan the memory map looking for the memory
descriptor to which a given physical address belongs for various
purposes.

The scan functionality is duplicated in all the three functions. The
common functionality is consolidated into a single function that three
functions mentioned above may call.

When checking the validity of the validity of the memory map, use
efi_enabled(), provided for this purpose.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 21 ++++++++++++++++++++-
 include/linux/efi.h         |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94..782d617 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -900,8 +900,27 @@ void __init efi_enter_virtual_mode(void)
 }
 
 /*
- * Convenience functions to obtain memory types and attributes
+ * Convenience functions to obtain memory descriptors,
+ * memory types and attributes
  */
+efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return NULL;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md;
+	}
+	return NULL;
+}
+
 u32 efi_mem_type(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45cb4ff..b36b588 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -866,6 +866,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
+extern efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
 extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
-- 
1.9.1

