Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaHFKjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:39:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56335 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaHFKjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:39:18 -0400
Message-ID: <53E205D5.4080001@arm.com>
Date: Wed, 06 Aug 2014 11:39:17 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xiaofeng.yan2012@gmail.com" <xiaofeng.yan2012@gmail.com>
Subject: Re: [PATCH v3] sched/deadline: overrun could happen in start_hrtick_dl
References: <1407316094-18207-1-git-send-email-xiaofeng.yan@huawei.com>
In-Reply-To: <1407316094-18207-1-git-send-email-xiaofeng.yan@huawei.com>
X-OriginalArrivalTime: 06 Aug 2014 10:39:14.0272 (UTC) FILETIME=[AA83F600:01CFB162]
X-MC-Unique: 114080611391618801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 06/08/14 10:08, xiaofeng.yan wrote:
> It could be wrong for the precision of runtime and deadline
> when the precision is within microsecond level. For example:
> Task runtime deadline period
>  P1   200us   500us   500us
> 
> This case need enbale HRTICK feature by the next command
> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
> PC#trace-cmd record -e sched_switch &
> PC#./schedtool -E -t 200000:500000 -e ./test
> 
> Some of runtime and deadline run with millisecond level by
> reading kernershark. Some pieces of trace.dat are as follows:
> (remove some irrelevant information)
> <idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
> test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
> <idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
> test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
> trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test
> 
> We can get the runtime from the information at some point.
> runtime = 157.605657 - 157.608183
> runtime = 0.002526(2.526ms)
> The correct runtime should be less than or equal to 200us at some point.
> 
> The problem is caused by a conditional judgment "delta > 10000".
> Because no hrtimer start up to control the runtime when runtime is less than 10us.
> So the process will continue to run until tick-period coming.
> 
> Move the code with the limit of the least time slice
> from hrtick_start_fair() to hrtick_start() because
> EDF schedule class also need this function in start_hrtick_dl().
> 
> To fix this problem, we call hrtimer_start() unconditionally in start_hrtick_dl(),
> and make sure schedule slice won't be smaller than 10us in hrtimer_start().
> 
> Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
> Reviewed-by:   Peter Zijlstra <peterz@infradead.org>
> Reviewed-by:   Li Zefan <lizefan@huawei.com>

For what concerns sched/deadline bits,

Acked-by: Juri Lelli <juri.lelli@arm.com>

Thanks!

- Juri

> ---
>  kernel/sched/core.c     |    8 +++++++-
>  kernel/sched/deadline.c |    5 +----
>  kernel/sched/fair.c     |    8 --------
>  3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575..53514ba 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -449,8 +449,14 @@ static void __hrtick_start(void *arg)
>  void hrtick_start(struct rq *rq, u64 delay)
>  {
>  	struct hrtimer *timer = &rq->hrtick_timer;
> -	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
> +	ktime_t time;
>  
> +	/*
> +	 * Don't schedule slices shorter than 10000ns, that just
> +	 * doesn't make sense and can cause timer DoS.
> +	 */
> +	s64 delta = max_t(s64, delay, 10000LL);
> +	time = ktime_add_ns(timer->base->get_time(), delta);
>  	hrtimer_set_expires(timer, time);
>  
>  	if (rq == this_rq()) {
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 255ce13..ce52d07 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -997,10 +997,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
>  #ifdef CONFIG_SCHED_HRTICK
>  static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>  {
> -	s64 delta = p->dl.dl_runtime - p->dl.runtime;
> -
> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	hrtick_start(rq, p->dl.runtime);
>  }
>  #endif
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86..0d6b3e6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3892,14 +3892,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
>  				resched_curr(rq);
>  			return;
>  		}
> -
> -		/*
> -		 * Don't schedule slices shorter than 10000ns, that just
> -		 * doesn't make sense. Rely on vruntime for fairness.
> -		 */
> -		if (rq->curr != p)
> -			delta = max_t(s64, 10000LL, delta);
> -
>  		hrtick_start(rq, delta);
>  	}
>  }
> 

