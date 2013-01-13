Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3AMRyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:54:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305Ab3AMRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:27 -0500
Message-Id: <20130113174257.513209424@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>, Steve Capper <Steve.Capper@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 08/49] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/page-flags.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b5d1384..70473da 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -362,7 +362,7 @@ static inline void ClearPageCompound(struct page *page)
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


