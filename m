Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaIZJ7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:59:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbaIZJqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/142] powerpc/thp: Invalidate old 64K based hash page mapping before insert of 4k pte
Date: Fri, 26 Sep 2014 11:44:25 +0200
Message-Id: <30da621f91f086da7964a3ad1233cfb722ba67f3.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 629149fae478f0ac6bf705a535708b192e9c6b59 upstream.

If we changed base page size of the segment, either via sub_page_protect
or via remap_4k_pfn, we do a demote_segment which doesn't flush the hash
table entries. We do a lazy hash page table flush for all mapped pages
in the demoted segment. This happens when we handle hash page fault
for these pages.

We use _PAGE_COMBO bit along with _PAGE_HASHPTE to indicate whether a
pte is backed by 4K hash pte. If we find _PAGE_COMBO not set on the pte,
that implies that we could possibly have older 64K hash pte entries in
the hash page table and we need to invalidate those entries.

Handle this correctly for 16M pages

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/mm/hugepage-hash64.c | 79 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/hugepage-hash64.c b/arch/powerpc/mm/hugepage-hash64.c
index f50c4dfd1819..e0da84719b46 100644
--- a/arch/powerpc/mm/hugepage-hash64.c
+++ b/arch/powerpc/mm/hugepage-hash64.c
@@ -18,6 +18,57 @@
 #include <linux/mm.h>
 #include <asm/machdep.h>
 
+static void invalidate_old_hpte(unsigned long vsid, unsigned long addr,
+				pmd_t *pmdp, unsigned int psize, int ssize)
+{
+	int i, max_hpte_count, valid;
+	unsigned long s_addr;
+	unsigned char *hpte_slot_array;
+	unsigned long hidx, shift, vpn, hash, slot;
+
+	s_addr = addr & HPAGE_PMD_MASK;
+	hpte_slot_array = get_hpte_slot_array(pmdp);
+	/*
+	 * IF we try to do a HUGE PTE update after a withdraw is done.
+	 * we will find the below NULL. This happens when we do
+	 * split_huge_page_pmd
+	 */
+	if (!hpte_slot_array)
+		return;
+
+	if (ppc_md.hugepage_invalidate)
+		return ppc_md.hugepage_invalidate(vsid, s_addr, hpte_slot_array,
+						  psize, ssize);
+	/*
+	 * No bluk hpte removal support, invalidate each entry
+	 */
+	shift = mmu_psize_defs[psize].shift;
+	max_hpte_count = HPAGE_PMD_SIZE >> shift;
+	for (i = 0; i < max_hpte_count; i++) {
+		/*
+		 * 8 bits per each hpte entries
+		 * 000| [ secondary group (one bit) | hidx (3 bits) | valid bit]
+		 */
+		valid = hpte_valid(hpte_slot_array, i);
+		if (!valid)
+			continue;
+		hidx =  hpte_hash_index(hpte_slot_array, i);
+
+		/* get the vpn */
+		addr = s_addr + (i * (1ul << shift));
+		vpn = hpt_vpn(addr, vsid, ssize);
+		hash = hpt_hash(vpn, shift, ssize);
+		if (hidx & _PTEIDX_SECONDARY)
+			hash = ~hash;
+
+		slot = (hash & htab_hash_mask) * HPTES_PER_GROUP;
+		slot += hidx & _PTEIDX_GROUP_IX;
+		ppc_md.hpte_invalidate(slot, vpn, psize,
+				       MMU_PAGE_16M, ssize, 0);
+	}
+}
+
+
 int __hash_page_thp(unsigned long ea, unsigned long access, unsigned long vsid,
 		    pmd_t *pmdp, unsigned long trap, int local, int ssize,
 		    unsigned int psize)
@@ -85,6 +136,15 @@ int __hash_page_thp(unsigned long ea, unsigned long access, unsigned long vsid,
 	vpn = hpt_vpn(ea, vsid, ssize);
 	hash = hpt_hash(vpn, shift, ssize);
 	hpte_slot_array = get_hpte_slot_array(pmdp);
+	if (psize == MMU_PAGE_4K) {
+		/*
+		 * invalidate the old hpte entry if we have that mapped via 64K
+		 * base page size. This is because demote_segment won't flush
+		 * hash page table entries.
+		 */
+		if ((old_pmd & _PAGE_HASHPTE) && !(old_pmd & _PAGE_COMBO))
+			invalidate_old_hpte(vsid, ea, pmdp, MMU_PAGE_64K, ssize);
+	}
 
 	valid = hpte_valid(hpte_slot_array, index);
 	if (valid) {
@@ -107,11 +167,8 @@ int __hash_page_thp(unsigned long ea, unsigned long access, unsigned long vsid,
 			 * safely update this here.
 			 */
 			valid = 0;
-			new_pmd &= ~_PAGE_HPTEFLAGS;
 			hpte_slot_array[index] = 0;
-		} else
-			/* clear the busy bits and set the hash pte bits */
-			new_pmd = (new_pmd & ~_PAGE_HPTEFLAGS) | _PAGE_HASHPTE;
+		}
 	}
 
 	if (!valid) {
@@ -119,15 +176,13 @@ int __hash_page_thp(unsigned long ea, unsigned long access, unsigned long vsid,
 
 		/* insert new entry */
 		pa = pmd_pfn(__pmd(old_pmd)) << PAGE_SHIFT;
-repeat:
-		hpte_group = ((hash & htab_hash_mask) * HPTES_PER_GROUP) & ~0x7UL;
-
-		/* clear the busy bits and set the hash pte bits */
-		new_pmd = (new_pmd & ~_PAGE_HPTEFLAGS) | _PAGE_HASHPTE;
+		new_pmd |= _PAGE_HASHPTE;
 
 		/* Add in WIMG bits */
 		rflags |= (new_pmd & (_PAGE_WRITETHRU | _PAGE_NO_CACHE |
 				      _PAGE_COHERENT | _PAGE_GUARDED));
+repeat:
+		hpte_group = ((hash & htab_hash_mask) * HPTES_PER_GROUP) & ~0x7UL;
 
 		/* Insert into the hash table, primary slot */
 		slot = ppc_md.hpte_insert(hpte_group, vpn, pa, rflags, 0,
@@ -168,6 +223,12 @@ repeat:
 		mark_hpte_slot_valid(hpte_slot_array, index, slot);
 	}
 	/*
+	 * Mark the pte with _PAGE_COMBO, if we are trying to hash it with
+	 * base page size 4k.
+	 */
+	if (psize == MMU_PAGE_4K)
+		new_pmd |= _PAGE_COMBO;
+	/*
 	 * The hpte valid is stored in the pgtable whose address is in the
 	 * second half of the PMD. Order this against clearing of the busy bit in
 	 * huge pmd.
-- 
2.1.0

