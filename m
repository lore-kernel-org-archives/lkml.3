Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3JUNhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3JUNhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:37:12 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: allow ioremap_cache() to use existing RAM mappings
Date: Mon, 21 Oct 2013 09:36:34 -0400
Message-Id: <1382362594-24947-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers (ACPI notably) use ioremap_cache() to map an area which could
either be outside of kernel RAM or in an already mapped reserved area of
RAM. To avoid aliases, __ioremap() does not allow RAM to be remapped. But
for ioremap_cache(), the existing kernel mapping may be used.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/include/asm/io.h |  2 +-
 arch/arm64/mm/ioremap.c     | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 1d12f89..b56e5b5 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -224,6 +224,7 @@ extern void __memset_io(volatile void __iomem *, int, size_t);
  */
 extern void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot);
 extern void __iounmap(volatile void __iomem *addr);
+extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 
 #define PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY)
 #define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
@@ -233,7 +234,6 @@ extern void __iounmap(volatile void __iomem *addr);
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
-#define ioremap_cached(addr, size)	__ioremap((addr), (size), __pgprot(PROT_NORMAL))
 #define iounmap				__iounmap
 
 #define PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF)
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 1725cd6..fb44b3d 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -79,6 +79,21 @@ void __iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
 
+	/* Nothing to do for normal memory. See ioremap_cache() */
+	if (pfn_valid(__virt_to_phys(addr) >> PAGE_SHIFT))
+		return;
+
 	vunmap(addr);
 }
 EXPORT_SYMBOL(__iounmap);
+
+void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
+{
+	/* For normal memory we already have a cacheable mapping. */
+	if (pfn_valid(__phys_to_pfn(phys_addr)))
+		return (void __iomem *)__phys_to_virt(phys_addr);
+
+	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
+				__builtin_return_address(0));
+}
+EXPORT_SYMBOL(ioremap_cache);
-- 
1.8.3.1

