Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaFJRvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:51:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:54396 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaFJRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:51:17 -0400
Date: Tue, 10 Jun 2014 19:51:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140610170716.GA7629@redhat.com>
Message-ID: <alpine.DEB.2.10.1406101948490.5170@nanos>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos> <20140610170716.GA7629@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Oleg Nesterov wrote:

> On 06/10, Thomas Gleixner wrote:
> >
> > +static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
> > +	__releases(lock->wait_lock)
> > +{
> > +	unsigned long owner, *p = (unsigned long *) &lock->owner;
> > +
> > +	owner = (unsigned long) rt_mutex_owner(lock);
> > +	clear_rt_mutex_waiters(lock);
> > +	raw_spin_unlock(&lock->wait_lock);
> > +	/*
> > +	 * If a new waiter comes in between the unlock and the cmpxchg
> > +	 * we have two situations:
> > +	 *
> > +	 * unlock(wait_lock);
> > +	 *					lock(wait_lock);
> > +	 * cmpxchg(p, owner, 0) == owner
> > +	 *					mark_rt_mutex_waiters(lock);
> > +	 *					acquire(lock);
> > +	 * or:
> > +	 *
> > +	 * unlock(wait_lock);
> > +	 *					lock(wait_lock);
> > +	 *					mark_rt_mutex_waiters(lock);
> > +	 *
> > +	 * cmpxchg(p, owner, 0) != owner
> > +	 *					enqueue_waiter();
> > +	 *					unlock(wait_lock);
> > +	 * lock(wait_lock);
> > +	 * wake waiter();
> > +	 * unlock(wait_lock);
> > +	 *					lock(wait_lock);
> > +	 *					acquire(lock);
> > +	 */
> > +	return rt_mutex_cmpxchg(p, owner, 0);
> 
> Wait, but this looks like a typo. rt_mutex_cmpxchg() needs "struct rt_mutex *",
> not "long *". It seems that you should simply kill "*p" above.

Uurgh. I had cmpxchg there first and then changed it. You're right, I
can kill the p magic. Bah, thats what you get sending out stuff just
before jumping into a car.



