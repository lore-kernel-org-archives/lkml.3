Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489Ab3GaQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3GaQBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:01:33 -0400
Message-ID: <51F9349A.3090605@redhat.com>
Date: Wed, 31 Jul 2013 12:00:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        KML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: Reduce overestimating avg_idle
References: <1375263472.3922.26.camel@j-VirtualBox>
In-Reply-To: <1375263472.3922.26.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 05:37 AM, Jason Low wrote:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e8b3350..62b484b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1341,12 +1341,12 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>
>   	if (rq->idle_stamp) {
>   		u64 delta = rq->clock - rq->idle_stamp;
> -		u64 max = 2*sysctl_sched_migration_cost;
> +		u64 max = (sysctl_sched_migration_cost * 3) / 2;
>
> -		if (delta > max)
> +		update_avg(&rq->avg_idle, delta);
> +
> +		if (rq->avg_idle > max)
>   			rq->avg_idle = max;
> -		else
> -			update_avg(&rq->avg_idle, delta);
>   		rq->idle_stamp = 0;
>   	}

I wonder if we could get even more conservative values
of avg_idle by clamping delta to max, before calling
update_avg...

Or rather, I wonder if that would matter enough to make
a difference, and in what direction that difference would
be.

In other words:

	if (rq->idle_stamp) {
		u64 delta = rq->clock - rq->idle_stamp;
		u64 max = (sysctl_sched_migration_cost * 3) / 2;

		if (delta > max)
			delta = max;

		update_avg(&rq->avg_idle, delta);
		rq->idle_stamp = 0;
	}

-- 
All rights reversed
