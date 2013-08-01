Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3HAHgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:36:48 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:2333 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3HAHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:36:46 -0400
Message-ID: <1375342601.1974.104.camel@j-VirtualBox>
Subject: Re: [RFC PATCH] sched: Reduce overestimating avg_idle
From: Jason Low <jason.low2@hp.com>
To: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, KML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 00:36:41 -0700
In-Reply-To: <51F9349A.3090605@redhat.com>
References: <1375263472.3922.26.camel@j-VirtualBox>
	 <51F9349A.3090605@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I wonder if we could get even more conservative values
> of avg_idle by clamping delta to max, before calling
> update_avg...
> 
> Or rather, I wonder if that would matter enough to make
> a difference, and in what direction that difference would
> be.
> 
> In other words:
> 
> 	if (rq->idle_stamp) {
> 		u64 delta = rq->clock - rq->idle_stamp;
> 		u64 max = (sysctl_sched_migration_cost * 3) / 2;
> 
> 		if (delta > max)
> 			delta = max;
> 
> 		update_avg(&rq->avg_idle, delta);
> 		rq->idle_stamp = 0;
> 	}

Yes, I initially tried to limit delta to the max. That helped keep the
avg_idle smaller and provided even better performance improvements on
the 8 socket HT-enabled case. Here were some of those performance boosts
on AIM7:

alltests: +14.5%   custom:      +15.9%   disk:         +15.9%
fserver:  +33.7%   new_fserver: +15.7%   high_systime: +16.7%   
shared:   +14.1%

When we limit the average instead of the delta, the performance boosts
were in the range of 5-10%, with the exception of fserver.

I initially thought that limiting delta to a small value might cause the
average to often be underestimated. But come to think of it, this might
actually provide a more accurate estimate of whether the majority of
idle durations are either less than or greater than migration_cost. Idle
durations can be a lot higher while there's a limit to how small each
short idle duration is. This may help offset some of that bias towards a
high avg.

So how acceptable is setting a limit of 2*migration cost or less on the
delta rather than on the avg?

Thanks,
Jason


