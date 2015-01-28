Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbbA1BxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:53:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbbA1Bib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 53/77] mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path
Date: Tue, 27 Jan 2015 17:27:31 -0800
Message-Id: <20150128012747.560855114@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 5dab29113ca56335c78be3f98bf5ddf2ef8eb6a6 upstream.

ALLOC_NO_WATERMARK is set in a few cases.  Always by kswapd, always for
__GFP_MEMALLOC, sometimes for swap-over-nfs, tasks etc.  Each of these
cases are relatively rare events but the ALLOC_NO_WATERMARK check is an
unlikely branch in the fast path.  This patch moves the check out of the
fast path and after it has been determined that the watermarks have not
been met.  This helps the common fast path at the cost of making the slow
path slower and hitting kswapd with a performance cost.  It's a reasonable
tradeoff.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1959,9 +1959,6 @@ zonelist_scan:
 			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
-			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
 		 * zone size to ensure fair page aging.  The zone a
@@ -2008,6 +2005,11 @@ zonelist_scan:
 				       classzone_idx, alloc_flags)) {
 			int ret;
 
+			/* Checked here to keep the fast path fast */
+			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+			if (alloc_flags & ALLOC_NO_WATERMARKS)
+				goto try_this_zone;
+
 			if (IS_ENABLED(CONFIG_NUMA) &&
 					!did_zlc_setup && nr_online_nodes > 1) {
 				/*


