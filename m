Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaGIJKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:10:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:35602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbaGIJKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,630,1400050800"; 
   d="scan'208";a="540762434"
Date: Wed, 9 Jul 2014 09:07:53 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140709010753.GD25653@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Ben.

On Tue, Jul 08, 2014 at 10:04:22AM -0700, bsegall@google.com wrote:

> > The sampling of cfs_rq->load.weight should be equivalent to the current
> > code in that at the end of day cfs_rq->load.weight worth of runnable would 
> > contribute to runnable_load_avg/blocked_load_avg for both the current and
> > the rewrite.
> 
> Yes, but the point is that it looks at load.weight when delta/1024 > 0
> and assumes that it has had that load.weight the entire time, when this
> might not actually be true. The largest error I can think of is if you
> have a very high weight task that tends to run for very short periods of
> time, you could end up losing their entire contribution to load. This
> may be acceptable, I'm not certain.

That I believe is not a problem. It is a matter of when cfs_rq->load.weight
changes and when we look at it to contribute to the cfs_rq's load_avg.
Fortunately, we will not miss any change of cfs_rq->load.weight, always
contributing to the load_avg the right amount. Put another way, we always
use the right cfs_rq->load.weight.

> > So left are the migrate_task_rq_fair() not holding lock issue and cfs_rq->avg.load_avg
> > overflow issue. I need some time to study them.
> >
> > Overall, I think none of these issues are originally caused by combination/split
> > of runnable and blocked. It is just a matter of how synchronized we want to be
> > (this rewrite is the most synchronized), and the workaround I need to borrow from the
> > current codes.
> 
> If you can manage to find a to deal with the migration issue without it,
> that would be great, I'm just pretty sure that's why we did the split.
 
After thinking about it the whole morning, this issue is a killer... :)

But I think, even by spliting and by using atomic operations, the current code
does not substract the migrating task's load absolutely synchronized:

When se migrating, you atomic_read cfs_rq->decay_counter (say t1), and then atomic_add
the se's load_avg_contrib to removed_load. However, when updating the cfs_rq->blocked_load_avg
it is not guranteed when substracting the removed_load from the blocked_load_avg,
the actual decay_counter (say t2) is the same as t1. Because at t1 time (when you
atomic_read it), the decay_counter can be being updated (before you atomic_add to
removed_load). Atomic operation does not help synchronize them. Right?

So essentially, to perfectly substract the right amount, we must first synchronize
the migrating task with its cfs_rq (catch up), and then substract it right away.
Those two steps must be synchronized (with lock) or atomically done at once. Considering
migrating and load averaging are not sequential (strict interleaving). Separating the
two steps but synchronizing them is not enough, they must be done atomically.

That is chalenging... Can someone (Peter) grant us a lock of the remote rq? :)

Thanks,
Yuyang

