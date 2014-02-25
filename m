Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBYQF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:05:26 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:36992 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaBYQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:05:25 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH] sched/rt: fix rt timer activation/deactivation
Date: Tue, 25 Feb 2014 17:05:28 +0100
Message-Id: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Destroy rt bandwidth timer when rq has no more RT tasks, even when
CONFIG_RT_GROUP_SCHED is not set.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/rt.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a2740b7..7dba25a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
 static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	hrtimer_cancel(&rt_b->rt_period_timer);
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
 #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
 
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
@@ -1011,8 +1011,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	start_rt_bandwidth(&def_rt_bandwidth);
 }
 
-static inline
-void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
+static void
+dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (!rt_rq->rt_nr_running)
+		destroy_rt_bandwidth(&def_rt_bandwidth);
+}
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-- 
1.7.9.5

