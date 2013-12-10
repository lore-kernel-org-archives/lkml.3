Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3LJRoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:44:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33333 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3LJRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:44:06 -0500
Date: Tue, 10 Dec 2013 09:44:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131210174400.GW4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205132101.45c56f93@lwn.net>
 <20131205214406.GY15492@linux.vnet.ibm.com>
 <20131210152006.GD873@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210152006.GD873@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121017-8236-0000-0000-000004C15945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:20:06PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > [...]
> > > 
> > > > + (*) The compiler is within its rights to reorder memory accesses unless
> > > > +     you tell it not to.  For example, consider the following interaction
> > > > +     between process-level code and an interrupt handler:
> > > > +
> > > > +	void process_level(void)
> > > > +	{
> > > > +		msg = get_message();
> > > > +		flag = true;
> > > > +	}
> > > > +
> > > > +	void interrupt_handler(void)
> > > > +	{
> > > > +		if (flag)
> > > > +			process_message(msg);
> > > > +	}
> > > > +
> > > > +     There is nothing to prevent the the compiler from transforming
> > > > +     process_level() to the following, in fact, this might well be a
> > > > +     win for single-threaded code:
> > > > +
> > > > +	void process_level(void)
> > > > +	{
> > > > +		flag = true;
> > > > +		msg = get_message();
> > > > +	}
> > > > +
> > > > +     If the interrupt occurs between these two statement, then
> > > > +     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
> > > > +     to prevent this as follows:
> > > > +
> > > > +	void process_level(void)
> > > > +	{
> > > > +		ACCESS_ONCE(msg) = get_message();
> > > > +		ACCESS_ONCE(flag) = true;
> > > > +	}
> > > > +
> > > > +	void interrupt_handler(void)
> > > > +	{
> > > > +		if (ACCESS_ONCE(flag))
> > > > +			process_message(ACCESS_ONCE(msg));
> > > > +	}
> > > 
> > > Looking at this, I find myself wondering why you couldn't just put a
> > > barrier() between the two statements in process_level()?  ACCESS_ONCE()
> > > seems like a heavy hammer to just avoid reordering of two assignments.
> > > What am I missing, and what could be added here to keep the other folks as
> > > dense as me from missing the same thing?
> > 
> > You could use barrier() from an ordering viewpoint.  However, 
> > ACCESS_ONCE() is often lighter weight than barrier().  ACCESS_ONCE() 
> > affects only that one access, while barrier() forces the compiler to 
> > forget pretty much anything it previously gleaned from any region of 
> > memory, including private locations that no one else touches.
> > 
> > I am adding a sentence saying that pure ordering can be provided by 
> > barrier(), though often at higher cost.
> 
> I suspect a related question would be, is the compiler allowed to 
> reorder:
> 
> 
> 	x = ACCESS_ONCE(a);
> 	y = ACCESS_ONCE(b);
> 
> ?
> 
> This wording:
> 
> + [...] Howevever, ACCESS_ONCE() can be thought of as a weak form

And I guess I should fix the "Howevever" as well.  Or make up a meaning
for it, this being English and all...

> +for barrier() that affects only the specific accesses flagged by the
> +ACCESS_ONCE().
> 
> Does not seem to be obvious enough to me - does it affect accesses to 
> the variables referenced (but still allows accesses to separate 
> variables reordered), or does it affect compiler-ordering of all 
> ACCESS_ONCE() instances, instructing the compiler to preserve program 
> order?

I cover this in the bullet item about reordering memory accesses:

 (*) The compiler is within its rights to reorder memory accesses unless
     you tell it not to.  For example, consider the following interaction
     between process-level code and an interrupt handler:

	void process_level(void)
	{
		msg = get_message();
		flag = true;
	}

	void interrupt_handler(void)
	{
		if (flag)
			process_message(msg);
	}

     There is nothing to prevent the the compiler from transforming
     process_level() to the following, in fact, this might well be a
     win for single-threaded code:

	void process_level(void)
	{
		flag = true;
		msg = get_message();
	}

     If the interrupt occurs between these two statement, then
     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
     to prevent this as follows:

	void process_level(void)
	{
		ACCESS_ONCE(msg) = get_message();
		ACCESS_ONCE(flag) = true;
	}

	void interrupt_handler(void)
	{
		if (ACCESS_ONCE(flag))
			process_message(ACCESS_ONCE(msg));
	}

     Note that the ACCESS_ONCE() wrappers in interrupt_handler()
     are needed if this interrupt handler can itself be interrupted
     by something that also accesses 'flag' and 'msg', for example,
     a nested interrupt or an NMI.  Otherwise, ACCESS_ONCE() is not
     needed in interrupt_handler() other than for documentation purposes.
     (Note also that nested interrupts do not typically occur in modern
     Linux kernels, in fact, if an interrupt handler returns with
     interrupts enabled, you will get a WARN_ONCE() splat.)

     This effect could also be achieved using barrier(), but ACCESS_ONCE()
     is more selective:  With ACCESS_ONCE(), the compiler need only forget
     the contents of the indicated memory located, while with barrier()
     the compiler must discard the value of all memory locations that
     it has currented cached in any machine registers.

Does that cover it?

> Also, it's not clear what happens if non-ACCESS_ONCE() access to a 
> variable is mixed with ACCESS_ONCE() access.

Different versions of the standard say different things here, and the
committee seems quite reluctant to tighten up volatile accesses.  I
believe that the best approach is to say that the compiler is free to
order ACCESS_ONCE() with non-ACCESS_ONCE() code.  How about the
following?

	You should assume that the compiler can move ACCESS_ONCE()
	past code not containing ACCESS_ONCE(), barrier(), or similar
	primitives.

							Thanx, Paul

