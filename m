Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaGWDSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:18:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:37664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbaGWDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577350575"
Message-ID: <53CF2977.2040307@linux.intel.com>
Date: Wed, 23 Jul 2014 11:18:15 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC Patch V1 09/30] mm, memcg: Use cpu_to_mem()/numa_mem_id()
 to support memoryless node
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-10-git-send-email-jiang.liu@linux.intel.com> <20140718073614.GC21453@dhcp22.suse.cz>
In-Reply-To: <20140718073614.GC21453@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,
	Thanks for your comments! As discussed, we will
rework the patch set in another direction to hide memoryless
node from normal slab users.
Regards!
Gerry

On 2014/7/18 15:36, Michal Hocko wrote:
> On Fri 11-07-14 15:37:26, Jiang Liu wrote:
>> When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
>> may return a node without memory, and later cause system failure/panic
>> when calling kmalloc_node() and friends with returned node id.
>> So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
>> memory for the/current cpu.
>>
>> If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
>> is the same as cpu_to_node()/numa_node_id().
> 
> The change makes difference only for really tiny memcgs. If we really
> have all pages on unevictable list or anon with no swap allowed and that
> is the reason why no node is set in scan_nodes mask then reclaiming
> memoryless node or any arbitrary close one doesn't make any difference.
> The current memcg might not have any memory on that node at all.
> 
> So the change doesn't make any practical difference and the changelog is
> misleading.
> 
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  mm/memcontrol.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index a2c7bcb0e6eb..d6c4b7255ca9 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1933,7 +1933,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>>  	 * we use curret node.
>>  	 */
>>  	if (unlikely(node == MAX_NUMNODES))
>> -		node = numa_node_id();
>> +		node = numa_mem_id();
>>  
>>  	memcg->last_scanned_node = node;
>>  	return node;
>> -- 
>> 1.7.10.4
>>
> 
