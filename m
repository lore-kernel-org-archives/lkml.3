Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3IPIIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:08:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3IPIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:08:35 -0400
Date: Mon, 16 Sep 2013 10:08:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/2] sched: load_balance: Prevent reselect prev dst_cpu
 if some pinned
Message-ID: <20130916080828.GO21832@twins.programming.kicks-ass.net>
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 09:30:13PM +0400, Vladimir Davydov wrote:
> Currently new_dst_cpu is prevented from being reselected actually, not
> dst_cpu. This can result in attempting to pull tasks to this_cpu twice.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  kernel/sched/fair.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9b3fe1c..cd59640 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5269,15 +5269,15 @@ more_balance:
>  		 */
>  		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
>  
> +			/* Prevent to re-select dst_cpu via env's cpus */
> +			cpumask_clear_cpu(env.dst_cpu, env.cpus);
> +
>  			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
>  			env.dst_cpu	 = env.new_dst_cpu;
>  			env.flags	&= ~LBF_SOME_PINNED;
>  			env.loop	 = 0;
>  			env.loop_break	 = sched_nr_migrate_break;
>  
> -			/* Prevent to re-select dst_cpu via env's cpus */
> -			cpumask_clear_cpu(env.dst_cpu, env.cpus);
> -
>  			/*
>  			 * Go back to "more_balance" rather than "redo" since we
>  			 * need to continue with same src_cpu.

FWIW please submit patches against tip/master (or at the very least
against tip/sched/core).

I currently picked up:

vladimir_davydov-2_sched-fix_small_imbalance__fix_local-_avg_load___busiest-_avg_load_case.patch
vladimir_davydov-sched-fix_task_h_load_calculation.patch
vladimir_davydov-1_sched-load_balance__prevent_reselect_prev_dst_cpu_if_some_pinned.patch

So I've two patches still outstanding.. one on the <= vs < issue and the
other for loosing the bound on the load-balance passes.
