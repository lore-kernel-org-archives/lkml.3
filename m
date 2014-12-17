Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaLQVsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:48:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:29146 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLQVsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:48:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="430361737"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Glenn Williamson" <glenn.p.williamson@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
Date: Wed, 17 Dec 2014 13:47:39 -0800
Message-Id: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
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
 arch/x86/mm/pgtable.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 6fb6927..695db92 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
@@ -271,12 +272,46 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 	}
 }
 
+/*
+ * Xen paravirt assumes pgd table should be in one page. pgd in 64 bit also
+ * needs to be in one page.
+ *
+ * But PAE without Xen only needs to allocate 256 bytes for pgd.
+ *
+ * So if kernel is compiled as PAE model without Xen, we allocate 256 bytes
+ * for pgd entries to save memory space.
+ *
+ * In other cases, one page is allocated for pgd. In theory, a kernel
+ * in PAE mode not running in Xen could allocate 256 bytes for pgd
+ * as well. But that will make the allocation and free more complex
+ * but not useful in reality. To simplify the code and testing, we just
+ * allocate one page when CONFIG_XEN is enabled regardelss kernel is running
+ * in Xen or not.
+ */
+static inline pgd_t *_pgd_alloc(void)
+{
+#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
+	return kmalloc(sizeof(pgdval_t) * PTRS_PER_PGD, PGALLOC_GFP);
+#else
+	return (pgd_t *)__get_free_page(PGALLOC_GFP);
+#endif
+}
+
+static inline void _pgd_free(pgd_t *pgd)
+{
+#if defined(CONFIG_X86_PAE) && !defined(CONFIG_XEN)
+	kfree(pgd);
+#else
+	free_page((unsigned long)pgd);
+#endif
+}
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
 
-	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
+	pgd = _pgd_alloc();
 
 	if (pgd == NULL)
 		goto out;
@@ -306,7 +341,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 out_free_pmds:
 	free_pmds(pmds);
 out_free_pgd:
-	free_page((unsigned long)pgd);
+	_pgd_free(pgd);
 out:
 	return NULL;
 }
@@ -316,7 +351,8 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
-	free_page((unsigned long)pgd);
+	_pgd_free(pgd);
+
 }
 
 /*
-- 
1.8.1.2

