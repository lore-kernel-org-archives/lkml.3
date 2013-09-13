Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3IMNGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:06:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:47774 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab3IMNGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="294477868"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 9/9] x86, mm: enable split page table lock for PMD level
Date: Fri, 13 Sep 2013 16:06:16 +0300
Message-Id: <1379077576-2472-10-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <20130910074748.GA2971@gmail.com>
 <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PMD split page table lock for X86_64 and PAE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig               | 4 ++++
 arch/x86/include/asm/pgalloc.h | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30c40f0..6a5cf6a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1880,6 +1880,10 @@ config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
 
+config ARCH_ENABLE_SPLIT_PMD_PTLOCK
+	def_bool y
+	depends on X86_64 || X86_PAE
+
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index b4389a4..f2daea1 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -80,12 +80,18 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 #if PAGETABLE_LEVELS > 2
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	struct page *page;
+	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT| __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+	pgtable_pmd_page_ctor(page);
+	return (pmd_t *)page_address(page);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	pgtable_pmd_page_dtor(virt_to_page(pmd));
 	free_page((unsigned long)pmd);
 }
 
-- 
1.8.4.rc3

