Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaHRJfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaHRJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>, Bob Liu <lliubbo@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Hedi Berriche <hedi@sgi.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 089/137] mm, thp: do not allow thp faults to avoid cpuset restrictions
Date: Mon, 18 Aug 2014 10:32:30 +0100
Message-Id: <1408354398-10226-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit b104a35d32025ca740539db2808aa3385d0f30eb upstream.

The page allocator relies on __GFP_WAIT to determine if ALLOC_CPUSET
should be set in allocflags.  ALLOC_CPUSET controls if a page allocation
should be restricted only to the set of allowed cpuset mems.

Transparent hugepages clears __GFP_WAIT when defrag is disabled to prevent
the fault path from using memory compaction or direct reclaim.  Thus, it
is unfairly able to allocate outside of its cpuset mems restriction as a
side-effect.

This patch ensures that ALLOC_CPUSET is only cleared when the gfp mask is
truly GFP_ATOMIC by verifying it is also not a thp allocation.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page_alloc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1b5e9fb49ed4..04dc7a35e299 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2350,7 +2350,7 @@ static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
-	const gfp_t wait = gfp_mask & __GFP_WAIT;
+	const bool atomic = !(gfp_mask & (__GFP_WAIT | __GFP_NO_KSWAPD));
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
@@ -2359,20 +2359,20 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (atomic == true) and ALLOC_HIGH (__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
-	if (!wait) {
+	if (atomic) {
 		/*
-		 * Not worth trying to allocate harder for
-		 * __GFP_NOMEMALLOC even if it can't schedule.
+		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
+		 * if it can't schedule.
 		 */
-		if  (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (!(gfp_mask & __GFP_NOMEMALLOC))
 			alloc_flags |= ALLOC_HARDER;
 		/*
-		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
-		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
+		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
+		 * comment for __cpuset_node_allowed_softwall().
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
-- 
1.9.1

