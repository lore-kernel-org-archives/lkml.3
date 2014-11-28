Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaK1Kzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:55:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaK1KyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:08 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 07/10] x86: Introduce function to get pmd entry pointer
Date: Fri, 28 Nov 2014 11:53:56 +0100
Message-Id: <1417172039-8627-8-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces lookup_pmd_address() to get the address of the pmd entry
related to a virtual address in the current address space. This
function is needed for support of a virtual mapped sparse p2m list
in xen pv domains, as we need the address of the pmd entry, not the
one of the pte in that case.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/pgtable_types.h |  1 +
 arch/x86/mm/pageattr.c               | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 0778964..d83f5e7 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -396,6 +396,7 @@ static inline void update_page_count(int level, unsigned long pages) { }
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 				    unsigned int *level);
+extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 36de293..1298108 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -384,6 +384,26 @@ static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 }
 
 /*
+ * Lookup the PMD entry for a virtual address. Return a pointer to the entry
+ * or NULL if not present.
+ */
+pmd_t *lookup_pmd_address(unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+
+	pgd = pgd_offset_k(address);
+	if (pgd_none(*pgd))
+		return NULL;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || pud_large(*pud) || !pud_present(*pud))
+		return NULL;
+
+	return pmd_offset(pud, address);
+}
+
+/*
  * This is necessary because __pa() does not work on some
  * kinds of memory, like vmalloc() or the alloc_remap()
  * areas on 32-bit NUMA systems.  The percpu areas can
-- 
2.1.2

