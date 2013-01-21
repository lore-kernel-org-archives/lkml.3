Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AURxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:53:06 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36654 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab3AURxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:53:02 -0500
Subject: [PATCH 2/5] pagetable level size/shift/mask helpers
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 09:52:46 -0800
References: <20130121175244.E5839E06@kernel.stglabs.ibm.com>
In-Reply-To: <20130121175244.E5839E06@kernel.stglabs.ibm.com>
Message-Id: <20130121175246.6B215415@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012117-5806-0000-0000-00001E8AC64D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I plan to use lookup_address() to walk the kernel pagetables
in a later patch.  It returns a "pte" and the level in the
pagetables where the "pte" was found.  The level is just an
enum and needs to be converted to a useful value in order to
do address calculations with it.  These helpers will be used
in at least two places.

This also gives the anonymous enum a real name so that no one
gets confused about what they should be passing in to these
helpers.

"PTE_SHIFT" was chosen for naming consistency with the other
pagetable levels (PGD/PUD/PMD_SHIFT).

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/pgtable.h       |   14 ++++++++++++++
 linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h |    2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable.h~pagetable-level-size-helpers arch/x86/include/asm/pgtable.h
--- linux-2.6.git/arch/x86/include/asm/pgtable.h~pagetable-level-size-helpers	2013-01-17 10:22:25.958428542 -0800
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable.h	2013-01-17 10:22:25.962428578 -0800
@@ -390,6 +390,7 @@ pte_t *populate_extra_pte(unsigned long
 
 #ifndef __ASSEMBLY__
 #include <linux/mm_types.h>
+#include <linux/log2.h>
 
 static inline int pte_none(pte_t pte)
 {
@@ -781,6 +782,19 @@ static inline void clone_pgd_range(pgd_t
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+#define PTE_SHIFT ilog2(PTRS_PER_PTE)
+static inline int page_level_shift(enum pg_level level)
+{
+	return (PAGE_SHIFT - PTE_SHIFT) + level * PTE_SHIFT;
+}
+static inline unsigned long page_level_size(enum pg_level level)
+{
+	return 1UL << page_level_shift(level);
+}
+static inline unsigned long page_level_mask(enum pg_level level)
+{
+	return ~(page_level_size(level) - 1);
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff -puN arch/x86/include/asm/pgtable_types.h~pagetable-level-size-helpers arch/x86/include/asm/pgtable_types.h
--- linux-2.6.git/arch/x86/include/asm/pgtable_types.h~pagetable-level-size-helpers	2013-01-17 10:22:25.958428542 -0800
+++ linux-2.6.git-dave/arch/x86/include/asm/pgtable_types.h	2013-01-17 10:22:25.966428612 -0800
@@ -331,7 +331,7 @@ extern void native_pagetable_init(void);
 struct seq_file;
 extern void arch_report_meminfo(struct seq_file *m);
 
-enum {
+enum pg_level {
 	PG_LEVEL_NONE,
 	PG_LEVEL_4K,
 	PG_LEVEL_2M,
_

