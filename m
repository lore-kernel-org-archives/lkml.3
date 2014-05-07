Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaEGMsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:48:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60802 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755847AbaEGMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:48:49 -0400
X-IronPort-AV: E=Sophos;i="4.97,1003,1389715200"; 
   d="scan'208";a="30199516"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched/clock: cleanup, remove wrap_{max|min}().
Date: Wed, 7 May 2014 20:48:58 +0900
Message-ID: <1399463338-15507-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure why we need the wrap_{max|min}() in kernel/sched/clock.c.
But I checked the implementation of max() and min() in linux/kernel.h, I think
we can reuse them here rather than introduce a new function named
wrap_{max|min}().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/clock.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 3ef6451..36c03a8 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -173,20 +173,6 @@ void sched_clock_init(void)
 }
 
 /*
- * min, max except they take wrapping into account
- */
-
-static inline u64 wrap_min(u64 x, u64 y)
-{
-	return (s64)(x - y) < 0 ? x : y;
-}
-
-static inline u64 wrap_max(u64 x, u64 y)
-{
-	return (s64)(x - y) > 0 ? x : y;
-}
-
-/*
  * update the percpu scd from the raw @now value
  *
  *  - filter out backward motion
@@ -212,11 +198,11 @@ again:
 	 */
 
 	clock = scd->tick_gtod + delta;
-	min_clock = wrap_max(scd->tick_gtod, old_clock);
-	max_clock = wrap_max(old_clock, scd->tick_gtod + TICK_NSEC);
+	min_clock = max(scd->tick_gtod, old_clock);
+	max_clock = max(old_clock, scd->tick_gtod + TICK_NSEC);
 
-	clock = wrap_max(clock, min_clock);
-	clock = wrap_min(clock, max_clock);
+	clock = max(clock, min_clock);
+	clock = min(clock, max_clock);
 
 	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
 		goto again;
-- 
1.8.2.1

