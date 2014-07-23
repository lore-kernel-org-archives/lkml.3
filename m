Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaGWSXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:23:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:38212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbaGWSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:23:12 -0400
Date: Wed, 23 Jul 2014 20:23:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723182309.GB3935@laptop>
References: <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
> Alternatively, keep it a "cpumask_var_t", but then you need to use
> __get_cpu_pointer() to get the address of it, and use
> "alloc_cpumask_var()" to allocate area for the OFFSTACK case.
> 
> TOTALLY UNTESTED AND PROBABLY PURE CRAP PATCH ATTACHED.
> 
> WARNING! WARNING! WARNING! This is just looking at the code, not
> really knowing it, and saying "that looks really really wrong". Maybe
> I'm full of shit.

If we're doing that, then we also need to unconditionally allocate
memory for that pointer.

The below is something that seems to be consistent and uses struct
cpumask * as you suggest.

Still wondering how the heck any of that worked and didn't generate more
crashing.

---
 kernel/sched/core.c | 17 +++++++----------
 kernel/sched/fair.c |  4 ++--
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599dc4aa4..976d520587a8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6867,7 +6867,7 @@ struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
-DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
+DECLARE_PER_CPU(struct cpumask *, load_balance_mask);
 
 void __init sched_init(void)
 {
@@ -6880,9 +6880,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
-#endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -6902,12 +6899,12 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
-#ifdef CONFIG_CPUMASK_OFFSTACK
-		for_each_possible_cpu(i) {
-			per_cpu(load_balance_mask, i) = (void *)ptr;
-			ptr += cpumask_size();
-		}
-#endif /* CONFIG_CPUMASK_OFFSTACK */
+	}
+
+	for_each_possible_cpu(i) {
+		per_cpu(load_balance_mask, i) = kzalloc_node(cpumask_size(),
+							     GFP_NOWAIT,
+							     cpu_to_node(i));
 	}
 
 	init_rt_bandwidth(&def_rt_bandwidth,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45943b2fa82b..e4d939dc1084 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6469,7 +6469,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-DEFINE_PER_CPU(cpumask_var_t, load_balance_mask);
+DEFINE_PER_CPU(struct cpumask *, load_balance_mask);
 
 static int need_active_balance(struct lb_env *env)
 {
@@ -6538,7 +6538,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_read(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
