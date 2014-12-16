Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaLPSJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:09:51 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:42305 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaLPSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:09:43 -0500
From: bsegall@google.com
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, pjt@google.com
Subject: Re: [PATCH] sched/fair: Fix the dealing with decay_count in __synchronize_entity_decay()
References: <1418745509-2609-1-git-send-email-pang.xunlei@linaro.org>
Date: Tue, 16 Dec 2014 10:09:40 -0800
In-Reply-To: <1418745509-2609-1-git-send-email-pang.xunlei@linaro.org> (Xunlei
	Pang's message of "Tue, 16 Dec 2014 23:58:29 +0800")
Message-ID: <xm26d27j79gb.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xunlei Pang <pang.xunlei@linaro.org> writes:

> In __synchronize_entity_decay(), if "decays" happens to be zero, 
> se->avg.decay_count will not be zeroed, holding the positive value
> assigned when dequeued last time.
>
> This is problematic in the following case:
> If this runnable task is CFS-balanced to other CPUs soon afterwards, 
> migrate_task_rq_fair() will treat it as a blocked task due to its
> non-zero decay_count, thereby adding its load to cfs_rq->removed_load
> wrongly.
>
> Thus, we must zero se->avg.decay_count in this case as well.

Yep. We probably didn't notice this because migrate will happen to clear
this by doing decay_count = -__synch(), but you can hit this via
switched_from_fair or just on enqueue followed by a load-balance
migration that thinks decay_counter was zero due to being on_rq.

>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>

Reviewed-by: Ben Segall <bsegall@google.com>

> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df2cdf7..ea517cd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2574,11 +2574,11 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
>  	u64 decays = atomic64_read(&cfs_rq->decay_counter);
>  
>  	decays -= se->avg.decay_count;
> +	se->avg.decay_count = 0;
>  	if (!decays)
>  		return 0;
>  
>  	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
> -	se->avg.decay_count = 0;
>  
>  	return decays;
>  }
