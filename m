Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3JJSMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:12:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:10074 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab3JJSGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="391219920"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 21/34] mips: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:46 +0300
Message-Id: <1381428359-14843-22-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/pgalloc.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 881d18b4e2..b336037e87 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -80,9 +80,12 @@ static inline struct page *pte_alloc_one(struct mm_struct *mm,
 	struct page *pte;
 
 	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
-	if (pte) {
-		clear_highpage(pte);
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	clear_highpage(pte);
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
 	}
 	return pte;
 }
-- 
1.8.4.rc3

