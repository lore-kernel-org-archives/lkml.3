Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3JJSL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:11:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:48972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab3JJSGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="408987117"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 30/34] unicore32: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:55 +0300
Message-Id: <1381428359-14843-31-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/pgalloc.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/unicore32/include/asm/pgalloc.h b/arch/unicore32/include/asm/pgalloc.h
index 0213e373a8..2e02d1356f 100644
--- a/arch/unicore32/include/asm/pgalloc.h
+++ b/arch/unicore32/include/asm/pgalloc.h
@@ -51,12 +51,14 @@ pte_alloc_one(struct mm_struct *mm, unsigned long addr)
 	struct page *pte;
 
 	pte = alloc_pages(PGALLOC_GFP, 0);
-	if (pte) {
-		if (!PageHighMem(pte)) {
-			void *page = page_address(pte);
-			clean_dcache_area(page, PTRS_PER_PTE * sizeof(pte_t));
-		}
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	if (!PageHighMem(pte)) {
+		void *page = page_address(pte);
+		clean_dcache_area(page, PTRS_PER_PTE * sizeof(pte_t));
+	}
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
 	}
 
 	return pte;
-- 
1.8.4.rc3

