Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3CHGmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:42:35 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57340 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3CHGmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:42:33 -0500
Date: Thu, 7 Mar 2013 22:42:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 10/14] x86, mm, numa: Move emulation handling down.
Message-ID: <20130308064227.GK14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-11-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-11-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:36PM -0800, Yinghai Lu wrote:
> -static int __init numa_check_memblks(struct numa_meminfo *mi)
> +
> +int __init numa_check_memblks(struct numa_meminfo *mi)
>  {
> +	nodemask_t tmp_node_map;
>  	unsigned long pfn_align;
>  
>  	/* Account for nodes with cpus and no memory */
> -	node_possible_map = numa_nodes_parsed;
> -	numa_nodemask_from_meminfo(&node_possible_map, mi);
> -	if (WARN_ON(nodes_empty(node_possible_map)))
> +	tmp_node_map = numa_nodes_parsed;
> +	numa_nodemask_from_meminfo(&tmp_node_map, mi);
> +	if (WARN_ON(nodes_empty(tmp_node_map)))
>  		return -EINVAL;
>  
>  	if (!numa_meminfo_cover_memory(mi))
> @@ -562,6 +564,7 @@ static int __init numa_check_memblks(struct numa_meminfo *mi)
>  		return -EINVAL;
>  	}
>  
> +	node_possible_map = tmp_node_map;

Hmmm.... it's kinda nasty to have a side effect like the above for a
function named numa_check_memblks().  Maybe we can move this to the
caller or name the function to make it clear that some global state is
being updated?

> @@ -608,8 +611,6 @@ static int __init numa_init(int (*init_func)(void))
>  	if (ret < 0)
>  		return ret;
>  
> -	numa_emulation(&numa_meminfo, numa_distance_cnt);
> -
>  	ret = numa_check_memblks(&numa_meminfo);
>  	if (ret < 0)
>  		return ret;
> @@ -669,6 +670,8 @@ void __init x86_numa_init(void)
>  	numa_init(dummy_numa_init);
>  
>  out:
> +	numa_emulation(&numa_meminfo, numa_distance_cnt);
> +
>  	for (i = 0; i < mi->nr_blks; i++) {
>  		struct numa_memblk *mb = &mi->blk[i];
>  		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
> diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
> index dbbbb47..5a0433d 100644
> --- a/arch/x86/mm/numa_emulation.c
> +++ b/arch/x86/mm/numa_emulation.c
> @@ -348,7 +348,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  	if (ret < 0)
>  		goto no_emu;
>  
> -	if (numa_cleanup_meminfo(&ei) < 0) {
> +	if (numa_cleanup_meminfo(&ei) < 0 || numa_check_memblks(&ei) < 0) {
>  		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
>  		goto no_emu;
>  	}

Given that acpi is the only mechanism which matters in any modern NUMA
machines, I think the re-ordering should be fine.

Thanks.

-- 
tejun
