Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaG3KNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:13:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38561 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaG3KNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:13:37 -0400
Date: Wed, 30 Jul 2014 11:13:31 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140730101331.GB15761@e103687>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
MIME-Version: 1.0
In-Reply-To: <20140727190237.GB22986@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 30 Jul 2014 10:13:32.0735 (UTC) FILETIME=[EACBD4F0:01CFABDE]
X-MC-Unique: 114073011133500901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 08:02:37PM +0100, Yuyang Du wrote:
> Hi Morten,
> 
> On Fri, Jul 18, 2014 at 04:39:31PM +0100, Morten Rasmussen wrote:
> > 1. runnable_avg_period is removed
> > 
> > load_avg_contrib used to be runnable_avg_sum/runnable_avg_period scaled
> > by the task load weight (priority). The runnable_avg_period is replaced
> > by a constant in this patch set. The effect of that change is that task
> > load tracking no longer is more sensitive early life of the task until
> > it has built up some history. Task are now initialized to start out as
> > if they have been runnable forever (>345ms). If this assumption about
> > the task behavior is wrong it will take longer to converge to the true
> > average than it did before. The upside is that is more stable.
> 
> I think "Give new task start runnable values to heavy its load in infant time"
> in general is good, with an emphasis on infant. Or from the opposite, making it
> zero to let it gain runnable weight looks worse than full weight.

Initializing tasks to have full weight is current behaviour, which I
agree with. However, with your changes (dropping runnable_avg_period) it
may take longer for the tracked load of new tasks to converge to the
true load of the task. I don't think it is a big deal, but it is a
change compared to the current implementation.

> 
> > 2. runnable_load_avg and blocked_load_avg are combined
> > 
> > runnable_load_avg currently represents the sum of load_avg_contrib of
> > all tasks on the rq, while blocked_load_avg is the sum of those tasks
> > not on a runqueue. It makes perfect sense to consider the sum of both
> > when calculating the load of a cpu, but we currently don't include
> > blocked_load_avg. The reason for that is the priority scaling of the
> > task load_avg_contrib may lead to under-utilization of cpus that
> > occasionally have tiny high priority task running. You can easily have a
> > task that takes 5% of cpu time but has a load_avg_contrib several times
> > larger than a default priority task runnable 100% of the time.
> 
> So this is the effect of historical averaging and weight scaling, both of which
> are just generally good, but may have bad cases.

I don't agree that weight scaling is generally good. There has been
several threads discussing that topic over the last half year or so. It
is there to ensure smp niceness, but it makes load-balancing on systems
which are not fully utilized sub-optimal. You may end up with some cpus
not being fully utilized while others are over-utilized when you have
multiple tasks running at different priorities.

It is a very real problem when user-space uses priorities extensively
like Android does. Tasks related to audio run at very high priorities
but only for a very short amount of time, but due the to priority
scaling their load ends up being several times higher than tasks running
all the time at normal priority. Hence task load is a very poor
indicator of utilization.

> > Another thing that might be an issue is that the blocked of a terminated
> > task lives on for quite a while until has decayed away.
> 
> Good point. To do so, if I read correctly, we need to hook do_exit(), but probably
> we are gonna encounter rq->lock issue.
> 
> What is the opinion/guidance from the maintainers/others?
>  
> > I'm all for taking the blocked load into consideration, but this issue
> > has to be resolved first. Which leads me on to the next thing.
> > 
> > Most of the work going on around energy awareness is based on the load
> > tracking to estimate task and cpu utilization. It seems that most of the
> > involved parties think that we need an unweighted variant of the tracked
> > load as well as tracking the running time of a task. The latter was part
> > of the original proposal by pjt and Ben, but wasn't used. It seems that
> > unweighted runnable tracking should be fairly easy to add to your
> > proposal, but I don't have an overview of whether it is possible to add
> > running tracking. Do you think that is possible?
> > 
> 
> Running tracking is absolutely possbile, just the matter of minimizing overhead
> (how to do it along with runnable for task and maybe for CPU, but not for
> cfs_rq) from execution and code cleanness ponit of view. We can do it as soon as
> it is needed.

>From a coding point of view it is very easy to add to the current
load-tracking. We have already discussed putting it back in to enable
better tracking of utilization. It is quite likely needed for the
energy-awareness improvements and also to fix the priority scaling
problem described above. 

IMHO, the above things need to be considered as part of a rewrite of the
load-tracking implementation otherwise we risk having to change it again
soon.

Morten

