Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaKEPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:49:56 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45929 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaKEPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:49:06 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 5/7] sched/deadline: Optimize find_later_rq() to select a cache hot cpu
Date: Wed,  5 Nov 2014 23:48:24 +0800
Message-Id: <1415202506-7800-5-git-send-email-pang.xunlei@linaro.org>
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
 kernel/sched/deadline.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 42edfcd..ddb6185 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1165,6 +1165,7 @@ static int find_later_rq(struct task_struct *task)
 	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int cpu = task_cpu(task);
+	int cachehot_cpu = nr_cpu_ids;
 
 	/* Make sure the mask is initialized first */
 	if (unlikely(!later_mask))
@@ -1209,7 +1210,7 @@ static int find_later_rq(struct task_struct *task)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		int best_cpu;
+		int wakeaffine_cpu;
 		if (sd->flags & SD_WAKE_AFFINE) {
 
 			/*
@@ -1222,16 +1223,24 @@ static int find_later_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			best_cpu = cpumask_first_and(later_mask,
-								sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids) {
+			wakeaffine_cpu = cpumask_first_and(later_mask,
+							 sched_domain_span(sd));
+			if (wakeaffine_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
-				return best_cpu;
+				return wakeaffine_cpu;
 			}
+		} else {
+			if (cachehot_cpu >= nr_cpu_ids)
+				cachehot_cpu = cpumask_first_and(later_mask,
+							   sched_domain_span(sd));
 		}
 	}
 	rcu_read_unlock();
 
+	/* Most likely cache-hot */
+	if (cachehot_cpu < nr_cpu_ids)
+		return cachehot_cpu;
+
 	/*
 	 * At this point, all our guesses failed, we just return
 	 * 'something', and let the caller sort the things out.
-- 
2.1.0

