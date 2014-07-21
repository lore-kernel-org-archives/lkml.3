Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaGUQSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:18:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbaGUQSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:18:30 -0400
Date: Mon, 21 Jul 2014 18:18:28 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140721161828.GH20751@pathway.suse.cz>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
 <20140716124356.398e21f4@gandalf.local.home>
 <20140718153443.GC6774@pathway.suse.cz>
 <20140721144324.GG20751@pathway.suse.cz>
 <20140721154317.GS8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140721154317.GS8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-07-21 08:43:17, Paul E. McKenney wrote:
> On Mon, Jul 21, 2014 at 04:43:24PM +0200, Petr Mládek wrote:
> 
> IIRC, deadlock in the case where two CPUs attempt to invoke
> smp_call_function_single() at each other, but both have
> interrupts disabled.  It might be possible to avoid this by telling
> smp_call_function_single() not to wait for a response, but this often
> just re-introduces the deadlock at a higher level.

I thought that IPI used NMI and thus could not be blocked if the
called function was reasonable. Note that ring_buffer_swap_cpu() does not take
any lock and can't block anywhere. I am probably too optimistic here.


> > Any pointers or ideas are welcome.
> 
> Not immediately.  Mark Batty (mark.batty@cl.cam.ac.uk) has come up with
> cute ring-buffer tricks in the past, but would need a clear statement of
> the problem.  I would be happy to bring him into the discussion if it
> would help.

In short. We have two operations: writing and swap. They "block" each
other by setting the variables "committing" and "record_disabled".
It is not a real block. The other operation is "nop" when the other
one is in the critical section.

We want to keep writing fast and avoid memory barriers there. Writing
works with per-CPU buffer. It would help when also the swap happens
on the same CPU.

More detailed description of the current race can be found at
https://lkml.org/lkml/2014/7/16/178


> And yes, my knee-jerk reaction of suggesting RCU runs into the problem
> that it is not so good to invoke synchronize_rcu() with interrupts
> disabled.  Might be able to use call_rcu(), but if that worked, then
> just telling smp_call_function_single() not to wait would probably
> be a lot simpler.

I am still not sure if it really has to be called with IRQs disabled.

BTW: I have just got another idea. If we store pointer to the used
cpu_buffer into struct ring_buffer_event, it might be possible
to keep the write operation consistent even when the cpu buffers
are switched.


Best Regards,
Petr
