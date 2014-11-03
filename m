Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaKCNDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:03:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaKCNCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:18 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 16/18] x86: Respect PAT bit when copying pte values between large and normal pages
Date: Mon,  3 Nov 2014 14:02:02 +0100
Message-Id: <1415019724-4317-17-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PAT bit in the ptes is not moved to the correct position when
copying page protection attributes between entries of different sized
pages. Translate the ptes according to their page size.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pageattr.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index de807c9..6c8e3fd 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -485,14 +485,23 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
+	 * Convert protection attributes to 4k-format, as cpa->mask* are set
+	 * up accordingly.
 	 */
 	old_pte = *kpte;
-	old_prot = req_prot = pte_pgprot(old_pte);
+	old_prot = req_prot = pgprot_large_2_4k(pte_pgprot(old_pte));
 
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
 	/*
+	 * req_prot is in format of 4k pages. It must be converted to large
+	 * page format: the caching mode includes the PAT bit located at
+	 * different bit positions in the two formats.
+	 */
+	req_prot = pgprot_4k_2_large(req_prot);
+
+	/*
 	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
 	 * set otherwise pmd_present/pmd_huge will return true even on
 	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
@@ -585,13 +594,10 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
-	/*
-	 * If we ever want to utilize the PAT bit, we need to
-	 * update this function to make sure it's converted from
-	 * bit 12 to bit 7 when we cross from the 2MB level to
-	 * the 4K level:
-	 */
-	WARN_ON_ONCE(pgprot_val(ref_prot) & _PAGE_PAT_LARGE);
+
+	/* promote PAT bit to correct position */
+	if (level == PG_LEVEL_2M)
+		ref_prot = pgprot_large_2_4k(ref_prot);
 
 #ifdef CONFIG_X86_64
 	if (level == PG_LEVEL_1G) {
@@ -879,6 +885,7 @@ static int populate_pmd(struct cpa_data *cpa,
 {
 	unsigned int cur_pages = 0;
 	pmd_t *pmd;
+	pgprot_t pmd_pgprot;
 
 	/*
 	 * Not on a 2M boundary?
@@ -910,6 +917,8 @@ static int populate_pmd(struct cpa_data *cpa,
 	if (num_pages == cur_pages)
 		return cur_pages;
 
+	pmd_pgprot = pgprot_4k_2_large(pgprot);
+
 	while (end - start >= PMD_SIZE) {
 
 		/*
@@ -921,7 +930,8 @@ static int populate_pmd(struct cpa_data *cpa,
 
 		pmd = pmd_offset(pud, start);
 
-		set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+		set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE |
+				   massage_pgprot(pmd_pgprot)));
 
 		start	  += PMD_SIZE;
 		cpa->pfn  += PMD_SIZE;
@@ -949,6 +959,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	pud_t *pud;
 	unsigned long end;
 	int cur_pages = 0;
+	pgprot_t pud_pgprot;
 
 	end = start + (cpa->numpages << PAGE_SHIFT);
 
@@ -986,12 +997,14 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 		return cur_pages;
 
 	pud = pud_offset(pgd, start);
+	pud_pgprot = pgprot_4k_2_large(pgprot);
 
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
 	while (end - start >= PUD_SIZE) {
-		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE |
+				   massage_pgprot(pud_pgprot)));
 
 		start	  += PUD_SIZE;
 		cpa->pfn  += PUD_SIZE;
-- 
1.8.4.5

