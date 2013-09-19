Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3ISO4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:56:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3ISOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:08 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 06/11] x86, pageattr: Add a PMD pagetable populating function
Date: Thu, 19 Sep 2013 16:54:49 +0200
Message-Id: <1379602494-26684-7-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Handle PMD-level mappings the same as PUD ones.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 41c6fdbbfab0..c56d71591617 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,6 +666,16 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
+static int alloc_pte_page(pmd_t *pmd)
+{
+	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	if (!pte)
+		return -1;
+
+	set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	return 0;
+}
+
 static int alloc_pmd_page(pud_t *pud)
 {
 	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -676,7 +686,77 @@ static int alloc_pmd_page(pud_t *pud)
 	return 0;
 }
 
-#define populate_pmd(cpa, start, end, pages, pud, pgprot)	(-1)
+#define populate_pte(cpa, start, end, pages, pmd, pgprot)	do {} while (0)
+
+static int populate_pmd(struct cpa_data *cpa,
+			unsigned long start, unsigned long end,
+			unsigned num_pages, pud_t *pud, pgprot_t pgprot)
+{
+	unsigned int cur_pages = 0;
+	pmd_t *pmd;
+
+	/*
+	 * Not on a 2M boundary?
+	 */
+	if (start & (PMD_SIZE - 1)) {
+		unsigned long pre_end = start + (num_pages << PAGE_SHIFT);
+		unsigned long next_page = (start + PMD_SIZE) & PMD_MASK;
+
+		pre_end   = min_t(unsigned long, pre_end, next_page);
+		cur_pages = (pre_end - start) >> PAGE_SHIFT;
+		cur_pages = min_t(unsigned int, num_pages, cur_pages);
+
+		/*
+		 * Need a PTE page?
+		 */
+		pmd = pmd_offset(pud, start);
+		if (pmd_none(*pmd))
+			if (alloc_pte_page(pmd))
+				return -1;
+
+		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
+
+		start = pre_end;
+	}
+
+	/*
+	 * We mapped them all?
+	 */
+	if (num_pages == cur_pages)
+		return cur_pages;
+
+	while (end - start >= PMD_SIZE) {
+
+		/*
+		 * We cannot use a 1G page so allocate a PMD page if needed.
+		 */
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		pmd = pmd_offset(pud, start);
+
+		set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+
+		start	  += PMD_SIZE;
+		cpa->pfn  += PMD_SIZE;
+		cur_pages += PMD_SIZE >> PAGE_SHIFT;
+	}
+
+	/*
+	 * Map trailing 4K pages.
+	 */
+	if (start < end) {
+		pmd = pmd_offset(pud, start);
+		if (pmd_none(*pmd))
+			if (alloc_pte_page(pmd))
+				return -1;
+
+		populate_pte(cpa, start, end, num_pages - cur_pages,
+			     pmd, pgprot);
+	}
+	return num_pages;
+}
 
 static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 			pgprot_t pgprot)
-- 
1.8.4

