Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaGYBlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:41:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:5453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaGYBlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,727,1400050800"; 
   d="scan'208";a="548743573"
Message-ID: <53D1B5C2.6020700@linux.intel.com>
Date: Fri, 25 Jul 2014 09:41:22 +0800
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
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Lans Zhang <jia.zhang@windriver.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [RFC Patch V1 29/30] mm, x86: Enable memoryless node support
 to better support CPU/memory hotplug
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-30-git-send-email-jiang.liu@linux.intel.com> <20140724232605.GB24458@linux.vnet.ibm.com>
In-Reply-To: <20140724232605.GB24458@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/7/25 7:26, Nishanth Aravamudan wrote:
> On 11.07.2014 [15:37:46 +0800], Jiang Liu wrote:
>> With current implementation, all CPUs within a NUMA node will be
>> assocaited with another NUMA node if the node has no memory installed.
> 
> <snip>
> 
>> ---
>>  arch/x86/Kconfig            |    3 +++
>>  arch/x86/kernel/acpi/boot.c |    5 ++++-
>>  arch/x86/kernel/smpboot.c   |    2 ++
>>  arch/x86/mm/numa.c          |   42 +++++++++++++++++++++++++++++++++++-------
>>  4 files changed, 44 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index a8f749ef0fdc..f35b25b88625 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1887,6 +1887,9 @@ config USE_PERCPU_NUMA_NODE_ID
>>  	def_bool y
>>  	depends on NUMA
>>
>> +config HAVE_MEMORYLESS_NODES
>> +	def_bool NUMA
>> +
>>  config ARCH_ENABLE_SPLIT_PMD_PTLOCK
>>  	def_bool y
>>  	depends on X86_64 || X86_PAE
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index 86281ffb96d6..3b5641703a49 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -612,6 +612,8 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
>>  	if (nid != -1) {
>>  		set_apicid_to_node(physid, nid);
>>  		numa_set_node(cpu, nid);
>> +		if (node_online(nid))
>> +			set_cpu_numa_mem(cpu, local_memory_node(nid));
> 
> How common is it for this method to be called for a CPU on an offline
> node? Aren't you fixing this in the next patch (so maybe the order
> should be changed?)?
Hi Nishanth,
	For physical CPU hot-addition instead of logical CPU online through
sysfs, the node is always in offline state.
	In v2, I have reordered the patch set so patch 30 goes first.

> 
>>  	}
>>  #endif
>>  }
>> @@ -644,9 +646,10 @@ int acpi_unmap_lsapic(int cpu)
>>  {
>>  #ifdef CONFIG_ACPI_NUMA
>>  	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
>> +	set_cpu_numa_mem(cpu, NUMA_NO_NODE);
>>  #endif
>>
>> -	per_cpu(x86_cpu_to_apicid, cpu) = -1;
>> +	per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
> 
> I think this is an unrelated change?
Thanks for reminder, it's unrelated to support memoryless node.

> 
>>  	set_cpu_present(cpu, false);
>>  	num_processors--;
>>
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 5492798930ef..4a5437989ffe 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -162,6 +162,8 @@ static void smp_callin(void)
>>  		      __func__, cpuid);
>>  	}
>>
>> +	set_numa_mem(local_memory_node(cpu_to_node(cpuid)));
>> +
> 
> Note that you might hit the same issue I reported on powerpc, if
> smp_callin() is part of smp_init(). The waitqueue initialization code
> depends on cpu_to_node() [and eventually cpu_to_mem()] to be initialized
> quite early.
Thanks for reminder. Patch 29/30 together will setup cpu_to_mem() array
when enumerating CPUs for hot-adding events, so it should be ready
for use when onlining those CPUs.

Regards!
Gerry
> 
> Thanks,
> Nish
> 
