Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaGHEI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:6510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaGHEIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,623,1400050800"; 
   d="scan'208";a="569747898"
Date: Tue, 8 Jul 2014 04:03:42 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com,
        Ben Segall <bsegall@google.com>
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140707200342.GA25653@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707104646.GK6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Peter.

On Mon, Jul 07, 2014 at 12:46:46PM +0200, Peter Zijlstra wrote:
> 
> That tg->load_avg cacheline is already red hot glowing, and you've just
> increased the amount of updates to it.. That's not going to be pleasant.
> 

Logically, this rewrite updates tg->load_avg as soon as it is changed. But
technically, this is not necessary, as it is only needed to be updated when
it is used before update_cfs_shares() and update_cfs_rq_h_load().

Yes, I can optimize it.

> So here you add the task to the cfs_rq avg when its got migrate in,
> however:
> 
> > @@ -4552,17 +4326,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
> >  	struct sched_entity *se = &p->se;
> >  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> >  
> > +	/* Update task on old CPU, then ready to go (entity must be off the queue) */
> > +	__update_load_avg(cfs_rq_clock_task(cfs_rq), &se->avg, 0);
> > +	se->avg.last_update_time = 0;
> >  
> >  	/* We have migrated, no longer consider this task hot */
> >  	se->exec_start = 0;
> 
> there you don't remove it first..
> 

Yes, I missed it. I wonder what I was thinking. Migration is the only reason
to track task load average...

Yuyang
