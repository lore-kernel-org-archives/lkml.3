Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbbA2JO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:14:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44927 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932761AbbA2JIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:24 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/176] mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled process being killed
Date: Wed, 28 Jan 2015 15:28:04 +0100
Message-Id: <72af0d9afe2fcf9ed7c72526367c32dd2c753b58.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9e5e3661727eaf960d3480213f8e87c8d67b6956 upstream.

Charles Shirron and Paul Cassella from Cray Inc have reported kswapd
stuck in a busy loop with nothing left to balance, but
kswapd_try_to_sleep() failing to sleep.  Their analysis found the cause
to be a combination of several factors:

1. A process is waiting in throttle_direct_reclaim() on pgdat->pfmemalloc_wait

2. The process has been killed (by OOM in this case), but has not yet been
   scheduled to remove itself from the waitqueue and die.

3. kswapd checks for throttled processes in prepare_kswapd_sleep():

        if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
                wake_up(&pgdat->pfmemalloc_wait);
		return false; // kswapd will not go to sleep
	}

   However, for a process that was already killed, wake_up() does not remove
   the process from the waitqueue, since try_to_wake_up() checks its state
   first and returns false when the process is no longer waiting.

4. kswapd is running on the same CPU as the only CPU that the process is
   allowed to run on (through cpus_allowed, or possibly single-cpu system).

5. CONFIG_PREEMPT_NONE=y kernel is used. If there's nothing to balance, kswapd
   encounters no voluntary preemption points and repeatedly fails
   prepare_kswapd_sleep(), blocking the process from running and removing
   itself from the waitqueue, which would let kswapd sleep.

So, the source of the problem is that we prevent kswapd from going to
sleep until there are processes waiting on the pfmemalloc_wait queue,
and a process waiting on a queue is guaranteed to be removed from the
queue only when it gets scheduled.  This was done to make sure that no
process is left sleeping on pfmemalloc_wait when kswapd itself goes to
sleep.

However, it isn't necessary to postpone kswapd sleep until the
pfmemalloc_wait queue actually empties.  To prevent processes from being
left sleeping, it's actually enough to guarantee that all processes
waiting on pfmemalloc_wait queue have been woken up by the time we put
kswapd to sleep.

This patch therefore fixes this issue by substituting 'wake_up' with
'wake_up_all' and removing 'return false' in the code snippet from
prepare_kswapd_sleep() above.  Note that if any process puts itself in
the queue after this waitqueue_active() check, or after the wake up
itself, it means that the process will also wake up kswapd - and since
we are under prepare_to_wait(), the wake up won't be missed.  Also we
update the comment prepare_kswapd_sleep() to hopefully more clearly
describe the races it is preventing.

Fixes: 5515061d22f0 ("mm: throttle direct reclaimers if PF_MEMALLOC reserves are low and swap is backed by network storage")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/vmscan.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5461d02ea718..ee8363f73cab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2868,18 +2868,20 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
 		return false;
 
 	/*
-	 * There is a potential race between when kswapd checks its watermarks
-	 * and a process gets throttled. There is also a potential race if
-	 * processes get throttled, kswapd wakes, a large process exits therby
-	 * balancing the zones that causes kswapd to miss a wakeup. If kswapd
-	 * is going to sleep, no process should be sleeping on pfmemalloc_wait
-	 * so wake them now if necessary. If necessary, processes will wake
-	 * kswapd and get throttled again
+	 * The throttled processes are normally woken up in balance_pgdat() as
+	 * soon as pfmemalloc_watermark_ok() is true. But there is a potential
+	 * race between when kswapd checks the watermarks and a process gets
+	 * throttled. There is also a potential race if processes get
+	 * throttled, kswapd wakes, a large process exits thereby balancing the
+	 * zones, which causes kswapd to exit balance_pgdat() before reaching
+	 * the wake up checks. If kswapd is going to sleep, no process should
+	 * be sleeping on pfmemalloc_wait, so wake them now if necessary. If
+	 * the wake up is premature, processes will wake kswapd and get
+	 * throttled again. The difference from wake ups in balance_pgdat() is
+	 * that here we are under prepare_to_wait().
 	 */
-	if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
-		wake_up(&pgdat->pfmemalloc_wait);
-		return false;
-	}
+	if (waitqueue_active(&pgdat->pfmemalloc_wait))
+		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	return pgdat_balanced(pgdat, order, classzone_idx);
 }
-- 
2.2.2

