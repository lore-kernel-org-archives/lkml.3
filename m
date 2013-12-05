Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3LEKLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:11:47 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39942 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3LEKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:11:42 -0500
Date: Thu, 5 Dec 2013 11:11:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Oleg Nesterov <oleg@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131205101137.GD16749@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205093334.GA16749@gmail.com>
 <1352854539.80112.1386237151296.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352854539.80112.1386237151296.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Ingo Molnar" <mingo@kernel.org>
> > To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, "mathieu
> > desnoyers" <mathieu.desnoyers@efficios.com>, josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
> > peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
> > fweisbec@gmail.com, sbw@mit.edu, "Oleg Nesterov" <oleg@redhat.com>, "Jonathan Corbet" <corbet@lwn.net>, "Rusty
> > Russell" <rusty@rustcorp.com.au>
> > Sent: Thursday, December 5, 2013 10:33:34 AM
> > Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt: Document ACCESS_ONCE()
> > 
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
> It might be worthwhile to state clearly those two different use-cases:
> 
> * no nesting (e.g. process vs process), where both sides of the access
>   need ACCESS_ONCE().
> 
> * nested access: the outer context needs ACCESS_ONCE(), but not the
>   inner context.
> 
> We don't actually care about IRQs being the "most atomic" context, 
> and we should not care about NMIs in this example. Only the relative 
> nesting of the execution contexts accessing the data matter.

I meant 'most atomic' in the sense of no NMI context having access to 
those same shared variables, obviously.

We do actually have 'triple' nesting in Linux, NMI context code with 
non-trivial complexity that accesses variables in different code paths 
from IRQ codepaths and from process level code paths, so technically 
the original example is valid - I just think misleading to most 
readers.

Thanks,

	Ingo
