Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbbA0MsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:48:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:38274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbbA0MsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:48:19 -0500
Date: Tue, 27 Jan 2015 13:48:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 3/5] sched/deadline: Fix wrong cpudl_find() in
 check_preempt_equal_dl()
Message-ID: <20150127124815.GC21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 04:49:38AM +0000, Xunlei Pang wrote:
> +++ b/kernel/sched/deadline.c
> @@ -943,14 +943,23 @@ out:
>  	return cpu;
>  }
>  
> +static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
> +
>  static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
>  {
> +	struct cpumask *later_mask =
> +			this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
> +
> +	/* Make sure the mask is initialized first */
> +	if (unlikely(!later_mask))
> +		return;
> +
>  	/*
>  	 * Current can't be migrated, useless to reschedule,
>  	 * let's hope p can move out.
>  	 */
>  	if (rq->curr->nr_cpus_allowed == 1 ||
> -	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
> +	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == -1)
>  		return;
>  
>  	/*

But but, should you not put something in that mask before you use it?
