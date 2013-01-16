Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3APQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:25:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab3APQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoffer Dall <cdall@cs.columbia.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <Will.Deacon@arm.com>, Steve Capper <Steve.Capper@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 174/222] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
Date: Wed, 16 Jan 2013 13:56:14 -0200
Message-Id: <1358351822-7675-175-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/page-flags.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index c88d2a9..4dabf0f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -361,7 +361,7 @@ static inline void ClearPageCompound(struct page *page)
  * pages on the LRU and/or pagecache.
  */
 TESTPAGEFLAG(Compound, compound)
-__PAGEFLAG(Head, compound)
+__SETPAGEFLAG(Head, compound)  __CLEARPAGEFLAG(Head, compound)
 
 /*
  * PG_reclaim is used in combination with PG_compound to mark the
@@ -373,8 +373,14 @@ __PAGEFLAG(Head, compound)
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
1.7.9.5

