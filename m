Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaFMLDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:03:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49803 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaFMLDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:03:30 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org, Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v3 5/5] acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI context.
Date: Fri, 13 Jun 2014 13:03:00 +0200
Message-Id: <1402657380-18539-6-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GHES currently maps two pages with atomic_ioremap.  From now
on, NMI is optional so there is no need to allocate an NMI page
for platforms without NMI support.

To make it possible to not use a second page, swap the existing
page order so that the IRQ context page is first, and the optional
NMI context page is second.  Then, use ARCH_HAS_ACPI_APEI_NMI to decide
at runtime how many pages are to be allocated.  Finally, put in
sanity checks to avoid accessing unallocated memory.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/kernel/acpi/apei.c |    6 ++++++
 drivers/acpi/apei/ghes.c    |   16 ++++++++--------
 include/acpi/apei.h         |    1 +
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
index 221a3a6..842d158 100644
--- a/arch/x86/kernel/acpi/apei.c
+++ b/arch/x86/kernel/acpi/apei.c
@@ -79,3 +79,9 @@ void arch_apei_nmi_oops_begin(void)
 {
 	oops_begin();
 }
+
+void arch_apei_flush_tlb_one(unsigned long addr)
+{
+	__flush_tlb_one(addr);
+}
+EXPORT_SYMBOL_GPL(arch_apei_flush_tlb_one);
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 21aeac5..93a4d0b 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -113,12 +113,11 @@ static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
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
+#define GHES_IOREMAP_IRQ_PAGE(base)	(base)
+#define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
 
 /* virtual memory area for atomic ioremap */
 static struct vm_struct *ghes_ioremap_area;
@@ -155,7 +154,8 @@ static struct ghes_notify_setup	ghes_notify_tab[];
 
 static int ghes_ioremap_init(void)
 {
-	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
+	ghes_ioremap_area = __get_vm_area(
+		PAGE_SIZE * (IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI) ? 2 : 1),
 		VM_IOREMAP, VMALLOC_START, VMALLOC_END);
 	if (!ghes_ioremap_area) {
 		pr_err(GHES_PFX "Failed to allocate virtual memory area for atomic ioremap.\n");
@@ -199,7 +199,7 @@ static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
@@ -209,7 +209,7 @@ static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
 
 	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
 	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
-	__flush_tlb_one(vaddr);
+	arch_apei_flush_tlb_one(vaddr);
 }
 
 static int ghes_estatus_pool_init(void)
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 348e1ea..ff2bb7e 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -51,6 +51,7 @@ int arch_apei_register_nmi(int (*nmi_handler)(unsigned int, struct pt_regs *),
 			   const char *name);
 void arch_apei_unregister_nmi(const char *name);
 void arch_apei_nmi_oops_begin(void);
+void arch_apei_flush_tlb_one(unsigned long addr);
 
 #endif
 #endif
-- 
1.7.9.5

