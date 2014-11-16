Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaKPK6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:58:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaKPK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:58:50 -0500
Date: Sun, 16 Nov 2014 02:58:36 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-f5b2831d654167d77da8afbef4d2584897b12d0c@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, jgross@suse.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        stefan.bader@canonical.com
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com,
        stefan.bader@canonical.com, tglx@linutronix.de, jgross@suse.com,
        mingo@kernel.org
In-Reply-To: <1415019724-4317-17-git-send-email-jgross@suse.com>
References: <1415019724-4317-17-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Respect PAT bit when copying pte values between large and normal pages
Git-Commit-ID: f5b2831d654167d77da8afbef4d2584897b12d0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5b2831d654167d77da8afbef4d2584897b12d0c
Gitweb:     http://git.kernel.org/tip/f5b2831d654167d77da8afbef4d2584897b12d0c
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:02:02 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:26 +0100

x86: Respect PAT bit when copying pte values between large and normal pages

The PAT bit in the ptes is not moved to the correct position when
copying page protection attributes between entries of different sized
pages. Translate the ptes according to their page size.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-17-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
