Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3IPL0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:26:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:43334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab3IPL0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:26:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,914,1371106800"; 
   d="scan'208";a="396283065"
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
Subject: [PATCHv2 9/9] x86, mm: enable split page table lock for PMD level
Date: Mon, 16 Sep 2013 14:25:40 +0300
Message-Id: <1379330740-5602-10-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PMD split page table lock for X86_64 and PAE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig               |  4 ++++
 arch/x86/include/asm/pgalloc.h | 11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

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
index b4389a4..e2fb2b6 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -80,12 +80,21 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 #if PAGETABLE_LEVELS > 2
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+	struct page *page;
+	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT| __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+	if (!pgtable_pmd_page_ctor(page)) {
+		__free_pages(page, 0);
+		return NULL;
+	}
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

