Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbaD2IkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:40:00 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58575 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaD2Ij5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:39:57 -0400
Date: Tue, 29 Apr 2014 10:39:53 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: "yjay.kim" <yjay.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: remove dl_new checking condition from
 dl_task_timer()
Message-Id: <20140429103953.e68eba1b2ac3309214e3dc5a@gmail.com>
In-Reply-To: <1398653845-22615-1-git-send-email-yjay.kim@lge.com>
References: <1398653845-22615-1-git-send-email-yjay.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 28 Apr 2014 11:57:25 +0900
"yjay.kim" <yjay.kim@lge.com> wrote:

> From: "yjay.kim" <yjay.kim@lge.com>
> 
> yield_task_dl() sets dl.dl_new as 1 and dequeue current dl task.
> After that it expects that next bandwidth timer callback `dl_task_timer()` will
> replenish budget of dl task and enqueue it again.
> 
> But current dl_task_timer() does nothing in case dl.dl_new is 1.
> So when dl task calls sched_yield(), it will never be scheduled again.
> 
> dl_task_timer() should works in case dl_new is 1.
> 
> Signed-off-by: yjay.kim <yjay.kim@lge.com>
> ---
>  kernel/sched/deadline.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 27ef409..6fb4004 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -522,7 +522,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>  	 * different from SCHED_DEADLINE or changed its reservation
>  	 * parameters (through sched_setscheduler()).
>  	 */
> -	if (!dl_task(p) || dl_se->dl_new)

Unfortunately, we still need this check to discriminate cases when the
user wanted to change reservation parameters while the task was
throttled; and we don't want to do anything in this case.

> +	if (!dl_task(p))
>  		goto unlock;
>  
>  	sched_clock_tick();

I'd propose something like the following instead.

Thanks,

- Juri

>From 5c7fb103db06bc8f30a24465000b1c49c7a6310e Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 15 Apr 2014 13:49:04 +0200
Subject: [PATCH] sched/deadline: fix sched_yield behavior

yield_task_dl() is broken:

 o it forces current to be throttled setting its runtime to zero;
 o it sets current's dl_se->dl_new to one, expecting that dl_task_timer()
   will queue it back with proper parameters at replenish time.

Unfortunately, dl_task_timer() has this check at the very beginning:

	if (!dl_task(p) || dl_se->dl_new)
		goto unlock;

So, it just bails out and the task is never replenished. It actually
yielded forever.

To fix this, introduce a new flag indicating that the task properly yielded
the CPU before its current runtime expired. While this is a little overdoing
at the moment, the flag would be useful in the future to discriminate between
"good" jobs (of which remaining runtime could be reclaimed, i.e. recycled)
and "bad" jobs (for which dl_throttled task has been set) that needed to be
stopped.

Reported-by: yjay.kim <yjay.kim@lge.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h   |    7 +++++--
 kernel/sched/core.c     |    1 +
 kernel/sched/deadline.c |    5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..2a4298f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1153,9 +1153,12 @@ struct sched_dl_entity {
 	 *
 	 * @dl_boosted tells if we are boosted due to DI. If so we are
 	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section).
+	 * exit the critical section);
+	 *
+	 * @dl_yielded tells if task gave up the cpu before consuming
+	 * all its available runtime during the last job.
 	 */
-	int dl_throttled, dl_new, dl_boosted;
+	int dl_throttled, dl_new, dl_boosted, dl_yielded;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..a0f5923 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3124,6 +3124,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
+	dl_se->dl_yielded = 0;
 }
 
 static void __setscheduler_params(struct task_struct *p,
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..800e99b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -528,6 +528,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	sched_clock_tick();
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
+	dl_se->dl_yielded = 0;
 	if (p->on_rq) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
@@ -893,10 +894,10 @@ static void yield_task_dl(struct rq *rq)
 	 * We make the task go to sleep until its current deadline by
 	 * forcing its runtime to zero. This way, update_curr_dl() stops
 	 * it and the bandwidth timer will wake it up and will give it
-	 * new scheduling parameters (thanks to dl_new=1).
+	 * new scheduling parameters (thanks to dl_yielded=1).
 	 */
 	if (p->dl.runtime > 0) {
-		rq->curr->dl.dl_new = 1;
+		rq->curr->dl.dl_yielded = 1;
 		p->dl.runtime = 0;
 	}
 	update_curr_dl(rq);
-- 
1.7.9.5
