Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaGHRE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:04:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34706 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaGHREZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:04:25 -0400
From: bsegall@google.com
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average tracking
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
	<1404268256-3019-2-git-send-email-yuyang.du@intel.com>
	<20140707104646.GK6758@twins.programming.kicks-ass.net>
	<xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140708000840.GB25653@intel.com>
Date: Tue, 08 Jul 2014 10:04:22 -0700
In-Reply-To: <20140708000840.GB25653@intel.com> (Yuyang Du's message of "Tue,
	8 Jul 2014 08:08:40 +0800")
Message-ID: <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuyang Du <yuyang.du@intel.com> writes:

> Thanks, Ben,
>
> On Mon, Jul 07, 2014 at 03:25:07PM -0700, bsegall@google.com wrote:
>> Also something to note is that cfs_rq->load_avg just takes samples of
>> load.weight every 1us, which seems unfortunate. We thought this was ok
>> for p->se.load.weight, because it isn't really likely for userspace to
>> be calling nice(2) all the time, but wake/sleeps are more frequent,
>> particularly on newer cpus. Still, it might not be /that/ bad.
>
> The sampling of cfs_rq->load.weight should be equivalent to the current
> code in that at the end of day cfs_rq->load.weight worth of runnable would 
> contribute to runnable_load_avg/blocked_load_avg for both the current and
> the rewrite.

Yes, but the point is that it looks at load.weight when delta/1024 > 0
and assumes that it has had that load.weight the entire time, when this
might not actually be true. The largest error I can think of is if you
have a very high weight task that tends to run for very short periods of
time, you could end up losing their entire contribution to load. This
may be acceptable, I'm not certain.

>  
>> Also, as a nitpick/annoyance this does a lot of
>>  if (entity_is_task(se)) __update_load_avg(... se ...)
>>  __update_load_avg(... cfs_rq_of(se) ...)
>> which is just a waste of the avg struct on every group se, and all it
>> buys you is the ability to not have a separate rq->avg struct (removed
>> by patch 1) instead of rq->cfs.avg.
>
> I actually struggled on this issue. As we only need a sched_avg for task (not
> entity), and a sched_avg for cfs_rq, I planned to move entity avg to
> task. Good?

Yeah, that can probably be done perfectly fine.

>
> So left are the migrate_task_rq_fair() not holding lock issue and cfs_rq->avg.load_avg
> overflow issue. I need some time to study them.
>
> Overall, I think none of these issues are originally caused by combination/split
> of runnable and blocked. It is just a matter of how synchronized we want to be
> (this rewrite is the most synchronized), and the workaround I need to borrow from the
> current codes.

If you can manage to find a to deal with the migration issue without it,
that would be great, I'm just pretty sure that's why we did the split.

>
> Yuyang
