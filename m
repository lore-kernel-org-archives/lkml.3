Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3JJSIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:08:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:10074 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3JJSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="417347974"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 27/34] sparc: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:52 +0300
Message-Id: <1381428359-14843-28-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/mm/init_64.c | 11 ++++++-----
 arch/sparc/mm/srmmu.c   |  5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index ed82edad1a..d6de9353ee 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2519,12 +2519,13 @@ pgtable_t pte_alloc_one(struct mm_struct *mm,
 		return pte;
 
 	page = __alloc_for_cache(mm);
-	if (page) {
-		pgtable_page_ctor(page);
-		pte = (pte_t *) page_address(page);
+	if (!page)
+		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		free_hot_cold_page(page, 0);
+		return NULL;
 	}
-
-	return pte;
+	return (pte_t *) page_address(page);
 }
 
 void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 5d721df48a..869023abe5 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -345,7 +345,10 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 	if ((pte = (unsigned long)pte_alloc_one_kernel(mm, address)) == 0)
 		return NULL;
 	page = pfn_to_page(__nocache_pa(pte) >> PAGE_SHIFT);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 	return page;
 }
 
-- 
1.8.4.rc3

