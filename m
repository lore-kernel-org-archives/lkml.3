Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaD2PLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:11:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38060 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaD2PLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:11:05 -0400
Date: Tue, 29 Apr 2014 08:11:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
Message-ID: <20140429151100.GC8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
 <20140428231002.GO4430@linux.vnet.ibm.com>
 <1398732649.2970.89.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398732649.2970.89.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042915-1542-0000-0000-0000016DB30F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:50:49PM -0700, Tim Chen wrote:
> On Mon, 2014-04-28 at 16:10 -0700, Paul E. McKenney wrote:
> 
> > > +#ifdef CONFIG_SMP
> > > +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> > > +{
> > > +	int retval;
> > > +	struct task_struct *owner;
> > > +
> > > +	rcu_read_lock();
> > > +	owner = ACCESS_ONCE(sem->owner);
> > 
> > OK, I'll bite...
> > 
> > Why ACCESS_ONCE() instead of rcu_dereference()?
> 
> We're using it as a speculative check on the sem->owner to see
> if the owner is running on the cpu.  The rcu_read_lock
> is used for ensuring that the owner->on_cpu memory is
> still valid.

OK, so if we read complete garbage, all that happens is that we
lose a bit of performance?  If so, I am OK with it as long as there
is a comment (which Davidlohr suggested later in this thread).

							Thanx, Paul

> > (My first question was "where is the update side", but this is covered
> > by task_struct allocation and deallocation.)
> 
> Tim
> 

