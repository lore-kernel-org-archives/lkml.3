Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaHPO5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 10:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaHPO5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:57:41 -0400
Date: Sat, 16 Aug 2014 16:55:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: Re: [PATCH 3/3] sched,time: atomically increment stime & utime
Message-ID: <20140816145515.GA17226@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com> <1408133138-22048-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408133138-22048-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, riel@redhat.com wrote:
>
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -605,9 +605,12 @@ static void cputime_adjust(struct task_cputime *curr,
>  	 * If the tick based count grows faster than the scheduler one,
>  	 * the result of the scaling may go backward.
>  	 * Let's enforce monotonicity.
> +	 * Atomic exchange protects against concurrent cputime_adjust.
>  	 */
> -	prev->stime = max(prev->stime, stime);
> -	prev->utime = max(prev->utime, utime);
> +	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
> +		cmpxchg(&prev->stime, rtime, stime);
> +	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
> +		cmpxchg(&prev->utime, rtime, utime);
>
>  out:
>  	*ut = prev->utime;

I am still not sure about this change. At least I think it needs some
discussion.

Let me repeat, afaics this can lead to inconsistent results. Just
suppose that the caller of thread_group_cputime_adjusted() gets a long
preemption between thread_group_cputime() and cputime_adjust(), and
the numbers in signal->prev_cputime grow significantly when this task
resumes. If cputime_adjust() sees both prev->stime and prev->utime
updated everything is fine. But we can race with cputime_adjust() on
another CPU and miss, say, the change in ->utime.

IOW. To simplify, suppose that thread_group_cputime(T) fills task_cputime
with zeros. Then the caller X is preempted.

Another task does thread_group_cputime(T) and this time task_cputime is
{ .utime = A_LOT_U, .stime = A_LOT_S }. This task calls cputime_adjust()
and sets prev->stime = A_LOT_S.

X resumes, calls cputime_adjust(), and returns { 0, A_LOT_S }.

If you think that we do not care, probably I won't argue. But at least
this should be documented/discussed. And if we can tolerate this, then we
can probably simply remove the scale_stime recalculation and change it to
just do

	static void cputime_adjust(struct task_cputime *curr,
				   struct cputime *prev,
				   cputime_t *ut, cputime_t *st)
	{
		cputime_t rtime, stime, utime;
		/*
		 * Let's enforce monotonicity.
		 * Atomic exchange protects against concurrent cputime_adjust.
		 */
		while (stime > (rtime = ACCESS_ONCE(prev->stime)))
			cmpxchg(&prev->stime, rtime, stime);
		while (utime > (rtime = ACCESS_ONCE(prev->utime)))
			cmpxchg(&prev->utime, rtime, utime);

		*ut = prev->utime;
		*st = prev->stime;
	}

Oleg.

