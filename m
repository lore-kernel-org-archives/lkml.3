Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3LSQzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:55:38 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51310 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3LSQzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:55:36 -0500
Date: Thu, 19 Dec 2013 17:55:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20131219165531.GA30299@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 757dfcaa41844595964f1220f1d33182dae49976 sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

An RT group-scheduling fix and the sched-domains topology setup fix 
from Mel.

 Thanks,

	Ingo

------------------>
Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Mel Gorman (1):
      sched: Assign correct scheduling domain to 'sd_llc'


 kernel/sched/core.c |  5 +++--
 kernel/sched/rt.c   | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

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
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7d57275..1c40655 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -901,6 +901,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -910,6 +917,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
