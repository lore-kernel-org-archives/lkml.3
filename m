Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaLOB6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:58:12 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:58893 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbaLOB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:58:11 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45143007"
Message-ID: <548E411C.3030102@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 10:02:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/5] workqueue: update wq_numa_possible_cpumask
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com> <20141212171821.GB20020@htj.dyndns.org>
In-Reply-To: <20141212171821.GB20020@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 01:18 AM, Tejun Heo wrote:
> On Fri, Dec 12, 2014 at 06:19:52PM +0800, Lai Jiangshan wrote:
> ...
>> +static void wq_update_numa_mapping(int cpu)
>> +{
>> +	int node, orig_node = NUMA_NO_NODE, new_node = cpu_to_node(cpu);
>> +
>> +	lockdep_assert_held(&wq_pool_mutex);
>> +
>> +	if (!wq_numa_enabled)
>> +		return;
>> +
>> +	/* the node of onlining CPU is not NUMA_NO_NODE */
>> +	if (WARN_ON(new_node == NUMA_NO_NODE))
>> +		return;
>> +
>> +	/* test whether the NUMA node mapping is changed. */
>> +	if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[new_node]))
>> +		return;
>> +
>> +	/* find the origin node */
>> +	for_each_node(node) {
>> +		if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[node])) {
>> +			orig_node = node;
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* there may be multi mappings changed, re-initial. */
>> +	cpumask_clear(wq_numa_possible_cpumask[new_node]);
>> +	if (orig_node != NUMA_NO_NODE)
>> +		cpumask_clear(wq_numa_possible_cpumask[orig_node]);
>> +	for_each_possible_cpu(cpu) {
>> +		node = cpu_to_node(node);
>> +		if (node == new_node)
>> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[new_node]);
>> +		else if (orig_node != NUMA_NO_NODE && node == orig_node)
>> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[orig_node]);
>> +	}
>> +}
> 
> Let's please move this to NUMA code and properly update it on actual
> mapping changes.
> 

Hi, TJ

I didn't get your means.  What did you mean "NUMA code"?  Which one did you mean?

1) "NUMA code" = system's NUMA memory hotplug code, AKA, keep the numa mapping stable

   I think this is the better idea.  This idea came to my mind immediately at the time
   I received the bug report.  And after some discussions, I was told that it is too HARD
   to keep the numa mapping stable across multiple physical system-board/node online/offline.

   This idea makes the assumption "the numa mapping is stable after system booted" as
   a restriction of the NUMA.  And it will favor all the code outside of the numa code,
   otherwise (we deny the assumption like this patchset) all the code which use
   "cpu_to_node()" and cache the return value will have to be fixed up like this patchset.

   Hi, hotplug-team, any idea to keep the numa mapping stable?

2) "NUMA code" = workqueue's NUMA code
   I think I already did it, the code I added was right below the code of
   wq_update_unbound_numa().  Or I missed something?

Thanks,
Lai
