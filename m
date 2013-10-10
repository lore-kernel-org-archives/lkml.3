Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3JJSJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:09:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:10074 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab3JJSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="391219921"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 24/34] s390: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:49 +0300
Message-Id: <1381428359-14843-25-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/mm/pgtable.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index c463e5cd3b..b109edb90b 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -754,7 +754,11 @@ static inline unsigned long *page_table_alloc_pgste(struct mm_struct *mm,
 		__free_page(page);
 		return NULL;
 	}
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		kfree(mp);
+		__free_page(page);
+		return NULL;
+	}
 	mp->vmaddr = vmaddr & PMD_MASK;
 	INIT_LIST_HEAD(&mp->mapper);
 	page->index = (unsigned long) mp;
@@ -884,7 +888,10 @@ unsigned long *page_table_alloc(struct mm_struct *mm, unsigned long vmaddr)
 		page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
 		if (!page)
 			return NULL;
-		pgtable_page_ctor(page);
+		if (!pgtable_page_ctor(page)) {
+			__free_page(page);
+			return NULL;
+		}
 		atomic_set(&page->_mapcount, 1);
 		table = (unsigned long *) page_to_phys(page);
 		clear_table(table, _PAGE_INVALID, PAGE_SIZE);
-- 
1.8.4.rc3

