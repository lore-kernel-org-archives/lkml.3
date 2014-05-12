Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaELQ06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:26:58 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:39907 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbaELQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:26:54 -0400
Date: Mon, 12 May 2014 18:26:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Architecture support for remote irq work
 raise
Message-ID: <20140512162641.GA28033@localhost.localdomain>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
 <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
 <20140512075650.GJ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512075650.GJ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 09:56:50AM +0200, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 01:33:53AM +0200, Frederic Weisbecker wrote:
> > We are going to extend irq work to support remote queuing.
> > 
> > So lets add a cpu argument to arch_irq_work_raise(). The architectures
> > willing to support that must then provide the backend to raise irq work
> > IPIs remotely.
> > 
> > Initial support is provided for x86 and ARM since they are easily
> > extended. The other archs that overwrite arch_irq_work_raise() seem
> > to use local clock interrupts and therefore need deeper rewrite of their
> > irq work support to implement remote raising.
> > 
> 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Why not borrow the smp_call_function IPI for the remote bits? We could
> limit the 'safe from NMI' to the local works. And we validate this by
> putting a WARN_ON(in_nmi()) in irq_work_queue_on().

Right, but although I don't need it to be safe from NMI, I need it
to be callable concurrently and when irqs are disabled.

So we can't use smp_call_function_single() for that. But we can use the async
version in which case we must keep the irq work claim. But that's
about the same than smp_queue_function_single() we had previously
and we are back with our csd_lock issue.

> 
> At some later stage we could look at maybe merging the smp_function_call
> and irq_work into a single thing, where we have the irq_work interface
> as async and the smp_function_call() as sync interface.
> 
> But for now a quick 'hack' would be to call __irq_work_run() from
> generic_smp_call_function_single_interrupt().
> 
> That would leave arch_irq_work_raise() as the special NMI safe local IPI
> hook.

I don't know, calling irq_work_run() from there sounds like an overkill.

Or we can encapsulate:

struct remote_irq_work {
    struct irq_work work;
    struct call_single_data csd;
}

bool irq_work_queue_on(remote_work, cpu)
{
   if (irq_work_claim(remote_work.work))
      return false;
   remote_work.csd.func = irq_work_remote_interrupt;
   remotr_work.csd.info = work
   smp_call_function_single_async(&remote_work.csd, cpu);
}

void irq_work_remote_interrupt(void *info)
{
    struct irq_work *work = info;

    work->func(work);
}

And some tweaking to make csd_lock() out of the way. smp_call_function_single_async()
don't need it.

Or the two other solutions:

1) expand irq_work to support remote queuing. And really this hasn't added more
atomic operations nor smp barriers that the local queuing. The only complication
is that we need remote raise support from arch.

2) expand smp_call_function stuff with smp_queue_function_single(). As I did
previously. It's the same than the above irq_work_queue_on() above will need to be
conditional though.

The native remote support on irq_work sounds to me the most proper. But unfortunately
it requires support from arch that we already have with smp_function...
