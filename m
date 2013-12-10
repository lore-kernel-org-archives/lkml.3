Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3LJNY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:24:59 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63610 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3LJNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:24:55 -0500
Date: Tue, 10 Dec 2013 14:24:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131210132448.GA31366@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205093334.GA16749@gmail.com>
 <20131205180200.GT15492@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205180200.GT15492@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Dec 05, 2013 at 10:33:34AM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > + (*) The compiler is within its rights to reorder memory accesses unless
> > > +     you tell it not to.  For example, consider the following interaction
> > > +     between process-level code and an interrupt handler:
> > > +
> > > +	void process_level(void)
> > > +	{
> > > +		msg = get_message();
> > > +		flag = true;
> > > +	}
> > > +
> > > +	void interrupt_handler(void)
> > > +	{
> > > +		if (flag)
> > > +			process_message(msg);
> > > +	}
> > > +
> > > +     There is nothing to prevent the the compiler from transforming
> > > +     process_level() to the following, in fact, this might well be a
> > > +     win for single-threaded code:
> > > +
> > > +	void process_level(void)
> > > +	{
> > > +		flag = true;
> > > +		msg = get_message();
> > > +	}
> > > +
> > > +     If the interrupt occurs between these two statement, then
> > > +     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
> > > +     to prevent this as follows:
> > > +
> > > +	void process_level(void)
> > > +	{
> > > +		ACCESS_ONCE(msg) = get_message();
> > > +		ACCESS_ONCE(flag) = true;
> > > +	}
> > > +
> > > +	void interrupt_handler(void)
> > > +	{
> > > +		if (ACCESS_ONCE(flag))
> > > +			process_message(ACCESS_ONCE(msg));
> > > +	}
> > 
> > Technically, if the interrupt handler is the innermost context, the 
> > ACCESS_ONCE() is not needed in the interrupt_handler() code.
> > 
> > Since for the vast majority of Linux code IRQ handlers are the most 
> > atomic contexts (very few drivers deal with NMIs) I suspect we should 
> > either remove that ACCESS_ONCE() from the example or add a comment 
> > explaining that in many cases those are superfluous?
> 
> How about the following additional paragraph?
> 
>      Note that the ACCESS_ONCE() wrappers in interrupt_handler()
>      are needed if this interrupt handler can itself be interrupted
>      by something that also accesses 'flag' and 'msg', for example,
>      a nested interrupt or an NMI.  Otherwise, ACCESS_ONCE() is not
>      needed in interrupt_handler() other than for documentation purposes.

Sounds great to me!

Note that nested IRQs generally don't happen on modern Linux anymore, 
we run almost all hardirqs with irqs disabled and in fact have a 
warning to detect irq handlers that enable irqs:

                res = action->handler(irq, action->dev_id);
                trace_irq_handler_exit(irq, action, res);

                if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
                              irq, action->handler))
                        local_irq_disable();

Thanks,

	Ingo
