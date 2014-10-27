Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJ0PmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:42:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47120 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ0PmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:42:20 -0400
Message-ID: <544E67D8.3020504@arm.com>
Date: Mon, 27 Oct 2014 15:42:16 +0000
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
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410252144170.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 27 Oct 2014 15:42:17.0225 (UTC) FILETIME=[9645E790:01CFF1FC]
X-MC-Unique: 114102715421705101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for looking into this.

On 25/10/14 21:27, Thomas Gleixner wrote:
> On Sat, 25 Oct 2014, Marc Zyngier wrote:
> 
> @@ -330,6 +330,7 @@ struct irq_chip {
>         void            (*irq_mask)(struct irq_data *data);
>         void            (*irq_mask_ack)(struct irq_data *data);
>         void            (*irq_unmask)(struct irq_data *data);
> +       void            (*irq_priority_drop)(struct irq_data *data);
> 
> Lacks the docbook comment.

Yup, will add.

>> +static void mask_threaded_irq(struct irq_desc *desc)
> 
> There is only one caller for this, i.e handle_fasteoi_irq, right? So
> this should go to the other eoi handler specific helpers and have eoi
> in its name.

I was seeing it as the pendent of unmask_threaded_irq(). But reading
below, you seem to have a very different approach

>> +{
>> +	struct irq_chip *chip = desc->irq_data.chip;
>> +
>> +	/* If we can do priority drop, then masking comes for free */
>> +	if (chip->irq_priority_drop)
>> +		irq_state_set_masked(desc);
>> +	else
>> +		mask_irq(desc);
>> +}
> 
>>  void unmask_irq(struct irq_desc *desc)
>>  {
>> -	if (desc->irq_data.chip->irq_unmask) {
>> -		desc->irq_data.chip->irq_unmask(&desc->irq_data);
>> +	struct irq_chip *chip = desc->irq_data.chip;
>> +
>> +	if (chip->irq_unmask && !chip->irq_priority_drop)
>> +		chip->irq_unmask(&desc->irq_data);
> 
> I have a hard time to understand that logic. Assume the interrupt
> being masked at the hardware level after boot. Now at request_irq()
> time what is going to unmask that very interrupt? Ditto for masking
> after disable_irq(). Probably not what you really want.

Peering at the code (and assuming I'm finally awake), request_irq() uses
irq_startup() -> irq_enable() -> chip->irq_unmask().

But you're perfectly right, it breaks an independent use of
unmask_irq(), which is pretty bad.

>> +static void eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>> +{
>> +	if (chip->irq_priority_drop)
>> +		chip->irq_priority_drop(&desc->irq_data);
>> +	if (chip->irq_eoi)
>> +		chip->irq_eoi(&desc->irq_data);
>> +}
> 
> So if you are using that priority drop stuff, you need both calls even
> for the non threaded case?

Yes. This is a global property (all interrupt lines for this irqchip are
affected), so even the non-threaded case has to issue both calls.

>>  static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>>  {
>>  	if (!(desc->istate & IRQS_ONESHOT)) {
>> -		chip->irq_eoi(&desc->irq_data);
>> +		eoi_irq(desc, chip);
>>  		return;
>>  	}
>> +
>> +	if (chip->irq_priority_drop)
>> +		chip->irq_priority_drop(&desc->irq_data);
>> +
>>  	/*
>>  	 * We need to unmask in the following cases:
>>  	 * - Oneshot irq which did not wake the thread (caused by a
>> @@ -485,7 +507,8 @@ static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>>  	if (!irqd_irq_disabled(&desc->irq_data) &&
>>  	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
>>  		chip->irq_eoi(&desc->irq_data);
>> -		unmask_irq(desc);
>> +		if (!chip->irq_priority_drop)
>> +			unmask_irq(desc);
> 
> This is really completely obfuscated: Brain starts melting and
> spiraling towards some unidentified universe.

Ah! I'm glad I'm not the only one with that feeling ;-).

> Seriously, I don't think it's a good idea to bandaid this
> functionality into the existing handle_fasteoi_irq() mechanism. It's
> complex enough already.

That was the other option. I may have to duplicate (or tweak)
handle_percpu_devid_irq as well though.

> So what you really want is a separate handler for this. But aside of
> adding the drop prio callback you probably want to handle the other
> existing callbacks completely differently than for the regular mode of
> that irq controller.
> 
> Can you please explain detailed how this "priority drop" mode
> works? 

The basics of this mode are pretty simple:
- Interrupt signalled, CPU enter the GIC code
- Read the IAR register, interrupt becomes active:
  -> no other interrupt can be taken
- Run whatever interrupt handler
- Write to the EOI register:
  -> interrupt is still active, and cannot be taken again, but other
interrupts can now be taken
- Write to the DIR register:
  -> interrupt is now inactive, and can be taken again.

A few interesting things here:
- EOI (which causes priority drop) acts as a mask
- DIR (which causes deactivate) acts as unmask+EOI

To me, it looks like DIR operation is exactly what we need when running
a threaded interrupt with IRQCHIP_EOI_THREADED, saving the whole
mask/unmask that is rather slow on ARM.

With that in mind, I end up mapping mask to priority_drop_irq (write to
EOI), and unmask to eoi_irq (write to DIR). Which is admittedly an
interesting brainfuck when trying to wire it into the existing framework.

So yeah, having a different handler will make it much simpler. My main
concern is how to plug this "elegantly" into the epilogue for a threaded
interrupt (irq_finalize_oneshot).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

