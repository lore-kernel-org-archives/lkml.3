Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3JJSGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:06:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:3703 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab3JJSGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="306244063"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 28/34] tile: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:53 +0300
Message-Id: <1381428359-14843-29-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/pgtable.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 4fd9ec0b58..5e86eac4bf 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -241,6 +241,11 @@ struct page *pgtable_alloc_one(struct mm_struct *mm, unsigned long address,
 	if (p == NULL)
 		return NULL;
 
+	if (!pgtable_page_ctor(p)) {
+		__free_pages(p, L2_USER_PGTABLE_ORDER);
+		return NULL;
+	}
+
 	/*
 	 * Make every page have a page_count() of one, not just the first.
 	 * We don't use __GFP_COMP since it doesn't look like it works
@@ -251,7 +256,6 @@ struct page *pgtable_alloc_one(struct mm_struct *mm, unsigned long address,
 		inc_zone_page_state(p+i, NR_PAGETABLE);
 	}
 
-	pgtable_page_ctor(p);
 	return p;
 }
 
-- 
1.8.4.rc3

