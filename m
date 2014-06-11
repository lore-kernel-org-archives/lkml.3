Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaFKT4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:56:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50889 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:56:19 -0400
Date: Wed, 11 Jun 2014 12:56:13 -0700
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
Message-ID: <20140611195613.GM4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140610165704.GA3110@redhat.com>
 <alpine.DEB.2.10.1406101959420.5170@nanos>
 <20140610141306.04a4bcf3@gandalf.local.home>
 <alpine.DEB.2.10.1406102203430.5170@nanos>
 <alpine.DEB.2.10.1406102210580.5170@nanos>
 <20140611155251.GA4581@linux.vnet.ibm.com>
 <20140611170705.GA26816@redhat.com>
 <20140611171734.GA27457@redhat.com>
 <20140611172958.GF4581@linux.vnet.ibm.com>
 <20140611175934.GA28912@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611175934.GA28912@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061119-7164-0000-0000-000002626A52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 07:59:34PM +0200, Oleg Nesterov wrote:
> On 06/11, Paul E. McKenney wrote:
> >
> > On Wed, Jun 11, 2014 at 07:17:34PM +0200, Oleg Nesterov wrote:
> > > On 06/11, Oleg Nesterov wrote:
> > > >
> > > > On 06/11, Paul E. McKenney wrote:
> > > >
> > > > >  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > > > >  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> > > > >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> > > > >
> > > > > +	/* Wait until boostee is done accessing mtx before reinitializing. */
> > > > > +	wait_for_completion(&rnp->boost_completion);
> > > > > +
> > > >
> > > > I must have missed something, I dont understand why we need ->boost_completion.
> > > >
> > > > What if you simply move that rt_mutex into rcu_node ?
> > > >
> > > > Or. Given that rcu_boost_kthread() never exits, it can declare this mutex
> > > > on stack and pass the pointer to rcu_boost() ?
> > >
> > > Ah, please ignore, I forgot about init_proxy_locked(). Although perhaps this
> > > can be solved easily.
> >
> > You beat me to it.  ;-)
> >
> > I was thinking of ->boost_completion as the way to solve it easily, but
> > what did you have in mind?
> 
> I meant, rcu_boost() could probably just do "mtx->owner = t", we know that
> it was unlocked by us and nobody else can use it until we set
> t->rcu_boost_mutex.

My concern with this is that rcu_read_unlock_special() could hypothetically
get preempted (either by kernel or hypervisor), so that it might be a long
time until it makes its reference.  But maybe that reference would be
harmless in this case.

> And if we move it into rcu_node, then we can probably kill ->rcu_boost_mutex,
> rcu_read_unlock_special() could check rnp->boost_mutex->owner == current.

If this was anywhere near a hot code path, I would be sorely tempted.

> But you know, I also think that the dentist removed the rest of my brains
> along my tooth, so I am not sure if I actually have something in mind.

Ouch!!!  When that happens to me, most of my brains return some time
after the anesthetic wears off, but I know the feeling!

							Thanx, Paul

