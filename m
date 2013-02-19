Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3BSCeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:34:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3BSCeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:34:08 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Tns0NbjpAz8A:10 a=FCxD4PBwpDUqGlj9m94A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361241246.23152.183.camel@gandalf.local.home>
Subject: Re: sched: BUG in load_balance
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Feb 2013 21:34:06 -0500
In-Reply-To: <5122E12E.6000109@oracle.com>
References: <5122CD9C.9070702@oracle.com>
	 <1361237185.23152.174.camel@gandalf.local.home>
	 <5122E12E.6000109@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 21:19 -0500, Sasha Levin wrote:

> > Only compiled tested:
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 0fcdbff..a31174c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5222,9 +5222,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >  	update_rq_runnable_avg(this_rq, 1);
> >  
> >  	/*
> > -	 * Drop the rq->lock, but keep preempt disabled.
> > +	 * Drop the rq->lock, but keep softirqs disabled.
> >  	 */
> > -	preempt_disable();
> > +	local_bh_disable();
> >  	raw_spin_unlock_irq(&this_rq->lock);
> >  
> >  	update_blocked_averages(this_cpu);
> > @@ -5253,7 +5253,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
> >  	rcu_read_unlock();
> >  
> >  	raw_spin_lock_irq(&this_rq->lock);
> > -	preempt_enable();
> > +	local_bh_enable();
> 
> I have to admit, I'm slightly confused with the patch: there's a raw_spin_lock_irq()
> followed by local_bh_enable(). afaik it's illegal to call local_bh_enable() with
> interrupts disabled.
> 

Bah, you're right. I was trying to enable interrupts without enabling
softirqs, but if an interrupt happens here and raises a softirq, it will
miss being executed by the local_bh_enabled().

We can keep the preempt disable and only disable local_bh, around the
idle_balance(). But still, I'm getting uncomfortable with these patches,
they may need more work, and Peter's not too happy with them either.

Ingo,

Can you revert this and the previous patch, and I'll work with Peter to
get something that we can agree on, where we can hopefully remove the
idle hooks from the scheduler.

Thanks,

-- Steve


-- Steve



