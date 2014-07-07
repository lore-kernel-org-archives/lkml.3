Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaGGAdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 20:33:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38531 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaGGAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 20:33:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53B9EAC8.6080608@jp.fujitsu.com>
Date: Mon, 7 Jul 2014 09:33:12 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: initialize cpumask of wq_numa_possible_cpumask
References: <53B98591.5030000@jp.fujitsu.com> <53B9E778.9070807@cn.fujitsu.com>
In-Reply-To: <53B9E778.9070807@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/07 9:19), Lai Jiangshan wrote:
> On 07/07/2014 01:21 AM, Yasuaki Ishimatsu wrote:
>> When hot-adding and onlining CPU, kernel panic occurs, showing following
>> call trace.
>>
>>   BUG: unable to handle kernel paging request at 0000000000001d08
>>   IP: [<ffffffff8114acfd>] __alloc_pages_nodemask+0x9d/0xb10
>>   PGD 0
>>   Oops: 0000 [#1] SMP
>>   ...
>>   Call Trace:
>>    [<ffffffff812b8745>] ? cpumask_next_and+0x35/0x50
>>    [<ffffffff810a3283>] ? find_busiest_group+0x113/0x8f0
>>    [<ffffffff81193bc9>] ? deactivate_slab+0x349/0x3c0
>>    [<ffffffff811926f1>] new_slab+0x91/0x300
>>    [<ffffffff815de95a>] __slab_alloc+0x2bb/0x482
>>    [<ffffffff8105bc1c>] ? copy_process.part.25+0xfc/0x14c0
>>    [<ffffffff810a3c78>] ? load_balance+0x218/0x890
>>    [<ffffffff8101a679>] ? sched_clock+0x9/0x10
>>    [<ffffffff81105ba9>] ? trace_clock_local+0x9/0x10
>>    [<ffffffff81193d1c>] kmem_cache_alloc_node+0x8c/0x200
>>    [<ffffffff8105bc1c>] copy_process.part.25+0xfc/0x14c0
>>    [<ffffffff81114d0d>] ? trace_buffer_unlock_commit+0x4d/0x60
>>    [<ffffffff81085a80>] ? kthread_create_on_node+0x140/0x140
>>    [<ffffffff8105d0ec>] do_fork+0xbc/0x360
>>    [<ffffffff8105d3b6>] kernel_thread+0x26/0x30
>>    [<ffffffff81086652>] kthreadd+0x2c2/0x300
>>    [<ffffffff81086390>] ? kthread_create_on_cpu+0x60/0x60
>>    [<ffffffff815f20ec>] ret_from_fork+0x7c/0xb0
>>    [<ffffffff81086390>] ? kthread_create_on_cpu+0x60/0x60
>>
>> In my investigation, I found the root cause is wq_numa_possible_cpumask.
>> All entries of wq_numa_possible_cpumask is allocated by
>> alloc_cpumask_var_node(). And these entries are used without initializing.
>> So these entries have wrong value.
>>
>> When hot-adding and onlining CPU, wq_update_unbound_numa() is called.
>> wq_update_unbound_numa() calls alloc_unbound_pwq(). And alloc_unbound_pwq()
>> calls get_unbound_pool(). In get_unbound_pool(), worker_pool->node is set
>> as follow:
>>
>> #kernel/workqueue.c
>> 3592         /* if cpumask is contained inside a NUMA node, we belong to that node */
>> 3593         if (wq_numa_enabled) {
>> 3594                 for_each_node(node) {
>> 3595                         if (cpumask_subset(pool->attrs->cpumask,
>> 3596                                            wq_numa_possible_cpumask[node])) {
>> 3597                                 pool->node = node;
>> 3598                                 break;
>> 3599                         }
>> 3600                 }
>> 3601         }
>>
>> But wq_numa_possible_cpumask[node] does not have correct cpumask. So, wrong
>> node is selected. As a result, kernel panic occurs.
>>
>> By this patch, all entries of wq_numa_possible_cpumask are allocated by
>> zalloc_cpumask_var_node to initialize them. And the panic disappeared.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> Hi, Yasuaki
>
> All cpumasks in the wq_numa_possible_cpumask array are allocated in
> wq_numa_init():
>
> 	for_each_node(node)
> 		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
> 				node_online(node) ? node : NUMA_NO_NODE));
>
> 	[snip...]
>
> 	wq_numa_possible_cpumask = tbl;
>
> I didn't find out how does this patch make the all entries of
> wq_numa_possible_cpumask zeroed.

Sorry. I mistook. I will resend soon.

Thanks,
Yasuaki Ishimatsu.

>
> Or I misunderstood.
>
> Thanks,
> Lai
>
>> ---
>>   kernel/workqueue.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 6203d29..b393ded 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -3338,7 +3338,7 @@ struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
>>   	attrs = kzalloc(sizeof(*attrs), gfp_mask);
>>   	if (!attrs)
>>   		goto fail;
>> -	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
>> +	if (!zalloc_cpumask_var(&attrs->cpumask, gfp_mask))
>>   		goto fail;
>>
>>   	cpumask_copy(attrs->cpumask, cpu_possible_mask);
>>
>> .
>>
>


