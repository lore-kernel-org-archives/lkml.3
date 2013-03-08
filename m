Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab3CHRTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:19:09 -0500
Received: from quarantine.alumni.tu-berlin.de ([130.149.4.13]:45822 "EHLO
	mailbox.alumni.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934460Ab3CHRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:19:07 -0500
X-tubIT-Incoming-IP: 80.218.149.249
Message-ID: <513A1D88.5060606@slac.stanford.edu>
Date: Fri, 08 Mar 2013 18:19:04 +0100
From: Till Straumann <strauman@slac.stanford.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
References: <alpine.LFD.2.02.1303071450130.22263@ionos> <5139F9E8.8090402@slac.stanford.edu> <alpine.LFD.2.02.1303081704230.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303081704230.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 05:12 PM, Thomas Gleixner wrote:
> On Fri, 8 Mar 2013, Till Straumann wrote:
>   
>> 1) I'm not sure adding the SPURIOUS_DEFERRED flag into
>>     threads_handled_last is OK - what happens if the atomic_t counter
>>     can hold more than 31 bits? In this case, when thread handlers
>>     increment the counter there is interference with the flag.  If
>>     this is not harmful then it is at least ugly.
> atomic_t is going to stay 32 bit otherwise we'll have more horrible
> problems than that one.
I know. But this means that when the counter overflows 31 bits (2^31 - 1)
then it spills into the SPURIOUS_DEFERRED flag, right?
>
>>      I'm not as familiar with the code as you are but wouldn't it be
>> simpler to always defer spurious detection thus avoiding to have to
>> keep track of the state (deferral active/inactive)? I.e., if any
>> primary handler returns IRQ_HANDLED then we simply increment the
>> counter. note_interrupt() could then always compare the previous
>> count to the current count and if they are equal conclude that the
>> interrupt was not handled:
> Yeah, we could do it that way. Would probably be simpler.
>   
>>      handle_irq_event_percpu()
>>      {
>>      ...
>>        if (!noirqdebug)
>>          note_interrupt(irq, desc, retval);
>>
>>        if ( (retval & IRQ_HANDLED) )
>>          atomic_inc(&desc->threads_handled);
>>      }
>>
>>      and in 'note_interrupt()'
>>
>>        handled = atomic_read(&desc->threads_handled);
>>        if ( desc->threads_handled_last == handled ) {
>>          action_ret = IRQ_NONE;
>>        } else {
>>          action_ret = IRQ_HANDLED;
>>          desc->threads_handled_last = handled;
>>        }
>>
>>     Either way - I'm not sure what deferral does to the part of the algorithm
>>     in note_interrupt() which deals with misrouted interrupts since the
>>     'action_ret' that goes into try_misrouted_irq() is delayed by one interrupt
>>     cycle.
> That should not matter much methinks, but I'll try what explodes on
> one of my affected machines.
>   
>> 2) note_interrupt is also called from irq/chip.c:handle_nested_irq() and I
>> believe
>>     this routine would also need to increment the 'threads_handled' counter
>> rather
>>     than calling note_interrupt.
> That's a different issue. The nested_irq handler is for interrupts
> which are demultiplexed by a primary threaded handler. That interrupt
> is never handled in hard interrupt context. It's always called from
> the context of the demultiplxing thread.
So you are saying that there 'handle_nested_irq()' can never be executed
from more than one thread for a single interrupt?

I find, however, that e.g., the gpio-sx150x.c driver calls

request_threaded_irq() with IRQF_SHARED set and it's thread_fn does call
handle_nested_irq(). It would thus be possible that multiple drivers
could share an interrupt and each driver would call handle_nested_irq()
which in-turn executes note_interrupt(). This would again raise the
issues we already discussed (note_interrupt() not serialized and thinking
that an interrupt was not handled because it was handled by a different
thread).

Probably I'm missing something regarding the use of nested interrupts
- I would really appreciate if you could help me understand why
it should be OK for handle_nested_irq() to call note_interrupt().

Cheers
- Till
>
> Thanks,
>
> 	tglx
>
>   

