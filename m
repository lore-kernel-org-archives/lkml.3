Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3FYSG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:06:59 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:34248 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3FYSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:06:22 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org, hpa@linux.intel.com,
        tglx@linutronix.de, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to generic code
Date: Tue, 25 Jun 2013 19:11:01 +0100
Message-Id: <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efi_lookup_mapped_addr is a handy helper function for translating
a physical address to the corresponding virtual one by scanning
through memmap.map.

This patch breaks it out into a new file for use elsewhere.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/x86/platform/efi/efi.c       |   28 ----------------------------
 drivers/firmware/efi/Makefile     |    2 +-
 drivers/firmware/efi/efi-helper.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 29 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-helper.c

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5ae2eb0..d1a1b6b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -814,34 +814,6 @@ static void __init runtime_code_page_mkexec(void)
 	}
 }
 
-/*
- * We can't ioremap data in EFI boot services RAM, because we've already mapped
- * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
- * callable after efi_enter_virtual_mode and before efi_free_boot_services.
- */
-void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
-{
-	void *p;
-	if (WARN_ON(!memmap.map))
-		return NULL;
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
-		u64 end = md->phys_addr + size;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-		if (!md->virt_addr)
-			continue;
-		if (phys_addr >= md->phys_addr && phys_addr < end) {
-			phys_addr += md->virt_addr - md->phys_addr;
-			return (__force void __iomem *)(unsigned long)phys_addr;
-		}
-	}
-	return NULL;
-}
-
 void efi_memory_uc(u64 addr, unsigned long size)
 {
 	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 99245ab..629a513 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,6 +1,6 @@
 #
 # Makefile for linux kernel
 #
-obj-y					+= efi.o vars.o
+obj-y					+= efi.o vars.o efi-helper.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/efi-helper.c b/drivers/firmware/efi/efi-helper.c
new file mode 100644
index 0000000..c5c2c72
--- /dev/null
+++ b/drivers/firmware/efi/efi-helper.c
@@ -0,0 +1,33 @@
+/*
+ * Common [U]EFI support helper functions across architectures.
+ */
+
+#include <linux/efi.h>
+
+/*
+ * We can't ioremap data in EFI boot services RAM, because we've already mapped
+ * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
+ * callable after efi_enter_virtual_mode and before efi_free_boot_services.
+ */
+void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
+{
+	void *p;
+	if (WARN_ON(!memmap.map))
+		return NULL;
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 end = md->phys_addr + size;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		if (!md->virt_addr)
+			continue;
+		if (phys_addr >= md->phys_addr && phys_addr < end) {
+			phys_addr += md->virt_addr - md->phys_addr;
+			return (__force void __iomem *)(unsigned long)phys_addr;
+		}
+	}
+	return NULL;
+}
-- 
1.7.10.4

