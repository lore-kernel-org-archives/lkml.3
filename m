Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3ANN7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:59:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39878 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab3ANN7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:59:12 -0500
Date: Mon, 14 Jan 2013 13:59:12 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 15/22] sched: log the cpu utilization at rq
Message-ID: <20130114135912.GA8502@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-16-git-send-email-alex.shi@intel.com>
 <20130110114044.GE2046@e103034-lin>
 <50EF8756.6050309@intel.com>
MIME-Version: 1.0
In-Reply-To: <50EF8756.6050309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Jan 2013 13:59:08.0464 (UTC) FILETIME=[5290AB00:01CDF25F]
X-MC-Unique: 113011413591004101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:30:30AM +0000, Alex Shi wrote:
> On 01/10/2013 07:40 PM, Morten Rasmussen wrote:
> >> >  #undef P64
> >> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> > index ee015b8..7bfbd69 100644
> >> > --- a/kernel/sched/fair.c
> >> > +++ b/kernel/sched/fair.c
> >> > @@ -1495,8 +1495,12 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
> >> >  
> >> >  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
> >> >  {
> >> > +	u32 period;
> >> >  	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
> >> >  	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
> >> > +
> >> > +	period = rq->avg.runnable_avg_period ? rq->avg.runnable_avg_period : 1;
> >> > +	rq->util = rq->avg.runnable_avg_sum * 100 / period;
> > The existing tg->runnable_avg and cfs_rq->tg_runnable_contrib variables
> > both holds
> > rq->avg.runnable_avg_sum / rq->avg.runnable_avg_period scaled by
> > NICE_0_LOAD (1024). Why not use one of the existing variables instead of
> > introducing a new one?
> 
> we want to a rq variable that reflect the utilization of the cpu, not of
> the tg

It is the same thing for the root tg. You use exactly the same variables
for calculating rq->util as is used to calculate both tg->runnable_avg and
cfs_rq->tg_runnable_contrib in __update_tg_runnable_avg(). The only
difference is that you scale by 100 while __update_tg_runnable_avg()
scale by NICE_0_LOAD.

Morten

> -- 
> Thanks Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

