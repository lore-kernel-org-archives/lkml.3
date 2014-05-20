Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaETU7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:59:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:44440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaETU7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,876,1392192000"; 
   d="scan'208";a="543834100"
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
References: <1400617046.2970.270.camel@schen9-DESK>
	 <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 May 2014 13:59:10 -0700
Message-ID: <1400619550.2970.274.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 13:51 -0700, Jason Low wrote:
> On Tue, May 20, 2014 at 1:17 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 9b4c4f3..97132db 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -6764,12 +6764,17 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
> >
> >                 rq = cpu_rq(balance_cpu);
> >
> > -               raw_spin_lock_irq(&rq->lock);
> > -               update_rq_clock(rq);
> > -               update_idle_cpu_load(rq);
> > -               raw_spin_unlock_irq(&rq->lock);
> > -
> > -               rebalance_domains(rq, CPU_IDLE);
> > +               /*
> > +                * If time for next balance is due,
> > +                * do the balance.
> > +                */
> > +               if (time_after(jiffies + 1, rq->next_balance)) {
> 
> Hi Tim,
> 
> If we want to do idle load balancing only when it is due for a
> balance, shouldn't the above just be "if (time_after(jiffies,
> rq->next_balance))"?

If rq->next_balance and jiffies are equal, then
time_after(jiffies, rq->next_balance) check will be false and
you will not do balance.  But actually you want to balance
for this case so the jiffies+1 was used.

Tim

