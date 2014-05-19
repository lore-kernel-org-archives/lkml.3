Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbaESRfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:35:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33644 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaESRfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:35:48 -0400
From: bsegall@google.com
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
References: <87mwej0yja.wl%klamm@yandex-team.ru>
	<xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<87lhu215ky.wl%klamm@yandex-team.ru>
	<20140519103247.GX30445@twins.programming.kicks-ass.net>
	<87vbt29ey1.wl%klamm@yandex-team.ru>
Date: Mon, 19 May 2014 10:35:46 -0700
In-Reply-To: <87vbt29ey1.wl%klamm@yandex-team.ru> (Roman Gushchin's message of
	"Mon, 19 May 2014 15:37:58 +0400")
Message-ID: <xm26ppj93c3x.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Gushchin <klamm@yandex-team.ru> writes:

> At Mon, 19 May 2014 12:32:47 +0200,
> Peter Zijlstra wrote:
>> 
>> OK, so can someone explain this ->timer_active thing? esp. what's the
>> 'obvious' difference with hrtimer_active()?
>
> A good question :)
>
>> Ideally we'd change the lot to not have this, but if we have to keep it
>> we'll need to make it lockdep visible because all this stinks
>
> If the patch below is what Ben means, timer_active will become even more unused.
> It seems to me now, that it will be perfectly possible to just drop it.
> I'll try to prepare a patch for.

Yeah, the below patch was the sort of idea I was thinking of. I'll send
a similar patch that also hits unthrottle_offline_cfs_rqs shortly. This
still doesn't save us from the unlock vs become !hrtimer_active race
though.

>
> --
>
> index 7570dd9..be7865e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3408,7 +3408,6 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  	u64 runtime, runtime_expires;
>  	int idle = 1, throttled;
>  
> -	raw_spin_lock(&cfs_b->lock);
>  	/* no need to continue the timer with no bandwidth constraint */
>  	if (cfs_b->quota == RUNTIME_INF)
>  		goto out_unlock;
> @@ -3477,7 +3476,6 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  out_unlock:
>  	if (idle)
>  		cfs_b->timer_active = 0;
> -	raw_spin_unlock(&cfs_b->lock);
>  
>  	return idle;
>  }
> @@ -3656,6 +3654,8 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
>  	int overrun;
>  	int idle = 0;
>  
> +	raw_spin_lock(&cfs_b->lock);
> +
>  	for (;;) {
>  		now = hrtimer_cb_get_time(timer);
>  		overrun = hrtimer_forward(timer, now, cfs_b->period);
> @@ -3666,6 +3666,8 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
>  		idle = do_sched_cfs_period_timer(cfs_b, overrun);
>  	}
>  
> +	raw_spin_unlock(&cfs_b->lock);
> +
>  	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
>  }
