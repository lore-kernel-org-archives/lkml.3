Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbbAFOK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:10:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbbAFOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:10:28 -0500
Date: Tue, 6 Jan 2015 15:10:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Fix RCU stall upon ENOMEM at
 sched_create_group().
Message-ID: <20150106141012.GY29390@twins.programming.kicks-ass.net>
References: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412252210.GCC30204.SOMVFFOtQJFLOH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 10:10:45PM +0900, Tetsuo Handa wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ef2b104..586ee15 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -7756,8 +7756,12 @@ static void task_move_group_fair(struct task_struct *p, int queued)
>  void free_fair_sched_group(struct task_group *tg)
>  {
>  	int i;
> +	struct cfs_bandwidth *cfs_b;
>  
> -	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
> +	/* Check whether init_cfs_bandwidth() was called. */
> +	cfs_b = tg_cfs_bandwidth(tg);
> +	if (cfs_b->throttled_cfs_rq.next)
> +		destroy_cfs_bandwidth(cfs_b);
>  
>  	for_each_possible_cpu(i) {
>  		if (tg->cfs_rq)

This doesn't actually compile for !CONFIG_CFS_BANDWIDTH, how about:

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4005,6 +4005,10 @@ void __start_cfs_bandwidth(struct cfs_ba
 
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
+	/* init_cfs_bandwidth() was not called */
+	if (!cfs_b->throttled_cfs_rq.next)
+		return;
+
 	hrtimer_cancel(&cfs_b->period_timer);
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
