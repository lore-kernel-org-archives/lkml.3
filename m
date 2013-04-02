Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab3DBCC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:02:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57936 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759864Ab3DBCCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:02:25 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-0b-515a3c2fe5c4
Date: Tue, 2 Apr 2013 11:02:36 +0900
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
Message-ID: <20130402020236.GC16699@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com>
 <51557C89.4070201@linux.vnet.ibm.com>
 <20130401050926.GB12015@lge.com>
 <51592D1E.7030707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51592D1E.7030707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Preeti.

On Mon, Apr 01, 2013 at 12:15:50PM +0530, Preeti U Murthy wrote:
> Hi Joonsoo,
> 
> On 04/01/2013 10:39 AM, Joonsoo Kim wrote:
> > Hello Preeti.
> > So we should limit this possible weird situation.
> >>>
> >>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >>>
> >>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>> index e232421..6ceffbc 100644
> >>> --- a/kernel/sched/fair.c
> >>> +++ b/kernel/sched/fair.c
> >>> @@ -645,6 +645,9 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >>>  	}
> >>>  	slice = calc_delta_mine(slice, se->load.weight, load);
> >>>
> >>> +	if (unlikely(slice > sysctl_sched_latency))
> >>> +		slice = sysctl_sched_latency;
> >>
> >> Then in this case the highest priority thread would get
> >> 20ms(sysctl_sched_latency), and the rest would get
> >> sysctl_sched_min_granularity * 10 * (1024/97977) which would be 0.4ms.
> >> Then all tasks would get scheduled ateast once within 20ms + (0.4*9) ms
> >> = 23.7ms, while your scheduling latency period was extended to 40ms,just
> >> so that each of these tasks don't have their sched_slices shrunk due to
> >> large number of tasks.
> > 
> > I don't know I understand your question correctly.
> > I will do my best to answer your comment. :)
> > 
> > With this patch, I just limit maximum slice at one time. Scheduling is
> > controlled through the vruntime. So, in this case, the task with nice -20
> > will be scheduled twice.
> > 
> > 20 + (0.4 * 9) + 20 = 43.9 ms
> > 
> > And after 43.9 ms, this process is repeated.
> > 
> > So I can tell you that scheduling period is preserved as before.
> > 
> > If we give a long period to a task at one go, it can cause
> > a latency problem. So IMHO, limiting this is meaningful.
> 
> Thank you very much for the explanation. Just one question. What is the
> reason behind you choosing sysctl_sched_latency as the upper bound here?

sysctl_sched_latency is a sched_slice when there is one task.
So, I think that this is proper as upper bound.

Thanks.

> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
