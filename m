Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3FDXVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:21:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35289 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3FDWlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:40 -0400
Message-Id: <20130604172131.843765277@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <Will.Deacon@arm.com>, Steve Capper <Steve.Capper@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 037/184] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Dall <cdall@cs.columbia.edu>

commit ad4b3fb7ff9940bcdb1e4cd62bd189d10fa636ba upstream.

Unfortunately with !CONFIG_PAGEFLAGS_EXTENDED, (!PageHead) is false, and
(PageHead) is true, for tail pages.  If this is indeed the intended
behavior, which I doubt because it breaks cache cleaning on some ARM
systems, then the nomenclature is highly problematic.

This patch makes sure PageHead is only true for head pages and PageTail
is only true for tail pages, and neither is true for non-compound pages.

[ This buglet seems ancient - seems to have been introduced back in Apr
  2008 in commit 6a1e7f777f61: "pageflags: convert to the use of new
  macros".  And the reason nobody noticed is because the PageHead()
  tests are almost all about just sanity-checking, and only used on
  pages that are actual page heads.  The fact that the old code returned
  true for tail pages too was thus not really noticeable.   - Linus ]

Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
Acked-by:  Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <Will.Deacon@arm.com>
Cc: Steve Capper <Steve.Capper@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/page-flags.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6b202b1..f451772 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -362,7 +362,7 @@ static inline int PageCompound(struct page *page)
  * pages on the LRU and/or pagecache.
  */
 TESTPAGEFLAG(Compound, compound)
-__PAGEFLAG(Head, compound)
+__SETPAGEFLAG(Head, compound)  __CLEARPAGEFLAG(Head, compound)
 
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
@@ -374,8 +374,14 @@ __PAGEFLAG(Head, compound)
  * PG_compound & PG_reclaim	=> Tail page
  * PG_compound & ~PG_reclaim	=> Head page
  */
+#define PG_head_mask ((1L << PG_compound))
 #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
 
+static inline int PageHead(struct page *page)
+{
+	return ((page->flags & PG_head_tail_mask) == PG_head_mask);
+}
+
 static inline int PageTail(struct page *page)
 {
 	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
-- 
1.7.12.2.21.g234cd45.dirty



