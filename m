Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaG1JFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:05:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:56891 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1JFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:05:51 -0400
Message-ID: <1406538338.23175.12.camel@tkhai>
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, <linux-kernel@vger.kernel.org>,
        <nicolas.pitre@linaro.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>
Date: Mon, 28 Jul 2014 13:05:38 +0400
In-Reply-To: <20140728080122.GL6758@twins.programming.kicks-ass.net>
References: <20140726145508.6308.69121.stgit@localhost>
	 <20140726145912.6308.32554.stgit@localhost>
	 <20140728080122.GL6758@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 28/07/2014 в 10:01 +0200, Peter Zijlstra пишет:
> On Sat, Jul 26, 2014 at 06:59:21PM +0400, Kirill Tkhai wrote:
> 
> > The profit is that double_rq_lock() is not needed now,
> > and this may reduce the latencies in some situations.
> 
> > We add a loop in the beginning of set_cpus_allowed_ptr.
> > It's like a handmade spinlock, which is similar
> > to situation we had before. We used to spin on rq->lock,
> > now we spin on "again:" label. Of course, it's worse
> > than arch-dependent spinlock, but we have to have it
> > here. 
> 
> > @@ -4623,8 +4639,16 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
> >  	struct rq *rq;
> >  	unsigned int dest_cpu;
> >  	int ret = 0;
> > +again:
> > +	while (unlikely(task_migrating(p)))
> > +		cpu_relax();
> >  
> >  	rq = task_rq_lock(p, &flags);
> > +	/* Check again with rq locked */
> > +	if (unlikely(task_migrating(p))) {
> > +		task_rq_unlock(rq, p, &flags);
> > +		goto again;
> > +	}
> >  
> >  	if (cpumask_equal(&p->cpus_allowed, new_mask))
> >  		goto out;
> 
> So I really dislike that, esp since you're now talking of adding more of
> this goo all over the place.
> 
> I'll ask again, why isn't this in task_rq_lock() and co?

I thought, this may give a little profit in cases of priority inheritance etc.
But since this is spreading throughout the scheduler, I'm agree with you.
It's better to place this in task_rq_lock() etc. This will decide all
the problems that we have discussed with Oleg.

> Also, you really need to talk the spin bounded, otherwise your two
> quoted paragraphs above are in contradiction. Now I think you can
> actually make an argument that way, so that's good.

Thanks,
Kirill

