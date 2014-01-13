Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaAMXKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:10:19 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:47721 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaAMXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:10:17 -0500
Date: Mon, 13 Jan 2014 14:34:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg
 of __lock_acquire()
Message-ID: <20140113223407.GP10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
 <20140112094041.GB31809@gmail.com>
 <20140112174532.GA12147@redhat.com>
 <20140112174554.GB12147@redhat.com>
 <20140113170609.GA9873@redhat.com>
 <20140113172833.GT31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113172833.GT31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011323-7164-0000-0000-000005159E67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 06:28:33PM +0100, Peter Zijlstra wrote:
> On Mon, Jan 13, 2014 at 06:06:09PM +0100, Oleg Nesterov wrote:
> > On 01/12, Oleg Nesterov wrote:
> > >
> > > The "int check" argument of lock_acquire() and held_lock->check
> > > are misleading and unneeded. This is only used as a boolean, 2
> > > denotes "true", everything else is "false". And this boolean is
> > > always equal to prove_locking.
> > >
> > > The only exception is __lockdep_no_validate__ which should make
> > > this condition "false" in validate_chain().
> > 
> > And I missed mark_irqflags(),
> > 
> > > @@ -3136,7 +3130,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> > >  	hlock->holdtime_stamp = lockstat_clock();
> > >  #endif
> > >
> > > -	if (check == 2 && !mark_irqflags(curr, hlock))
> > > +	if (prove_locking && !mark_irqflags(curr, hlock))
> > >  		return 0;
> > 
> > This change is not right, at least it is not equivalent.
> > 
> > And I just realized that rcu_lock_acquire() does lock_acquire(check => 1).
> > Probably we can mark rcu_lock_map's as __lockdep_no_validate__.
> 
> Can't, RCU needs its own classes. Otherwise it cannot tell which version
> of the RCU read lock its holding at just that moment.

Just confirming this.  RCU uses this to detected mismatches between
the rcu_read_lock() group and the rcu_dereference() group.

							Thanx, Paul

> > Anything else I missed?
> 
> Nothing springs to mind, but then, I totally missed the RCU thing too.
> 
> At the very least we can reduce check to a single bit.
> 

