Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JXOyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab3JXOyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:54:45 -0400
Message-ID: <1382626457.1768.80.camel@deneb.redhat.com>
Subject: [PATCH v2] arm64: allow ioremap_cache() to use existing RAM mappings
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Oct 2013 10:54:17 -0400
In-Reply-To: <20131023143717.GA19317@mbp>
References: <1382362594-24947-1-git-send-email-msalter@redhat.com>
	 <1382519898.10408.1.camel@mbp> <1382535972.1768.68.camel@deneb.redhat.com>
	 <20131023143717.GA19317@mbp>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers (ACPI notably) use ioremap_cache() to map an area which could
either be outside of kernel RAM or in an already mapped reserved area of
RAM. To avoid aliases with different caching attributes, ioremap() does
not allow RAM to be remapped. But for ioremap_cache(), the existing kernel
mapping may be used.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/include/asm/io.h |  2 +-
 arch/arm64/mm/ioremap.c     | 20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

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
index 1725cd6..2bb1d58 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -77,8 +77,24 @@ EXPORT_SYMBOL(__ioremap);
 
 void __iounmap(volatile void __iomem *io_addr)
 {
-	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
+	unsigned long addr = (unsigned long)io_addr & PAGE_MASK;
 
-	vunmap(addr);
+	/*
+	 * We could get an address outside vmalloc range in case
+	 * of ioremap_cache() reusing a RAM mapping.
+	 */
+	if (VMALLOC_START <= addr && addr < VMALLOC_END)
+		vunmap((void *)addr);
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



