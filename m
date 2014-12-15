Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaLOC4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:56:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44141 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLOC4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:56:12 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548E4DBF.7090406@jp.fujitsu.com>
Date: Mon, 15 Dec 2014 11:55:59 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 4/4] workqueue: handle change in cpu-node relationship.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548C6B72.5080302@jp.fujitsu.com> <548E4388.5090308@cn.fujitsu.com> <548E4578.3070209@jp.fujitsu.com> <548E4BF7.3000605@cn.fujitsu.com>
In-Reply-To: <548E4BF7.3000605@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/15 11:48), Lai Jiangshan wrote:
> On 12/15/2014 10:20 AM, Kamezawa Hiroyuki wrote:
>> (2014/12/15 11:12), Lai Jiangshan wrote:
>>> On 12/14/2014 12:38 AM, Kamezawa Hiroyuki wrote:
>>>> Although workqueue detects relationship between cpu<->node at boot,
>>>> it is finally determined in cpu_up().
>>>> This patch tries to update pool->node using online status of cpus.
>>>>
>>>> 1. When a node goes down, clear per-cpu pool's node attr.
>>>> 2. When a cpu comes up, update per-cpu pool's node attr.
>>>> 3. When a cpu comes up, update possinle node cpumask workqueue is using for sched.
>>>> 4. Detect the best node for unbound pool's cpumask using the latest info.
>>>>
>>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>> ---
>>>>    kernel/workqueue.c | 67 ++++++++++++++++++++++++++++++++++++++++++------------
>>>>    1 file changed, 53 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>>>> index 07b4eb5..259b3ba 100644
>>>> --- a/kernel/workqueue.c
>>>> +++ b/kernel/workqueue.c
>>>> @@ -266,7 +266,8 @@ struct workqueue_struct {
>>>>    static struct kmem_cache *pwq_cache;
>>>>
>>>>    static cpumask_var_t *wq_numa_possible_cpumask;
>>>> -                    /* possible CPUs of each node */
>>>> +    /* possible CPUs of each node initialized with possible info at boot.
>>>> +           but modified at cpu hotplug to be adjusted to real info.  */
>>>>
>>>>    static bool wq_disable_numa;
>>>>    module_param_named(disable_numa, wq_disable_numa, bool, 0444);
>>>> @@ -3449,6 +3450,31 @@ static void put_unbound_pool(struct worker_pool *pool)
>>>>        call_rcu_sched(&pool->rcu, rcu_free_pool);
>>>>    }
>>>>
>>>> +/*
>>>> + * detect best node for given cpumask.
>>>> + */
>>>> +static int pool_detect_best_node(const struct cpumask *cpumask)
>>>> +{
>>>> +    int node, best, match, selected;
>>>> +    static struct cpumask andmask; /* we're under mutex */
>>>> +
>>>> +    /* Is any node okay ? */
>>>> +    if (!wq_numa_enabled ||
>>>> +        cpumask_subset(cpu_online_mask, cpumask))
>>>> +        return NUMA_NO_NODE;
>>>> +    best = 0;
>>>> +    selected = NUMA_NO_NODE;
>>>> +    /* select a node which contains the most cpu of cpumask */
>>>> +    for_each_node_state(node, N_ONLINE) {
>>>> +        cpumask_and(&andmask, cpumask, cpumask_of_node(node));
>>>> +        match = cpumask_weight(&andmask);
>>>> +        if (match > best)
>>>> +            selected = node;
>>>> +    }
>>>> +    return selected;
>>>> +}
>>>> +
>>>> +
>>>>    /**
>>>>     * get_unbound_pool - get a worker_pool with the specified attributes
>>>>     * @attrs: the attributes of the worker_pool to get
>>>> @@ -3467,7 +3493,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
>>>>    {
>>>>        u32 hash = wqattrs_hash(attrs);
>>>>        struct worker_pool *pool;
>>>> -    int node;
>>>>
>>>>        lockdep_assert_held(&wq_pool_mutex);
>>>>
>>>> @@ -3492,17 +3517,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
>>>>         * 'struct workqueue_attrs' comments for detail.
>>>>         */
>>>>        pool->attrs->no_numa = false;
>>>> -
>>>> -    /* if cpumask is contained inside a NUMA node, we belong to that node */
>>>> -    if (wq_numa_enabled) {
>>>> -        for_each_node(node) {
>>>> -            if (cpumask_subset(pool->attrs->cpumask,
>>>> -                       wq_numa_possible_cpumask[node])) {
>>>> -                pool->node = node;
>>>> -                break;
>>>> -            }
>>>> -        }
>>>> -    }
>>>> +    pool->node = pool_detect_best_node(pool->attrs->cpumask);
>>>>
>>>>        if (worker_pool_assign_id(pool) < 0)
>>>>            goto fail;
>>>> @@ -4567,7 +4582,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
>>>>        int cpu = (unsigned long)hcpu;
>>>>        struct worker_pool *pool;
>>>>        struct workqueue_struct *wq;
>>>> -    int pi;
>>>> +    int pi, node;
>>>>
>>>>        switch (action & ~CPU_TASKS_FROZEN) {
>>>>        case CPU_UP_PREPARE:
>>>> @@ -4583,6 +4598,16 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
>>>>        case CPU_ONLINE:
>>>>            mutex_lock(&wq_pool_mutex);
>>>>
>>>> +        /* now cpu <-> node info is established, update the info. */
>>>> +        if (!wq_disable_numa) {
>>>
>>>
>>>
>>>> +            for_each_node_state(node, N_POSSIBLE)
>>>> +                cpumask_clear_cpu(cpu,
>>>> +                    wq_numa_possible_cpumask[node]);
>>>
>>> The wq code try to reuse the origin pwqs/pools when the node still have cpu online.
>>> these 3 lines of code will cause the origin pwqs/pools be on the road of dying, and
>>> create a new set of pwqs/pools.
>>
>> because the result of wq_calc_node_cpumask() changes ?
>
> Yes.
>
>> Do you mean some comment should be added here ? or explaination for your reply for [3/4] ?
>
> this fix [4/4] breaks the original design.
>

I'm sorry that I can't understand what this patch breaks.
Do you mean it's better to work with broken wq_numa_possible_cpumask ?

I guess removing wq_numa_possible_mask entirely may be the best way
byusing online_mask of the node.

Thanks,
-Kame




