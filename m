Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaKJQgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:36:43 -0500
Received: from relay.parallels.com ([195.214.232.42]:40774 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaKJQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:36:42 -0500
Message-ID: <1415637390.474.34.camel@tkhai>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, <linux-kernel@vger.kernel.org>,
        "Oleg Nesterov" <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Vladimir Davydov" <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 10 Nov 2014 19:36:30 +0300
In-Reply-To: <1415635836.474.24.camel@tkhai>
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com>
	 <20141110160320.GA10501@worktop.programming.kicks-ass.net>
	 <1415635836.474.24.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 10/11/2014 в 19:10 +0300, Kirill Tkhai пишет:
> В Пн, 10/11/2014 в 17:03 +0100, Peter Zijlstra пишет:
> > On Fri, Nov 07, 2014 at 10:48:27PM -0500, Sasha Levin wrote:
> > > [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
> > > [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
> > 
> > Ooh, look at that. CPU#10 vs .owner_cpu: 13 on the _same_ task.
> > 
> > One of those again :/
> 
> We do not initialyse task_struct::numa_preferred_nid for INIT_TASK.
> It there no a problem?
> 

I mean task_numa_find_cpu(). If a garbage is in cpumask_of_node(env->dst_nid)
and cpu is bigger than mask, the check

cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)

may be true.

So, we dereference wrong rq in task_numa_compare(). It's not rq at all.
Strange cpu may be from here. It's just a int number in a wrong memory.

A hypothesis that below may help:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..a2b4a8a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1376,6 +1376,9 @@ static void task_numa_find_cpu(struct task_numa_env *env,
 {
 	int cpu;
 
+	if (!node_online(env->dst_nid))
+		return;
+
 	for_each_cpu(cpu, cpumask_of_node(env->dst_nid)) {
 		/* Skip this CPU if the source task cannot migrate */
 		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))


