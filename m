Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbaGRPjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:39:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13410 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422874AbaGRPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:39:40 -0400
Date: Fri, 18 Jul 2014 16:39:31 +0100
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
Message-ID: <20140718153931.GJ8700@e103034-lin>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:26:04AM +0100, Yuyang Du wrote:
> Thanks to Morten, Ben, and Fengguang.
> 
> v4 changes:
> 
> - Insert memory barrier before writing cfs_rq->load_last_update_copy.
> - Fix typos.

It is quite a challenge keeping up with your revisions :) Three
revisions in five days. It takes time to go through all the changes to
understand the implications of your proposed changes.

I still haven't gotten to the bottom of everything, but this is my view
so far.

1. runnable_avg_period is removed

load_avg_contrib used to be runnable_avg_sum/runnable_avg_period scaled
by the task load weight (priority). The runnable_avg_period is replaced
by a constant in this patch set. The effect of that change is that task
load tracking no longer is more sensitive early life of the task until
it has built up some history. Task are now initialized to start out as
if they have been runnable forever (>345ms). If this assumption about
the task behavior is wrong it will take longer to converge to the true
average than it did before. The upside is that is more stable.

2. runnable_load_avg and blocked_load_avg are combined

runnable_load_avg currently represents the sum of load_avg_contrib of
all tasks on the rq, while blocked_load_avg is the sum of those tasks
not on a runqueue. It makes perfect sense to consider the sum of both
when calculating the load of a cpu, but we currently don't include
blocked_load_avg. The reason for that is the priority scaling of the
task load_avg_contrib may lead to under-utilization of cpus that
occasionally have tiny high priority task running. You can easily have a
task that takes 5% of cpu time but has a load_avg_contrib several times
larger than a default priority task runnable 100% of the time.

Another thing that might be an issue is that the blocked of a terminated
task lives on for quite a while until has decayed away.

I'm all for taking the blocked load into consideration, but this issue
has to be resolved first. Which leads me on to the next thing.

Most of the work going on around energy awareness is based on the load
tracking to estimate task and cpu utilization. It seems that most of the
involved parties think that we need an unweighted variant of the tracked
load as well as tracking the running time of a task. The latter was part
of the original proposal by pjt and Ben, but wasn't used. It seems that
unweighted runnable tracking should be fairly easy to add to your
proposal, but I don't have an overview of whether it is possible to add
running tracking. Do you think that is possible?

Morten
