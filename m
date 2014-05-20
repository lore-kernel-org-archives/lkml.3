Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaETO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:58:38 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:24661 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaETO6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:58:34 -0400
X-Nat-Received: from [202.181.97.72]:28281 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400597912.10224
To: david@fromorbit.com, riel@redhat.com
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
	<20140520063024.GH18954@dastard>
In-Reply-To: <20140520063024.GH18954@dastard>
Message-Id: <201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 20 May 2014 23:58:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20052014 #7960777, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I discussed with Kosaki-san at LinuxCon Japan 2014 about this issue.
He does not like the idea of adding timeout to throttle loop. As Dave
posted a patch that fixes a bug in XFS delayed allocation, I updated
my patch accordingly.

Although the bug in XFS was fixed by Dave's patch, other kernel code
would have bugs which would fall into this infinite throttle loop.
But to keep the possibility of triggering OOM killer minimum, can we
agree with this updated patch (and in the future adding some warning
mechanism like /proc/sys/kernel/hung_task_timeout_secs for detecting
memory allocation stall)?

Dave, if you are OK with this updated patch, please let me know
commit ID of your patch.

Regards.
----------
>From 408e65d9025e8e24838e7bf6ac9066ba8a9391a6 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 20 May 2014 23:34:34 +0900
Subject: [PATCH] mm/vmscan: Do not throttle kswapd at shrink_inactive_list().

I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
too many pages are isolated already" causes RHEL7 environment to stall
with 0% CPU usage when a certain type of memory pressure is given.
This is because nobody can reclaim memory due to rules listed below.

  (a) XFS uses a kernel worker thread for delayed allocation
  (b) kswapd wakes up the kernel worker thread for delayed allocation
  (c) the kernel worker thread is throttled due to commit 35cd7815

This patch and commit XXXXXXXX "xfs: block allocation work needs to be
kswapd aware" will solve rule (c).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/vmscan.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..5c6960e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1460,12 +1460,22 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+	/*
+	 * Throttle only direct reclaimers. Allocations by kswapd (and
+	 * allocation workqueue on behalf of kswapd) should not be
+	 * throttled here; otherwise memory allocation will deadlock.
+	 */
+	if (!sc->hibernation_mode && !current_is_kswapd()) {
+		while (unlikely(too_many_isolated(zone, file, sc))) {
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
-		/* We are about to die and free our memory. Return now. */
-		if (fatal_signal_pending(current))
-			return SWAP_CLUSTER_MAX;
+			/*
+			 * We are about to die and free our memory.
+			 * Return now.
+			 */
+			if (fatal_signal_pending(current))
+				return SWAP_CLUSTER_MAX;
+		}
 	}
 
 	lru_add_drain();
-- 
1.7.1
