Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaJHIbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:31:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaJHIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:31:44 -0400
Date: Wed, 8 Oct 2014 10:31:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, riel@redhat.com,
        tkhai@yandex.ru, mgorman@suse.de
Subject: Re: [PATCH] sched/fair: Care divide error in
 update_task_scan_period()
Message-ID: <20141008083139.GD10832@worktop.programming.kicks-ass.net>
References: <5434DCFF.1040208@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5434DCFF.1040208@jp.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:43:11PM +0900, Yasuaki Ishimatsu wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86..fb7dc3f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1496,18 +1496,26 @@ static void update_task_scan_period(struct task_struct *p,
>  			slot = 1;
>  		diff = slot * period_slot;
>  	} else {
> -		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
> +		if (unlikely((private + shared) == 0))
> +			/*
> +			 * This is a rare case. The trigger is node offline.
> +			 */
> +			diff = 0;
> +		else {
> +			diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
> 
> -		/*
> -		 * Scale scan rate increases based on sharing. There is an
> -		 * inverse relationship between the degree of sharing and
> -		 * the adjustment made to the scanning period. Broadly
> -		 * speaking the intent is that there is little point
> -		 * scanning faster if shared accesses dominate as it may
> -		 * simply bounce migrations uselessly
> -		 */
> -		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
> -		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
> +			/*
> +			 * Scale scan rate increases based on sharing. There is
> +			 * an inverse relationship between the degree of sharing
> +			 * and the adjustment made to the scanning period.
> +			 * Broadly speaking the intent is that there is little
> +			 * point scanning faster if shared accesses dominate as
> +			 * it may simply bounce migrations uselessly
> +			 */
> +			ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS,
> +							(private + shared));
> +			diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
> +		}
>  	}
> 
>  	p->numa_scan_period = clamp(p->numa_scan_period + diff,

Yeah, so I don't like the patch nor do I really like the function as it
stands -- which I suppose is part of why I don't like the patch.

The problem I have with the function is that its very inconsistent in
behaviour. In the early return path it sets numa_scan_period and
numa_next_scan, in the later return path it sets numa_scan_period and
numa_faults_locality.

I feel both return paths should affect the same set of variables, esp.
the non clearing of numa_faults_locality in the early path seems weird.

The thing I suppose I don't like about the patch is its added
indentation and the fact that the simple +1 thing wasn't considered.
