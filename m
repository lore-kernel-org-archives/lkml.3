Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3JJSNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:13:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:26345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab3JJSGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="408987111"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 15/34] frv: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:40 +0300
Message-Id: <1381428359-14843-16-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/mm/pgalloc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index f6084bc524..41907d25ed 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -37,11 +37,15 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 #else
 	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
 #endif
-	if (page) {
-		clear_highpage(page);
-		pgtable_page_ctor(page);
-		flush_dcache_page(page);
+	if (!page)
+		return NULL;
+
+	clear_highpage(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
 	}
+	flush_dcache_page(page);
 	return page;
 }
 
-- 
1.8.4.rc3

