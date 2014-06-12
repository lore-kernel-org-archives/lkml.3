Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbaFLW1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:27:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46333 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFLW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:27:53 -0400
Date: Thu, 12 Jun 2014 15:27:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140612222748.GF4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.10.1406102210580.5170@nanos>
 <20140611155251.GA4581@linux.vnet.ibm.com>
 <20140611170705.GA26816@redhat.com>
 <20140611171734.GA27457@redhat.com>
 <20140611172958.GF4581@linux.vnet.ibm.com>
 <20140611175934.GA28912@redhat.com>
 <20140611195613.GM4581@linux.vnet.ibm.com>
 <20140612172844.GA15795@redhat.com>
 <20140612203518.GZ4581@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406122337060.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406122337060.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061222-6688-0000-0000-00000288520F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:40:07PM +0200, Thomas Gleixner wrote:
> On Thu, 12 Jun 2014, Paul E. McKenney wrote:
> > On Thu, Jun 12, 2014 at 07:28:44PM +0200, Oleg Nesterov wrote:
> > > On 06/11, Paul E. McKenney wrote:
> > > >
> > > > On Wed, Jun 11, 2014 at 07:59:34PM +0200, Oleg Nesterov wrote:
> > > > > On 06/11, Paul E. McKenney wrote:
> > > > > >
> > > > > > I was thinking of ->boost_completion as the way to solve it easily, but
> > > > > > what did you have in mind?
> > > > >
> > > > > I meant, rcu_boost() could probably just do "mtx->owner = t", we know that
> > > > > it was unlocked by us and nobody else can use it until we set
> > > > > t->rcu_boost_mutex.
> > > >
> > > > My concern with this is that rcu_read_unlock_special() could hypothetically
> > > > get preempted (either by kernel or hypervisor), so that it might be a long
> > > > time until it makes its reference.  But maybe that reference would be
> > > > harmless in this case.
> > > 
> > > Confused... Not sure I understand what did you mean, and certainly I do not
> > > understand how this connects to the proxy-locking method.
> > > 
> > > Could you explain?
> > 
> > Here is the hypothetical sequence of events, which cannot happen unless
> > the CPU releasing the lock accesses the structure after releasing
> > the lock:
> > 
> > 	CPU 0				CPU 1 (booster)
> > 
> > 	releases boost_mutex
> > 
> > 					acquires boost_mutex
> > 					releases boost_mutex
> > 					post-release boost_mutex access?
> > 					Loops to next task to boost
> > 					proxy-locks boost_mutex
> > 
> > 	post-release boost_mutex access:
> > 		confused due to proxy-lock
> > 		operation?
> > 
> > Now maybe this ends up being safe, but it sure feels like an accident
> > waiting to happen.  Some bright developer comes up with a super-fast
> > handoff, and blam, RCU priority boosting takes it in the shorts.  ;-)
> > In contrast, using the completion prevents this.
> > 
> > > > > And if we move it into rcu_node, then we can probably kill ->rcu_boost_mutex,
> > > > > rcu_read_unlock_special() could check rnp->boost_mutex->owner == current.
> > > >
> > > > If this was anywhere near a hot code path, I would be sorely tempted.
> > > 
> > > Ah, but I didn't mean perfomance. I think it is always good to try to remove
> > > something from task_struct, it is huge. I do not mean sizeof() in the first
> > > place, the very fact that I can hardly understand the purpose of a half of its
> > > members makes me sad ;)
> > 
> > Now -that- just might make a huge amount of sense!  Let's see...
> > 
> > o	We hold the rcu_node structure's ->lock when checking the owner
> > 	(looks like rt_mutex_owner() is the right API).
> > 
> > o	We hold the rcu_node structure's ->lock when doing
> > 	rt_mutex_init_proxy_locked().
> > 
> > o	We -don't- hold ->lock when releasing the rt_mutex, but that
> > 	should be OK: The owner is releasing it, and it is going to
> > 	not-owned, so no other task can possibly see ownership moving
> > 	to/from them.
> > 
> > o	The rcu_node structure grows a bit, but not enough to worry
> > 	about, and on most systems, the decrease in task_struct size
> > 	will more than outweigh the increase in rcu_node size.
> > 
> > Looks quite promising, how about the following?  (Hey, it builds, so it
> > must be correct, right?)
> 
> True. Why should we have users if we would test the crap we produce?

Well, it seems to be passing initial tests as well.  Must be my tests
need more work.

> Just FYI, I have a patch pending which makes the release safe.
> 
>       http://marc.info/?l=linux-kernel&m=140251240630730&w=2

Very good, belt -and- suspenders!  Might even work that way.  ;-)

I could argue for a cpu_relax() in the "while (!rt_mutex_has_waiters(lock))"
loop for the case in which the CPU enqueuing itself is preempted, possibly
by a hypervisor, but either way:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

