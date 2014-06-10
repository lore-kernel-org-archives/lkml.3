Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaFJI4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:56:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49146 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaFJI4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:56:22 -0400
Message-ID: <5396C82C.6060101@linux.vnet.ibm.com>
Date: Tue, 10 Jun 2014 16:56:12 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net> <53759303.40409@linux.vnet.ibm.com> <20140516075421.GL11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516075421.GL11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061008-3568-0000-0000-000005A6EBE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 03:54 PM, Peter Zijlstra wrote:
[snip]
> 
> Hmm, that _should_ more or less work and does indeed suggest there's
> something iffy.
> 

I think we locate the reason why cpu-cgroup doesn't works well on dbench
now... finally.

I'd like to link the reproduce way of the issue here since long time
passed...

	https://lkml.org/lkml/2014/5/16/4

Now here is the analysis:

So our problem is when put tasks like dbench which sleep and wakeup each other
frequently into a deep-group, they will gathered on same CPU when workload like
stress are running, which lead to that the whole group could gain no more than
one CPU.

Basically there are two key points here, load-balance and wake-affine.

Wake-affine for sure pull tasks together for workload like dbench, what make
it difference when put dbench into a group one level deeper is the
load-balance, which happened less.

Usually, when system is busy, during the wakeup when we could not locate
idle cpu, we pick the search point instead, whatever how busy it is since
we count on the balance routine later to help balance the load.

However, in our cases the load balance could not help on that, since deeper
the group is, less the load effect it means to root group.

By which means even tasks in deep group all gathered on one CPU, the load
could still balanced from the view of root group, and the tasks lost the
only chances (balance) to spread when they already on the same CPU...

Furthermore, for tasks flip frequently like dbench, it'll become far more
harder for load balance to help, it could even rarely catch them on rq.

So in such cases, the only chance to do balance for these tasks is during
the wakeup, however it will be expensive...

Thus the cheaper way is something just like select_idle_sibling(), the only
difference is now we balance tasks inside the group to prevent them from
gathered.

Below patch has solved the problem during the testing, I'd like to do more
testing on other benchmarks before send out the formal patch, any comments
are welcomed ;-)

Regards,
Michael Wang



diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..e1381cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4409,6 +4409,62 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	return idlest;
 }
 
+static inline int tg_idle_cpu(struct task_group *tg, int cpu)
+{
+	return !tg->cfs_rq[cpu]->nr_running;
+}
+
+/*
+ * Try and locate an idle CPU in the sched_domain from tg's view.
+ *
+ * Although gathered on same CPU and spread accross CPUs could make
+ * no difference from highest group's view, this will cause the tasks
+ * starving, even they have enough share to fight for CPU, they only
+ * got one battle filed, which means whatever how big their weight is,
+ * they totally got one CPU at maximum.
+ *
+ * Thus when system is busy, we filtered out those tasks which couldn't
+ * gain help from balance routine, and try to balance them internally
+ * by this func, so they could stand a chance to show their power.
+ *
+ */
+static int tg_idle_sibling(struct task_struct *p, int target)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg;
+	int i = task_cpu(p);
+	struct task_group *tg = task_group(p);
+
+	if (tg_idle_cpu(tg, target))
+		goto done;
+
+	sd = rcu_dereference(per_cpu(sd_llc, target));
+	for_each_lower_domain(sd) {
+		sg = sd->groups;
+		do {
+			if (!cpumask_intersects(sched_group_cpus(sg),
+						tsk_cpus_allowed(p)))
+				goto next;
+
+			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (i == target || !tg_idle_cpu(tg, i))
+					goto next;
+			}
+
+			target = cpumask_first_and(sched_group_cpus(sg),
+					tsk_cpus_allowed(p));
+
+			goto done;
+next:
+			sg = sg->next;
+		} while (sg != sd->groups);
+	}
+
+done:
+
+	return target;
+}
+
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -4417,6 +4473,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i = task_cpu(p);
+	struct sched_entity *se = task_group(p)->se[i];
 
 	if (idle_cpu(target))
 		return target;
@@ -4451,6 +4508,30 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
+
+	if (!idle_cpu(target)) {
+		/*
+		 * No idle cpu located imply the system is somewhat busy,
+		 * usually we count on load balance routine's help and
+		 * just pick the target whatever how busy it is.
+		 *
+		 * However, when task belong to a deep group (harder to
+		 * make root imbalance) and flip frequently (harder to be
+		 * caught during balance), load balance routine could help
+		 * nothing, and these tasks will eventually gathered on same
+		 * cpu when they wakeup each other, that is the chance of
+		 * gathered stand far more higher than the chance of spread.
+		 *
+		 * Thus for such tasks, we need to handle them carefully
+		 * during wakeup, since it's the very rarely chance for
+		 * them to spread.
+		 *
+		 */
+		if (se && se->depth &&
+				p->wakee_flips > this_cpu_read(sd_llc_size))
+			return tg_idle_sibling(p, target);
+	}
+
 	return target;
 }
 

