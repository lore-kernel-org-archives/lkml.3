Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaLPIS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:18:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44630 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLPIS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:18:27 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548FEAC7.4030705@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 17:18:15 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 3/4] workqueue: Update workqueue's possible cpumask when
 a new node, coming up.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com> <548EC36C.5040402@jp.fujitsu.com> <548FE40D.5080400@cn.fujitsu.com> <548FE8F6.3060100@jp.fujitsu.com>
In-Reply-To: <548FE8F6.3060100@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/16 17:10), Kamezawa Hiroyuki wrote:
> (2014/12/16 16:49), Lai Jiangshan wrote:
>> On 12/15/2014 07:18 PM, Kamezawa Hiroyuki wrote:
>>> Workqueue keeps cpu<->node relationship including all possible cpus.
>>> The original information was made at boot but it may change when
>>> a new node is added.
>>>
>>> Update information if a new node is ready with using node-hotplug callback.
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> ---
>>>   include/linux/memory_hotplug.h |  2 ++
>>>   kernel/workqueue.c             | 28 +++++++++++++++++++++++++++-
>>>   mm/memory_hotplug.c            |  4 ++++
>>>   3 files changed, 33 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
>>> index 8f1a419..cd3cb67 100644
>>> --- a/include/linux/memory_hotplug.h
>>> +++ b/include/linux/memory_hotplug.h
>>> @@ -270,4 +270,6 @@ extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
>>>   extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>>>                         unsigned long pnum);
>>>
>>> +/* update for workqueues */
>>> +void workqueue_node_register(int node);
>>>   #endif /* __LINUX_MEMORY_HOTPLUG_H */
>>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>>> index 2fd0bd7..5499b76 100644
>>> --- a/kernel/workqueue.c
>>> +++ b/kernel/workqueue.c
>>> @@ -266,7 +266,7 @@ struct workqueue_struct {
>>>   static struct kmem_cache *pwq_cache;
>>>
>>>   static cpumask_var_t *wq_numa_possible_cpumask;
>>> -                    /* possible CPUs of each node */
>>> +                    /* PL: possible CPUs of each node */
>>>
>>>   static bool wq_disable_numa;
>>>   module_param_named(disable_numa, wq_disable_numa, bool, 0444);
>>> @@ -4559,6 +4559,32 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
>>>           WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
>>>                             pool->attrs->cpumask) < 0);
>>>   }
>>> +#ifdef CONFIG_MEMORY_HOTPLUG
>>> +
>>> +static void reflesh_wq_possible_mask(int cpu, int node)
>>> +{
>>> +    int oldnode;
>>> +    for_each_node_state(oldnode, N_POSSIBLE)
>>> +        cpumask_clear_cpu(cpu, wq_numa_possible_cpumask[oldnode]);
>>
>> You need to check and update all the wq->numa_pwq_tbl[oldnode]
>>
>
> you mean : if I drop patch 1/4, it will be required. Right ?
> I'll add that check.

Ah, isn't it handled by wq_update_unbound_numa() called at workqueue_cpu_down_callback() ?
Because node's online cpumask will be empty, new pwq will be attached.

Thanks
-Kame




