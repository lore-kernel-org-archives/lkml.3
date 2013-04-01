Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3DAFJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:09:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61605 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3DAFJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:09:19 -0400
X-AuditID: 9c930197-b7c9dae000006959-3c-5159167b953e
Date: Mon, 1 Apr 2013 14:09:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 5/5] sched: limit sched_slice if it is more than
 sysctl_sched_latency
Message-ID: <20130401050926.GB12015@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com>
 <51557C89.4070201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51557C89.4070201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Preeti.

On Fri, Mar 29, 2013 at 05:05:37PM +0530, Preeti U Murthy wrote:
> Hi Joonsoo
> 
> On 03/28/2013 01:28 PM, Joonsoo Kim wrote:
> > sched_slice() compute ideal runtime slice. If there are many tasks
> > in cfs_rq, period for this cfs_rq is extended to guarantee that each task
> > has time slice at least, sched_min_granularity. And then each task get
> > a portion of this period for it. If there is a task which have much larger
> > load weight than others, a portion of period can exceed far more than
> > sysctl_sched_latency.
> 
> Correct. But that does not matter, the length of the scheduling latency
> period is determined by the return value of ___sched_period(), not the
> value of sysctl_sched_latency. You would not extend the period,if you
> wanted all tasks to have a slice within the sysctl_sched_latency, right?
> 
> So since the value of the length of the scheduling latency period, is
> dynamic depending on the number of the processes running, the
> sysctl_sched_latency which is the default latency period length is not
> mesed with, but is only used as a base to determine the actual
> scheduling period.
> 
> > 
> > For exampple, you can simply imagine that one task with nice -20 and
> > 9 tasks with nice 0 on one cfs_rq. In this case, load weight sum for
> > this cfs_rq is 88761 + 9 * 1024, 97977. So a portion of slice for the
> > task with nice -20 is sysctl_sched_min_granularity * 10 * (88761 / 97977),
> > that is, approximately, sysctl_sched_min_granularity * 9. This aspect
> > can be much larger if there is more tasks with nice 0.
> 
> Yeah so the __sched_period says that within 40ms, all tasks need to be
> scheduled ateast once, and the highest priority task gets nearly 36ms of
> it, while the rest is distributed among the others.
> 
> > 
> > So we should limit this possible weird situation.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index e232421..6ceffbc 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -645,6 +645,9 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  	}
> >  	slice = calc_delta_mine(slice, se->load.weight, load);
> > 
> > +	if (unlikely(slice > sysctl_sched_latency))
> > +		slice = sysctl_sched_latency;
> 
> Then in this case the highest priority thread would get
> 20ms(sysctl_sched_latency), and the rest would get
> sysctl_sched_min_granularity * 10 * (1024/97977) which would be 0.4ms.
> Then all tasks would get scheduled ateast once within 20ms + (0.4*9) ms
> = 23.7ms, while your scheduling latency period was extended to 40ms,just
> so that each of these tasks don't have their sched_slices shrunk due to
> large number of tasks.

I don't know I understand your question correctly.
I will do my best to answer your comment. :)

With this patch, I just limit maximum slice at one time. Scheduling is
controlled through the vruntime. So, in this case, the task with nice -20
will be scheduled twice.

20 + (0.4 * 9) + 20 = 43.9 ms

And after 43.9 ms, this process is repeated.

So I can tell you that scheduling period is preserved as before.

If we give a long period to a task at one go, it can cause
a latency problem. So IMHO, limiting this is meaningful.

Thanks.

> 
> > +
> >  	return slice;
> >  }
> > 
> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
