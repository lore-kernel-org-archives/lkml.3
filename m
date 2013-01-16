Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3APO1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:27:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54082 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3APO1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:27:37 -0500
Date: Wed, 16 Jan 2013 14:27:30 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in
 fork/exec/wake
Message-ID: <20130116142730.GA30805@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-17-git-send-email-alex.shi@intel.com>
 <20130110150108.GF2046@e103034-lin>
 <50EFBA7D.5070907@intel.com>
 <20130114160934.GA8528@e103034-lin>
 <50F6426D.7030201@intel.com>
MIME-Version: 1.0
In-Reply-To: <50F6426D.7030201@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Jan 2013 14:27:31.0098 (UTC) FILETIME=[9E3D7FA0:01CDF3F5]
X-MC-Unique: 113011614273308501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:02:21AM +0000, Alex Shi wrote:
> On 01/15/2013 12:09 AM, Morten Rasmussen wrote:
> > On Fri, Jan 11, 2013 at 07:08:45AM +0000, Alex Shi wrote:
> >> On 01/10/2013 11:01 PM, Morten Rasmussen wrote:
> >>> On Sat, Jan 05, 2013 at 08:37:45AM +0000, Alex Shi wrote:
> >>>> This patch add power aware scheduling in fork/exec/wake. It try to
> >>>> select cpu from the busiest while still has utilization group. That's
> >>>> will save power for other groups.
> >>>>
> >>>> The trade off is adding a power aware statistics collection in group
> >>>> seeking. But since the collection just happened in power scheduling
> >>>> eligible condition, the worst case of hackbench testing just drops
> >>>> about 2% with powersaving/balance policy. No clear change for
> >>>> performance policy.
> >>>>
> >>>> I had tried to use rq load avg utilisation in this balancing, but since
> >>>> the utilisation need much time to accumulate itself. It's unfit for any
> >>>> burst balancing. So I use nr_running as instant rq utilisation.
> >>>
> >>> So you effective use a mix of nr_running (counting tasks) and PJT's
> >>> tracked load for balancing?
> >>
> >> no, just task number here.
> >>>
> >>> The problem of slow reaction time of the tracked load a cpu/rq is an
> >>> interesting one. Would it be possible to use it if you maintained a
> >>> sched group runnable_load_avg similar to cfs_rq->runnable_load_avg where
> >>> load contribution of a tasks is added when a task is enqueued and
> >>> removed again if it migrates to another cpu?
> >>> This way you would know the new load of the sched group/domain instantly
> >>> when you migrate a task there. It might not be precise as the load
> >>> contribution of the task to some extend depends on the load of the cpu
> >>> where it is running. But it would probably be a fair estimate, which is
> >>> quite likely to be better than just counting tasks (nr_running).
> >>
> >> For power consideration scenario, it ask task number less than Lcpu
> >> number, don't care the load weight, since whatever the load weight, the
> >> task only can burn one LCPU.
> >>
> > 
> > True, but you miss the opportunities for power saving when you have many
> > light tasks (> LCPU). Currently, the sd_utils < threshold check will go
> > for SCHED_POLICY_PERFORMANCE if the number tasks (sd_utils) is greater
> > than the domain weight/capacity irrespective of the actual load caused
> > by those tasks.
> > 
> > If you used tracked task load weight for sd_utils instead you would be
> > able to go for power saving in scenarios with many light tasks as well.
> 
> yes, that's right on power consideration. but for performance consider,
> it's better to spread tasks on different LCPU to save CS cost. And if
> the cpu usage is nearly full, we don't know if some tasks real want more
> cpu time.

If the cpu is nearly full according to its tracked load it should not be
used for packing more tasks. It is the nearly idle scenario that I am
more interested in. If you have lots of task with tracked load <10% then
why not pack them. The performance impact should be minimal.

Furthermore, nr_running is just a snapshot of the current runqueue
status. The combination of runnable and blocked load should give a
better overall view of the cpu loads.

> Even in the power sched policy, we still want to get better performance
> if it's possible. :)

I agree if it comes for free in terms of power. In my opinion it is
acceptable to sacrifice a bit of performance to save power when using a
power sched policy as long as the performance regression can be
justified by the power savings. It will of course depend on the system
and its usage how trade-off power and performance. My point is just that
with multiple sched policies (performance, balance and power as you
propose) it should be acceptable to focus on power for the power policy
and let users that only/mostly care about performance use the balance or
performance policy.

> > 
> >>>> +
> >>>> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
> >>>> +			threshold = sgs.group_weight;
> >>>> +		else
> >>>> +			threshold = sgs.group_capacity;
> >>>
> >>> Is group_capacity larger or smaller than group_weight on your platform?
> >>
> >> Guess most of your confusing come from the capacity != weight here.
> >>
> >> In most of Intel CPU, a cpu core's power(with 2 HT) is usually 1178, it
> >> just bigger than a normal cpu power - 1024. but the capacity is still 1,
> >> while the group weight is 2.
> >>
> > 
> > Thanks for clarifying. To the best of my knowledge there are no
> > guidelines for how to specify cpu power so it may be a bit dangerous to
> > assume that capacity < weight when capacity is based on cpu power.
> 
> Sure. I also just got them from code. and don't know other arch how to
> different them.
> but currently, seems this cpu power concept works fine.

Yes, it seems to work fine for your test platform. I just want to
highlight that the assumption you make might not be valid for other
architectures. I know that cpu power is not widely used, but that may
change with the increasing focus on power aware scheduling.

Morten

> > 
> > You could have architectures where the cpu power of each LCPU (HT, core,
> > cpu, whatever LCPU is on the particular platform) is greater than 1024
> > for most LCPUs. In that case, the capacity < weight assumption fails.
> > Also, on non-HT systems it is quite likely that you will have capacity =
> > weight.
> 
> yes.
> > 
> > Morten
> > 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> 
> 
> -- 
> Thanks Alex
> 

