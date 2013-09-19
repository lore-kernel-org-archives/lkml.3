Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3ISO5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:57:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58798 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab3ISOzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 09/11] x86, pageattr: Add last levels of error path
Date: Thu, 19 Sep 2013 16:54:52 +0200
Message-Id: <1379602494-26684-10-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We try to free the pagetable pages once we've unmapped our portion.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a0d2e90ad62b..ca76481c09e8 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,7 +666,99 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
-#define unmap_pmd_range(pud, start, pre_end)		do {} while (0)
+static bool try_to_free_pte_page(pte_t *pte)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		if (!pte_none(pte[i]))
+			return false;
+
+	free_page((unsigned long)pte);
+	return true;
+}
+
+static bool try_to_free_pmd_page(pmd_t *pmd)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PMD; i++)
+		if (!pmd_none(pmd[i]))
+			return false;
+
+	free_page((unsigned long)pmd);
+	return true;
+}
+
+static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
+{
+	pte_t *pte = pte_offset_kernel(pmd, start);
+
+	while (start < end) {
+		set_pte(pte, __pte(0));
+
+		start += PAGE_SIZE;
+		pte++;
+	}
+
+	if (try_to_free_pte_page((pte_t *)pmd_page_vaddr(*pmd))) {
+		pmd_clear(pmd);
+		return true;
+	}
+	return false;
+}
+
+static void __unmap_pmd_range(pud_t *pud, pmd_t *pmd,
+			      unsigned long start, unsigned long end)
+{
+	if (unmap_pte_range(pmd, start, end))
+		if (try_to_free_pmd_page((pmd_t *)pud_page_vaddr(*pud)))
+			pud_clear(pud);
+}
+
+static void unmap_pmd_range(pud_t *pud, unsigned long start, unsigned long end)
+{
+	pmd_t *pmd = pmd_offset(pud, start);
+
+	/*
+	 * Not on a 2MB page boundary?
+	 */
+	if (start & (PMD_SIZE - 1)) {
+		unsigned long next_page = (start + PMD_SIZE) & PMD_MASK;
+		unsigned long pre_end = min_t(unsigned long, end, next_page);
+
+		__unmap_pmd_range(pud, pmd, start, pre_end);
+
+		start = pre_end;
+		pmd++;
+	}
+
+	/*
+	 * Try to unmap in 2M chunks.
+	 */
+	while (end - start >= PMD_SIZE) {
+		if (pmd_large(*pmd))
+			pmd_clear(pmd);
+		else
+			__unmap_pmd_range(pud, pmd, start, start + PMD_SIZE);
+
+		start += PMD_SIZE;
+		pmd++;
+	}
+
+	/*
+	 * 4K leftovers?
+	 */
+	if (start < end)
+		return __unmap_pmd_range(pud, pmd, start, end);
+
+	/*
+	 * Try again to free the PMD page if haven't succeeded above.
+	 */
+	if (!pud_none(*pud))
+		if (try_to_free_pmd_page((pmd_t *)pud_page_vaddr(*pud)))
+			pud_clear(pud);
+}
 
 static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
 {
-- 
1.8.4

