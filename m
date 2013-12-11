Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3LKWgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:36:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:27862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3LKWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="423195687"
Subject: [PATCH 2/2] mm: blk-mq: uses page->list incorrectly
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cl@gentwo.org, kirill.shutemov@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>, akpm@linux-foundation.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 11 Dec 2013 14:36:32 -0800
References: <20131211223631.51094A3D@viggo.jf.intel.com>
In-Reply-To: <20131211223631.51094A3D@viggo.jf.intel.com>
Message-Id: <20131211223632.8B2DFD41@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

'struct page' has two list_head fields: 'lru' and 'list'.
Conveniently, they are unioned together.  This means that code
can use them interchangably, which gets horribly confusing.

The blk-mq made the logical decision to try to use page->list.
But, that field was actually introduced just for the slub code.
->lru is the right field to use outside of slab/slub.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/block/blk-mq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN block/blk-mq.c~blk-mq-uses-page-list-incorrectly block/blk-mq.c
--- linux.git/block/blk-mq.c~blk-mq-uses-page-list-incorrectly	2013-12-11 14:34:51.735196799 -0800
+++ linux.git-davehans/block/blk-mq.c	2013-12-11 14:34:51.739196977 -0800
@@ -1087,8 +1087,8 @@ static void blk_mq_free_rq_map(struct bl
 	struct page *page;
 
 	while (!list_empty(&hctx->page_list)) {
-		page = list_first_entry(&hctx->page_list, struct page, list);
-		list_del_init(&page->list);
+		page = list_first_entry(&hctx->page_list, struct page, lru);
+		list_del_init(&page->lru);
 		__free_pages(page, page->private);
 	}
 
@@ -1152,7 +1152,7 @@ static int blk_mq_init_rq_map(struct blk
 			break;
 
 		page->private = this_order;
-		list_add_tail(&page->list, &hctx->page_list);
+		list_add_tail(&page->lru, &hctx->page_list);
 
 		p = page_address(page);
 		entries_per_page = order_to_size(this_order) / rq_size;
_
