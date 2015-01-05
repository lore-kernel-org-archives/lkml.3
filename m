Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbbAEPVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:21:45 -0500
Received: from mail3.unitn.it ([193.205.206.24]:54600 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbbAEPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:21:44 -0500
Message-ID: <54AAABFB.3060109@unitn.it>
Date: Mon, 05 Jan 2015 16:21:31 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <20141230002738.6c12db31@utopia> <2629881420411885@web9m.yandex.ru>
In-Reply-To: <2629881420411885@web9m.yandex.ru>
Content-Type: multipart/mixed;
 boundary="------------010700090501040200010507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010700090501040200010507
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kirill,

On 01/04/2015 11:51 PM, Kirill Tkhai wrote:
> Hi, Luca,
>
> I've just notived this.
[...]
> I think we should do something like below.
>
> hrtimer_init() is already called in sched_fork(), so we shouldn't do this
> twice. Also, we shouldn't reinit dl_throttled etc if timer is pending,
> and we should prevent a race here.
Thanks for the comments (I did not notice that hrtimer_init() was called twice)
and for the patch. I'll test it in the next days.

For reference, I attach the patch I am using locally (based on what I suggested
in my previous mail) and seems to work fine here.

Based on your comments, I suspect my patch can be further simplified by moving
the call to init_dl_task_timer() in __sched_fork().

[...]
> @@ -3250,16 +3251,19 @@ static void
>   __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
>   {
>   	struct sched_dl_entity *dl_se = &p->dl;
> +        struct hrtimer *timer = &dl_se->dl_timer;
> +
> +	if (!hrtimer_active(timer) || hrtimer_try_to_cancel(timer) != -1) {
Just for the sake of curiosity, why trying to cancel the timer
("|| hrtimer_try_to_cancel(timer)") here? If it is active, cannot we leave it
active (without touching dl_throttled, dl_new and dl_yielded)?

I mean: if I try to change the parameters of a task when it is throttled, I'd like
it to stay throttled until the end of the reservation period... Or am I missing
something?


				Thanks,
					Luca

> +		dl_se->dl_throttled = 0;
> +		dl_se->dl_new = 1;
> +		dl_se->dl_yielded = 0;
> +	}
>
> -	init_dl_task_timer(dl_se);
>   	dl_se->dl_runtime = attr->sched_runtime;
>   	dl_se->dl_deadline = attr->sched_deadline;
>   	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
>   	dl_se->flags = attr->sched_flags;
>   	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
> -	dl_se->dl_throttled = 0;
> -	dl_se->dl_new = 1;
> -	dl_se->dl_yielded = 0;
>   }
>
>   /*
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index e5db8c6..8649bd6 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -500,7 +500,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
>    * updating (and the queueing back to dl_rq) will be done by the
>    * next call to enqueue_task_dl().
>    */
> -static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> +enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>   {
>   	struct sched_dl_entity *dl_se = container_of(timer,
>   						     struct sched_dl_entity,
> @@ -559,14 +559,6 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>
> -void init_dl_task_timer(struct sched_dl_entity *dl_se)
> -{
> -	struct hrtimer *timer = &dl_se->dl_timer;
> -
> -	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	timer->function = dl_task_timer;
> -}
> -
>   static
>   int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
>   {
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 9a2a45c..ad3a2f0 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1257,7 +1257,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
>
>   extern struct dl_bandwidth def_dl_bandwidth;
>   extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
> -extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
>
>   unsigned long to_ratio(u64 period, u64 runtime);
>
>


--------------010700090501040200010507
Content-Type: text/x-diff;
 name="0003-Do-not-initialize-the-deadline-timer-if-it-is-alread.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-Do-not-initialize-the-deadline-timer-if-it-is-alread.pa";
 filename*1="tch"

>From 7a0e6747c40cf9186f3645eb94408090ab11936a Mon Sep 17 00:00:00 2001
From: Luca Abeni <luca.abeni@unitn.it>
Date: Sat, 27 Dec 2014 18:20:57 +0100
Subject: [PATCH 03/11] Do not initialize the deadline timer if it is already
 initialized

After commit 67dfa1b756f250972bde31d65e3f8fde6aeddc5b changing the
parameters of a SCHED_DEADLINE tasks might crash the system. This
happens because 67dfa1b756f250972bde31d65e3f8fde6aeddc5b removed the
following lines from init_dl_task_timer():
-       if (hrtimer_active(timer)) {
-               hrtimer_try_to_cancel(timer);
-               return;
-       }

As a result, if sched_setattr() is invoked to change the parameters
(runtime or period) of a SCHED_DEADLINE task, init_dl_task_timer()
might end up initializing a pending timer.

Fix this problem by modifying __setparam_dl() to call init_dl_task_timer()
only if the task is not already a SCHED_DEADLINE one.
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..470111c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3251,7 +3251,9 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 
-	init_dl_task_timer(dl_se);
+        if (p->sched_class != &dl_sched_class) {
+		init_dl_task_timer(dl_se);
+	}
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
-- 
2.1.0


--------------010700090501040200010507--
