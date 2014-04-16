Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaDPDPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:15:10 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54809 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDPDPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:15:07 -0400
Message-ID: <534DF5B1.7070702@linux.vnet.ibm.com>
Date: Wed, 16 Apr 2014 11:14:57 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, paulus@samba.org, nfont@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        rcj@linux.vnet.ibm.com, jlarrew@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, alistair@popple.id.au
Subject: Re: [PATCH v2] power, sched: stop updating inside arch_update_cpu_topology()
 when nothing to be update
References: <533B8431.8090507@linux.vnet.ibm.com> <53436AC8.5020705@linux.vnet.ibm.com>
In-Reply-To: <53436AC8.5020705@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041603-2000-0000-0000-000010D28BE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:19 AM, Michael wang wrote:
> Since v1:
> 	Edited the comment according to Srivatsa's suggestion.
> 
> During the testing, we encounter below WARN followed by Oops:

Is there any more comments on this issue? Should we apply this fix?

Regards,
Michael Wang

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
> The cpu's domain contained nothing because the cpu was assigned to a wrong
> node, due to the following unfortunate sequence of events:
> 
> 1. The hypervisor sent a topology update to the guest OS, to notify changes
>    to the cpu-node mapping. However, the update was actually redundant - i.e.,
>    the "new" mapping was exactly the same as the old one.
> 
> 2. Due to this, the 'updated_cpus' mask turned out to be empty after exiting
>    the 'for-loop' in arch_update_cpu_topology().
> 
> 3. So we ended up calling stop-machine() with an empty cpumask list, which made
>    stop-machine internally elect cpumask_first(cpu_online_mask), i.e., CPU0 as
>    the cpu to run the payload (the update_cpu_topology() function).
> 
> 4. This causes update_cpu_topology() to be run by CPU0. And since 'updates'
>    is kzalloc()'ed inside arch_update_cpu_topology(), update_cpu_topology()
>    finds update->cpu as well as update->new_nid to be 0. In other words, we
>    end up assigning CPU0 (and eventually its siblings) to node 0, incorrectly.
> 
> Along with the following wrong updating, it causes the sched-domain rebuild
> code to break and crash the system.
> 
> Fix this by skipping the topology update in cases where we find that
> the topology has not actually changed in reality (ie., spurious updates).
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
> Suggested-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  arch/powerpc/mm/numa.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 30a42e2..4ebbb9e 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -1591,6 +1591,20 @@ int arch_update_cpu_topology(void)
>  		cpu = cpu_last_thread_sibling(cpu);
>  	}
>  
> +	/*
> +	 * In cases where we have nothing to update (because the updates list
> +	 * is too short or because the new topology is same as the old one),
> +	 * skip invoking update_cpu_topology() via stop-machine(). This is
> +	 * necessary (and not just a fast-path optimization) since stop-machine
> +	 * can end up electing a random CPU to run update_cpu_topology(), and
> +	 * thus trick us into setting up incorrect cpu-node mappings (since
> +	 * 'updates' is kzalloc()'ed).
> +	 *
> +	 * And for the similar reason, we will skip all the following updating.
> +	 */
> +	if (!cpumask_weight(&updated_cpus))
> +		goto out;
> +
>  	stop_machine(update_cpu_topology, &updates[0], &updated_cpus);
>  
>  	/*
> @@ -1612,6 +1626,7 @@ int arch_update_cpu_topology(void)
>  		changed = 1;
>  	}
>  
> +out:
>  	kfree(updates);
>  	return changed;
>  }
> 

