Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbaFKRaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:30:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39237 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaFKRaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:30:07 -0400
Date: Wed, 11 Jun 2014 10:29:58 -0700
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
Message-ID: <20140611172958.GF4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140609154114.20585056@gandalf.local.home>
 <alpine.DEB.2.10.1406101051210.3830@nanos>
 <20140610165704.GA3110@redhat.com>
 <alpine.DEB.2.10.1406101959420.5170@nanos>
 <20140610141306.04a4bcf3@gandalf.local.home>
 <alpine.DEB.2.10.1406102203430.5170@nanos>
 <alpine.DEB.2.10.1406102210580.5170@nanos>
 <20140611155251.GA4581@linux.vnet.ibm.com>
 <20140611170705.GA26816@redhat.com>
 <20140611171734.GA27457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611171734.GA27457@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061117-3532-0000-0000-0000026928F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 07:17:34PM +0200, Oleg Nesterov wrote:
> On 06/11, Oleg Nesterov wrote:
> >
> > On 06/11, Paul E. McKenney wrote:
> >
> > >  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > >  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> > >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> > >
> > > +	/* Wait until boostee is done accessing mtx before reinitializing. */
> > > +	wait_for_completion(&rnp->boost_completion);
> > > +
> >
> > I must have missed something, I dont understand why we need ->boost_completion.
> >
> > What if you simply move that rt_mutex into rcu_node ?
> >
> > Or. Given that rcu_boost_kthread() never exits, it can declare this mutex
> > on stack and pass the pointer to rcu_boost() ?
> 
> Ah, please ignore, I forgot about init_proxy_locked(). Although perhaps this
> can be solved easily.

You beat me to it.  ;-)

I was thinking of ->boost_completion as the way to solve it easily, but
what did you have in mind?

							Thanx, Paul

