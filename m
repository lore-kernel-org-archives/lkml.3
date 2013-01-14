Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3ANQJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:09:41 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35810 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab3ANQJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:09:39 -0500
Date: Mon, 14 Jan 2013 16:09:34 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
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
Message-ID: <20130114160934.GA8528@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-17-git-send-email-alex.shi@intel.com>
 <20130110150108.GF2046@e103034-lin>
 <50EFBA7D.5070907@intel.com>
MIME-Version: 1.0
In-Reply-To: <50EFBA7D.5070907@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Jan 2013 16:09:31.0164 (UTC) FILETIME=[8941F5C0:01CDF271]
X-MC-Unique: 113011416093607901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 07:08:45AM +0000, Alex Shi wrote:
> On 01/10/2013 11:01 PM, Morten Rasmussen wrote:
> > On Sat, Jan 05, 2013 at 08:37:45AM +0000, Alex Shi wrote:
> >> This patch add power aware scheduling in fork/exec/wake. It try to
> >> select cpu from the busiest while still has utilization group. That's
> >> will save power for other groups.
> >>
> >> The trade off is adding a power aware statistics collection in group
> >> seeking. But since the collection just happened in power scheduling
> >> eligible condition, the worst case of hackbench testing just drops
> >> about 2% with powersaving/balance policy. No clear change for
> >> performance policy.
> >>
> >> I had tried to use rq load avg utilisation in this balancing, but since
> >> the utilisation need much time to accumulate itself. It's unfit for any
> >> burst balancing. So I use nr_running as instant rq utilisation.
> > 
> > So you effective use a mix of nr_running (counting tasks) and PJT's
> > tracked load for balancing?
> 
> no, just task number here.
> > 
> > The problem of slow reaction time of the tracked load a cpu/rq is an
> > interesting one. Would it be possible to use it if you maintained a
> > sched group runnable_load_avg similar to cfs_rq->runnable_load_avg where
> > load contribution of a tasks is added when a task is enqueued and
> > removed again if it migrates to another cpu?
> > This way you would know the new load of the sched group/domain instantly
> > when you migrate a task there. It might not be precise as the load
> > contribution of the task to some extend depends on the load of the cpu
> > where it is running. But it would probably be a fair estimate, which is
> > quite likely to be better than just counting tasks (nr_running).
> 
> For power consideration scenario, it ask task number less than Lcpu
> number, don't care the load weight, since whatever the load weight, the
> task only can burn one LCPU.
> 

True, but you miss the opportunities for power saving when you have many
light tasks (> LCPU). Currently, the sd_utils < threshold check will go
for SCHED_POLICY_PERFORMANCE if the number tasks (sd_utils) is greater
than the domain weight/capacity irrespective of the actual load caused
by those tasks.

If you used tracked task load weight for sd_utils instead you would be
able to go for power saving in scenarios with many light tasks as well.

> >> +
> >> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
> >> +			threshold = sgs.group_weight;
> >> +		else
> >> +			threshold = sgs.group_capacity;
> > 
> > Is group_capacity larger or smaller than group_weight on your platform?
> 
> Guess most of your confusing come from the capacity != weight here.
> 
> In most of Intel CPU, a cpu core's power(with 2 HT) is usually 1178, it
> just bigger than a normal cpu power - 1024. but the capacity is still 1,
> while the group weight is 2.
> 

Thanks for clarifying. To the best of my knowledge there are no
guidelines for how to specify cpu power so it may be a bit dangerous to
assume that capacity < weight when capacity is based on cpu power.

You could have architectures where the cpu power of each LCPU (HT, core,
cpu, whatever LCPU is on the particular platform) is greater than 1024
for most LCPUs. In that case, the capacity < weight assumption fails.
Also, on non-HT systems it is quite likely that you will have capacity =
weight.

Morten

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

