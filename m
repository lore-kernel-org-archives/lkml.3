Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaFMOyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:54:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaFMOyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:54:03 -0400
Date: Fri, 13 Jun 2014 16:52:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140613145239.GA29669@redhat.com>
References: <alpine.DEB.2.10.1406102203430.5170@nanos> <alpine.DEB.2.10.1406102210580.5170@nanos> <20140611155251.GA4581@linux.vnet.ibm.com> <20140611170705.GA26816@redhat.com> <20140611171734.GA27457@redhat.com> <20140611172958.GF4581@linux.vnet.ibm.com> <20140611175934.GA28912@redhat.com> <20140611195613.GM4581@linux.vnet.ibm.com> <20140612172844.GA15795@redhat.com> <20140612203518.GZ4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612203518.GZ4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Paul E. McKenney wrote:
>
> On Thu, Jun 12, 2014 at 07:28:44PM +0200, Oleg Nesterov wrote:
> > On 06/11, Paul E. McKenney wrote:
> > >
> > > On Wed, Jun 11, 2014 at 07:59:34PM +0200, Oleg Nesterov wrote:
> > > > On 06/11, Paul E. McKenney wrote:
> > > > >
> > > > > I was thinking of ->boost_completion as the way to solve it easily, but
> > > > > what did you have in mind?
> > > >
> > > > I meant, rcu_boost() could probably just do "mtx->owner = t", we know that
> > > > it was unlocked by us and nobody else can use it until we set
> > > > t->rcu_boost_mutex.
> > >
> > > My concern with this is that rcu_read_unlock_special() could hypothetically
> > > get preempted (either by kernel or hypervisor), so that it might be a long
> > > time until it makes its reference.  But maybe that reference would be
> > > harmless in this case.
> >
> > Confused... Not sure I understand what did you mean, and certainly I do not
> > understand how this connects to the proxy-locking method.
> >
> > Could you explain?
>
> Here is the hypothetical sequence of events, which cannot happen unless
> the CPU releasing the lock accesses the structure after releasing
> the lock:
>
> 	CPU 0				CPU 1 (booster)
>
> 	releases boost_mutex
>
> 					acquires boost_mutex
> 					releases boost_mutex
> 					post-release boost_mutex access?
> 					Loops to next task to boost
> 					proxy-locks boost_mutex
>
> 	post-release boost_mutex access:
> 		confused due to proxy-lock
> 		operation?

But this is the same problem I was worried about. Should be fixed by the
patch from Thomas but lets ignore this, lets assume that we should not rely
on this (and that is why you addded completion).

My point was, in this case we can separate "init" and "proxy_locked" and solve
the problem. If we initialize this mutex once, then "->owner = t" should be
always safe: whatever "post-release" above does we were able to lock (and unlock)
this mutex, nobody else (including "post-release) can play with ->owner.

But given that Thomas fixed rt_mutex, I think this all doesn't matter. And
I obviously like your last patch which moves boost_mtx into rcu_node ;)

> Now maybe this ends up being safe, but it sure feels like an accident
> waiting to happen.  Some bright developer comes up with a super-fast
> handoff,

Yes, initially I thought the same, but then I changed my mind. rt kernel
uses rt_mutex instead of spinlock_t and this means that rt_mutex_unlock()
must be atomic just as spin_unlock().

> o	We -don't- hold ->lock when releasing the rt_mutex, but that
> 	should be OK: The owner is releasing it, and it is going to
> 	not-owned, so no other task can possibly see ownership moving
> 	to/from them.

Yes. I have a very minor here, I'll reply to the last version.

Oleg.

