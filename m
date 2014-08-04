Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaHEFoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:44:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:35666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbaHEFoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,803,1400050800"; 
   d="scan'208";a="553805333"
Date: Tue, 5 Aug 2014 05:42:04 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140804214204.GB2480@intel.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
 <20140804191526.GA2480@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804191526.GA2480@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 03:15:26AM +0800, Yuyang Du wrote:
> Hi Jason,
> 
> I am not sure whether you noticed my latest work: rewriting per entity load average
> 
> http://article.gmane.org/gmane.linux.kernel/1760754
> http://article.gmane.org/gmane.linux.kernel/1760755
> http://article.gmane.org/gmane.linux.kernel/1760757
> http://article.gmane.org/gmane.linux.kernel/1760756
> 
> which simply does not track blocked load average at all.

Actually, it tracks blocked load, but along with runnable load, so no this extra
overhead.

> Are you interested in
> testing the patchset with the workload you have? The comparison can also help
> us understand the rewrite. Overall, per our tests, the overhead should be less,
> and perf should be better.
> 
> 
> On Mon, Aug 04, 2014 at 01:28:38PM -0700, Jason Low wrote:
> > When running workloads on 2+ socket systems, based on perf profiles, the
> > update_cfs_rq_blocked_load function constantly shows up as taking up a
> > noticeable % of run time. This is especially apparent on an 8 socket
> > machine. For example, when running the AIM7 custom workload, we see:
> > 
> >    4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> > 
> > Much of the contention is in __update_cfs_rq_tg_load_contrib when we
> > update the tg load contribution stats.  However, it turns out that in many
> > cases, they don't need to be updated and "tg_contrib" is 0.
> > 
> > This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
> > tg load contribution stats when nothing needs to be updated. This reduces the
> > cacheline contention that would be unnecessary. In the above case, with the
> > patch, perf reports the total time spent in this function went down by more
> > than a factor of 3x:
> > 
> >    1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> > 
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> > ---
> >  kernel/sched/fair.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index bfa3c86..8d4cc72 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2377,6 +2377,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> >  	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> >  	tg_contrib -= cfs_rq->tg_load_contrib;
> >  
> > +	if (!tg_contrib)
> > +		return;
> > +
> >  	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> >  		atomic_long_add(tg_contrib, &tg->load_avg);
> >  		cfs_rq->tg_load_contrib += tg_contrib;
> > -- 
> > 1.7.1
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
