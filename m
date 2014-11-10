Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaKJKDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:03:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaKJKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:03:42 -0500
Date: Mon, 10 Nov 2014 11:03:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141110100328.GF29390@twins.programming.kicks-ass.net>
References: <1413962231.19914.130.camel@tkhai>
 <545D928B.2070508@oracle.com>
 <1415542020.474.22.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415542020.474.22.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 05:07:00PM +0300, Kirill Tkhai wrote:
> > I've complained about an unrelated issue in that part of the code
> > a while back (https://lkml.org/lkml/2014/5/12/508) which PeterZ
> > ended up fixing (https://lkml.org/lkml/2014/5/21/428) but it seems
> > that both of us forgot to follow up on that and the fix never got
> > upstream.

Argh, sorry for that!

> The bellow is equal to the patch suggested by Peter.
> 
> The only thing, I'm doubt, is about the comparison of cpus instead of nids.
> Should task_numa_compare() be able to be called with src_nid == dst_nid
> like this may happens now?! Maybe better, we should change task_numa_migrate()
> and check for env.dst_nid != env.src.nid.
> 
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 826fdf3..c18129e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1380,6 +1380,8 @@ static void task_numa_find_cpu(struct task_numa_env *env,
>  		/* Skip this CPU if the source task cannot migrate */
>  		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
>  			continue;
> +		if (cpu == env->src_cpu)
> +			continue;
>  
>  		env->dst_cpu = cpu;
>  		task_numa_compare(env, taskimp, groupimp);

Not quite the same, current can still get migrated to another cpu than
env->src_cpu, at which point we can still end up selecting ourselves.

How about the below instead, that is pretty much the old patch, but with
a nice comment.

---
Subject: sched, numa: Avoid selecting oneself as swap target
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Nov 10 10:54:35 CET 2014

Because the whole numa task selection stuff runs with preemption
enabled (its long and expensive) we can end up migrating and selecting
oneself as a swap target. This doesn't really work out well -- we end
up trying to acquire the same lock twice for the swap migrate -- so
avoid this.

Cc: Rik van Riel <riel@redhat.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/fair.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1268,6 +1268,13 @@ static void task_numa_compare(struct tas
 	raw_spin_unlock_irq(&dst_rq->lock);
 
 	/*
+	 * Because we have preemption enabled we can get migrated around and
+	 * end try selecting ourselves (current == env->p) as a swap candidate.
+	 */
+	if (cur == env->p)
+		goto unlock;
+
+	/*
 	 * "imp" is the fault differential for the source task between the
 	 * source and destination node. Calculate the total differential for
 	 * the source task and potential destination task. The more negative
