Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3EFPAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:00:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:4204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3EFPAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:00:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="237519749"
Message-ID: <5187C59F.1020305@intel.com>
Date: Mon, 06 May 2013 23:00:47 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com>
In-Reply-To: <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> blocked_load_avg is the expected "to wake" contribution from tasks
> already assigned to this rq.
> 
> e.g. this could be:
>   load = this_rq->cfs.runnable_load_avg + this_rq->cfs.blocked_load_avg;

Current load balance doesn't consider slept task's load which is
represented by blocked_load_avg. And the slept task is not on_rq, so
consider it in load balance is a little strange.

But your concern is worth to try. I will change the patchset and give
the testing results.

> 
> Although, in general I have a major concern with the current implementation:
> 
> The entire reason for stability with the bottom up averages is that
> when load migrates between cpus we are able to migrate it between the
> tracked sums.
> 
> Stuffing observed averages of these into the load_idxs loses that
> mobility; we will have to stall (as we do today for idx > 0) before we
> can recognize that a cpu's load has truly left it; this is a very
> similar problem to the need to stably track this for group shares
> computation.
> 
> To that end, I would rather see the load_idx disappear completely:
>  (a) We can calculate the imbalance purely from delta (runnable_avg +
> blocked_avg)
>  (b) It eliminates a bad tunable.

I also show the similar concern of load_idx months ago. seems overlooked. :)
> 
>> -       return cpu_rq(cpu)->load.weight;
>> +       return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
> 
> Isn't this going to truncate on the 32-bit case?

I guess not, the old load.weight is unsigned long, and runnable_load_avg
is smaller than the load.weight. so it should be fine.

btw, according to above reason, guess move runnable_load_avg to
'unsigned long' type is ok, do you think so?
> 

-- 
Thanks
    Alex
