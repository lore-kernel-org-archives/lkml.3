Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3LRKcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LRKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:39 -0500
Date: Wed, 18 Dec 2013 02:32:00 -0800
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-5d4cf996cf134e8ddb4f906b8197feb9267c2b77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <20131217092124.GV11295@suse.de>
References: <20131217092124.GV11295@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Assign correct scheduling domain to '
 sd_llc'
Git-Commit-ID: 5d4cf996cf134e8ddb4f906b8197feb9267c2b77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d4cf996cf134e8ddb4f906b8197feb9267c2b77
Gitweb:     http://git.kernel.org/tip/5d4cf996cf134e8ddb4f906b8197feb9267c2b77
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Tue, 17 Dec 2013 09:21:25 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:08:43 +0100

sched: Assign correct scheduling domain to 'sd_llc'

Commit 42eb088e (sched: Avoid NULL dereference on sd_busy) corrected a NULL
dereference on sd_busy but the fix also altered what scheduling domain it
used for the 'sd_llc' percpu variable.

One impact of this is that a task selecting a runqueue may consider
idle CPUs that are not cache siblings as candidates for running.
Tasks are then running on CPUs that are not cache hot.

This was found through bisection where ebizzy threads were not seeing equal
performance and it looked like a scheduling fairness issue. This patch
mitigates but does not completely fix the problem on all machines tested
implying there may be an additional bug or a common root cause. Here are
the average range of performance seen by individual ebizzy threads. It
was tested on top of candidate patches related to x86 TLB range flushing.

	4-core machine
			    3.13.0-rc3            3.13.0-rc3
			       vanilla            fixsd-v3r3
	Mean   1        0.00 (  0.00%)        0.00 (  0.00%)
	Mean   2        0.34 (  0.00%)        0.10 ( 70.59%)
	Mean   3        1.29 (  0.00%)        0.93 ( 27.91%)
	Mean   4        7.08 (  0.00%)        0.77 ( 89.12%)
	Mean   5      193.54 (  0.00%)        2.14 ( 98.89%)
	Mean   6      151.12 (  0.00%)        2.06 ( 98.64%)
	Mean   7      115.38 (  0.00%)        2.04 ( 98.23%)
	Mean   8      108.65 (  0.00%)        1.92 ( 98.23%)

	8-core machine
	Mean   1         0.00 (  0.00%)        0.00 (  0.00%)
	Mean   2         0.40 (  0.00%)        0.21 ( 47.50%)
	Mean   3        23.73 (  0.00%)        0.89 ( 96.25%)
	Mean   4        12.79 (  0.00%)        1.04 ( 91.87%)
	Mean   5        13.08 (  0.00%)        2.42 ( 81.50%)
	Mean   6        23.21 (  0.00%)       69.46 (-199.27%)
	Mean   7        15.85 (  0.00%)      101.72 (-541.77%)
	Mean   8       109.37 (  0.00%)       19.13 ( 82.51%)
	Mean   12      124.84 (  0.00%)       28.62 ( 77.07%)
	Mean   16      113.50 (  0.00%)       24.16 ( 78.71%)

It's eliminated for one machine and reduced for another.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131217092124.GV11295@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 19af58f..a88f4a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4902,6 +4902,7 @@ DEFINE_PER_CPU(struct sched_domain *, sd_asym);
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain *sd;
+	struct sched_domain *busy_sd = NULL;
 	int id = cpu;
 	int size = 1;
 
@@ -4909,9 +4910,9 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
-		sd = sd->parent; /* sd_busy */
+		busy_sd = sd->parent; /* sd_busy */
 	}
-	rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
+	rcu_assign_pointer(per_cpu(sd_busy, cpu), busy_sd);
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_size, cpu) = size;
