Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaHDU2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:28:43 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:5141 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaHDU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:28:42 -0400
Message-ID: <1407184118.11407.11.camel@j-VirtualBox>
Subject: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>
Cc: linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Date: Mon, 04 Aug 2014 13:28:38 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running workloads on 2+ socket systems, based on perf profiles, the
update_cfs_rq_blocked_load function constantly shows up as taking up a
noticeable % of run time. This is especially apparent on an 8 socket
machine. For example, when running the AIM7 custom workload, we see:

   4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load

Much of the contention is in __update_cfs_rq_tg_load_contrib when we
update the tg load contribution stats.  However, it turns out that in many
cases, they don't need to be updated and "tg_contrib" is 0.

This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
tg load contribution stats when nothing needs to be updated. This reduces the
cacheline contention that would be unnecessary. In the above case, with the
patch, perf reports the total time spent in this function went down by more
than a factor of 3x:

   1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..8d4cc72 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2377,6 +2377,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
+	if (!tg_contrib)
+		return;
+
 	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
 		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
-- 
1.7.1



