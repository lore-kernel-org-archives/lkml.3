Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbaGYBuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:50:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:11628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbaGYBuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:50:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,727,1400050800"; 
   d="scan'208";a="548746009"
Message-ID: <53D1B7C9.9040907@linux.intel.com>
Date: Fri, 25 Jul 2014 09:50:01 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
CC: Tony Luck <tony.luck@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-hotplug@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <20140721172331.GB4156@linux.vnet.ibm.com> <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com> <20140721175736.GG4156@linux.vnet.ibm.com> <53CF7048.20302@linux.intel.com> <20140724233230.GD24458@linux.vnet.ibm.com>
In-Reply-To: <20140724233230.GD24458@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/7/25 7:32, Nishanth Aravamudan wrote:
> On 23.07.2014 [16:20:24 +0800], Jiang Liu wrote:
>>
>>
>> On 2014/7/22 1:57, Nishanth Aravamudan wrote:
>>> On 21.07.2014 [10:41:59 -0700], Tony Luck wrote:
>>>> On Mon, Jul 21, 2014 at 10:23 AM, Nishanth Aravamudan
>>>> <nacc@linux.vnet.ibm.com> wrote:
>>>>> It seems like the issue is the order of onlining of resources on a
>>>>> specific x86 platform?
>>>>
>>>> Yes. When we online a node the BIOS hits us with some ACPI hotplug events:
>>>>
>>>> First: Here are some new cpus
>>>
>>> Ok, so during this period, you might get some remote allocations. Do you
>>> know the topology of these CPUs? That is they belong to a
>>> (soon-to-exist) NUMA node? Can you online that currently offline NUMA
>>> node at this point (so that NODE_DATA()) resolves, etc.)?
>> Hi Nishanth,
>> 	We have method to get the NUMA information about the CPU, and
>> patch "[RFC Patch V1 30/30] x86, NUMA: Online node earlier when doing
>> CPU hot-addition" tries to solve this issue by onlining NUMA node
>> as early as possible. Actually we are trying to enable memoryless node
>> as you have suggested.
> 
> Ok, it seems like you have two sets of patches then? One is to fix the
> NUMA information timing (30/30 only). The rest of the patches are
> general discussions about where cpu_to_mem() might be used instead of
> cpu_to_node(). However, based upon Tejun's feedback, it seems like
> rather than force all callers to use cpu_to_mem(), we should be looking
> at the core VM to ensure fallback is occuring appropriately when
> memoryless nodes are present. 
> 
> Do you have a specific situation, once you've applied 30/30, where
> kmalloc_node() leads to an Oops?
Hi Nishanth,
	After following the two threads related to support of memoryless
node and digging more code, I realized my first version path set is an
overkill. As Tejun has pointed out, we shouldn't expose the detail of
memoryless node to normal user, but there are still some special users
who need the detail. So I have tried to summarize it as:
1) Arch code should online corresponding NUMA node before onlining any
   CPU or memory, otherwise it may cause invalid memory access when
   accessing NODE_DATA(nid).
2) For normal memory allocations without __GFP_THISNODE setting in the
   gfp_flags, we should prefer numa_node_id()/cpu_to_node() instead of
   numa_mem_id()/cpu_to_mem() because the latter loses hardware topology
   information as pointed out by Tejun:
           A - B - X - C - D
        Where X is the memless node.  numa_mem_id() on X would return
        either B or C, right?  If B or C can't satisfy the allocation,
        the allocator would fallback to A from B and D for C, both of
        which aren't optimal. It should first fall back to C or B
        respectively, which the allocator can't do anymoe because the
        information is lost when the caller side performs numa_mem_id().
3) For memory allocation with __GFP_THISNODE setting in gfp_flags,
   numa_node_id()/cpu_to_node() should be used if caller only wants to
   allocate from local memory, otherwise numa_mem_id()/cpu_to_mem()
   should be used if caller wants to allocate from the nearest node.
4) numa_mem_id()/cpu_to_mem() should be used if caller wants to check
   whether a page is allocated from the nearest node.

And my v2 patch set is based on above rules.
Any suggestions here?
Regards!
Gerry

> 
> Thanks,
> Nish
> 
