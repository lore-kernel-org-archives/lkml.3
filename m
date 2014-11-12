Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaKLJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:49:43 -0500
Received: from relay.parallels.com ([195.214.232.42]:46895 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKLJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:49:40 -0500
Message-ID: <1415785772.15631.23.camel@tkhai>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "Ingo Molnar" <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "Kirill Tkhai" <tkhai@yandex.ru>
Date: Wed, 12 Nov 2014 12:49:32 +0300
In-Reply-To: <2477901415649681@web30o.yandex.ru>
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com>
		 <20141110160320.GA10501@worktop.programming.kicks-ass.net>
		 <1415635836.474.24.camel@tkhai> <1415637390.474.34.camel@tkhai>
	 <5460EB78.8040201@oracle.com> <2477901415649681@web30o.yandex.ru>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 10/11/2014 в 23:01 +0300, Kirill Tkhai пишет:
> 
> 10.11.2014, 19:45, "Sasha Levin" <sasha.levin@oracle.com>:
> > On 11/10/2014 11:36 AM, Kirill Tkhai wrote:
> >>  I mean task_numa_find_cpu(). If a garbage is in cpumask_of_node(env->dst_nid)
> >>  and cpu is bigger than mask, the check
> >>
> >>  cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)
> >>
> >>  may be true.
> >>
> >>  So, we dereference wrong rq in task_numa_compare(). It's not rq at all.
> >>  Strange cpu may be from here. It's just a int number in a wrong memory.
> >
> > But the odds of the spinlock magic and owner pointer matching up are slim
> > to none in that case. The memory is also likely to be valid since KASAN didn't
> > complain about the access, so I don't believe it to be an access to freed memory.
> 
> I'm not good with lockdep checks, so I can't judge right now...
> Just a hypothesis.
> 
> >>  A hypothesis that below may help:
> >>
> >>  diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>  index 826fdf3..a2b4a8a 100644
> >>  --- a/kernel/sched/fair.c
> >>  +++ b/kernel/sched/fair.c
> >>  @@ -1376,6 +1376,9 @@ static void task_numa_find_cpu(struct task_numa_env *env,
> >>   {
> >>           int cpu;
> >>
> >>  + if (!node_online(env->dst_nid))
> >>  + return;
> >
> > I've changed that to BUG_ON(!node_online(env->dst_nid)) and will run it for a
> > bit.
> 
> I've looked one more time, and it looks like it's better to check for
> BUG_ON(env->dst_nid > MAX_NUMNODES). node_online() may do not work for
> insane nids.
> 
> Anyway, even if it's not connected, we need to initialize numa_preferred_nid
> of init_task, because it's inherited by kernel_init() (and /sbin/init too).
> I'll send the patch tomorrow.

Also we can check for cpu. A problem may be in how nodes are built etc..

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..8f5c316 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1381,6 +1381,14 @@ static void task_numa_find_cpu(struct task_numa_env *env,
 		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
 			continue;
 
+		/*
+		 * Is cpumask_of_node() broken? In sched_init() we
+		 * initialize only possible RQs (their rq->lock etc).
+		 */
+		BUG_ON(cpu >= NR_CPUS || !cpu_possible(cpu));
+		/* Insane node id? */
+		BUG_ON(env->dst_nid >= MAX_NUMNODES || !node_online(env->dst_nid));
+
 		env->dst_cpu = cpu;
 		task_numa_compare(env, taskimp, groupimp);
 	}


