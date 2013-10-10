Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3JJSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:13:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:15491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3JJSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="415020991"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 10/34] arc: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:35 +0300
Message-Id: <1381428359-14843-11-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/pgalloc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgalloc.h
index 36a9f20c21..81208bfd9d 100644
--- a/arch/arc/include/asm/pgalloc.h
+++ b/arch/arc/include/asm/pgalloc.h
@@ -105,11 +105,16 @@ static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	pgtable_t pte_pg;
+	struct page *page;
 
 	pte_pg = __get_free_pages(GFP_KERNEL | __GFP_REPEAT, __get_order_pte());
-	if (pte_pg) {
-		memzero((void *)pte_pg, PTRS_PER_PTE * 4);
-		pgtable_page_ctor(virt_to_page(pte_pg));
+	if (!pte_pg)
+		return 0;
+	memzero((void *)pte_pg, PTRS_PER_PTE * 4);
+	page = virt_to_page(pte_pg);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return 0;
 	}
 
 	return pte_pg;
-- 
1.8.4.rc3

