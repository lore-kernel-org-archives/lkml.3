Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaKEPs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:48:58 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62078 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaKEPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:48:55 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 3/7] sched/rt: Optimize find_lowest_rq() to select a cache hot cpu
Date: Wed,  5 Nov 2014 23:48:22 +0800
Message-Id: <1415202506-7800-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
References: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the case for iteration of sched_domains without SD_WAKE_AFFINE
flags to select a cpu, this flag may be unset through proc by users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/rt.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index da6922e..49164f1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1549,6 +1549,7 @@ static int find_lowest_rq(struct task_struct *task)
 	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	int cachehot_cpu = nr_cpu_ids;
 
 	/* Make sure the mask is initialized first */
 	if (unlikely(!lowest_mask))
@@ -1581,7 +1582,7 @@ static int find_lowest_rq(struct task_struct *task)
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
-			int best_cpu;
+			int wakeaffine_cpu;
 
 			/*
 			 * "this_cpu" is cheaper to preempt than a
@@ -1593,16 +1594,25 @@ static int find_lowest_rq(struct task_struct *task)
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
+		} else {
+			/* affine domain outweighs lower level non-affine domain? */
+			if (cachehot_cpu >= nr_cpu_ids)
+				cachehot_cpu = cpumask_first_and(lowest_mask,
+							   sched_domain_span(sd));
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
2.1.0

