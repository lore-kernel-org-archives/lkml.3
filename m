Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaJBRSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaJBRSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:18:22 -0400
Date: Thu, 2 Oct 2014 13:15:48 -0400
From: Rik van Riel <riel@redhat.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH RFC] sched,idle: teach select_idle_sibling about idle states
Message-ID: <20141002131548.6cd377d5@cuia.bos.redhat.com>
In-Reply-To: <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
	<1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
	<542B277D.7050103@redhat.com>
	<alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 19:15:00 -0400 (EDT)
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 30 Sep 2014, Rik van Riel wrote:

> > The main thing it does not cover is already running tasks that
> > get woken up again, since select_idle_sibling() covers everything
> > except for newly forked and newly executed tasks.
> 
> True. Now that you bring this up, I remember that Peter mentioned it as 
> well.
> 
> > I am looking at adding similar logic to select_idle_sibling()
> 
> OK thanks.

This patch is ugly. I have not bothered cleaning it up, because it
causes a regression with hackbench. Apparently for hackbench (and
potentially other sync wakeups), locality is more important than
idleness.

We may need to add a third clause before the search, something
along the lines of, to ensure target gets selected if neither
target or i are idle and the wakeup is synchronous...

    if (sync_wakeup && cpu_of(target)->nr_running == 1)
	return target;

I still need to run tests with other workloads, too.

Another consideration is that search costs with this patch
are potentially much increased. I suspect we may want to simply
propagate the load on each sched_group up the tree hierarchically,
with delta accounting and propagating the info upwards only when
the delta is significant, like done in __update_tg_runnable_avg.

---8<---

Subject: sched,idle: teach select_idle_sibling about idle states

Change select_idle_sibling to take cpu idle exit latency into
account.  First preference is to select the cpu with the lowest
exit latency from a completely idle sched_group inside the CPU;
if that is not available, we pick the CPU with the lowest exit
latency in any sched_group.

This increases the total search time of select_idle_sibling,
we may want to look into propagating load info up the sched_group
tree in some way. That information would also be useful to prevent
the wake_affine logic from causing a load imbalance between
sched_groups.

It is not clear when locality (from staying on the old CPU) beats
a lower idle exit latency. Having information on whether the CPU
drops content from the CPU caches in certain idle states would
help with that, but with multiple CPUs bound together in the same
physical CPU core, the hardware often does not do what we tell it,
anyway...

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 10a5a28..12540cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4465,41 +4465,76 @@ static int select_idle_sibling(struct task_struct *p, int target)
 {
 	struct sched_domain *sd;
 	struct sched_group *sg;
+	unsigned int min_exit_latency_thread = UINT_MAX;
+	unsigned int min_exit_latency_core = UINT_MAX;
+	int shallowest_idle_thread = -1;
+	int shallowest_idle_core = -1;
 	int i = task_cpu(p);
 
+	/* target always has some code running and is not in an idle state */
 	if (idle_cpu(target))
 		return target;
 
 	/*
 	 * If the prevous cpu is cache affine and idle, don't be stupid.
+	 * XXX: does i's exit latency exceed sysctl_sched_migration_cost?
 	 */
 	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
 		return i;
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * First preference is finding a totally idle core with a thread
+	 * in a shallow idle state; second preference is whatever idle
+	 * thread has the shallowest idle state anywhere.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
+			unsigned int min_sg_exit_latency = UINT_MAX;
+			int shallowest_sg_idle_thread = -1;
+			bool all_idle = true;
+
 			if (!cpumask_intersects(sched_group_cpus(sg),
 						tsk_cpus_allowed(p)))
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (i == target || !idle_cpu(i))
-					goto next;
+				struct rq *rq;
+				struct cpuidle_state *idle;
+
+				if (i == target || !idle_cpu(i)) {
+					all_idle = false;
+					continue;
+				}
+
+				rq = cpu_rq(i);
+				idle = idle_get_state(rq);
+
+				if (idle && idle->exit_latency < min_sg_exit_latency) {
+					min_sg_exit_latency = idle->exit_latency;
+					shallowest_sg_idle_thread = i;
+				}
+			}
+
+			if (all_idle && min_sg_exit_latency < min_exit_latency_core) {
+				shallowest_idle_core = shallowest_sg_idle_thread;
+				min_exit_latency_core = min_sg_exit_latency;
+			} else if (min_sg_exit_latency < min_exit_latency_thread) {
+				shallowest_idle_thread = shallowest_sg_idle_thread;
+				min_exit_latency_thread = min_sg_exit_latency;
 			}
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
 next:
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
-done:
+	if (shallowest_idle_core >= 0)
+		target = shallowest_idle_core;
+	else if (shallowest_idle_thread >= 0)
+		target = shallowest_idle_thread;
+
 	return target;
 }
 

