Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609Ab3DBJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:26:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761597Ab3DBJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:26:41 -0400
X-AuditID: 9c930197-b7b50ae00000018c-08-515aa44bb09e
Date: Tue, 2 Apr 2013 18:26:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Message-ID: <20130402092647.GE16699@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
 <51553EF5.90702@linux.vnet.ibm.com>
 <20130401040820.GA12015@lge.com>
 <5159320C.4050903@linux.vnet.ibm.com>
 <20130402022556.GD16699@lge.com>
 <515A64BB.5050005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515A64BB.5050005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Preeti.

On Tue, Apr 02, 2013 at 10:25:23AM +0530, Preeti U Murthy wrote:
> Hi Joonsoo,
> 
> On 04/02/2013 07:55 AM, Joonsoo Kim wrote:
> > Hello, Preeti.
> > 
> > On Mon, Apr 01, 2013 at 12:36:52PM +0530, Preeti U Murthy wrote:
> >> Hi Joonsoo,
> >>
> >> On 04/01/2013 09:38 AM, Joonsoo Kim wrote:
> >>> Hello, Preeti.
> >>>
> >>
> >>>>
> >>>> Ideally the children's cpu share must add upto the parent's share.
> >>>>
> >>>
> >>> I don't think so.
> >>>
> >>> We should schedule out the parent tg if 5ms is over. As we do so, we can
> >>> fairly distribute time slice to every tg within short term. If we add
> >>> the children's cpu share upto the parent's, the parent tg may have
> >>> large time slice, so it cannot be preempted easily. There may be a latency
> >>> problem if there are many tgs.
> >>
> >> In the case where the #running < sched_nr_latency, the children's
> >> sched_slices add up to the parent's.
> >>
> >> A rq with two tgs,each with 3 tasks.
> >>
> >> Each of these tasks have a sched slice of
> >> [(sysctl_sched_latency / 3) / 2] as of the present implementation.
> >>
> >> The sum of the above sched_slice of all tasks of a tg will lead to the
> >> sched_slice of its parent: sysctl_sched_latency / 2
> >>
> >> This breaks when the nr_running on each tg > sched_nr_latency. However I
> >> don't know if this is a good thing or a bad thing.
> > 
> > Ah.. Now I get your point. Yes, you are right and it may be good thing.
> > With that property, all tasks in the system can be scheduled at least once
> > in sysctl_sched_latency. sysctl_sched_latency is system-wide configuration,
> > so my patch may be wrong. With my patch, all tasks in the system cannot be
> > scheduled at least once in sysctl_sched_latency. Instead, it schedule
> > all tasks in cfs_rq at least once in sysctl_sched_latency if there is
> > no other tgs.
> 
> Exactly. You have got all the above points right.
> 
> > 
> > I think that it is real problem that sysctl_sched_min_granularity is not
> > guaranteed for each task.
> > Instead of this patch, how about considering low bound?
> > 
> > if (slice < sysctl_sched_min_granularity)
> > 	slice = sysctl_sched_min_granularity;
> 
> Consider the below scenario.
> 
> A runqueue has two task groups,each with 10 tasks.
> 
> With the current implementation,each of these tasks get a sched_slice of
> 2ms.Hence in a matter of (10*2) + (10*2) = 40 ms, all tasks( all tasks
> of both the task groups) will get the chance to run.
> 
> But what is the scheduling period in this scenario? Is it 40ms (extended
> sysctl_sched_latency), which is the scheduling period for each of the
> runqueues with 10 tasks in it?
> Or is it 80ms which is the total of the scheduling periods of each of
> the run queues with 10 tasks.Either way all tasks seem to get scheduled
> atleast once within the scheduling period.So we appear to be safe.
> Although the sched_slice < sched_min_granularity.
> 
> With your above lower bound of sysctl_sched_min_granularity, each task
> of each tg gets 4ms as its sched_slice.So in a matter of
> (10*4) + (10*4) = 80ms,all tasks get to run. With the above question
> being put forth here as well, we don't appear to be safe if the
> scheduling_period is considered to be 40ms, otherwise it appears fine to
> me, because it ensures the sched_slice is atleast sched_min_granularity
> no matter what.

So, you mean that we should guarantee to schedule each task atleast once
in sysctl_sched_latency? But this is not guaranteed in current code,
this is why I made this patch. Please refer a patch description.

Thanks.

> 
> Thank you
> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
