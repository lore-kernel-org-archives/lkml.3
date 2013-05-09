Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3EIQYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:24:07 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56260 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752375Ab3EIQYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:24:06 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: use this_rq() helper
Date: Thu,  9 May 2013 11:24:03 -0500
Message-Id: <1368116643-87971-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a few instructions more efficent to and slightly more readable to use
this_rq()-> instead of cpu_rq(smp_processor_id()->

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org> 
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 kernel/sched/fair.c | 6 ++----
 kernel/sched/rt.c   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..f2c9c0c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5418,10 +5418,9 @@ static inline void nohz_balance_exit_idle(int cpu)
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
@@ -5436,10 +5435,9 @@ unlock:
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
-	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 127a2c4..7aced2e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -472,7 +472,7 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 #ifdef CONFIG_SMP
 static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_rq(smp_processor_id())->rd->span;
+	return this_rq()->rd->span;
 }
 #else
 static inline const struct cpumask *sched_rt_period_mask(void)
-- 
1.8.2.1

