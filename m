Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3JaQ2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:28:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49583 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab3JaQZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:21 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 04/11] x86, pageattr: Add a PUD pagetable populating function
Date: Thu, 31 Oct 2013 17:25:02 +0100
Message-Id: <1383236709-19716-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add the next level of the pagetable populating function, we handle
chunks around a 1G boundary by mapping them with the lower level
functions - otherwise we use 1G pages for the mappings, thus using as
less amount of pagetable pages as possible.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 4b47ae0602e1..81deca77b871 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,7 +666,92 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
-#define populate_pud(cpa, addr, pgd, pgprot)	(-1)
+static int alloc_pmd_page(pud_t *pud)
+{
+	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	if (!pmd)
+		return -1;
+
+	set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	return 0;
+}
+
+#define populate_pmd(cpa, start, end, pages, pud, pgprot)	(-1)
+
+static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
+			pgprot_t pgprot)
+{
+	pud_t *pud;
+	unsigned long end;
+	int cur_pages = 0;
+
+	end = start + (cpa->numpages << PAGE_SHIFT);
+
+	/*
+	 * Not on a Gb page boundary? => map everything up to it with
+	 * smaller pages.
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long pre_end;
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+
+		pre_end   = min_t(unsigned long, end, next_page);
+		cur_pages = (pre_end - start) >> PAGE_SHIFT;
+		cur_pages = min_t(int, (int)cpa->numpages, cur_pages);
+
+		pud = pud_offset(pgd, start);
+
+		/*
+		 * Need a PMD page?
+		 */
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
+					 pud, pgprot);
+		if (cur_pages < 0)
+			return cur_pages;
+
+		start = pre_end;
+	}
+
+	/* We mapped them all? */
+	if (cpa->numpages == cur_pages)
+		return cur_pages;
+
+	pud = pud_offset(pgd, start);
+
+	/*
+	 * Map everything starting from the Gb boundary, possibly with 1G pages
+	 */
+	while (end - start >= PUD_SIZE) {
+		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+
+		start	  += PUD_SIZE;
+		cpa->pfn  += PUD_SIZE;
+		cur_pages += PUD_SIZE >> PAGE_SHIFT;
+		pud++;
+	}
+
+	/* Map trailing leftover */
+	if (start < end) {
+		int tmp;
+
+		pud = pud_offset(pgd, start);
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
+				   pud, pgprot);
+		if (tmp < 0)
+			return cur_pages;
+
+		cur_pages += tmp;
+	}
+	return cur_pages;
+}
 
 /*
  * Restrictions for kernel page table do not necessarily apply when mapping in
-- 
1.8.4

