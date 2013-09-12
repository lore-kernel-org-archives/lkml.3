Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3ILSG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:06:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3ILSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:06:41 -0400
Date: Thu, 12 Sep 2013 11:06:06 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-dczmbi8tfgixacg1ji2av1un@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vincent.guitto@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, vincent.guitto@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix the group_capacity computation
Git-Commit-ID: c61037e905a5cb74c7d786c35ee2cdbab9ed63af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:06:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c61037e905a5cb74c7d786c35ee2cdbab9ed63af
Gitweb:     http://git.kernel.org/tip/c61037e905a5cb74c7d786c35ee2cdbab9ed63af
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 28 Aug 2013 12:40:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:45 +0200

sched/fair: Fix the group_capacity computation

Do away with 'phantom' cores due to N*frac(smt_power) >= 1 by limiting
the capacity to the actual number of cores.

The assumption of 1 < smt_power < 2 is an actual requirement because
of what SMT is so this should work regardless of the SMT
implementation.

It can still be defeated by creative use of cpu hotplug, but if you're
one of those freaks, you get to live with it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guitto@linaro.org>
Link: http://lkml.kernel.org/n/tip-dczmbi8tfgixacg1ji2av1un@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 218f9c5..51c5c3e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4556,18 +4556,24 @@ static inline int sg_imbalanced(struct sched_group *group)
 /*
  * Compute the group capacity.
  *
- * For now the capacity is simply the number of power units in the group_power.
- * A power unit represents a full core.
- *
- * This has an issue where N*frac(smt_power) >= 1, in that case we'll see extra
- * 'cores' that aren't actually there.
+ * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
+ * first dividing out the smt factor and computing the actual number of cores
+ * and limit power unit capacity with that.
  */
 static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 {
+	unsigned int capacity, smt, cpus;
+	unsigned int power, power_orig;
+
+	power = group->sgp->power;
+	power_orig = group->sgp->power_orig;
+	cpus = group->group_weight;
 
-	unsigned int power = group->sgp->power;
-	unsigned int capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
+	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
+	capacity = cpus / smt; /* cores */
 
+	capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
 	if (!capacity)
 		capacity = fix_small_capacity(env->sd, group);
 
