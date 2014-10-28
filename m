Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaJ1TmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:42:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38062 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJ1Tl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:41:58 -0400
Message-ID: <544FF183.9030705@arm.com>
Date: Tue, 28 Oct 2014 19:41:55 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com> <alpine.DEB.2.11.1410272158160.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410272158160.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 28 Oct 2014 19:41:56.0004 (UTC) FILETIME=[3B1B3640:01CFF2E7]
X-MC-Unique: 114102819415503601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 15:32, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Marc Zyngier wrote:
>> On 25/10/14 21:27, Thomas Gleixner wrote:
>>> On Sat, 25 Oct 2014, Marc Zyngier wrote:
>>>> +{
>>>> +	struct irq_chip *chip = desc->irq_data.chip;
>>>> +
>>>> +	/* If we can do priority drop, then masking comes for free */
>>>> +	if (chip->irq_priority_drop)
>>>> +		irq_state_set_masked(desc);
>>>> +	else
>>>> +		mask_irq(desc);
>>>> +}
>>>
>>>>  void unmask_irq(struct irq_desc *desc)
>>>>  {
>>>> -	if (desc->irq_data.chip->irq_unmask) {
>>>> -		desc->irq_data.chip->irq_unmask(&desc->irq_data);
>>>> +	struct irq_chip *chip = desc->irq_data.chip;
>>>> +
>>>> +	if (chip->irq_unmask && !chip->irq_priority_drop)
>>>> +		chip->irq_unmask(&desc->irq_data);
>>>
>>> I have a hard time to understand that logic. Assume the interrupt
>>> being masked at the hardware level after boot. Now at request_irq()
>>> time what is going to unmask that very interrupt? Ditto for masking
>>> after disable_irq(). Probably not what you really want.
>>
>> Peering at the code (and assuming I'm finally awake), request_irq() uses
>> irq_startup() -> irq_enable() -> chip->irq_unmask().
> 
> Right. That's the default implementation.
> 
>> But you're perfectly right, it breaks an independent use of
>> unmask_irq(), which is pretty bad.
> 
> Indeed.
>  
>>>> +static void eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>>>> +{
>>>> +	if (chip->irq_priority_drop)
>>>> +		chip->irq_priority_drop(&desc->irq_data);
>>>> +	if (chip->irq_eoi)
>>>> +		chip->irq_eoi(&desc->irq_data);
>>>> +}
>>>
>>> So if you are using that priority drop stuff, you need both calls even
>>> for the non threaded case?
>>
>> Yes. This is a global property (all interrupt lines for this irqchip are
>> affected), so even the non-threaded case has to issue both calls.
> 
> Ok.
>  
>>> Can you please explain detailed how this "priority drop" mode
>>> works? 
>>
>> The basics of this mode are pretty simple:
>> - Interrupt signalled, CPU enter the GIC code
>> - Read the IAR register, interrupt becomes active:
>>   -> no other interrupt can be taken
>> - Run whatever interrupt handler
>> - Write to the EOI register:
>>   -> interrupt is still active, and cannot be taken again, but other
>> interrupts can now be taken
>> - Write to the DIR register:
>>   -> interrupt is now inactive, and can be taken again.
>>
>> A few interesting things here:
>> - EOI (which causes priority drop) acts as a mask
>> - DIR (which causes deactivate) acts as unmask+EOI
> 
> Let me make a few assumptions and correct me if I'm wrong as usual.
> 
> 1) The startup/shutdown procedure for such an interrupt is the
>    expensive mask/unmask which you want to avoid for the actual
>    handling case

Indeed.

> 2) In case of an actual interrupt the flow (ignoring locking) is:
> 
>    handle_xxx_irq()
> 
> 	mask_irq();	/* chip->irq_mask() maps to EOI */
> 
> 	if (!action || irq_disabled())
> 	   return;
> 
> 	handle_actions();
> 
> 	if (irq_threads_active() || irq_disabled())
> 	   return;
> 
> 	unmask_irq();	/* chip->irq_unmask() maps to DIR */
> 
>   So that is handle_level_irq() with the chip callbacks being:
> 
>    irq_startup  = gic_unmask
>    irq_shutdown = gic_mask
>    irq_unmask	= gic_dir
>    irq_mask	= gic_eoi

So while this works really well for the interrupt handling part, it will
break [un]mask_irq(). This is because you can only write to EOI for an
interrupt that you have ACKed just before (anything else and the GIC
state machine goes crazy). Basically, any use for EOI/DIR outside of the
interrupt context itself (hardirq or thread) is really dangerous.

If we had a flag like IRQCHIP_UNMASK_IS_STARTUP, we could distinguish
this particular case, but that's borderline ugly.

> 3) In the threaded case as seen above finalize_oneshot() will call
>    chip->unmask_irq() which maps to the DIR write and gets things
>    going again.

Yup.

> 4) In the lazy irq disable case if the interrupt fires mask_irq()
>    [EOI] is good enough to silence it.
> 
>    Though in the enable_irq() case you cannot rely on the automatic
>    resend of the interrupt when you unmask [DIR]. So we need to make
>    sure that even in the level case (dunno whether that's supported in
>    that mode) we end up calling the irq_retrigger() callback. But
>    that's rather simple to achieve with a new chip flag.

I think this one breaks for the same reason as above. And an interrupt
masked with EOI cannot easily be restarted without clearing the ACTIVE
bit (and everything becomes even more of a complete madness).

I need to think about it again.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

