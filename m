Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaKZApg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:59901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaKZApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294371"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 6/7] sched: fix start hrtick for short schedule slices on UP
Date: Wed, 26 Nov 2014 08:44:06 +0800
Message-Id: <1416962647-76792-7-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
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

Cc: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 837d2ea..b71a10e 100644
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

