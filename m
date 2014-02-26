Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaBZXJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:09:48 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35132 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBZXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:09:47 -0500
Date: Wed, 26 Feb 2014 15:08:59 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] percpu_ida: Do not steal all remote CPU tags at once
Message-ID: <20140226230859.GG11655@kmo>
References: <cover.1391688720.git.agordeev@redhat.com>
 <20140216112528.GA13853@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140216112528.GA13853@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 12:25:29PM +0100, Alexander Gordeev wrote:
> When stealing from a remote CPU all available tags are moved
> from the remote CPU's cache to the stealing CPU's one. Since
> the best CPU to steal from is not selected the victim might
> actively performing IO and (as result of losing all local
> tags) a further cycle of cache rebouncing and/or stealing
> could be provoked.
> 
> This update is an attempt to soften the described scenario
> and limit the number of tags to be stolen at once to the
> value of percpu_batch_size.

I don't want this patch without a benchmark justifying the change and more
analysis; this could easily lead to more stealing and cacheline bouncing.

> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> ---
>  lib/percpu_ida.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index fad029c..b4c4cc7 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -84,20 +84,22 @@ static inline void steal_tags(struct percpu_ida *pool,
>  		pool->cpu_last_stolen = cpu;
>  		remote = per_cpu_ptr(pool->tag_cpu, cpu);
>  
> -		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
> -
> -		if (remote == tags)
> +		if (remote == tags) {
> +			cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
>  			continue;
> +		}
>  
>  		spin_lock(&remote->lock);
>  
>  		if (remote->nr_free) {
> -			memcpy(tags->freelist,
> -			       remote->freelist,
> -			       sizeof(unsigned) * remote->nr_free);
> +			const struct percpu_ida *p = pool;
> +
> +			move_tags(tags->freelist, &tags->nr_free,
> +				  remote->freelist, &remote->nr_free,
> +				  min(remote->nr_free, p->percpu_batch_size));
>  
> -			tags->nr_free = remote->nr_free;
> -			remote->nr_free = 0;
> +			if (!remote->nr_free)
> +				cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
>  		}
>  
>  		spin_unlock(&remote->lock);
> -- 
> 1.7.7.6
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
