Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3KMCC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:02:27 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44304 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3KMCCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:02:21 -0500
Date: Tue, 12 Nov 2013 18:02:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, vmscan: abort futile reclaim if we've been oom killed
Message-ID: <alpine.DEB.2.02.1311121801200.18803@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer is only invoked when reclaim has already failed and it
only kills processes if the victim is also oom.  In other words, the oom
killer does not select victims when a process tries to allocate from a
disjoint cpuset or allocate DMA memory, for example.

Therefore, it's pointless for an oom killed process to continue
attempting to reclaim memory in a loop when it has been granted access to
memory reserves.  It can simply return to the page allocator and allocate
memory.

If there is a very large number of processes trying to reclaim memory,
the cond_resched() in shrink_slab() becomes troublesome since it always
forces a schedule to other processes also trying to reclaim memory.
Compounded by many reclaim loops, it is possible for a process to sit in
do_try_to_free_pages() for a very long time when reclaim is pointless and
it could allocate if it just returned to the page allocator.

This patch checks if current has been oom killed and, if so, aborts
futile reclaim immediately.  We're not concerned with complete depletion
of memory reserves since there's nothing else we can do.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmscan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2428,6 +2428,14 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 			goto out;
 
 		/*
+		 * If we've been oom killed, reclaim has already failed.  We've
+		 * been given access to memory reserves so that we can allocate
+		 * and quickly die, so just abort futile efforts.
+		 */
+		if (unlikely(test_thread_flag(TIF_MEMDIE)))
+			aborted_reclaim = true;
+
+		/*
 		 * If we're getting trouble reclaiming, start doing
 		 * writepage even in laptop mode.
 		 */
