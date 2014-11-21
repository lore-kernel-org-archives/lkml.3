Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaKUIYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:24:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:14555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbaKUIYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:24:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,429,1413270000"; 
   d="scan'208";a="641011377"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched: fix start hrtick for short schedule slices on UP
Date: Fri, 21 Nov 2014 16:24:43 +0800
Message-Id: <1416558283-204916-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start hrtick for schedule slices shorter than 10000ns doesn't make any 
sense and can cause timer DoS.

The commit 177ef2a6315e ("sched/deadline: Fix a precision problem in 
the microseconds range") fixes the shorter slices issue for dl class. 
Both the UP and SMP sides of hrtick_start() will handle the shorter 
slices issue before the commit, however, the UP side of hrtick_start() 
doesn't handle shorter slides issue any more after the commit applied.

This patch fix it by making sure the scheduling slice won't be smaller 
than 10us in the UP side of hrtick_start() for fair and dl schedule 
class.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d44d0c5..dbfcca6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -490,6 +490,11 @@ static __init void init_hrtick(void)
  */
 void hrtick_start(struct rq *rq, u64 delay)
 {
+	/*
+	 * Don't schedule slices shorter than 10000ns, that just
+	 * doesn't make sense. Rely on vruntime for fairness.
+	 */
+	delay = max_t(u64, delay, 10000LL);
 	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
 }
-- 
1.9.1

