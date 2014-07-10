Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaGKEL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:11:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:1225 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGKELZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:11:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="455721904"
Date: Fri, 11 Jul 2014 04:08:32 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140710200831.GB12984@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <20140709184543.GI9918@twins.programming.kicks-ass.net>
 <20140709233049.GA12024@intel.com>
 <xm2638e9xhws.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm2638e9xhws.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:06:27AM -0700, bsegall@google.com wrote:
 
> So, sched_clock(_cpu) can be arbitrarily far off of cfs_rq_clock_task, so you
> can't really do that. Ideally, yes, you would account for any time since
> the last update and account that time as !runnable. However, I don't
> think there is any good way to do that, and the current code doesn't.

Yeah. We only catch up the migrating task to its cfs_rq and substract. No catching
up to "current" time.
 
> >
> > I made another mistake. Should not only track task entity load, group entity
> > (as an entity) is also needed. Otherwise, task_h_load can't be done correctly...
> > Sorry for the messup. But this won't make much change in the codes.
> 
> This will increase it to 2x __update_load_avg per cgroup per
> enqueue/dequeue. What does this (and this patch in general) do to
> context switch cost at cgroup depth 1/2/3?
 
We can update cfs_rq load_avg, and let the cfs_rq's own se take a ride in that update.
These two should get exactly synchronized anyway (group se's load is only usefull for
task_h_load calc, and group cfs_rq's load is useful for task_h_load and update_cfs_share
calc). And technically, it looks easy:

To update cfs_rq, the update weight is cfs_rq->load.weight
To update its se, the update weight is cfs_rq->tg->se[cpu]->load.weight * on_rq

So the it will not increase to 2x, but 1.05x, maybe, :)

Thanks,
Yuyang
