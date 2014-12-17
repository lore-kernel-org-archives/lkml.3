Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaLQCqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:46:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:7825 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaLQCqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:46:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499924363"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Glenn Williamson" <glenn.p.williamson@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] X86-32: Allocate 256 bytes for pgd in PAE paging
Date: Tue, 16 Dec 2014 18:45:31 -0800
Message-Id: <1418784331-8465-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

X86 32-bit machine and kernel use PAE paging, which currently wastes about
4K of memory per process on Linux where we have to reserve an entire page to
support a single 256-byte PGD structure.  It would be a very good thing if
we could eliminate that wastage.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/mm/pgtable.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 6fb6927..e75f923 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
@@ -276,7 +277,27 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
 
+	/*
+	 * Xen paravirt assumes pgd table should be in one page. pgd in
+	 * 64 bit also needs to be in one page.
+	 *
+	 * But PAE without Xen only needs to allocate 256 bytes for pgd.
+	 *
+	 * So if kernel is compiled as PAE model without Xen, we allocate
+	 * 256 bytes for pgd entries to save memory space.
+	 *
+	 * In other cases, one page is allocated for pgd. In theory, a kernel
+	 * in PAE mode not running in Xen could allocate 256 bytes for pgd
+	 * as well. But that will make the allocation and free more complex
+	 * but not useful in reality. To simplify the code and testing, we just
+	 * allocate one page when CONFIG_XEN is enabled regardelss kernel
+	 * is running in Xen or not.
+	 */
+#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
+	pgd = kmalloc(sizeof(pgdval_t) * PTRS_PER_PGD, PGALLOC_GFP);
+#else
 	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
+#endif
 
 	if (pgd == NULL)
 		goto out;
@@ -306,7 +327,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 out_free_pmds:
 	free_pmds(pmds);
 out_free_pgd:
+#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
+	kfree(pgd);
+#else
 	free_page((unsigned long)pgd);
+#endif
 out:
 	return NULL;
 }
@@ -316,7 +341,12 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
+#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
+	kfree(pgd);
+#else
 	free_page((unsigned long)pgd);
+#endif
+
 }
 
 /*
-- 
1.8.1.2

