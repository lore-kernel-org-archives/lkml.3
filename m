Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbbASEwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:52:37 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51894 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbASEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:51:58 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 5/5] sched/rt: Optimize find_lowest_rq() to select a cache hot cpu
Date: Mon, 19 Jan 2015 04:49:40 +0000
Message-Id: <1421642980-10045-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In find_lowest_rq(), if we can't find a wake_affine cpu from
sched_domain, then we can actually determine a cache hot cpu
instead of simply calling "cpumask_any(lowest_mask)" which
always returns the first cpu in the mask.

So, we can determine the cache hot cpu during the interation of
sched_domain() in passing.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 kernel/sched/rt.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d28cfa4..e6a42e6 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1535,6 +1535,7 @@ static int find_lowest_rq(struct task_struct *task)
 	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	int cachehot_cpu = nr_cpu_ids;
 
 	/* Make sure the mask is initialized first */
 	if (unlikely(!lowest_mask))
@@ -1566,8 +1567,12 @@ static int find_lowest_rq(struct task_struct *task)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		if (cachehot_cpu >= nr_cpu_ids)
+			cachehot_cpu = cpumask_first_and(lowest_mask,
+						   sched_domain_span(sd));
+
 		if (sd->flags & SD_WAKE_AFFINE) {
-			int best_cpu;
+			int wakeaffine_cpu;
 
 			/*
 			 * "this_cpu" is cheaper to preempt than a
@@ -1579,16 +1584,20 @@ static int find_lowest_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			best_cpu = cpumask_first_and(lowest_mask,
+			wakeaffine_cpu = cpumask_first_and(lowest_mask,
 						     sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids) {
+			if (wakeaffine_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
-				return best_cpu;
+				return wakeaffine_cpu;
 			}
 		}
 	}
 	rcu_read_unlock();
 
+	/* most likely cache-hot */
+	if (cachehot_cpu < nr_cpu_ids)
+		return cachehot_cpu;
+
 	/*
 	 * And finally, if there were no matches within the domains
 	 * just give the caller *something* to work with from the compatible
-- 
1.9.1

