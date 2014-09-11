Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaIKMif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:38:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.392622110@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 063/131] powerpc: Fix build errors STRICT_MM_TYPECHECKS
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 83d5e64b7efa7f39b10ff5e92792e807a720289c upstream.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 2 +-
 arch/powerpc/kernel/pci-common.c          | 5 ++---
 arch/powerpc/mm/init_64.c                 | 3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -47,7 +47,7 @@
  * generic accessors and iterators here
  */
 #define __real_pte(e,p) 	((real_pte_t) { \
-			(e), ((e) & _PAGE_COMBO) ? \
+			(e), (pte_val(e) & _PAGE_COMBO) ? \
 				(pte_val(*((p) + PTRS_PER_PTE))) : 0 })
 #define __rpte_to_hidx(r,index)	((pte_val((r).pte) & _PAGE_COMBO) ? \
         (((r).hidx >> ((index)<<2)) & 0xf) : ((pte_val((r).pte) >> 12) & 0xf))
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -363,7 +363,6 @@ static pgprot_t __pci_mmap_set_pgprot(st
 				      enum pci_mmap_state mmap_state,
 				      int write_combine)
 {
-	unsigned long prot = pgprot_val(protection);
 
 	/* Write combine is always 0 on non-memory space mappings. On
 	 * memory space, if the user didn't pass 1, we check for a
@@ -380,9 +379,9 @@ static pgprot_t __pci_mmap_set_pgprot(st
 
 	/* XXX would be nice to have a way to ask for write-through */
 	if (write_combine)
-		return pgprot_noncached_wc(prot);
+		return pgprot_noncached_wc(protection);
 	else
-		return pgprot_noncached(prot);
+		return pgprot_noncached(protection);
 }
 
 /*
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -218,7 +218,8 @@ static void __meminit vmemmap_create_map
 					     unsigned long phys)
 {
 	int  mapped = htab_bolt_mapping(start, start + page_size, phys,
-					PAGE_KERNEL, mmu_vmemmap_psize,
+					pgprot_val(PAGE_KERNEL),
+					mmu_vmemmap_psize,
 					mmu_kernel_ssize);
 	BUG_ON(mapped < 0);
 }

