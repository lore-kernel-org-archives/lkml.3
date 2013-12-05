Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3LEJdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:33:47 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63137 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LEJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:33:43 -0500
Date: Thu, 5 Dec 2013 10:33:34 +0100
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
Message-ID: <20131205093334.GA16749@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> + (*) The compiler is within its rights to reorder memory accesses unless
> +     you tell it not to.  For example, consider the following interaction
> +     between process-level code and an interrupt handler:
> +
> +	void process_level(void)
> +	{
> +		msg = get_message();
> +		flag = true;
> +	}
> +
> +	void interrupt_handler(void)
> +	{
> +		if (flag)
> +			process_message(msg);
> +	}
> +
> +     There is nothing to prevent the the compiler from transforming
> +     process_level() to the following, in fact, this might well be a
> +     win for single-threaded code:
> +
> +	void process_level(void)
> +	{
> +		flag = true;
> +		msg = get_message();
> +	}
> +
> +     If the interrupt occurs between these two statement, then
> +     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
> +     to prevent this as follows:
> +
> +	void process_level(void)
> +	{
> +		ACCESS_ONCE(msg) = get_message();
> +		ACCESS_ONCE(flag) = true;
> +	}
> +
> +	void interrupt_handler(void)
> +	{
> +		if (ACCESS_ONCE(flag))
> +			process_message(ACCESS_ONCE(msg));
> +	}

Technically, if the interrupt handler is the innermost context, the 
ACCESS_ONCE() is not needed in the interrupt_handler() code.

Since for the vast majority of Linux code IRQ handlers are the most 
atomic contexts (very few drivers deal with NMIs) I suspect we should 
either remove that ACCESS_ONCE() from the example or add a comment 
explaining that in many cases those are superfluous?

> + (*) For aligned memory locations whose size allows them to be accessed
> +     with a single memory-reference instruction, prevents "load tearing"
> +     and "store tearing," in which a single large access is replaced by
> +     multiple smaller accesses.  For example, given an architecture having
> +     16-bit store instructions with 7-bit immediate fields, the compiler
> +     might be tempted to use two 16-bit store-immediate instructions to
> +     implement the following 32-bit store:
> +
> +	p = 0x00010002;
> +
> +     Please note that GCC really does use this sort of optimization,
> +     which is not surprising given that it would likely take more
> +     than two instructions to build the constant and then store it.
> +     This optimization can therefore be a win in single-threaded code.
> +     In fact, a recent bug (since fixed) caused GCC to incorrectly use
> +     this optimization in a volatile store.  In the absence of such bugs,
> +     use of ACCESS_ONCE() prevents store tearing:
> +
> +	ACCESS_ONCE(p) = 0x00010002;

I suspect the last sentence should read:

> +                                             In the absence of such bugs,
> +     use of ACCESS_ONCE() prevents store tearing in this example:
> +
> +	ACCESS_ONCE(p) = 0x00010002;

Otherwise it could be read as a more generic statement (leaving out 
'load tearing')?

Thanks,

	Ingo
