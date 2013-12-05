Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3LEUVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:21:06 -0500
Received: from tex.lwn.net ([70.33.254.29]:40428 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab3LEUVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:21:03 -0500
Date: Thu, 5 Dec 2013 13:21:01 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131205132101.45c56f93@lwn.net>
In-Reply-To: <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
	<1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Dec 2013 14:46:59 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The situations in which ACCESS_ONCE() is required are not well documented,
> so this commit adds some verbiage to memory-barriers.txt.

[...]

> +     But please note that the compiler is also closely watching what you
> +     do with the value after the ACCESS_ONCE().  For example, suppose you
> +     do the following and MAX is a preprocessor macro with the value 1:
> +
> +	for ((tmp = ACCESS_ONCE(a)) % MAX)
> +		do_something_with(tmp);

That sure looks like it was meant to be "while" instead of "for"?

[...]

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

Looking at this, I find myself wondering why you couldn't just put a
barrier() between the two statements in process_level()?  ACCESS_ONCE()
seems like a heavy hammer to just avoid reordering of two assignments.
What am I missing, and what could be added here to keep the other folks as
dense as me from missing the same thing?

Thanks,

jon
