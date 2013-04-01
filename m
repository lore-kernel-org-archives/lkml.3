Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3DAEIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:08:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64232 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3DAEIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:08:12 -0400
X-AuditID: 9c930197-b7c9dae000006959-d0-515908290bce
Date: Mon, 1 Apr 2013 13:08:20 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Message-ID: <20130401040820.GA12015@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
 <51553EF5.90702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51553EF5.90702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Preeti.

On Fri, Mar 29, 2013 at 12:42:53PM +0530, Preeti U Murthy wrote:
> Hi Joonsoo,
> 
> On 03/28/2013 01:28 PM, Joonsoo Kim wrote:
> > Following-up upper se in sched_slice() should not be done,
> > because sched_slice() is used for checking that resched is needed
> > whithin *this* cfs_rq and there is one problem related to this
> > in current implementation.
> > 
> > The problem is that if we follow-up upper se in sched_slice(), it is
> > possible that we get a ideal slice which is lower than
> > sysctl_sched_min_granularity.
> > 
> > For example, we assume that we have 4 tg which is attached to root tg
> > with same share and each one have 20 runnable tasks on cpu0, respectivly.
> > In this case, __sched_period() return sysctl_sched_min_granularity * 20
> > and then go into loop. At first iteration, we compute a portion of slice
> > for this task on this cfs_rq, so get a slice, sysctl_sched_min_granularity.
> > Afterward, we enter second iteration and get a slice which is a quarter of
> > sysctl_sched_min_granularity, because there is 4 tgs with same share
> > in that cfs_rq.
> > 
> > Ensuring slice larger than min_granularity is important for performance
> > and there is no lower bound about this, except timer tick, we should
> > fix it not to consider upper se when calculating sched_slice.
> > 
> 
> I am assuming the sysctl_sched_latency = 20ms and
> sysctl_sched_min_granularity = 4ms.
> In that case:
> 
> With your patch, the sum of the sched_slice(runnable_task) on each_tg is
>  40ms = sched_min_granularity * 10, while the parent tg has a
> sched_slice of sysctl_sched_latency / 4 = (20 / 4) = 5ms.
> 
> Ideally the children's cpu share must add upto the parent's share.
>

I don't think so.

We should schedule out the parent tg if 5ms is over. As we do so, we can
fairly distribute time slice to every tg within short term. If we add
the children's cpu share upto the parent's, the parent tg may have
large time slice, so it cannot be preempted easily. There may be a latency
problem if there are many tgs.

Thanks.

> 
> Thank you
> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
