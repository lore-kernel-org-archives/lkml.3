Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaBEUph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:45:37 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48295 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbaBEUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:20 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Christoffer Dall <cdall@cs.columbia.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <Will.Deacon@arm.com>, Steve Capper <Steve.Capper@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 101/213] mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
Date: Wed, 5 Feb 2014 15:00:56 -0500
Message-ID: <1391630568-49251-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoffer Dall <cdall@cs.columbia.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/page-flags.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5b59f35dcb8f..040ce385f262 100644
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
1.8.5.2

