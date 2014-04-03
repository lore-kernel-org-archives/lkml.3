Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162641AbaDCIvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:51:21 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40162 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162526AbaDCIvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:51:13 -0400
Message-ID: <533D20E1.4000008@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2014 14:20:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, paulus@samba.org, nfont@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        rcj@linux.vnet.ibm.com, jlarrew@linux.vnet.ibm.com,
        alistair@popple.id.au, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] power, sched: stop updating inside arch_update_cpu_topology()
 when nothing to be update
References: <533B8431.8090507@linux.vnet.ibm.com>
In-Reply-To: <533B8431.8090507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040308-3864-0000-0000-00000D4C404F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 08:59 AM, Michael wang wrote:
> During the testing, we encounter below WARN followed by Oops:
> 
> 	WARNING: at kernel/sched/core.c:6218
> 	...
> 	NIP [c000000000101660] .build_sched_domains+0x11d0/0x1200
> 	LR [c000000000101358] .build_sched_domains+0xec8/0x1200
> 	PACATMSCRATCH [800000000000f032]
> 	Call Trace:
> 	[c00000001b103850] [c000000000101358] .build_sched_domains+0xec8/0x1200
> 	[c00000001b1039a0] [c00000000010aad4] .partition_sched_domains+0x484/0x510
> 	[c00000001b103aa0] [c00000000016d0a8] .rebuild_sched_domains+0x68/0xa0
> 	[c00000001b103b30] [c00000000005cbf0] .topology_work_fn+0x10/0x30
> 	...
> 	Oops: Kernel access of bad area, sig: 11 [#1]
> 	...
> 	NIP [c00000000045c000] .__bitmap_weight+0x60/0xf0
> 	LR [c00000000010132c] .build_sched_domains+0xe9c/0x1200
> 	PACATMSCRATCH [8000000000029032]
> 	Call Trace:
> 	[c00000001b1037a0] [c000000000288ff4] .kmem_cache_alloc_node_trace+0x184/0x3a0
> 	[c00000001b103850] [c00000000010132c] .build_sched_domains+0xe9c/0x1200
> 	[c00000001b1039a0] [c00000000010aad4] .partition_sched_domains+0x484/0x510
> 	[c00000001b103aa0] [c00000000016d0a8] .rebuild_sched_domains+0x68/0xa0
> 	[c00000001b103b30] [c00000000005cbf0] .topology_work_fn+0x10/0x30
> 	...
> 
> This was caused by that 'sd->groups == NULL' after building groups, which
> was caused by the empty 'sd->span'.
> 
> The cpu's domain contain nothing because the cpu was assigned to wrong
> node inside arch_update_cpu_topology() by calling update_lookup_table()
> with the uninitialized param, in the case when there is nothing to be
> update.
>

I think we need to verify this theory. Here are my thoughts:

If we get a topology update notification from the hypervisor, and then the
update happens to be nothing new (as in, new_node == old_node for the given
cpu), then updated_cpus mask will not have any cpus set in it (like you noted
below). In that scenario, the following sequence will take place:

Inside arch_cpu_update_topology(), the 'updates' has been kzalloc()'ed.
So updates[0] will have all its fields set to 0, such as ->cpu, ->new_nid etc.

When we invoke stop_machine() the first time like this:

stop_machine(update_cpu_topology, &updates[0], &updated_cpus);

stop-machine will notice that updated_cpus mask does not have any cpus set
in it, so it will nominate cpumask_first(cpu_online_mask) to run the
update_cpu_topology() function, which means that CPU0 will run it.

So, when CPU0 runs update_cpu_topology(), it will find that cpu == update->cpu
since both are 0, and will invoke unmap_cpu_from_node() and then calls
map_cpu_to_node(), with update->new_nid == 0.

Now, the interesting thing to note here is that, if CPU0's node was already
set as node0, *nothing* should go wrong, since its just a redundant update.
However, if CPU0's original node mapping was something different, or if
node0 doesn't even exist in the machine, then the system can crash.

Have you verified that CPU0's node mapping is different from node 0?
That is, boot the kernel with "numa=debug" in the kernel command line and
it will print out the cpu-to-node associativity during boot. That way you
can figure out what was the original associativity that was set. This will
confirm the theory that the hypervisor sent a redundant update, but because
of the weird pre-allocation using kzalloc that we do inside
arch_update_cpu_topology(), we wrongly updated CPU0's mapping as CPU0 <-> Node0.


Regards,
Srivatsa S. Bhat
 
> Thus we should stop the updating in such cases, this patch will achieve
> this and fix the issue.
> 
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Robert Jennings <rcj@linux.vnet.ibm.com>
> CC: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
> CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> CC: Alistair Popple <alistair@popple.id.au>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  arch/powerpc/mm/numa.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 30a42e2..6757690 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -1591,6 +1591,14 @@ int arch_update_cpu_topology(void)
>  		cpu = cpu_last_thread_sibling(cpu);
>  	}
> 
> +	/*
> +	 * The 'cpu_associativity_changes_mask' could be cleared if
> +	 * all the cpus it indicates won't change their node, in
> +	 * which case the 'updated_cpus' will be empty.
> +	 */
> +	if (!cpumask_weight(&updated_cpus))
> +		goto out;
> +
>  	stop_machine(update_cpu_topology, &updates[0], &updated_cpus);
> 
>  	/*
> @@ -1612,6 +1620,7 @@ int arch_update_cpu_topology(void)
>  		changed = 1;
>  	}
> 
> +out:
>  	kfree(updates);
>  	return changed;
>  }
> 

