Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaGHLX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:23:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13508 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaGHLX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:23:28 -0400
Message-ID: <53BBD4A7.5050701@huawei.com>
Date: Tue, 8 Jul 2014 19:23:19 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@redhat.com>, <juri.lelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <xiaofeng.yan2012@gmail.com>
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com> <20140708093334.GD6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140708093334.GD6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 17:33, Peter Zijlstra wrote:
> On Tue, Jul 08, 2014 at 08:53:27AM +0000, xiaofeng.yan wrote:
>>   static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>>   {
>> -	s64 delta = p->dl.dl_runtime - p->dl.runtime;
>> -
>> -	if (delta > 10000)
>> -		hrtick_start(rq, p->dl.runtime);
>> +	delta = max_t(s64, 10000LL, delta);
>> +	hrtick_start(rq, delta);
>>   }
> no, no, no. I said to unify the test.

I understand your idea after reading the next patch. This is good solution.
I will test it with your patch.

> ---
>   kernel/sched/core.c     | 9 ++++++++-
>   kernel/sched/deadline.c | 3 +--
>   kernel/sched/fair.c     | 7 -------
>   3 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e1a2f31bb0cb..c7b8a6fbac66 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -444,7 +444,14 @@ static void __hrtick_start(void *arg)
>   void hrtick_start(struct rq *rq, u64 delay)
>   {
>   	struct hrtimer *timer = &rq->hrtick_timer;
> -	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
> +	ktime_t time;
> +
> +	/*
> +	 * Don't schedule slices shorter than 10000ns, that just
> +	 * doesn't make sense and can cause timer DoS.
> +	 */
> +	delta = max_t(s64, delta, 10000LL);

transfer the argument delta to delay

> +	time = ktime_add_ns(timer->base->get_time(), delay);
>   
>   	hrtimer_set_expires(timer, time);
>   
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index fc4f98b1258f..e1e24eea8061 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -999,8 +999,7 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>   {
>   	s64 delta = p->dl.dl_runtime - p->dl.runtime;
>   
> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	hrtick_start(rq, p->dl.runtime);
>   }
>   #endif
>   
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 923fe32db6b3..713c58d2a7b0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3901,13 +3901,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
>   			return;
>   		}
>   
> -		/*
> -		 * Don't schedule slices shorter than 10000ns, that just
> -		 * doesn't make sense. Rely on vruntime for fairness.
> -		 */
> -		if (rq->curr != p)
> -			delta = max_t(s64, 10000LL, delta);
> -
>   		hrtick_start(rq, delta);
>   	}
>   }


