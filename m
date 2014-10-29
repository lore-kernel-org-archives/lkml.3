Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbaJ2Qd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:33:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46604 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbaJ2Qdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:33:55 -0400
Message-ID: <545116F7.7080607@arm.com>
Date: Wed, 29 Oct 2014 16:33:59 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] sched/dl: fix yield task artificial overrun
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-2-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 29 Oct 2014 16:33:52.0569 (UTC) FILETIME=[20116A90:01CFF396]
X-MC-Unique: 114102916335204101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/10/14 01:41, Wanpeng Li wrote:
> The yield semantic of deadline class is to reduce remaining runtime to 
> zero, and then update_curr_dl() will stop it. However, comsumed bandwidth 
> is reduced from the budget of yield task again even if it has already been 
> set to zero which leads to artificial overrun. This patch fix it by reduce 
> remaining runtime to zero if there is still remaining runtime after comsumed 
> bandwidth is accumulated.
> 

Oh, right. But, how about what below instead (with a proper comment
and changelog)?

Thanks,

- Juri

>From 108ecdff52b154ea2c79d4aac552ddf1ead871c7 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@arm.com>
Date: Wed, 29 Oct 2014 16:09:06 +0000
Subject: [PATCH] sched/deadline: fix artificial overrun introduced by
 yield_task_dl

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2e31a30..db6ad38 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -633,7 +633,7 @@ static void update_curr_dl(struct rq *rq)
 
 	sched_rt_avg_update(rq, delta_exec);
 
-	dl_se->runtime -= delta_exec;
+	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
-- 
2.1.2

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index abfaf3d..d4ffc1e 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -568,7 +568,12 @@ static
>  int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
>  {
>  	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
> -	int rorun = dl_se->runtime <= 0;
> +	int rorun;
> +
> +	if (dl_se->dl_yielded && dl_se->runtime > 0)
> +		dl_se->runtime = 0;
> +
> +	rorun = dl_se->runtime <= 0;
>  
>  	if (!rorun && !dmiss)
>  		return 0;
> @@ -897,10 +902,8 @@ static void yield_task_dl(struct rq *rq)
>  	 * it and the bandwidth timer will wake it up and will give it
>  	 * new scheduling parameters (thanks to dl_yielded=1).
>  	 */
> -	if (p->dl.runtime > 0) {
> +	if (p->dl.runtime > 0)
>  		rq->curr->dl.dl_yielded = 1;
> -		p->dl.runtime = 0;
> -	}
>  	update_curr_dl(rq);
>  }
>  
> 

