Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3GXD0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:26:43 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34831 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3GXD0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:26:41 -0400
Message-ID: <51EF4969.4050807@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 11:26:33 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
References: <1374601332.9192.0.camel@localhost.localdomain>
In-Reply-To: <1374601332.9192.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072403-3864-0000-0000-0000093A4A5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rakib

On 07/24/2013 01:42 AM, Rakib Mullick wrote:
> Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
> callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
> domain and update only at the times of building schedule domains.
> 
> 	partition_sched_domains()
> 		detach_destroy_domain()
> 			cpu_attach_domain()
> 				update_top_cache_domain()

IMHO, cpu_attach_domain() and update_top_cache_domain() should be
paired, below patch will open a window which 'rq->sd == NULL' while
'sd_llc != NULL', isn't it?

I don't think we have the promise that before we rebuild the stuff
correctly, no one will utilize 'sd_llc'...

Further more, what will happen if the old sd was freed after next rcu
work cycle while 'sd_llc' still hold the reference for some victims?

Thus I do suggest we leave the things untouched since the benefit we get
is too less, not worth the risk...

Regards,
Michael Wang

> 		build_sched_domains()
> 			cpu_attach_domain()
> 				update_top_cache_domain()
> 
> Changes since v1: use sd to determine when to skip, courtesy PeterZ
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b7c32cb..387fb66 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5138,7 +5138,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>  	rcu_assign_pointer(rq->sd, sd);
>  	destroy_sched_domains(tmp, cpu);
> 
> -	update_top_cache_domain(cpu);
> +	if (sd)
> +		update_top_cache_domain(cpu);
>  }
> 
>  /* cpus with isolated domains */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

