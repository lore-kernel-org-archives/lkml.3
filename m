Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab3CHQMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:12:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:55230 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab3CHQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:12:10 -0500
Date: Fri, 8 Mar 2013 17:12:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Till Straumann <strauman@slac.stanford.edu>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
In-Reply-To: <5139F9E8.8090402@slac.stanford.edu>
Message-ID: <alpine.LFD.2.02.1303081704230.22263@ionos>
References: <alpine.LFD.2.02.1303071450130.22263@ionos> <5139F9E8.8090402@slac.stanford.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Till Straumann wrote:
 
> 1) I'm not sure adding the SPURIOUS_DEFERRED flag into
>    threads_handled_last is OK - what happens if the atomic_t counter
>    can hold more than 31 bits? In this case, when thread handlers
>    increment the counter there is interference with the flag.  If
>    this is not harmful then it is at least ugly.

atomic_t is going to stay 32 bit otherwise we'll have more horrible
problems than that one.

>     I'm not as familiar with the code as you are but wouldn't it be
> simpler to always defer spurious detection thus avoiding to have to
> keep track of the state (deferral active/inactive)? I.e., if any
> primary handler returns IRQ_HANDLED then we simply increment the
> counter. note_interrupt() could then always compare the previous
> count to the current count and if they are equal conclude that the
> interrupt was not handled:

Yeah, we could do it that way. Would probably be simpler.
 
>     handle_irq_event_percpu()
>     {
>     ...
>       if (!noirqdebug)
>         note_interrupt(irq, desc, retval);
> 
>       if ( (retval & IRQ_HANDLED) )
>         atomic_inc(&desc->threads_handled);
>     }
> 
>     and in 'note_interrupt()'
> 
>       handled = atomic_read(&desc->threads_handled);
>       if ( desc->threads_handled_last == handled ) {
>         action_ret = IRQ_NONE;
>       } else {
>         action_ret = IRQ_HANDLED;
>         desc->threads_handled_last = handled;
>       }
> 
>    Either way - I'm not sure what deferral does to the part of the algorithm
>    in note_interrupt() which deals with misrouted interrupts since the
>    'action_ret' that goes into try_misrouted_irq() is delayed by one interrupt
>    cycle.

That should not matter much methinks, but I'll try what explodes on
one of my affected machines.
 
> 
> 2) note_interrupt is also called from irq/chip.c:handle_nested_irq() and I
> believe
>    this routine would also need to increment the 'threads_handled' counter
> rather
>    than calling note_interrupt.

That's a different issue. The nested_irq handler is for interrupts
which are demultiplexed by a primary threaded handler. That interrupt
is never handled in hard interrupt context. It's always called from
the context of the demultiplxing thread.

Thanks,

	tglx

 
