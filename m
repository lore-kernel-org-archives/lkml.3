Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538AbaGPPw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:52:29 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:6362 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965323AbaGPPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:51:53 -0400
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <ralf@linux-mips.org>, <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <m.szyprowski@samsung.com>, <mina86@mina86.com>
CC: <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-arch@vger.kernel.org>
Subject: [PATCH 4/4] mips: dma: Add cma support
Date: Wed, 16 Jul 2014 16:51:32 +0100
Message-ID: <1405525892-60383-5-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds cma support to the mips architecture.

cma uses memblock. However, mips uses bootmem.
bootmem is informed about any regions reserved by memblock

dma api is modified to use cma reserved memory regions when available

Tested using cma_test. cma_test is a simple driver that assigns blocks
of memory from cma reserved sections.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 arch/mips/Kconfig            |  1 +
 arch/mips/include/asm/Kbuild |  1 +
 arch/mips/kernel/setup.c     |  9 +++++++++
 arch/mips/mm/dma-default.c   | 37 +++++++++++++++++++++++++------------
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 1f7bd32..7ebe54f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -30,6 +30,7 @@ config MIPS
 	select GENERIC_ATOMIC64 if !64BIT
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DMA_ATTRS
+	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DMA_API_DEBUG
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 0543918..552ed28 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,6 +1,7 @@
 # MIPS headers
 generic-y += cputime.h
 generic-y += current.h
+generic-y += dma-contiguous.h
 generic-y += emergency-restart.h
 generic-y += hash.h
 generic-y += local64.h
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index a842154..217928f 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -24,6 +24,8 @@
 #include <linux/debugfs.h>
 #include <linux/kexec.h>
 #include <linux/sizes.h>
+#include <linux/device.h>
+#include <linux/dma-contiguous.h>
 
 #include <asm/addrspace.h>
 #include <asm/bootinfo.h>
@@ -476,6 +478,7 @@ static void __init bootmem_init(void)
  *  o bootmem_init()
  *  o sparse_init()
  *  o paging_init()
+ *  o dma_continguous_reserve()
  *
  * At this stage the bootmem allocator is ready to use.
  *
@@ -609,6 +612,7 @@ static void __init request_crashkernel(struct resource *res)
 
 static void __init arch_mem_init(char **cmdline_p)
 {
+	struct memblock_region *reg;
 	extern void plat_mem_setup(void);
 
 	/* call board setup routine */
@@ -675,6 +679,11 @@ static void __init arch_mem_init(char **cmdline_p)
 	sparse_init();
 	plat_swiotlb_setup();
 	paging_init();
+
+	dma_contiguous_reserve(PFN_PHYS(max_low_pfn));
+	/* Tell bootmem about cma reserved memblock section */
+	for_each_memblock(reserved, reg)
+		reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
 }
 
 static void __init resource_init(void)
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 44b6dff..33ba3c5 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/dma-contiguous.h>
 
 #include <asm/cache.h>
 #include <asm/cpu-type.h>
@@ -128,23 +129,30 @@ static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t * dma_handle, gfp_t gfp, struct dma_attrs *attrs)
 {
 	void *ret;
+	struct page *page = NULL;
+	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
 		return ret;
 
 	gfp = massage_gfp_flags(dev, gfp);
 
-	ret = (void *) __get_free_pages(gfp, get_order(size));
-
-	if (ret) {
-		memset(ret, 0, size);
-		*dma_handle = plat_map_dma_mem(dev, ret, size);
-
-		if (!plat_device_is_coherent(dev)) {
-			dma_cache_wback_inv((unsigned long) ret, size);
-			if (!hw_coherentio)
-				ret = UNCAC_ADDR(ret);
-		}
+	if (IS_ENABLED(CONFIG_DMA_CMA) && !(gfp & GFP_ATOMIC))
+		page = dma_alloc_from_contiguous(dev,
+					count, get_order(size));
+	if (!page)
+		page = alloc_pages(gfp, get_order(size));
+
+	if (!page)
+		return NULL;
+
+	ret = page_address(page);
+	memset(ret, 0, size);
+	*dma_handle = plat_map_dma_mem(dev, ret, size);
+	if (!plat_device_is_coherent(dev)) {
+		dma_cache_wback_inv((unsigned long) ret, size);
+		if (!hw_coherentio)
+			ret = UNCAC_ADDR(ret);
 	}
 
 	return ret;
@@ -164,6 +172,8 @@ static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	unsigned long addr = (unsigned long) vaddr;
 	int order = get_order(size);
+	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	struct page *page = NULL;
 
 	if (dma_release_from_coherent(dev, order, vaddr))
 		return;
@@ -173,7 +183,10 @@ static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 	if (!plat_device_is_coherent(dev) && !hw_coherentio)
 		addr = CAC_ADDR(addr);
 
-	free_pages(addr, get_order(size));
+	page = virt_to_page((void *) addr);
+
+	if (!dma_release_from_contiguous(dev, page, count))
+		__free_pages(page, get_order(size));
 }
 
 static inline void __dma_sync_virtual(void *addr, size_t size,
-- 
1.9.1

