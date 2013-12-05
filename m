Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3LEJwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:52:37 -0500
Received: from mail.efficios.com ([78.47.125.74]:47118 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab3LEJwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:52:31 -0500
Date: Thu, 5 Dec 2013 09:52:31 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Oleg Nesterov <oleg@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <1352854539.80112.1386237151296.JavaMail.zimbra@efficios.com>
In-Reply-To: <20131205093334.GA16749@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com> <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com> <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com> <20131205093334.GA16749@gmail.com>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.131.58.147]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: Documentation/memory-barriers.txt: Document ACCESS_ONCE()
Thread-Index: zAaiyN81xHa/XqybOfp91cVtGmrNPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Ingo Molnar" <mingo@kernel.org>
> To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, "mathieu
> desnoyers" <mathieu.desnoyers@efficios.com>, josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
> peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
> fweisbec@gmail.com, sbw@mit.edu, "Oleg Nesterov" <oleg@redhat.com>, "Jonathan Corbet" <corbet@lwn.net>, "Rusty
> Russell" <rusty@rustcorp.com.au>
> Sent: Thursday, December 5, 2013 10:33:34 AM
> Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt: Document ACCESS_ONCE()
> 
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

It might be worthwhile to state clearly those two different use-cases:

* no nesting (e.g. process vs process), where both sides of the access
  need ACCESS_ONCE().

* nested access: the outer context needs ACCESS_ONCE(), but not the
  inner context.

We don't actually care about IRQs being the "most atomic" context, and
we should not care about NMIs in this example. Only the relative nesting
of the execution contexts accessing the data matter.

Thanks,

Mathieu

> 
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
> 
> Thanks,
> 
> 	Ingo
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
