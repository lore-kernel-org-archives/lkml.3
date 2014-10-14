Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaJNURM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:17:12 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:38472 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaJNUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:16:54 -0400
From: Yu Zhao <yuzhao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH 2/2] mm: verify compound order when freeing a page
Date: Tue, 14 Oct 2014 13:16:40 -0700
Message-Id: <1413317800-25450-2-git-send-email-yuzhao@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413317800-25450-1-git-send-email-yuzhao@google.com>
References: <1413317800-25450-1-git-send-email-yuzhao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to easily catch the bug fixed in previous patch.

Here we also verify whether a page is tail page or not -- tail
pages are supposed to be freed along with their head, not by
themselves.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 736d8e1..2bcc770 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -750,6 +750,9 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 	int i;
 	int bad = 0;
 
+	VM_BUG_ON(PageTail(page));
+	VM_BUG_ON(PageHead(page) && compound_order(page) != order);
+
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
-- 
2.1.0.rc2.206.gedb03e5

