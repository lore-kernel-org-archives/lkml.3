Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbbAPEbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:31:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:48399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbAPEbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:31:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,408,1418112000"; 
   d="scan'208";a="651945767"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Christoph Lameter" <cl@linux.com>,
        "Glenn Williamson" <glenn.p.williamson@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3] X86-32: Allocate 32 bytes for pgd in PAE paging
Date: Thu, 15 Jan 2015 20:30:01 -0800
Message-Id: <1421382601-46912-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

With more embedded systems emerging using Quark, among other things,
32-bit kernel matters again. 32-bit machine and kernel uses PAE paging,
which currently wastes at least 4K of memory per process on Linux where we
have to reserve an entire page to support a single 32-byte PGD structure.
It would be a very good thing if we could eliminate that wastage.

PAE paging is used to access more than 4GB memory on x86-32. And it is
required for NX.

In this patch, we still allocate one page for pgd for a Xen domain and 64-bit
kernel because one page pgd is assumed in these cases. But we can save memory
space by only allocating 32-byte pgd for 32-bit PAE kernel when it is not
running as a Xen domain.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/mm/pgtable.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 6fb6927..d223e1f 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -271,12 +271,87 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 	}
 }
 
+/*
+ * Xen paravirt assumes pgd table should be in one page. 64 bit kernel also
+ * assumes that pgd should be in one page.
+ *
+ * But kernel with PAE paging that is not running as a Xen domain
+ * only needs to allocate 32 bytes for pgd instead of one page.
+ */
+#ifdef CONFIG_X86_PAE
+
+#include <linux/slab.h>
+
+#define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
+#define PGD_ALIGN	32
+
+static struct kmem_cache *pgd_cache;
+
+static int __init pgd_cache_init(void)
+{
+	/*
+	 * When PAE kernel is running as a Xen domain, it does not use
+	 * shared kernel pmd. And this requires a whole page for pgd.
+	 */
+	if (!SHARED_KERNEL_PMD)
+		return 0;
+
+	/*
+	 * when PAE kernel is not running as a Xen domain, it uses
+	 * shared kernel pmd. Shared kernel pmd does not require a whole
+	 * page for pgd. We are able to just allocate a 32-byte for pgd.
+	 * During boot time, we create a 32-byte slab for pgd table allocation.
+	 */
+	pgd_cache = kmem_cache_create("pgd_cache", PGD_SIZE, PGD_ALIGN,
+				      SLAB_PANIC, NULL);
+	if (!pgd_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+core_initcall(pgd_cache_init);
+
+static inline pgd_t *_pgd_alloc(void)
+{
+	/*
+	 * If no SHARED_KERNEL_PMD, PAE kernel is running as a Xen domain.
+	 * We allocate one page for pgd.
+	 */
+	if (!SHARED_KERNEL_PMD)
+		return (pgd_t *)__get_free_page(PGALLOC_GFP);
+
+	/*
+	 * Now PAE kernel is not running as a Xen domain. We can allocate
+	 * a 32-byte slab for pgd to save memory space.
+	 */
+	return kmem_cache_alloc(pgd_cache, PGALLOC_GFP);
+}
+
+static inline void _pgd_free(pgd_t *pgd)
+{
+	if (!SHARED_KERNEL_PMD)
+		free_page((unsigned long)pgd);
+	else
+		kmem_cache_free(pgd_cache, pgd);
+}
+#else
+static inline pgd_t *_pgd_alloc(void)
+{
+	return (pgd_t *)__get_free_page(PGALLOC_GFP);
+}
+
+static inline void _pgd_free(pgd_t *pgd)
+{
+	free_page((unsigned long)pgd);
+}
+#endif /* CONFIG_X86_PAE */
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
 
-	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
+	pgd = _pgd_alloc();
 
 	if (pgd == NULL)
 		goto out;
@@ -306,7 +381,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 out_free_pmds:
 	free_pmds(pmds);
 out_free_pgd:
-	free_page((unsigned long)pgd);
+	_pgd_free(pgd);
 out:
 	return NULL;
 }
@@ -316,7 +391,7 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
-	free_page((unsigned long)pgd);
+	_pgd_free(pgd);
 }
 
 /*
-- 
1.8.1.2

