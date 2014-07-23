Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbaGWIQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:16:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:23848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGWIQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:16:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="577451840"
Message-ID: <53CF6F4E.6030908@linux.intel.com>
Date: Wed, 23 Jul 2014 16:16:14 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 28/30] mm: Update _mem_id_[] for every possible
 CPU when memory configuration changes
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-29-git-send-email-jiang.liu@linux.intel.com> <20140721174754.GE4156@linux.vnet.ibm.com>
In-Reply-To: <20140721174754.GE4156@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/7/22 1:47, Nishanth Aravamudan wrote:
> On 11.07.2014 [15:37:45 +0800], Jiang Liu wrote:
>> Current kernel only updates _mem_id_[cpu] for onlined CPUs when memory
>> configuration changes. So kernel may allocate memory from remote node
>> for a CPU if the CPU is still in absent or offline state even if the
>> node associated with the CPU has already been onlined.
> 
> This just sounds like the topology information is being updated at the
> wrong place/time? That is, the memory is online, the CPU is being
> brought online, but isn't associated with any node?
Hi Nishanth,
	Yes, that's the case.

> 
>> This patch tries to improve performance by updating _mem_id_[cpu] for
>> each possible CPU when memory configuration changes, thus kernel could
>> always allocate from local node once the node is onlined.
> 
> Ok, what is the impact? Do you actually see better performance?
No real data to support this yet, just with code analysis.
Regards!
Gerry
> 
>> We check node_online(cpu_to_node(cpu)) because:
>> 1) local_memory_node(nid) needs to access NODE_DATA(nid)
>> 2) try_offline_node(nid) just zeroes out NODE_DATA(nid) instead of free it
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  mm/page_alloc.c |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 0ea758b898fd..de86e941ed57 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3844,13 +3844,13 @@ static int __build_all_zonelists(void *data)
>>  		/*
>>  		 * We now know the "local memory node" for each node--
>>  		 * i.e., the node of the first zone in the generic zonelist.
>> -		 * Set up numa_mem percpu variable for on-line cpus.  During
>> -		 * boot, only the boot cpu should be on-line;  we'll init the
>> -		 * secondary cpus' numa_mem as they come on-line.  During
>> -		 * node/memory hotplug, we'll fixup all on-line cpus.
>> +		 * Set up numa_mem percpu variable for all possible cpus
>> +		 * if associated node has been onlined.
>>  		 */
>> -		if (cpu_online(cpu))
>> +		if (node_online(cpu_to_node(cpu)))
>>  			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
>> +		else
>> +			set_cpu_numa_mem(cpu, NUMA_NO_NODE);
>>  #endif
> 
> 
