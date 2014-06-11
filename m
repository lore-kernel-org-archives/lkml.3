Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaFKR2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:28:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56860 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbaFKR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:28:00 -0400
Date: Wed, 11 Jun 2014 10:27:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140611172755.GE4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
 <20140609154114.20585056@gandalf.local.home>
 <alpine.DEB.2.10.1406101051210.3830@nanos>
 <20140610165704.GA3110@redhat.com>
 <alpine.DEB.2.10.1406101959420.5170@nanos>
 <20140610141306.04a4bcf3@gandalf.local.home>
 <alpine.DEB.2.10.1406102203430.5170@nanos>
 <alpine.DEB.2.10.1406102210580.5170@nanos>
 <20140611155251.GA4581@linux.vnet.ibm.com>
 <20140611170705.GA26816@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611170705.GA26816@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061117-6688-0000-0000-0000027FEE82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 07:07:05PM +0200, Oleg Nesterov wrote:
> On 06/11, Paul E. McKenney wrote:
> >
> > @@ -1202,10 +1204,14 @@ static int rcu_boost(struct rcu_node *rnp)
> >  	t = container_of(tb, struct task_struct, rcu_node_entry);
> >  	rt_mutex_init_proxy_locked(&mtx, t);
> >  	t->rcu_boost_mutex = &mtx;
> > +	init_completion(&rnp->boost_completion);
> 
> can't rcu_init_one() do this? but this is minor,

It could, but I would have to define yet another init-time function under
CONFIG_RCU_BOOST and not.  Yeah, lazy...

> >  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> >
> > +	/* Wait until boostee is done accessing mtx before reinitializing. */
> > +	wait_for_completion(&rnp->boost_completion);
> > +
> 
> I must have missed something, I dont understand why we need ->boost_completion.

Because rt_mutex_init_proxy_locked() stomps on mtx periodically.
Which might happen to be work at the moment, but doesn't seem like a
particularly good thing.

> What if you simply move that rt_mutex into rcu_node ?
> 
> Or. Given that rcu_boost_kthread() never exits, it can declare this mutex
> on stack and pass the pointer to rcu_boost() ?

It is true that moving mtx to either the rcu_node structure or to
rcu_boost_kthread()'s stack frame would preserve type safety, but not
initialization safety.

Or maybe I am being too paranoid?

							Thanx, Paul

