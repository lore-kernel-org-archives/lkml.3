Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaKJQpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:45:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaKJQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:45:11 -0500
Message-ID: <5460EB78.8040201@oracle.com>
Date: Mon, 10 Nov 2014 11:44:40 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com>	 <20141110160320.GA10501@worktop.programming.kicks-ass.net>	 <1415635836.474.24.camel@tkhai> <1415637390.474.34.camel@tkhai>
In-Reply-To: <1415637390.474.34.camel@tkhai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 11:36 AM, Kirill Tkhai wrote:
> I mean task_numa_find_cpu(). If a garbage is in cpumask_of_node(env->dst_nid)
> and cpu is bigger than mask, the check
> 
> cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)
> 
> may be true.
> 
> So, we dereference wrong rq in task_numa_compare(). It's not rq at all.
> Strange cpu may be from here. It's just a int number in a wrong memory.

But the odds of the spinlock magic and owner pointer matching up are slim
to none in that case. The memory is also likely to be valid since KASAN didn't
complain about the access, so I don't believe it to be an access to freed memory.

> 
> A hypothesis that below may help:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 826fdf3..a2b4a8a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1376,6 +1376,9 @@ static void task_numa_find_cpu(struct task_numa_env *env,
>  {
>  	int cpu;
>  
> +	if (!node_online(env->dst_nid))
> +		return;

I've changed that to BUG_ON(!node_online(env->dst_nid)) and will run it for a
bit.


Thanks,
Sasha
