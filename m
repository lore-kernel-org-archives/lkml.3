Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535Ab3DBJf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:35:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44215 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336Ab3DBJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:35:23 -0400
X-AuditID: 9c930197-b7b50ae00000018c-44-515aa6587e58
Date: Tue, 2 Apr 2013 18:35:35 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Message-ID: <20130402093535.GF16699@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
 <51553EF5.90702@linux.vnet.ibm.com>
 <20130401040820.GA12015@lge.com>
 <5159320C.4050903@linux.vnet.ibm.com>
 <20130402022556.GD16699@lge.com>
 <1364870126.9544.5.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364870126.9544.5.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Tue, Apr 02, 2013 at 04:35:26AM +0200, Mike Galbraith wrote:
> On Tue, 2013-04-02 at 11:25 +0900, Joonsoo Kim wrote: 
> > Hello, Preeti.
> > 
> > On Mon, Apr 01, 2013 at 12:36:52PM +0530, Preeti U Murthy wrote:
> > > Hi Joonsoo,
> > > 
> > > On 04/01/2013 09:38 AM, Joonsoo Kim wrote:
> > > > Hello, Preeti.
> > > > 
> > > 
> > > >>
> > > >> Ideally the children's cpu share must add upto the parent's share.
> > > >>
> > > > 
> > > > I don't think so.
> > > > 
> > > > We should schedule out the parent tg if 5ms is over. As we do so, we can
> > > > fairly distribute time slice to every tg within short term. If we add
> > > > the children's cpu share upto the parent's, the parent tg may have
> > > > large time slice, so it cannot be preempted easily. There may be a latency
> > > > problem if there are many tgs.
> > > 
> > > In the case where the #running < sched_nr_latency, the children's
> > > sched_slices add up to the parent's.
> > > 
> > > A rq with two tgs,each with 3 tasks.
> > > 
> > > Each of these tasks have a sched slice of
> > > [(sysctl_sched_latency / 3) / 2] as of the present implementation.
> > > 
> > > The sum of the above sched_slice of all tasks of a tg will lead to the
> > > sched_slice of its parent: sysctl_sched_latency / 2
> > > 
> > > This breaks when the nr_running on each tg > sched_nr_latency. However I
> > > don't know if this is a good thing or a bad thing.
> > 
> > Ah.. Now I get your point. Yes, you are right and it may be good thing.
> > With that property, all tasks in the system can be scheduled at least once
> > in sysctl_sched_latency. sysctl_sched_latency is system-wide configuration,
> > so my patch may be wrong. With my patch, all tasks in the system cannot be
> > scheduled at least once in sysctl_sched_latency. Instead, it schedule
> > all tasks in cfs_rq at least once in sysctl_sched_latency if there is
> > no other tgs.
> > 
> > I think that it is real problem that sysctl_sched_min_granularity is not
> > guaranteed for each task.
> > Instead of this patch, how about considering low bound?
> > 
> > if (slice < sysctl_sched_min_granularity)
> > 	slice = sysctl_sched_min_granularity;
> 
> How many SCHED_IDLE or +nice tasks will fit in that?

It is more related to how many running tasks in cfs_rq and how many tg is
in the system. If we have two tgs which have more than sched_nr_latency
tasks, all these tasks fit in this condition in current implementation.

Thanks.

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
