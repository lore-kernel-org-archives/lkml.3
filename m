Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab3BHOqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:46:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3BHOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:46:21 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Q7m8p2VVOasA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=XFz9PPAos6YA:10 a=KKAkSRfTAAAA:8 a=D19gQVrFAAAA:8 a=Fgu8Ls2hX2PifQBoYEIA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360334778.2621.106.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: fix wrong rq's runnable_avg update with rt task
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        fweisbec@gmail.com
Date: Fri, 08 Feb 2013 09:46:18 -0500
In-Reply-To: <1360321887-18251-1-git-send-email-vincent.guittot@linaro.org>
References: <1360321887-18251-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 12:11 +0100, Vincent Guittot wrote:
> When a RT task is scheduled on an idle CPU, the update of the rq's load is
> not done because CFS's functions are not called. Then, the idle_balance,
> which is called just before entering the idle function, updates the
> rq's load and makes the assumption that the elapsed time since the last
> update, was only running time.
> 
> The rq's load of a CPU that only runs a periodic RT task, is close to
> LOAD_AVG_MAX whatever the running duration of the RT task is.
> 
> A new idle_exit function is called when the prev task is the idle function
> so the elapsed time will be accounted as idle time in the rq's load.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/core.c  |    3 +++
>  kernel/sched/fair.c  |   10 ++++++++++
>  kernel/sched/sched.h |    5 +++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..592e06c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2927,6 +2927,9 @@ need_resched:
>  
>  	pre_schedule(rq, prev);
>  
> +	if (unlikely(prev == rq->idle))
> +		idle_exit(cpu, rq);
> +

Let's get rid of the added junk in the core code that should be isolated
in the idle code.

I posted these patches before, and I'm about to post again:

https://lkml.org/lkml/2012/12/21/378
https://lkml.org/lkml/2012/12/21/377

I'm working to clean these patches up today and post them again. Would
working on top of these work for you?

-- Steve


>  	if (unlikely(!rq->nr_running))
>  		idle_balance(cpu, rq);
>  


