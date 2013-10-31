Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JaQ0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:26:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49588 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3JaQZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:22 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 09/11] x86, cpa: Map in an arbitrary pgd
Date: Thu, 31 Oct 2013 17:25:07 +0100
Message-Id: <1383236709-19716-10-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add the ability to map pages in an arbitrary pgd. This wires in the
remaining stuff so that there's a new interface with which you can map a
region into an arbitrary PGD.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 53 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index db8ace29514f..b3b19f46c016 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -453,7 +453,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * Check for races, another CPU might have split this page
 	 * up already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte)
 		goto out_unlock;
 
@@ -559,7 +559,8 @@ out_unlock:
 }
 
 static int
-__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
+__split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
+		   struct page *base)
 {
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
@@ -572,7 +573,7 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte) {
 		spin_unlock(&pgd_lock);
 		return 1;
@@ -648,7 +649,8 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	return 0;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
+			    unsigned long address)
 {
 	struct page *base;
 
@@ -660,7 +662,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	if (__split_large_page(kpte, address, base))
+	if (__split_large_page(cpa, kpte, address, base))
 		__free_page(base);
 
 	return 0;
@@ -1041,6 +1043,9 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
+	if (cpa->pgd)
+		return populate_pgd(cpa, vaddr);
+
 	/*
 	 * Ignore all non primary paths.
 	 */
@@ -1085,7 +1090,7 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	else
 		address = *cpa->vaddr;
 repeat:
-	kpte = lookup_address(address, &level);
+	kpte = _lookup_address_cpa(cpa, address, &level);
 	if (!kpte)
 		return __cpa_process_fault(cpa, address, primary);
 
@@ -1149,7 +1154,7 @@ repeat:
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(kpte, address);
+	err = split_large_page(cpa, kpte, address);
 	if (!err) {
 		/*
 	 	 * Do a global flush tlb after splitting the large page
@@ -1298,6 +1303,8 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	int ret, cache, checkalias;
 	unsigned long baddr = 0;
 
+	memset(&cpa, 0, sizeof(cpa));
+
 	/*
 	 * Check, if we are requested to change a not supported
 	 * feature:
@@ -1744,6 +1751,7 @@ static int __set_pages_p(struct page *page, int numpages)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
+				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0),
@@ -1762,6 +1770,7 @@ static int __set_pages_np(struct page *page, int numpages)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
+				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
@@ -1822,6 +1831,36 @@ bool kernel_page_present(struct page *page)
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+			    unsigned numpages, unsigned long page_flags)
+{
+	int retval = -EINVAL;
+
+	struct cpa_data cpa = {
+		.vaddr = &address,
+		.pfn = pfn,
+		.pgd = pgd,
+		.numpages = numpages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(0),
+		.flags = 0,
+	};
+
+	if (!(__supported_pte_mask & _PAGE_NX))
+		goto out;
+
+	if (!(page_flags & _PAGE_NX))
+		cpa.mask_clr = __pgprot(_PAGE_NX);
+
+	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
+
+	retval = __change_page_attr_set_clr(&cpa, 0);
+	__flush_tlb_all();
+
+out:
+	return retval;
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
-- 
1.8.4

