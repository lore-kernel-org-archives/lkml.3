Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3LRTTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3LRTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:31 -0500
Date: Wed, 18 Dec 2013 20:19:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 4/7] mm: thp: turn put_compound_page() into
	__put_page_tail()
Message-ID: <20131218191958.GA8330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_page(page) calls put_compound_page() if PageCompound(), but
put_compound_page() falls back to __put_nontail_page() if the page
is non-tail.

So we can simply shift the PageTail() logic from put_compound_page()
to put_page(), and put_page() can use __put_nontail_page() otherwise.

The patch also renames put_compound_page() to __put_page_tail() to
reflect the semantics change. And this way put_page() looks more
symmetrical with get_page().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index b0e65b6..0400f3b 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -93,15 +93,10 @@ static void __put_nontail_page(struct page *page)
 	}
 }
 
-static void put_compound_page(struct page *page)
+static void __put_page_tail(struct page *page)
 {
 	struct page *page_head;
 
-	if (likely(!PageTail(page))) {
-		__put_nontail_page(page);
-		return;
-	}
-
 	/* __split_huge_page_refcount can run under us */
 	page_head = compound_trans_head(page);
 
@@ -222,10 +217,10 @@ out_put_single:
 
 void put_page(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		put_compound_page(page);
-	else if (put_page_testzero(page))
-		__put_single_page(page);
+	if (unlikely(PageTail(page)))
+		__put_page_tail(page);
+	else
+		__put_nontail_page(page);
 }
 EXPORT_SYMBOL(put_page);
 
@@ -247,7 +242,7 @@ bool __get_page_tail(struct page *page)
 	bool got;
 	struct page *page_head = compound_trans_head(page);
 
-	/* Ref to put_compound_page() comment. */
+	/* Ref to __put_page_tail() comment. */
 	if (!__compound_tail_refcounted(page_head)) {
 		smp_rmb();
 		if (likely(PageTail(page))) {
-- 
1.5.5.1

