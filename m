Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJOTUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:20:32 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:36252 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaJOTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:20:30 -0400
From: Yu Zhao <yuzhao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH v2 2/2] mm: verify compound order when freeing a page
Date: Wed, 15 Oct 2014 12:20:05 -0700
Message-Id: <1413400805-15547-2-git-send-email-yuzhao@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413400805-15547-1-git-send-email-yuzhao@google.com>
References: <1413400805-15547-1-git-send-email-yuzhao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to catch the bug fixed in the previous patch
(mm: free compound page with correct order).

Here we also verify whether a page is tail page or not -- tail
pages are supposed to be freed along with their head, not by
themselves.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 736d8e1..5bf44e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -750,6 +750,9 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 	int i;
 	int bad = 0;
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageHead(page) && compound_order(page) != order, page);
+
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
-- 
2.1.0.rc2.206.gedb03e5

