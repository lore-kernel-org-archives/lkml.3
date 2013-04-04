Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333Ab3DDAmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:42:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44268 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761607Ab3DDAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:42:12 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-80-515ccc61e57c
Date: Thu, 4 Apr 2013 09:42:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Message-ID: <20130404004231.GA10683@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
 <51553EF5.90702@linux.vnet.ibm.com>
 <20130401040820.GA12015@lge.com>
 <5159320C.4050903@linux.vnet.ibm.com>
 <20130402022556.GD16699@lge.com>
 <515A64BB.5050005@linux.vnet.ibm.com>
 <20130402092647.GE16699@lge.com>
 <515B163B.8050509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B163B.8050509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Preeti.

On Tue, Apr 02, 2013 at 11:02:43PM +0530, Preeti U Murthy wrote:
> Hi Joonsoo,
> 
> 
> >>> I think that it is real problem that sysctl_sched_min_granularity is not
> >>> guaranteed for each task.
> >>> Instead of this patch, how about considering low bound?
> >>>
> >>> if (slice < sysctl_sched_min_granularity)
> >>> 	slice = sysctl_sched_min_granularity;
> >>
> >> Consider the below scenario.
> >>
> >> A runqueue has two task groups,each with 10 tasks.
> >>
> >> With the current implementation,each of these tasks get a sched_slice of
> >> 2ms.Hence in a matter of (10*2) + (10*2) = 40 ms, all tasks( all tasks
> >> of both the task groups) will get the chance to run.
> >>
> >> But what is the scheduling period in this scenario? Is it 40ms (extended
> >> sysctl_sched_latency), which is the scheduling period for each of the
> >> runqueues with 10 tasks in it?
> >> Or is it 80ms which is the total of the scheduling periods of each of
> >> the run queues with 10 tasks.Either way all tasks seem to get scheduled
> >> atleast once within the scheduling period.So we appear to be safe.
> >> Although the sched_slice < sched_min_granularity.
> >>
> >> With your above lower bound of sysctl_sched_min_granularity, each task
> >> of each tg gets 4ms as its sched_slice.So in a matter of
> >> (10*4) + (10*4) = 80ms,all tasks get to run. With the above question
> >> being put forth here as well, we don't appear to be safe if the
> >> scheduling_period is considered to be 40ms, otherwise it appears fine to
> >> me, because it ensures the sched_slice is atleast sched_min_granularity
> >> no matter what.
> > 
> > So, you mean that we should guarantee to schedule each task atleast once
> > in sysctl_sched_latency? 
> 
> I would rather say all tasks get to run atleast once in a sched_period,
> which could be just sysctl_sched_latency or more depending on the number
> of tasks in the current implementation.
> 
> But this is not guaranteed in current code,
> > this is why I made this patch. Please refer a patch description.
> 
> Ok,take the example of a runqueue with 2 task groups,each with 10
> tasks.Same as your previous example. Can you explain how your patch
> ensures that all 20 tasks get to run atleast once in a sched_period?

My patch doesn't ensure that :)
I just want to say a problem of current implementation which can't
ensure to run atleast once in sched_period through my patch description.

So, how about extending a sched_period with rq->nr_running, instead of
cfs_rq->nr_running? It is my quick thought and I think that we can ensure
to run atleast once in this extending sched_period.

And, do we leave a problem if we cannot guaranteed atleast once property?

Thanks.

> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
