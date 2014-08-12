Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaHLIec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:34:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:33479 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHLIea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:34:30 -0400
Message-ID: <1407832463.23412.2.camel@tkhai>
Subject: Re: [PATCH v4 3/6] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>, <tkhai@yandex.ru>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>,
        <nicolas.pitre@linaro.org>
Date: Tue, 12 Aug 2014 12:34:23 +0400
In-Reply-To: <20140812075523.GN9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
	 <1407312379.8424.38.camel@tkhai>
	 <20140812075523.GN9918@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 12/08/2014 в 09:55 +0200, Peter Zijlstra пишет:
> On Wed, Aug 06, 2014 at 12:06:19PM +0400, Kirill Tkhai wrote:
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -331,9 +331,13 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
> >  	lockdep_assert_held(&p->pi_lock);
> >  
> >  	for (;;) {
> > +		while (unlikely(task_migrating(p)))
> > +			cpu_relax();
> > +
> >  		rq = task_rq(p);
> >  		raw_spin_lock(&rq->lock);
> > -		if (likely(rq == task_rq(p)))
> > +		if (likely(rq == task_rq(p) &&
> > +			   !task_migrating(p)))
> >  			return rq;
> >  		raw_spin_unlock(&rq->lock);
> >  	}
> > @@ -349,10 +353,14 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
> >  	struct rq *rq;
> >  
> >  	for (;;) {
> > +		while (unlikely(task_migrating(p)))
> > +			cpu_relax();
> > +
> >  		raw_spin_lock_irqsave(&p->pi_lock, *flags);
> >  		rq = task_rq(p);
> >  		raw_spin_lock(&rq->lock);
> > -		if (likely(rq == task_rq(p)))
> > +		if (likely(rq == task_rq(p) &&
> > +			   !task_migrating(p)))
> >  			return rq;
> >  		raw_spin_unlock(&rq->lock);
> >  		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
> 
> I know I suggested that; but I changed it like the below. The advantage
> is of not having two task_migrating() tests on the likely path.

I don't have objections. Should I resend the series (also with new [4/6] log
commentary)?

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -331,15 +331,15 @@ static inline struct rq *__task_rq_lock(
>  	lockdep_assert_held(&p->pi_lock);
>  
>  	for (;;) {
> -		while (unlikely(task_migrating(p)))
> -			cpu_relax();
> -
>  		rq = task_rq(p);
>  		raw_spin_lock(&rq->lock);
>  		if (likely(rq == task_rq(p) &&
>  			   !task_migrating(p)))
>  			return rq;
>  		raw_spin_unlock(&rq->lock);
> +
> +		while (unlikely(task_migrating(p)))
> +			cpu_relax();
>  	}
>  }
>  
> @@ -353,9 +353,6 @@ static struct rq *task_rq_lock(struct ta
>  	struct rq *rq;
>  
>  	for (;;) {
> -		while (unlikely(task_migrating(p)))
> -			cpu_relax();
> -
>  		raw_spin_lock_irqsave(&p->pi_lock, *flags);
>  		rq = task_rq(p);
>  		raw_spin_lock(&rq->lock);
> @@ -364,6 +361,9 @@ static struct rq *task_rq_lock(struct ta
>  			return rq;
>  		raw_spin_unlock(&rq->lock);
>  		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
> +
> +		while (unlikely(task_migrating(p)))
> +			cpu_relax();
>  	}
>  }
>  


