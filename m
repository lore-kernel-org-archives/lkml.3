Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaCMPN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbaCMPNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:13:53 -0400
Message-ID: <5321CB12.3090704@redhat.com>
Date: Thu, 13 Mar 2014 16:13:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for
 the ENMI (irq 0)
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com> <1394644627-12315-5-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403131542060.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403131542060.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/13/2014 03:46 PM, Thomas Gleixner wrote:
> On Wed, 12 Mar 2014, Hans de Goede wrote:
> 
>> The ENMI needs to have the ack done *after* clearing the interrupt source,
>> otherwise we will get a spurious interrupt for each real interrupt. Switch
>> to the new handle_fasteoi_late_irq handler which gives us the desired behavior.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  drivers/irqchip/irq-sun4i.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
>> index 8a2fbee..4b1c874 100644
>> --- a/drivers/irqchip/irq-sun4i.c
>> +++ b/drivers/irqchip/irq-sun4i.c
>> @@ -77,15 +77,22 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>>  static struct irq_chip sun4i_irq_chip = {
>>  	.name		= "sun4i_irq",
>>  	.irq_ack	= sun4i_irq_ack,
>> +	.irq_eoi	= sun4i_irq_ack, /* For the ENMI */
>>  	.irq_mask	= sun4i_irq_mask,
>>  	.irq_unmask	= sun4i_irq_unmask,
>> +	.flags		= IRQCHIP_EOI_THREADED, /* Only affects the ENMI */
> 
> That's not really true. The flags affect all interrupts which share
> that chip.

Yep, I figured out as much myself too while thinking a bit more about this
this morning.

So what I'm going to do in my next version of this patch is use 2
irqchip structures for the sun4i irqchip, one to describe the special
IRQ 0 and for all the others.

> 
>>  };
>>  
>>  static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
>>  			 irq_hw_number_t hw)
>>  {
>> -	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
>> -				 handle_level_irq);
>> +	if (hw == 0) /* IRQ 0, the ENMI needs special handling */
>> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
>> +					 handle_fasteoi_late_irq);
>> +	else
>> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
>> +					 handle_level_irq);
> 
> I wonder what happens when you use the fasteoi handler for all of
> them.

As mentioned in my previous mail doing an ack (or an eio) seems to
be unnecessary for all but IRQ 0.

I do wonder if handle_level_irq is the right handle*irq function
to use in this case, since this is strictly used in the non smp
case I think that the mask / unmask done by handle_level_irq is
not necessary for non threaded handlers. So what would be the
correct handle*irq function to use in this case ?

Note the irqs are level irqs. IOW they may stay asserted while
the handler runs because of the handler and a new irq raising.

Regards,

Hans
