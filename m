Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3C2LhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:37:25 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55232 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3C2LhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:37:23 -0400
Message-ID: <51557C89.4070201@linux.vnet.ibm.com>
Date: Fri, 29 Mar 2013 17:05:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 5/5] sched: limit sched_slice if it is more than sysctl_sched_latency
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032911-9264-0000-0000-0000036D19A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo

On 03/28/2013 01:28 PM, Joonsoo Kim wrote:
> sched_slice() compute ideal runtime slice. If there are many tasks
> in cfs_rq, period for this cfs_rq is extended to guarantee that each task
> has time slice at least, sched_min_granularity. And then each task get
> a portion of this period for it. If there is a task which have much larger
> load weight than others, a portion of period can exceed far more than
> sysctl_sched_latency.

Correct. But that does not matter, the length of the scheduling latency
period is determined by the return value of ___sched_period(), not the
value of sysctl_sched_latency. You would not extend the period,if you
wanted all tasks to have a slice within the sysctl_sched_latency, right?

So since the value of the length of the scheduling latency period, is
dynamic depending on the number of the processes running, the
sysctl_sched_latency which is the default latency period length is not
mesed with, but is only used as a base to determine the actual
scheduling period.

> 
> For exampple, you can simply imagine that one task with nice -20 and
> 9 tasks with nice 0 on one cfs_rq. In this case, load weight sum for
> this cfs_rq is 88761 + 9 * 1024, 97977. So a portion of slice for the
> task with nice -20 is sysctl_sched_min_granularity * 10 * (88761 / 97977),
> that is, approximately, sysctl_sched_min_granularity * 9. This aspect
> can be much larger if there is more tasks with nice 0.

Yeah so the __sched_period says that within 40ms, all tasks need to be
scheduled ateast once, and the highest priority task gets nearly 36ms of
it, while the rest is distributed among the others.

> 
> So we should limit this possible weird situation.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e232421..6ceffbc 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -645,6 +645,9 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	}
>  	slice = calc_delta_mine(slice, se->load.weight, load);
> 
> +	if (unlikely(slice > sysctl_sched_latency))
> +		slice = sysctl_sched_latency;

Then in this case the highest priority thread would get
20ms(sysctl_sched_latency), and the rest would get
sysctl_sched_min_granularity * 10 * (1024/97977) which would be 0.4ms.
Then all tasks would get scheduled ateast once within 20ms + (0.4*9) ms
= 23.7ms, while your scheduling latency period was extended to 40ms,just
so that each of these tasks don't have their sched_slices shrunk due to
large number of tasks.

> +
>  	return slice;
>  }
> 

Regards
Preeti U Murthy

