Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaGVJUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:20:51 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49943 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaGVJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:20:43 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, rric@kernel.org
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v5 3/3] acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI context.
Date: Tue, 22 Jul 2014 11:20:13 +0200
Message-Id: <1406020813-9176-4-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GHES currently maps two pages with atomic_ioremap.  From now
on, NMI is architectural depended so there is no need to allocate
an NMI page for platforms without NMI support.

To make it possible to not use a second page, swap the existing
page order so that the IRQ context page is first, and the optional
NMI context page is second.  Then, use HAVE_ACPI_APEI_NMI to decide
how many pages are to be allocated.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/kernel/acpi/apei.c |  6 ++++++
 drivers/acpi/apei/ghes.c    | 18 +++++++++++-------
 include/acpi/apei.h         |  1 +
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
index 12b13de..c280df6 100644
--- a/arch/x86/kernel/acpi/apei.c
+++ b/arch/x86/kernel/acpi/apei.c
@@ -15,6 +15,7 @@
 #include <acpi/apei.h>
 
 #include <asm/mce.h>
+#include <asm/tlbflush.h>
 
 int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data)
 {
@@ -54,3 +55,8 @@ void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 	apei_mce_report_mem_error(sev, mem_err);
 #endif
 }
+
+void arch_apei_flush_tlb_one(unsigned long addr)
+{
+	__flush_tlb_one(addr);
+}
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 7fcf4d7..e05d84e7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -105,12 +105,16 @@ static DEFINE_MUTEX(ghes_list_mutex);
  */
 
 /*
- * Two virtual pages are used, one for NMI context, the other for
- * IRQ/PROCESS context
+ * Two virtual pages are used, one for IRQ/PROCESS context, the other for
+ * NMI context (optionally).
  */
-#define GHES_IOREMAP_PAGES		2
-#define GHES_IOREMAP_NMI_PAGE(base)	(base)
-#define GHES_IOREMAP_IRQ_PAGE(base)	((base) + PAGE_SIZE)
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+#define GHES_IOREMAP_PAGES           2
+#else
+#define GHES_IOREMAP_PAGES           1
+#endif
+#define GHES_IOREMAP_IRQ_PAGE(base)	(base)
+#define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
 
 /* virtual memory area for atomic ioremap */
 static struct vm_struct *ghes_ioremap_area;
@@ -173,7 +177,7 @@ static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
@@ -183,7 +187,7 @@ static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static int ghes_estatus_pool_init(void)
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 8a23c95..76284bb 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -44,6 +44,7 @@ int erst_clear(u64 record_id);
 
 int arch_apei_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data);
 void arch_apei_report_mem_error(int sev, struct cper_sec_mem_err *mem_err);
+void arch_apei_flush_tlb_one(unsigned long addr);
 
 #endif
 #endif
-- 
1.9.1

