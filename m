Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbaDBUWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:22:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42838 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758903AbaDBUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 32/40] Revert "xen: properly account for _PAGE_NUMA during xen pte translations"
Date: Wed,  2 Apr 2014 22:13:18 +0200
Message-Id: <dac766e559ef7b3f3de7b9111dcf165d6355d3f6.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5926f87fdaad4be3ed10cec563bf357915e55a86 upstream.

This reverts commit a9c8e4beeeb64c22b84c803747487857fe424b68.

PTEs in Xen PV guests must contain machine addresses if _PAGE_PRESENT
is set and pseudo-physical addresses is _PAGE_PRESENT is clear.

This is because during a domain save/restore (migration) the page
table entries are "canonicalised" and uncanonicalised". i.e., MFNs are
converted to PFNs during domain save so that on a restore the page
table entries may be rewritten with the new MFNs on the destination.
This canonicalisation is only done for PTEs that are present.

This change resulted in writing PTEs with MFNs if _PAGE_PROTNONE (or
_PAGE_NUMA) was set but _PAGE_PRESENT was clear.  These PTEs would be
migrated as-is which would result in unexpected behaviour in the
destination domain.  Either a) the MFN would be translated to the
wrong PFN/page; b) setting the _PAGE_PRESENT bit would clear the PTE
because the MFN is no longer owned by the domain; or c) the present
bit would not get set.

Symptoms include "Bad page" reports when munmapping after migrating a
domain.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/pgtable.h | 14 ++------------
 arch/x86/xen/mmu.c             |  4 ++--
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5ad38ad07890..bbc8b12fa443 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -445,20 +445,10 @@ static inline int pte_same(pte_t a, pte_t b)
 	return a.pte == b.pte;
 }
 
-static inline int pteval_present(pteval_t pteval)
-{
-	/*
-	 * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
-	 * way clearly states that the intent is that protnone and numa
-	 * hinting ptes are considered present for the purposes of
-	 * pagetable operations like zapping, protection changes, gup etc.
-	 */
-	return pteval & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_NUMA);
-}
-
 static inline int pte_present(pte_t a)
 {
-	return pteval_present(pte_flags(a));
+	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE |
+			       _PAGE_NUMA);
 }
 
 #define pte_accessible pte_accessible
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d5af43af64dc..fdc3ba28ca38 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 /* Assume pteval_t is equivalent to all the other *val_t types. */
 static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
-	if (pteval_present(val)) {
+	if (val & _PAGE_PRESENT) {
 		unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		unsigned long pfn = mfn_to_pfn(mfn);
 
@@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 
 static pteval_t pte_pfn_to_mfn(pteval_t val)
 {
-	if (pteval_present(val)) {
+	if (val & _PAGE_PRESENT) {
 		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & PTE_FLAGS_MASK;
 		unsigned long mfn;
-- 
1.9.1

