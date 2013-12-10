Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3LJS2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:28:08 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58979 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3LJS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:28:05 -0500
Date: Tue, 10 Dec 2013 19:28:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131210182800.GA20770@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205132101.45c56f93@lwn.net>
 <20131205214406.GY15492@linux.vnet.ibm.com>
 <20131210152006.GD873@gmail.com>
 <20131210174400.GW4208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210174400.GW4208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > +for barrier() that affects only the specific accesses flagged by the
> > +ACCESS_ONCE().
> > 
> > Does not seem to be obvious enough to me - does it affect accesses 
> > to the variables referenced (but still allows accesses to separate 
> > variables reordered), or does it affect compiler-ordering of all 
> > ACCESS_ONCE() instances, instructing the compiler to preserve 
> > program order?
> 
> I cover this in the bullet item about reordering memory accesses:
> 
>  (*) The compiler is within its rights to reorder memory accesses unless
>      you tell it not to.  For example, consider the following interaction
>      between process-level code and an interrupt handler:
> 
> 	void process_level(void)
> 	{
> 		msg = get_message();
> 		flag = true;
> 	}
> 
> 	void interrupt_handler(void)
> 	{
> 		if (flag)
> 			process_message(msg);
> 	}
> 
>      There is nothing to prevent the the compiler from transforming
>      process_level() to the following, in fact, this might well be a
>      win for single-threaded code:
> 
> 	void process_level(void)
> 	{
> 		flag = true;
> 		msg = get_message();
> 	}
> 
>      If the interrupt occurs between these two statement, then
>      interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
>      to prevent this as follows:
> 
> 	void process_level(void)
> 	{
> 		ACCESS_ONCE(msg) = get_message();
> 		ACCESS_ONCE(flag) = true;
> 	}
> 
> 	void interrupt_handler(void)
> 	{
> 		if (ACCESS_ONCE(flag))
> 			process_message(ACCESS_ONCE(msg));
> 	}
> 
>      Note that the ACCESS_ONCE() wrappers in interrupt_handler()
>      are needed if this interrupt handler can itself be interrupted
>      by something that also accesses 'flag' and 'msg', for example,
>      a nested interrupt or an NMI.  Otherwise, ACCESS_ONCE() is not
>      needed in interrupt_handler() other than for documentation purposes.
>      (Note also that nested interrupts do not typically occur in modern
>      Linux kernels, in fact, if an interrupt handler returns with
>      interrupts enabled, you will get a WARN_ONCE() splat.)
> 
>      This effect could also be achieved using barrier(), but ACCESS_ONCE()
>      is more selective:  With ACCESS_ONCE(), the compiler need only forget
>      the contents of the indicated memory located, while with barrier()
>      the compiler must discard the value of all memory locations that
>      it has currented cached in any machine registers.
> 
> Does that cover it?

btw.:

  s/indicated memory located/
    indicated memory location

?

So, what I don't see this statement cover (and I might be dense about 
it!) is whether two ACCESS_ONCE() macros referring to different 
variables are allowed to be reordered with each other.

If the compiler reorders:

	ACCESS_ONCE(x);
	ACCESS_ONCE(y);

to:

	ACCESS_ONCE(y);
	ACCESS_ONCE(x);

then AFAICS it still meets the "compiler need only forget the contents 
of the indicated memory located" requirement that you listed, right?

[ I have a good excuse for asking this: after a long day my IQ dropped 
  by 50 points and all that! :-) ]

Thanks,

	Ingo
