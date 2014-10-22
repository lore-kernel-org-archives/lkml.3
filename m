Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaJVIQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:16:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:32196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaJVIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="609183706"
Date: Wed, 22 Oct 2014 08:13:16 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141022001316.GC2577@intel.com>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
 <20141021145652.GB23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021145652.GB23531@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:56:52PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 10, 2014 at 10:21:56AM +0800, Yuyang Du wrote:
> >  static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
> >  {
> > -	long tg_weight;
> > -
> > -	/*
> > -	 * Use this CPU's actual weight instead of the last load_contribution
> > -	 * to gain a more accurate current total weight. See
> > -	 * update_cfs_rq_load_contribution().
> > -	 */
> > -	tg_weight = atomic_long_read(&tg->load_avg);
> > -	tg_weight -= cfs_rq->tg_load_contrib;
> > -	tg_weight += cfs_rq->load.weight;
> > -
> > -	return tg_weight;
> > +	return atomic_long_read(&tg->load_avg);
> 
> Since you're now also delaying updating load_avg, why not retain this
> slightly better approximation?

Oh, yeah, I know load_avg is delayed, but I don't know why this is slightly better
approximation, in which "Use this CPU's actual weight instead of the last
load_contribution".

In addition to that, if we use this approximation, should we worry that
the child cfs and group's added weight is toward likely to be underrated? No?

or we do this instead:

	tg_weight = atomic_long_read(&tg->load_avg);
	tg_weight -= cfs_rq->tg_load_contrib;
	tg_weight += cfs_rq->load_avg;
                         ~~~~~~~~

Thanks,
Yuyang
