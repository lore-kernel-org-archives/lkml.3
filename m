Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaELHzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:55:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbaELHzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:55:40 -0400
Date: Mon, 12 May 2014 09:55:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        akpm <akpm@linux-foundation.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH V3] MM: make vmpressure_win dynamic
Message-ID: <20140512075537.GA9564@dhcp22.suse.cz>
References: <20140510085217.24a34794f0e4a4881c8eec0b@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510085217.24a34794f0e4a4881c8eec0b@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-05-14 08:52:17, Fabian Frederick wrote:
> This patch addresses TODO featuring in original version :

This is the 3rd version of the patch and I still fail to see the
motivation other than addressing a TODO which doesn't sound like a
sufficient justification to me. Why is the new scheme needed in the
first place? Why is calculate_normal_threshold a proper scheme?

> "Make the window size depend on machine size, as we do for vmstat"
> 
> It initializes vmpressure_win in vmstat using calculate_normal_threshold()
> based on each zone/cpu * SWAP_CLUSTER_SIZE instead of
> static SWAP_CLUSTER_MAX * 16 = 512
> 
> Some values :
> 
> CPU	MB	VMPRESSURE
> 8	512	1024
> 1	1024 	320
> 2	1024 	640
> 2	2048 	768
> 4	2048	1152
> 1	4096 	640
> 4	4096 	1920
> ...
> 
> (No maximum vmpressure value currently defined)
> 
> cf mm/vmstat.c: calculate_normal_threshold for further values
> 
> vmpressure_win is refreshed through cpu notifier and exposed read-only in
> /proc/sys/vm/vmpressure_win
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V3:
>   -Further description
>   -sysctl handler / ulong
>   -Cc list
> 
> V2: Suggestions by Andrew Morton
>   -Expose vmpressure_win
>   -Remove spinlock
> 
>  include/linux/swap.h | 4 ++++
>  kernel/sysctl.c      | 9 +++++++++
>  mm/vmpressure.c      | 4 +---
>  mm/vmstat.c          | 6 ++++++
>  4 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3507115..886897d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -354,6 +354,10 @@ extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
>  extern unsigned long vm_total_pages;
>  
> +#ifdef CONFIG_MEMCG
> +extern unsigned long vmpressure_win;
> +#endif
> +
>  #ifdef CONFIG_NUMA
>  extern int zone_reclaim_mode;
>  extern int sysctl_min_unmapped_ratio;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 74f5b58..c0c5ea6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1202,6 +1202,15 @@ static struct ctl_table vm_table[] = {
>  		.mode           = 0444 /* read-only */,
>  		.proc_handler   = pdflush_proc_obsolete,
>  	},
> +#ifdef CONFIG_MEMCG
> +	{
> +		.procname	= "vmpressure_window",
> +		.data		= &vmpressure_win,
> +		.maxlen		= sizeof(vmpressure_win),
> +		.mode		= 0444,
> +		.proc_handler	= proc_doulongvec_minmax,
> +	},
> +#endif
>  	{
>  		.procname	= "swappiness",
>  		.data		= &vm_swappiness,
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index d4042e7..d738670 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -35,10 +35,8 @@
>   * As the vmscan reclaimer logic works with chunks which are multiple of
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
>   *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
>   */
> -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
>  
>  /*
>   * These thresholds are used when we account memory pressure through
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 302dd07..ede68fd 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -20,6 +20,7 @@
>  #include <linux/writeback.h>
>  #include <linux/compaction.h>
>  #include <linux/mm_inline.h>
> +#include <linux/swap.h>
>  
>  #include "internal.h"
>  
> @@ -163,11 +164,13 @@ void refresh_zone_stat_thresholds(void)
>  	struct zone *zone;
>  	int cpu;
>  	int threshold;
> +	unsigned long new_vmpressure_win = 0;
>  
>  	for_each_populated_zone(zone) {
>  		unsigned long max_drift, tolerate_drift;
>  
>  		threshold = calculate_normal_threshold(zone);
> +		new_vmpressure_win += threshold;
>  
>  		for_each_online_cpu(cpu)
>  			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
> @@ -184,6 +187,9 @@ void refresh_zone_stat_thresholds(void)
>  			zone->percpu_drift_mark = high_wmark_pages(zone) +
>  					max_drift;
>  	}
> +#ifdef CONFIG_MEMCG
> +	vmpressure_win = new_vmpressure_win * SWAP_CLUSTER_MAX;
> +#endif
>  }
>  
>  void set_pgdat_percpu_threshold(pg_data_t *pgdat,
> -- 
> 1.8.4.5

-- 
Michal Hocko
SUSE Labs
