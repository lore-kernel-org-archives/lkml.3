Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3HLUUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:20:11 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1318 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3HLUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:20:09 -0400
Message-ID: <1376338799.2697.18.camel@j-VirtualBox>
Subject: Re: [PATCH] sched: Give idle_balance() a break when it does not
 move tasks.
From: Jason Low <jason.low2@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, "Bui, Tuan" <tuan.d.bui@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Makphaibulchoke, Thavatchai" <thavatchai.makpahibulchoke@hp.com>,
        "Bueso, Davidlohr" <davidlohr.bueso@hp.com>
Date: Mon, 12 Aug 2013 13:19:59 -0700
In-Reply-To: <20130812110045.GA1925@linux.vnet.ibm.com>
References: <1376296970.1795.9.camel@j-VirtualBox>
	 <20130812110045.GA1925@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-12 at 16:30 +0530, Srikar Dronamraju wrote:
> >  	/*
> > @@ -5298,6 +5300,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >  			continue;
> > 
> >  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> > +			load_balance_attempted = true;
> > +
> >  			/* If we've pulled tasks over stop searching: */
> >  			pulled_task = load_balance(this_cpu, this_rq,
> >  						   sd, CPU_NEWLY_IDLE, &balance);
> > @@ -5322,6 +5326,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >  		 */
> >  		this_rq->next_balance = next_balance;
> >  	}
> > +
> > +	/* Give idle balance on this CPU a break when it isn't moving tasks */
> > +	if (load_balance_attempted && !pulled_task)
> > +		this_rq->next_newidle_balance = jiffies + (HZ / 100);
> >  }
> 
> Looks reasonable. However should we do this per sd and not per rq. i.e
> move the next_newidle_balance to sched_domain. So if we find a
> load_balance in newly_idle context that wasn't successful, we skip
> load_balance for that sd in the next newly idle balance.

I wonder, if we skip newidle balance for a domain after a newidle
balance attempt for a CPU did not move tasks, would that potentially
cause some "unfairness" for all the other CPUS within the domain?

Perhaps we can reduce the duration that idle balance is blocked from 10
ms to a much smaller duration if we were to block on a per domain basis.

Peter, any thoughts on which method is preferable?

Thanks for the suggestion,
Jason


