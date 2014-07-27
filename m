Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbaG1DFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:05:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:4455 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaG1DFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:05:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,745,1400050800"; 
   d="scan'208";a="462114329"
Date: Mon, 28 Jul 2014 03:02:37 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
Message-ID: <20140727190237.GB22986@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718153931.GJ8700@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

On Fri, Jul 18, 2014 at 04:39:31PM +0100, Morten Rasmussen wrote:
> 1. runnable_avg_period is removed
> 
> load_avg_contrib used to be runnable_avg_sum/runnable_avg_period scaled
> by the task load weight (priority). The runnable_avg_period is replaced
> by a constant in this patch set. The effect of that change is that task
> load tracking no longer is more sensitive early life of the task until
> it has built up some history. Task are now initialized to start out as
> if they have been runnable forever (>345ms). If this assumption about
> the task behavior is wrong it will take longer to converge to the true
> average than it did before. The upside is that is more stable.

I think "Give new task start runnable values to heavy its load in infant time"
in general is good, with an emphasis on infant. Or from the opposite, making it
zero to let it gain runnable weight looks worse than full weight.

> 2. runnable_load_avg and blocked_load_avg are combined
> 
> runnable_load_avg currently represents the sum of load_avg_contrib of
> all tasks on the rq, while blocked_load_avg is the sum of those tasks
> not on a runqueue. It makes perfect sense to consider the sum of both
> when calculating the load of a cpu, but we currently don't include
> blocked_load_avg. The reason for that is the priority scaling of the
> task load_avg_contrib may lead to under-utilization of cpus that
> occasionally have tiny high priority task running. You can easily have a
> task that takes 5% of cpu time but has a load_avg_contrib several times
> larger than a default priority task runnable 100% of the time.

So this is the effect of historical averaging and weight scaling, both of which
are just generally good, but may have bad cases.

> Another thing that might be an issue is that the blocked of a terminated
> task lives on for quite a while until has decayed away.

Good point. To do so, if I read correctly, we need to hook do_exit(), but probably
we are gonna encounter rq->lock issue.

What is the opinion/guidance from the maintainers/others?
 
> I'm all for taking the blocked load into consideration, but this issue
> has to be resolved first. Which leads me on to the next thing.
> 
> Most of the work going on around energy awareness is based on the load
> tracking to estimate task and cpu utilization. It seems that most of the
> involved parties think that we need an unweighted variant of the tracked
> load as well as tracking the running time of a task. The latter was part
> of the original proposal by pjt and Ben, but wasn't used. It seems that
> unweighted runnable tracking should be fairly easy to add to your
> proposal, but I don't have an overview of whether it is possible to add
> running tracking. Do you think that is possible?
> 

Running tracking is absolutely possbile, just the matter of minimizing overhead
(how to do it along with runnable for task and maybe for CPU, but not for
cfs_rq) from execution and code cleanness ponit of view. We can do it as soon as
it is needed.

Thanks,
Yuyang
