Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024AbaGXXao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:30:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47163 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934568AbaGXXal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:30:41 -0400
Date: Thu, 24 Jul 2014 16:30:27 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [RFC Patch V1 30/30] x86, NUMA: Online node earlier when doing
 CPU hot-addition
Message-ID: <20140724233027.GC24458@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-31-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064267-11678-31-git-send-email-jiang.liu@linux.intel.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072423-5806-0000-0000-0000001211DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.2014 [15:37:47 +0800], Jiang Liu wrote:
> With typical CPU hot-addition flow on x86, PCI host bridges embedded
> in physical processor are always associated with NOMA_NO_NODE, which
> may cause sub-optimal performance.
> 1) Handle CPU hot-addition notification
> 	acpi_processor_add()
> 		acpi_processor_get_info()
> 			acpi_processor_hotadd_init()
> 				acpi_map_lsapic()
> 1.a)					acpi_map_cpu2node()
> 
> 2) Handle PCI host bridge hot-addition notification
> 	acpi_pci_root_add()
> 		pci_acpi_scan_root()
> 2.a)			if (node != NUMA_NO_NODE && !node_online(node)) node = NUMA_NO_NODE;
> 
> 3) Handle memory hot-addition notification
> 	acpi_memory_device_add()
> 		acpi_memory_enable_device()
> 			add_memory()
> 3.a)				node_set_online();
> 
> 4) Online CPUs through sysfs interfaces
> 	cpu_subsys_online()
> 		cpu_up()
> 			try_online_node()
> 4.a)				node_set_online();
> 
> So associated node is always in offline state because it is onlined
> until step 3.a or 4.a.
> 
> We could improve performance by online node at step 1.a. This change
> also makes the code symmetric. Nodes are always created when handling
> CPU/memory hot-addition events instead of handling user requests from
> sysfs interfaces, and are destroyed when handling CPU/memory hot-removal
> events.

It seems like this patch has little to nothing to do with the rest of
the series and can be sent on its own?

> It also close a race window caused by kmalloc_node(cpu_to_node(cpu)),

To be clear, the race is that on some x86 platforms, there is a period
of time where a node ID returned by cpu_to_node() is offline.

<snip>

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 3b5641703a49..00c2ed507460 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -611,6 +611,7 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
>  	nid = acpi_get_node(handle);
>  	if (nid != -1) {
>  		set_apicid_to_node(physid, nid);
> +		try_online_node(nid);

try_online_node() seems like it can fail? I assume it's a pretty rare
case, but should the return code be checked?

If it does fail, it seems like there are pretty serious problems and we
shouldn't be onlining this CPU, etc.?

>  		numa_set_node(cpu, nid);
>  		if (node_online(nid))
>  			set_cpu_numa_mem(cpu, local_memory_node(nid));

Which means you can remove this check presuming try_online_node()
returned 0.

Thanks,
Nish

