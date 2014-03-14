Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaCNSme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbaCNSmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:42:32 -0400
Message-ID: <53234D78.5050901@redhat.com>
Date: Fri, 14 Mar 2014 19:42:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] irqchip: sun4i: Don't mask + unmask for the non oneshot
 case
References: <1394740202-1952-1-git-send-email-hdegoede@redhat.com> <1394740202-1952-2-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403141228290.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403141228290.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/14/2014 12:35 PM, Thomas Gleixner wrote:
> On Thu, 13 Mar 2014, Hans de Goede wrote:
> 
>> Since sun4i and sun5i are single core SOCs there is no need to mask non
>> oneshot IRQs, to achieve this we use handle_fasteoi_irq with a dummy eoi.
> 
> This is slightly wrong :)
> 
> Even on a SMP system there is no need to mask the interrupt when the
> controller works like that sunxi one. If the controller is not broken
> beyond repair then it does not deliver the same interrupt to a
> different cpu. Such a thing would always deliver it to all cores and
> those would race to grab the spinlock and mask it. I've seen such
> horror, but don't ask how that performs.
> 
> The reason why you can spare the mask/unmask dance is that the
> controller does not require any action and clears the interrupt when
> the level goes back to inactive. That happens when the device handler
> acks it at the device level.
> 
> Now there might be the case when the device reactivates the interrupt
> before the RETI. But that does not matter as we run the primary
> interrupt handlers with interrupts disabled.

Ok, I'm going to wait a bit to see if Maxime has anything to say
to this second series, and then I'll do a v2 with the commit msg
fixed.

Regards,

Hans


> 
> Thanks,
> 
> 	tglx
>  
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  drivers/irqchip/irq-sun4i.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
>> index a0ed1ea..0a71990 100644
>> --- a/drivers/irqchip/irq-sun4i.c
>> +++ b/drivers/irqchip/irq-sun4i.c
>> @@ -74,8 +74,17 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>>  	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
>>  }
>>  
>> +/*
>> + * Since sun4i and sun5i are single core SOCs there is no need to mask non
>> + * oneshot IRQs, to achieve this we use handle_fasteoi_irq with a dummy eoi.
>> + */
>> +static void sun4i_irq_dummy_eoi(struct irq_data *irqd)
>> +{
>> +}
>> +
>>  static struct irq_chip sun4i_irq_chip = {
>>  	.name		= "sun4i_irq",
>> +	.irq_eoi	= sun4i_irq_dummy_eoi,
>>  	.irq_mask	= sun4i_irq_mask,
>>  	.irq_unmask	= sun4i_irq_unmask,
>>  };
>> @@ -97,7 +106,7 @@ static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
>>  					 handle_fasteoi_irq);
>>  	else
>>  		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
>> -					 handle_level_irq);
>> +					 handle_fasteoi_irq);
>>  
>>  	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
>>  
>> -- 
>> 1.9.0
>>
>>
