Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3JaQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:25:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49556 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3JaQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 02/11] x86, pageattr: Lookup address in an arbitrary PGD
Date: Thu, 31 Oct 2013 17:25:00 +0100
Message-Id: <1383236709-19716-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is preparatory work in order to be able to map pages into a
specified PGD and not implicitly and only into init_mm.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480c2d71..c53de62a1170 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -30,6 +30,7 @@
  */
 struct cpa_data {
 	unsigned long	*vaddr;
+	pgd_t		*pgd;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
@@ -322,17 +323,9 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-/*
- * Lookup the page table entry for a virtual address. Return a pointer
- * to the entry and the level of the mapping.
- *
- * Note: We return pud and pmd either when the entry is marked large
- * or when the present bit is not set. Otherwise we would return a
- * pointer to a nonexisting mapping.
- */
-pte_t *lookup_address(unsigned long address, unsigned int *level)
+static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+				      unsigned int *level)
 {
-	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -361,8 +354,31 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 
 	return pte_offset_kernel(pmd, address);
 }
+
+/*
+ * Lookup the page table entry for a virtual address. Return a pointer
+ * to the entry and the level of the mapping.
+ *
+ * Note: We return pud and pmd either when the entry is marked large
+ * or when the present bit is not set. Otherwise we would return a
+ * pointer to a nonexisting mapping.
+ */
+pte_t *lookup_address(unsigned long address, unsigned int *level)
+{
+        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+}
 EXPORT_SYMBOL_GPL(lookup_address);
 
+static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
+				  unsigned int *level)
+{
+        if (cpa->pgd)
+		return __lookup_address_in_pgd(cpa->pgd + pgd_index(address),
+					       address, level);
+
+        return lookup_address(address, level);
+}
+
 /*
  * This is necessary because __pa() does not work on some
  * kinds of memory, like vmalloc() or the alloc_remap()
-- 
1.8.4

