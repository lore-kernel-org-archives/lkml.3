Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972Ab3LIV4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:56:44 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52276 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3LIV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:56:40 -0500
Date: Mon, 9 Dec 2013 13:56:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, page_alloc: make __GFP_NOFAIL really not fail
Message-ID: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_NOFAIL specifies that the page allocator cannot fail to return
memory.  Allocators that call it may not even check for NULL upon
returning.

It turns out GFP_NOWAIT | __GFP_NOFAIL or GFP_ATOMIC | __GFP_NOFAIL can
actually return NULL.  More interestingly, processes that are doing
direct reclaim and have PF_MEMALLOC set may also return NULL for any
__GFP_NOFAIL allocation.

This patch fixes it so that the page allocator never actually returns
NULL as expected for __GFP_NOFAIL.  It turns out that no code actually
does anything as crazy as GFP_ATOMIC | __GFP_NOFAIL currently, so this
is more for correctness than a bug fix for that issue.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2535,17 +2535,19 @@ rebalance:
 		}
 	}
 
-	/* Atomic allocations - we can't balance anything */
-	if (!wait)
-		goto nopage;
-
-	/* Avoid recursion of direct reclaim */
-	if (current->flags & PF_MEMALLOC)
-		goto nopage;
-
-	/* Avoid allocations with no watermarks from looping endlessly */
-	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
-		goto nopage;
+	if (likely(!(gfp_mask & __GFP_NOFAIL))) {
+		/* Atomic allocations - we can't balance anything */
+		if (!wait)
+			goto nopage;
+
+		/* Avoid recursion of direct reclaim */
+		if (current->flags & PF_MEMALLOC)
+			goto nopage;
+
+		/* Avoid allocations with no watermarks from looping forever */
+		if (test_thread_flag(TIF_MEMDIE))
+			goto nopage;
+	}
 
 	/*
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
