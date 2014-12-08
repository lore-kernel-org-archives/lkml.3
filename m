Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaLHOQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:16:49 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:52862 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbaLHOQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:16:47 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc32: missing accessors to pgprot_t objects
Message-Id: <20141208141629.912861A5D5B@localhost.localdomain>
Date: Mon,  8 Dec 2014 15:16:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation with #define STRICT_MM_TYPECHECKS in arch/powerpc/include/asm/page.h
fails due to missing use of pgprot_val() when using pgprot_t objects.

arch/powerpc/mm/pgtable_32.c: In function '__ioremap_caller':
arch/powerpc/mm/pgtable_32.c:185:9: error: invalid operands to binary | (have 'long unsigned int' and 'pgprot_t')
   flags |= PAGE_KERNEL;
         ^
arch/powerpc/mm/pgtable_32.c: In function '__mapin_ram_chunk':
arch/powerpc/mm/pgtable_32.c:320:5: error: incompatible types when assigning to type 'long unsigned int' from type 'pgprot_t'
   f = ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL;
     ^
arch/powerpc/mm/ppc_mmu_32.c:95:2: error: incompatible type for argument 5 of 'setbat'
  setbat(2, PAGE_OFFSET, 0, bl, PAGE_KERNEL_X);
  ^
In file included from arch/powerpc/mm/ppc_mmu_32.c:35:0:
arch/powerpc/mm/mmu_decl.h:98:13: note: expected 'int' but argument is of type 'pgprot_t'
 extern void setbat(int index, unsigned long virt, phys_addr_t phys,
             ^
arch/powerpc/mm/ppc_mmu_32.c:103:3: error: incompatible type for argument 5 of 'setbat'
   setbat(3, PAGE_OFFSET+done, done, bl, PAGE_KERNEL_X);
   ^
In file included from arch/powerpc/mm/ppc_mmu_32.c:35:0:
arch/powerpc/mm/mmu_decl.h:98:13: note: expected 'int' but argument is of type 'pgprot_t'
 extern void setbat(int index, unsigned long virt, phys_addr_t phys,
             ^

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/mm/dma-noncoherent.c | 2 +-
 arch/powerpc/mm/pgtable_32.c      | 4 ++--
 arch/powerpc/mm/ppc_mmu_32.c      | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index d85e86a..169aba4 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -228,7 +228,7 @@ __dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t
 		do {
 			SetPageReserved(page);
 			map_page(vaddr, page_to_phys(page),
-				 pgprot_noncached(PAGE_KERNEL));
+				 pgprot_val(pgprot_noncached(PAGE_KERNEL)));
 			page++;
 			vaddr += PAGE_SIZE;
 		} while (size -= PAGE_SIZE);
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index cf11342..a349089 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -182,7 +182,7 @@ __ioremap_caller(phys_addr_t addr, unsigned long size, unsigned long flags,
 
 	/* Make sure we have the base flags */
 	if ((flags & _PAGE_PRESENT) == 0)
-		flags |= PAGE_KERNEL;
+		flags |= pgprot_val(PAGE_KERNEL);
 
 	/* Non-cacheable page cannot be coherent */
 	if (flags & _PAGE_NO_CACHE)
@@ -317,7 +317,7 @@ void __init __mapin_ram_chunk(unsigned long offset, unsigned long top)
 	p = memstart_addr + s;
 	for (; s < top; s += PAGE_SIZE) {
 		ktext = ((char *) v >= _stext && (char *) v < etext);
-		f = ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL;
+		f = pgprot_val(ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL);
 		map_page(v, p, f);
 #ifdef CONFIG_PPC_STD_MMU_32
 		if (ktext)
diff --git a/arch/powerpc/mm/ppc_mmu_32.c b/arch/powerpc/mm/ppc_mmu_32.c
index 5029dc1..dc710d4 100644
--- a/arch/powerpc/mm/ppc_mmu_32.c
+++ b/arch/powerpc/mm/ppc_mmu_32.c
@@ -92,7 +92,7 @@ unsigned long __init mmu_mapin_ram(unsigned long top)
 			break;
 	}
 
-	setbat(2, PAGE_OFFSET, 0, bl, PAGE_KERNEL_X);
+	setbat(2, PAGE_OFFSET, 0, bl, pgprot_val(PAGE_KERNEL_X));
 	done = (unsigned long)bat_addrs[2].limit - PAGE_OFFSET + 1;
 	if ((done < tot) && !bat_addrs[3].limit) {
 		/* use BAT3 to cover a bit more */
@@ -100,7 +100,8 @@ unsigned long __init mmu_mapin_ram(unsigned long top)
 		for (bl = 128<<10; bl < max_size; bl <<= 1)
 			if (bl * 2 > tot)
 				break;
-		setbat(3, PAGE_OFFSET+done, done, bl, PAGE_KERNEL_X);
+		setbat(3, PAGE_OFFSET+done, done, bl,
+		       pgprot_val(PAGE_KERNEL_X));
 		done = (unsigned long)bat_addrs[3].limit - PAGE_OFFSET + 1;
 	}
 
-- 
2.1.0

