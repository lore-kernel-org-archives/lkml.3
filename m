Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaLJSBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:01:17 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:18023 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383AbaLJSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:01:15 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/4] powerpc32: misuse of accessors to pte_t objects
Message-Id: <20141210180033.71D4A1A5D62@localhost.localdomain>
Date: Wed, 10 Dec 2014 19:00:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_val() is not meant to be used as L value.
__pte() has to be used to assign value to pte_t.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/pgtable.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 316f9a5..5d4fdcc 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -115,24 +115,25 @@ static inline unsigned long pte_pfn(pte_t pte)	{
 
 /* Generic modifiers for PTE bits */
 static inline pte_t pte_wrprotect(pte_t pte) {
-	pte_val(pte) &= ~(_PAGE_RW | _PAGE_HWWRITE); return pte; }
+	pte = __pte(pte_val(pte) & ~(_PAGE_RW | _PAGE_HWWRITE)); return pte; }
 static inline pte_t pte_mkclean(pte_t pte) {
-	pte_val(pte) &= ~(_PAGE_DIRTY | _PAGE_HWWRITE); return pte; }
+	pte = __pte(pte_val(pte) & ~(_PAGE_DIRTY | _PAGE_HWWRITE));
+	return pte; }
 static inline pte_t pte_mkold(pte_t pte) {
-	pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
+	pte = __pte(pte_val(pte) & ~_PAGE_ACCESSED); return pte; }
 static inline pte_t pte_mkwrite(pte_t pte) {
-	pte_val(pte) |= _PAGE_RW; return pte; }
+	pte = __pte(pte_val(pte) | _PAGE_RW); return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
-	pte_val(pte) |= _PAGE_DIRTY; return pte; }
+	pte = __pte(pte_val(pte) | _PAGE_DIRTY); return pte; }
 static inline pte_t pte_mkyoung(pte_t pte) {
-	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+	pte = __pte(pte_val(pte) | _PAGE_ACCESSED); return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
-	pte_val(pte) |= _PAGE_SPECIAL; return pte; }
+	pte = __pte(pte_val(pte) | _PAGE_SPECIAL); return pte; }
 static inline pte_t pte_mkhuge(pte_t pte) {
 	return pte; }
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	pte_val(pte) = (pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot);
+	pte = __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
 	return pte;
 }
 
-- 
2.1.0

