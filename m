Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaLOFV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:21:27 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:57722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbaLOFV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:21:26 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45155173"
Message-ID: <548E70C6.8020202@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 13:25:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] workqueue: fix memory leak in wq_numa_init()
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-2-git-send-email-laijs@cn.fujitsu.com> <20141212171216.GA20020@htj.dyndns.org>
In-Reply-To: <20141212171216.GA20020@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 01:12 AM, Tejun Heo wrote:
> On Fri, Dec 12, 2014 at 06:19:51PM +0800, Lai Jiangshan wrote:
>> wq_numa_init() will quit directly on some bonkers cases without freeing the
>> memory.  Add the missing cleanup code.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
>> Cc: tangchen <tangchen@cn.fujitsu.com>
>> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 09b685d..a6fd2b8 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4811,6 +4811,9 @@ static void __init wq_numa_init(void)
>>  		if (WARN_ON(node == NUMA_NO_NODE)) {
>>  			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
>>  			/* happens iff arch is bonkers, let's just proceed */
>> +			for_each_node(node)
>> +				free_cpumask_var(tbl[node]);
>> +			kfree(tbl);
> 
> The comment right up there says that this happens if and only if the
> arch code is seriously broken and it's consciously skipping exception
> handling.  That's a condition where we might as well trigger BUG_ON().
> Just leave it alone.


cpu_to_node() can return NUMA_NO_NODE after system booted (when node offline) currently.
so I don't think it is seriously broken if cpu_to_node() returns NUMA_NO_NODE
when booting.

See:

static void unmap_cpu_on_node(pg_data_t *pgdat)
{
#ifdef CONFIG_ACPI_NUMA
	int cpu;

	for_each_possible_cpu(cpu)
		if (cpu_to_node(cpu) == pgdat->node_id)
			numa_clear_node(cpu);
#endif
}

> 
> Thanks.
> 

