Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3JaQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:25:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49560 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3JaQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:20 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 03/11] x86, pageattr: Add a PGD pagetable populating function
Date: Thu, 31 Oct 2013 17:25:01 +0100
Message-Id: <1383236709-19716-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This allocates, if necessary, and populates the corresponding PGD entry
with a PUD page. The next population level is a dummy macro which will
be removed by the next patch and it is added here to keep the patch
small and easily reviewable but not break bisection, at the same time.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index c53de62a1170..4b47ae0602e1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,6 +666,45 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
+#define populate_pud(cpa, addr, pgd, pgprot)	(-1)
+
+/*
+ * Restrictions for kernel page table do not necessarily apply when mapping in
+ * an alternate PGD.
+ */
+static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
+{
+	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
+	bool allocd_pgd = false;
+	pgd_t *pgd_entry;
+	pud_t *pud = NULL;	/* shut up gcc */
+	int ret;
+
+	pgd_entry = cpa->pgd + pgd_index(addr);
+
+	/*
+	 * Allocate a PUD page and hand it down for mapping.
+	 */
+	if (pgd_none(*pgd_entry)) {
+		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		if (!pud)
+			return -1;
+
+		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
+		allocd_pgd = true;
+	}
+
+	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
+	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
+
+	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
+	if (ret < 0)
+		return ret;
+
+	cpa->numpages = ret;
+	return 0;
+}
+
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
-- 
1.8.4

