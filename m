Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3ISO5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:57:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab3ISOzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:04 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 08/11] x86, pageattr: Add a PUD error unwinding path
Date: Thu, 19 Sep 2013 16:54:51 +0200
Message-Id: <1379602494-26684-9-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

In case we encounter an error during the mapping of a region, we want to
unwind what we've established so far exactly the way we did the mapping.
This is the PUD part kept deliberately small for easier review.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 02cf97b3bb7c..a0d2e90ad62b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,6 +666,51 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
+#define unmap_pmd_range(pud, start, pre_end)		do {} while (0)
+
+static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
+{
+	pud_t *pud = pud_offset(pgd, start);
+
+	/*
+	 * Not on a GB page boundary?
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+		unsigned long pre_end	= min_t(unsigned long, end, next_page);
+
+		unmap_pmd_range(pud, start, pre_end);
+
+		start = pre_end;
+		pud++;
+	}
+
+	/*
+	 * Try to unmap in 1G chunks?
+	 */
+	while (end - start >= PUD_SIZE) {
+
+		if (pud_large(*pud))
+			pud_clear(pud);
+		else
+			unmap_pmd_range(pud, start, start + PUD_SIZE);
+
+		start += PUD_SIZE;
+		pud++;
+	}
+
+	/*
+	 * 2M leftovers?
+	 */
+	if (start < end)
+		unmap_pmd_range(pud, start, end);
+
+	/*
+	 * No need to try to free the PUD page because we'll free it in
+	 * populate_pgd's error path
+	 */
+}
+
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -883,9 +928,20 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		unmap_pud_range(pgd_entry, addr,
+				addr + (cpa->numpages << PAGE_SHIFT));
 
+		if (allocd_pgd) {
+			/*
+			 * If I allocated this PUD page, I can just as well
+			 * free it in this error path.
+			 */
+			pgd_clear(pgd_entry);
+			free_page((unsigned long)pud);
+		}
+		return ret;
+	}
 	cpa->numpages = ret;
 	return 0;
 }
-- 
1.8.4

