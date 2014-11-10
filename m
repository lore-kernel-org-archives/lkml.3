Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaKJUB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:01:27 -0500
Received: from forward2o.mail.yandex.net ([37.140.190.31]:60584 "EHLO
	forward2o.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaKJUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:01:26 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Sasha Levin <sasha.levin@oracle.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
In-Reply-To: <5460EB78.8040201@oracle.com>
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com>	 <20141110160320.GA10501@worktop.programming.kicks-ass.net>	 <1415635836.474.24.camel@tkhai> <1415637390.474.34.camel@tkhai> <5460EB78.8040201@oracle.com>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
MIME-Version: 1.0
Message-Id: <2477901415649681@web30o.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 10 Nov 2014 23:01:21 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



10.11.2014, 19:45, "Sasha Levin" <sasha.levin@oracle.com>:
> On 11/10/2014 11:36 AM, Kirill Tkhai wrote:
>> šI mean task_numa_find_cpu(). If a garbage is in cpumask_of_node(env->dst_nid)
>> šand cpu is bigger than mask, the check
>>
>> šcpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)
>>
>> šmay be true.
>>
>> šSo, we dereference wrong rq in task_numa_compare(). It's not rq at all.
>> šStrange cpu may be from here. It's just a int number in a wrong memory.
>
> But the odds of the spinlock magic and owner pointer matching up are slim
> to none in that case. The memory is also likely to be valid since KASAN didn't
> complain about the access, so I don't believe it to be an access to freed memory.

I'm not good with lockdep checks, so I can't judge right now...
Just a hypothesis.

>> šA hypothesis that below may help:
>>
>> šdiff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> šindex 826fdf3..a2b4a8a 100644
>> š--- a/kernel/sched/fair.c
>> š+++ b/kernel/sched/fair.c
>> š@@ -1376,6 +1376,9 @@ static void task_numa_find_cpu(struct task_numa_env *env,
>> šš{
>> ššššššššššint cpu;
>>
>> š+ if (!node_online(env->dst_nid))
>> š+ return;
>
> I've changed that to BUG_ON(!node_online(env->dst_nid)) and will run it for a
> bit.

I've looked one more time, and it looks like it's better to check for
BUG_ON(env->dst_nid > MAX_NUMNODES). node_online() may do not work for
insane nids.

Anyway, even if it's not connected, we need to initialize numa_preferred_nid
of init_task, because it's inherited by kernel_init() (and /sbin/init too).
I'll send the patch tomorrow.

Kirill
