Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3AULTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:19:30 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:58268 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AULT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:19:29 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] MIPS: fix 64-bit kernel build
Date: Mon, 21 Jan 2013 13:19:19 +0200
Message-Id: <1358767159-19585-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3ce88431892b703b04769566338a89eda6b0477 (MIPS: Fix modpost
error in modules attepting to use virt_addr_valid()) in 3.8-rc3 broke
the 64-bit MIPS build:

  LD      init/built-in.o
kernel/built-in.o: In function `memory_bm_free':
snapshot.c:(.text+0x3c76c): undefined reference to `__virt_addr_valid'
snapshot.c:(.text+0x3c800): undefined reference to `__virt_addr_valid'
kernel/built-in.o: In function `snapshot_write_next':
(.text+0x3e094): undefined reference to `__virt_addr_valid'
kernel/built-in.o: In function `snapshot_write_next':
(.text+0x3e468): undefined reference to `__virt_addr_valid'

Fix by providing __virt_addr_valid also when CONFIG_32BIT is not set.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/mm/Makefile  |    6 +++---
 arch/mips/mm/ioremap.c |    4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/mips/mm/Makefile b/arch/mips/mm/Makefile
index 90ceb963..cbfec8c 100644
--- a/arch/mips/mm/Makefile
+++ b/arch/mips/mm/Makefile
@@ -3,10 +3,10 @@
 #
 
 obj-y				+= cache.o dma-default.o extable.o fault.o \
-				   gup.o init.o mmap.o page.o page-funcs.o \
-				   tlbex.o tlbex-fault.o uasm.o
+				   gup.o init.o ioremap.o mmap.o page.o \
+				   page-funcs.o tlbex.o tlbex-fault.o uasm.o
 
-obj-$(CONFIG_32BIT)		+= ioremap.o pgtable-32.o
+obj-$(CONFIG_32BIT)		+= pgtable-32.o
 obj-$(CONFIG_64BIT)		+= pgtable-64.o
 obj-$(CONFIG_HIGHMEM)		+= highmem.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/mips/mm/ioremap.c b/arch/mips/mm/ioremap.c
index 7657fd2..a7a14e3 100644
--- a/arch/mips/mm/ioremap.c
+++ b/arch/mips/mm/ioremap.c
@@ -16,6 +16,8 @@
 #include <asm/io.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_32BIT
+
 static inline void remap_area_pte(pte_t * pte, unsigned long address,
 	phys_t size, phys_t phys_addr, unsigned long flags)
 {
@@ -191,6 +193,8 @@ void __iounmap(const volatile void __iomem *addr)
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(__iounmap);
 
+#endif /* CONFIG_32BIT */
+
 int __virt_addr_valid(const volatile void *kaddr)
 {
 	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
-- 
1.7.10.4

