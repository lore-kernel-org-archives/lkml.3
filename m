Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaI2PA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:00:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44379 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2PAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:00:55 -0400
Message-ID: <54297448.8080501@arm.com>
Date: Mon, 29 Sep 2014 16:01:28 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 1/2] sched/dl: Implement cancel_dl_timer() to use in switched_from_dl()
References: <20140927084044.1634.60573.stgit@localhost>
In-Reply-To: <20140927084044.1634.60573.stgit@localhost>
X-OriginalArrivalTime: 29 Sep 2014 15:00:52.0661 (UTC) FILETIME=[29CA8650:01CFDBF6]
X-MC-Unique: 114092916005209901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 27/09/14 09:40, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> hrtimer_try_to_cancel() may bring a suprise, and even two its calls
> may fail.
> 
> So, let's implement 100% guaranteed way to cancel the timer and let's
> be sure we are safe even in very unlikely situations.
> 

Could you give more details about the unlikely situations in the
changelog? It would be nice to have some more information for future
reference.

Thanks,

- Juri

> We do not create any problem with rq unlocking, because it already
> may happed below in pull_dl_task(). No problem with deadline tasks
> balancing too.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/deadline.c |   33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index abfaf3d..63f8b4a 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -555,11 +555,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
>  {
>  	struct hrtimer *timer = &dl_se->dl_timer;
>  
> -	if (hrtimer_active(timer)) {
> -		hrtimer_try_to_cancel(timer);
> -		return;
> -	}
> -
>  	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	timer->function = dl_task_timer;
>  }
> @@ -1567,10 +1562,34 @@ void init_sched_dl_class(void)
>  
>  #endif /* CONFIG_SMP */
>  
> +/*
> + *  Surely cancel task's dl_timer. May drop rq->lock.
> + */
> +static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
> +{
> +	struct hrtimer *dl_timer = &p->dl.dl_timer;
> +
> +	/* Nobody will change task's class if pi_lock is held */
> +	lockdep_assert_held(&p->pi_lock);
> +
> +	if (hrtimer_active(dl_timer)) {
> +		int ret = hrtimer_try_to_cancel(dl_timer);
> +
> +		if (unlikely(ret == -1)) {
> +			/*
> +			 * Note, p may migrate OR new deadline tasks
> +			 * may appear in rq when we are unlocking it.
> +			 */
> +			raw_spin_unlock(&rq->lock);
> +			hrtimer_cancel(dl_timer);
> +			raw_spin_lock(&rq->lock);
> +		}
> +	}
> +}
> +
>  static void switched_from_dl(struct rq *rq, struct task_struct *p)
>  {
> -	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
> -		hrtimer_try_to_cancel(&p->dl.dl_timer);
> +	cancel_dl_timer(rq, p);
>  
>  	__dl_clear_params(p);
>  
> 
> 

