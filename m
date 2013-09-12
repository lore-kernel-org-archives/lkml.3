Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3ILSGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:06:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3ILSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:06:32 -0400
Date: Thu, 12 Sep 2013 11:05:56 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-az1hl1ya55k361nkeh9bj0yw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Rework and comment the group_capacity code
Git-Commit-ID: b37d931685b519cd61a67fbdfe5b04707eb76e32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:06:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b37d931685b519cd61a67fbdfe5b04707eb76e32
Gitweb:     http://git.kernel.org/tip/b37d931685b519cd61a67fbdfe5b04707eb76e32
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 28 Aug 2013 11:50:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:44 +0200

sched/fair: Rework and comment the group_capacity code

Pull out the group_capacity computation so that we can more clearly
comment its issues.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-az1hl1ya55k361nkeh9bj0yw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index baba313..218f9c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4553,6 +4553,27 @@ static inline int sg_imbalanced(struct sched_group *group)
 	return group->sgp->imbalance;
 }
 
+/*
+ * Compute the group capacity.
+ *
+ * For now the capacity is simply the number of power units in the group_power.
+ * A power unit represents a full core.
+ *
+ * This has an issue where N*frac(smt_power) >= 1, in that case we'll see extra
+ * 'cores' that aren't actually there.
+ */
+static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
+{
+
+	unsigned int power = group->sgp->power;
+	unsigned int capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
+
+	if (!capacity)
+		capacity = fix_small_capacity(env->sd, group);
+
+	return capacity;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -4596,16 +4617,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	sgs->group_imb = sg_imbalanced(group);
-
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
-
-	if (!sgs->group_capacity)
-		sgs->group_capacity = fix_small_capacity(env->sd, group);
-
 	sgs->group_weight = group->group_weight;
 
+	sgs->group_imb = sg_imbalanced(group);
+	sgs->group_capacity = sg_capacity(env, group);
+
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
 }
