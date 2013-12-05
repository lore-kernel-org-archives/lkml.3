Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3LESCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:02:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:54325 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3LESCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:02:07 -0500
Date: Thu, 5 Dec 2013 10:02:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20131205180200.GT15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205093334.GA16749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205093334.GA16749@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120518-6688-0000-0000-0000043363A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:33:34AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > + (*) The compiler is within its rights to reorder memory accesses unless
> > +     you tell it not to.  For example, consider the following interaction
> > +     between process-level code and an interrupt handler:
> > +
> > +	void process_level(void)
> > +	{
> > +		msg = get_message();
> > +		flag = true;
> > +	}
> > +
> > +	void interrupt_handler(void)
> > +	{
> > +		if (flag)
> > +			process_message(msg);
> > +	}
> > +
> > +     There is nothing to prevent the the compiler from transforming
> > +     process_level() to the following, in fact, this might well be a
> > +     win for single-threaded code:
> > +
> > +	void process_level(void)
> > +	{
> > +		flag = true;
> > +		msg = get_message();
> > +	}
> > +
> > +     If the interrupt occurs between these two statement, then
> > +     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
> > +     to prevent this as follows:
> > +
> > +	void process_level(void)
> > +	{
> > +		ACCESS_ONCE(msg) = get_message();
> > +		ACCESS_ONCE(flag) = true;
> > +	}
> > +
> > +	void interrupt_handler(void)
> > +	{
> > +		if (ACCESS_ONCE(flag))
> > +			process_message(ACCESS_ONCE(msg));
> > +	}
> 
> Technically, if the interrupt handler is the innermost context, the 
> ACCESS_ONCE() is not needed in the interrupt_handler() code.
> 
> Since for the vast majority of Linux code IRQ handlers are the most 
> atomic contexts (very few drivers deal with NMIs) I suspect we should 
> either remove that ACCESS_ONCE() from the example or add a comment 
> explaining that in many cases those are superfluous?

How about the following additional paragraph?

     Note that the ACCESS_ONCE() wrappers in interrupt_handler()
     are needed if this interrupt handler can itself be interrupted
     by something that also accesses 'flag' and 'msg', for example,
     a nested interrupt or an NMI.  Otherwise, ACCESS_ONCE() is not
     needed in interrupt_handler() other than for documentation purposes.

> > + (*) For aligned memory locations whose size allows them to be accessed
> > +     with a single memory-reference instruction, prevents "load tearing"
> > +     and "store tearing," in which a single large access is replaced by
> > +     multiple smaller accesses.  For example, given an architecture having
> > +     16-bit store instructions with 7-bit immediate fields, the compiler
> > +     might be tempted to use two 16-bit store-immediate instructions to
> > +     implement the following 32-bit store:
> > +
> > +	p = 0x00010002;
> > +
> > +     Please note that GCC really does use this sort of optimization,
> > +     which is not surprising given that it would likely take more
> > +     than two instructions to build the constant and then store it.
> > +     This optimization can therefore be a win in single-threaded code.
> > +     In fact, a recent bug (since fixed) caused GCC to incorrectly use
> > +     this optimization in a volatile store.  In the absence of such bugs,
> > +     use of ACCESS_ONCE() prevents store tearing:
> > +
> > +	ACCESS_ONCE(p) = 0x00010002;
> 
> I suspect the last sentence should read:
> 
> > +                                             In the absence of such bugs,
> > +     use of ACCESS_ONCE() prevents store tearing in this example:
> > +
> > +	ACCESS_ONCE(p) = 0x00010002;
> 
> Otherwise it could be read as a more generic statement (leaving out 
> 'load tearing')?

Good point, fixed.

Indeed, I don't have a good example for load tearing.  I do have some -bad-
examples, like the following:

	struct __attribute__((__packed__)) foo {
		short a;
		int b;
		short c;
	};
	struct foo foov;
	short aa;
	int bb;
	short cc;

	...

	aa = foov.a;
	bb = foov.b;
	cc = foov.c;

A clever compiler might choose to pack aa, bb, and cc in memory, then
implement the three assignments using two 32-bit loads and two 32-bit
stores, which would result in load tearing of foov.b.

Hmmm...  Maybe I should give this example anyway, just to show that
load tearing really could occur in practice...  If nothing else, it
should be a cautionary tale for those tempted to pack their structures.
And there are quite a number of packed structures in the Linux kernel.

Sold!  I have added this example, but using a pair of struct foo variables
in order to forestall maidenly protests from those who believe that no
production-quality compiler would ever misalign variable bb.  ;-)

							Thanx, Paul

