Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3CLNWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:22:43 -0400
Received: from quarantine.alumni.tu-berlin.de ([130.149.4.13]:62031 "EHLO
	mailbox.alumni.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab3CLNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:22:42 -0400
X-tubIT-Incoming-IP: 80.218.149.249
Message-ID: <513F2C1E.6080500@slac.stanford.edu>
Date: Tue, 12 Mar 2013 14:22:38 +0100
From: Till Straumann <strauman@slac.stanford.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
References: <alpine.LFD.2.02.1303071450130.22263@ionos> <5139F9E8.8090402@slac.stanford.edu> <alpine.LFD.2.02.1303081704230.22263@ionos> <513A1D88.5060606@slac.stanford.edu> <alpine.LFD.2.02.1303082032390.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303082032390.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. Thanks for the explanation.

However - even if not strictly necessary - wouldn't it
be simpler and the code easier to understand if
spurious interrupt detection just always would use the
deferred algorithm?
  - after handling by whatever scheme (hard, threaded, nested)
    the counter is incremented
  - the next hard IRQ calls note_interrupt() which checks
    if the counter has changed since last time.

Just my 2 cents...

Thanks again
- Till

On 03/08/2013 08:41 PM, Thomas Gleixner wrote:
> On Fri, 8 Mar 2013, Till Straumann wrote:
>> On 03/08/2013 05:12 PM, Thomas Gleixner wrote:
>>> On Fri, 8 Mar 2013, Till Straumann wrote:
>>>    
>>>> 1) I'm not sure adding the SPURIOUS_DEFERRED flag into
>>>>      threads_handled_last is OK - what happens if the atomic_t counter
>>>>      can hold more than 31 bits? In this case, when thread handlers
>>>>      increment the counter there is interference with the flag.  If
>>>>      this is not harmful then it is at least ugly.
>>> atomic_t is going to stay 32 bit otherwise we'll have more horrible
>>> problems than that one.
>> I know. But this means that when the counter overflows 31 bits (2^31 - 1)
>> then it spills into the SPURIOUS_DEFERRED flag, right?
> Gah, yes. /me should stop doing overoptimizations :)
>   
>>>> 2) note_interrupt is also called from irq/chip.c:handle_nested_irq() and I
>>>> believe
>>>>      this routine would also need to increment the 'threads_handled'
>>>> counter
>>>> rather
>>>>      than calling note_interrupt.
>>> That's a different issue. The nested_irq handler is for interrupts
>>> which are demultiplexed by a primary threaded handler. That interrupt
>>> is never handled in hard interrupt context. It's always called from
>>> the context of the demultiplxing thread.
>> So you are saying that there 'handle_nested_irq()' can never be executed
>> from more than one thread for a single interrupt?
>>
>> I find, however, that e.g., the gpio-sx150x.c driver calls
>>
>> request_threaded_irq() with IRQF_SHARED set and it's thread_fn does call
>> handle_nested_irq(). It would thus be possible that multiple drivers
>> could share an interrupt and each driver would call handle_nested_irq()
>> which in-turn executes note_interrupt(). This would again raise the
>> issues we already discussed (note_interrupt() not serialized and thinking
>> that an interrupt was not handled because it was handled by a different
>> thread).
>>
>> Probably I'm missing something regarding the use of nested interrupts
>> - I would really appreciate if you could help me understand why
>> it should be OK for handle_nested_irq() to call note_interrupt().
> The thing about nested irqs is:
>
> main irq is threaded (requested by the driver for stuff like i2c)
>
> The handler of this irq reads a pending irq register in the chip and
> then invokes handle_nested_irq() for each of the pending bits.
>
> Those interrupts cannot be shared even if the driver request them as
> shared:
>
>          irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>          raw_spin_unlock_irq(&desc->lock);
>
>          action_ret = action->thread_fn(action->irq, action->dev_id);
>          if (!noirqdebug)
>                  note_interrupt(irq, desc, action_ret);
>
>          raw_spin_lock_irq(&desc->lock);
>          irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>
> So there is no loop over action->next. And even if that code would
> loop over action next, then it still would be serialized
>
> main irq is raised
>
>       -> wake thread
>
> thread runs
>
>         read pending reg()
>
>         for each pending bit {
>
>         	   handle_nested_irq();
> 		action = desc->action;
>
> 		while (action) {
> 		      action->thread_fn()
> 		      action = action->next)
> 		}
> 		note_interrupt();
>         }
>
> thread done
>
> Hope that helps. Thanks,
>
>       tglx
>
>        
>
>
>

