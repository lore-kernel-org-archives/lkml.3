Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaDXLcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:32:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbaDXLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:32:37 -0400
Date: Thu, 24 Apr 2014 13:32:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Jason Low <jason.low2@hp.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "aswin@hp.com" <aswin@hp.com>,
        "chegu_vinod@hp.com" <chegu_vinod@hp.com>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424113231.GR11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
 <20140424103059.GL2500@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424103059.GL2500@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:30:59AM +0100, Morten Rasmussen wrote:
> On Thu, Apr 24, 2014 at 02:30:35AM +0100, Jason Low wrote:
> > @@ -6704,7 +6703,12 @@ static int idle_balance(struct rq *this_rq)
> >  		interval = msecs_to_jiffies(sd->balance_interval);
> >  		if (time_after(next_balance, sd->last_balance + interval))
> >  			next_balance = sd->last_balance + interval;
> > -		if (pulled_task)
> > +
> > +		/*
> > +		 * Stop searching for tasks to pull if there are
> > +		 * now runnable tasks on this rq.
> > +		 */
> > +		if (pulled_task || this_rq->nr_running > 0)
> 
> Should this be cfs tasks instead?
> 
> +		if (pulled_task || this_rq->cfs.h_nr_running > 0)
> 
> 3.15-rc2 commit 35805ff8f4fc535ac85330170d3c56829c87c677 seems to
> indicate that using rq->nr_running may lead to trouble.
> 
> The other two patches look good to me.

No, this really wants to be nr_running, we want to bail the idle
balancer when there's anything runnable present.

Note how out: is very careful to return -1 (which results in RETRY_TASK)
when rq->nr_running != rq->cfs.h_nr_running.

That same out: test also makes problem that commit fixes impossible
again.
