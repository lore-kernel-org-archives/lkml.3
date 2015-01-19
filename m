Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbbASRsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:48:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:30797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbASRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:48:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,428,1418112000"; 
   d="scan'208";a="639425218"
Message-ID: <1421689725.2399.38.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH v6 5/7] sched/fair: fix idle balance when remaining
 tasks are all non-CFS tasks
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, riel@redhat.com, jason.low2@hp.com,
        fweisbec@gmail.com
Date: Mon, 19 Jan 2015 09:48:45 -0800
In-Reply-To: <20150119124528.GO25256@twins.programming.kicks-ass.net>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
	 <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
	 <20150119124528.GO25256@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-19 at 13:45 +0100, Peter Zijlstra wrote:
> On Wed, Nov 26, 2014 at 08:44:05AM +0800, Wanpeng Li wrote:
> > The overload indicator is used for knowing when we can totally avoid load
> > balancing to a cpu that is about to go idle. We can avoid load balancing
> > when no cpu has cfs task and both rt and deadline have push/pull mechanism
> > to do their own balancing.
> > 
> > However, rq->nr_running on behalf of the total number of each class tasks
> > on the cpu, do idle balance when remaining tasks are all non-CFS tasks does
> > not make any sense.
> > 
> > This patch fix it by idle balance when there are still other CFS tasks in
> > the rq's root domain.
> > 
> 
> Please always try and Cc the people who touched that code last; for the
> idle_balance bits commit 4486edd12b5a ("sched/fair: Implement fast
> idling of CPUs when the system is partially loaded") gives a fair clue
> as to who that would be.
> 
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 31f1e4d..f7dd978 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -1269,7 +1269,8 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
> >  
> >  	rq->nr_running = prev_nr + count;
> >  
> > -	if (prev_nr < 2 && rq->nr_running >= 2) {
> > +	if (prev_nr < 2 && rq->nr_running >= 2 &&
> > +		rq->cfs.h_nr_running > 0) {
> >  #ifdef CONFIG_SMP
> >  		if (!rq->rd->overload)
> >  			rq->rd->overload = true;
> 

After this change, you will not start cfs load balance if you have one
cfs task and a few other non-cfs tasks on a run-queue.  In this case if
there's a less loaded run queue available, the cfs scheduler would not
move the cfs task there. So you will be forcing the deadline and rt
scheduler to move their tasks away.  In this case, a cfs task will
behave like a "higher" priority task than the rt and deadline tasks in
the sense that it forces the other classes of tasks to be moved to
accommodate cfs tasks.  I don't think this is the right behavior.

Also, add_nr_running could add more than one cfs tasks.  So if there are
more than one cfs tasks being added, you should load balance and that
need to be checked in add_nr_running if you make the change there.

Tim

> Here 3882ec643997 ("nohz: Use IPI implicit full barrier against
> rq->nr_running r/w") might be a clue.
> 
> Also, this is wrong, it breaks NOHZ_FULL.


