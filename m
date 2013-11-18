Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3KROiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:38:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57140 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KROh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:37:58 -0500
Message-ID: <528A2565.4000802@ti.com>
Date: Mon, 18 Nov 2013 16:34:13 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 3/7] gpio: davinci: use irqdomain
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>	<1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com> <CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
In-Reply-To: <CACRpkdaJg4wqtD5xhPVrHJHxFoVwau6jidbOuQ9xFSK_6drxPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
On 11/18/2013 03:11 PM, Linus Walleij wrote:
> On Fri, Nov 8, 2013 at 11:11 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch converts the davinci gpio driver to use irqdomain
>> support.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> (...)
>> @@ -282,8 +283,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
>>          desc->irq_data.chip->irq_ack(&desc->irq_data);
>>          while (1) {
>>                  u32             status;
>> -               int             n;
>> -               int             res;
>> +               int             bit;
>
> Why is this an int? I think u8 would suffice.
>
>>                  /* now demux them to the right lowlevel handler */
>> -               n = d->irq_base;
>> -               if (irq & 1) {
>> -                       n += 16;
>> -                       status >>= 16;
>> -               }
>> -
>>                  while (status) {
>> -                       res = ffs(status);
>> -                       n += res;
>> -                       generic_handle_irq(n - 1);
>> -                       status >>= res;
>> +                       bit = __ffs(status);
>> +                       status &= ~(1 << bit);
>> +                       generic_handle_irq(irq_find_mapping(d->irq_domain,
>> +                                                           bit));
>
> This is a nice hunk of the patch.
>
> I would use <linux/bitops.h> and do:
> status &= ~BIT(bit);
>
>
>> @@ -313,10 +307,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
>>   {
>>          struct davinci_gpio_controller *d = chip2controller(chip);
>>
>> -       if (d->irq_base >= 0)
>> -               return d->irq_base + offset;
>> -       else
>> -               return -ENODEV;
>> +       return irq_create_mapping(d->irq_domain, offset);
>>   }
>
> I think we recently established that map creating cannot be done
> in gpio_to_irq* functions as that will not work properly if you request
> an IRQ from device tree without first obtaining the IRQ from the GPIO
> number with this function.

Why? Could you point on corresponding thread, pls?
Current call tree is:
irq_create_of_mapping()
|-hwirq = omain->ops->xlate()
|-irq_create_mapping(domain, hwirq)

>
> Instead call irq_create_mapping() on *all* used IRQ lines in the
> probe function and use irq_find_mapping() here too.
>
>> +       for (gpio = 0, bank = 0; gpio < ngpio; bank++, bank_irq++, gpio += 16) {
>>                  /* disabled by default, enabled only as needed */
>>                  g = gpio2regs(gpio);
>>                  writel(~0, &g->clr_falling);
>> @@ -467,14 +483,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>>                   */
>>                  irq_set_handler_data(bank_irq, &chips[gpio / 32]);
>
> So for example here you could call iurq_create_mapping();
>
> Also: please write a patch that marks the IRQ lines.
> Call gpio_lock_as_irq(*gpio_chip, offset); in the
> irqchip startup/shutdown functions. (Can be a separate
> patch.)

It seems, some misunderstanding is here. So I'd like to clarify few 
points and would be very appreciate for your comments:
1) This patch itself will work unless we switch to DT (as in the 
following patch)

2) After this patch the following object structure will be created 
during Davinci GPIO driver initialization (DA850 has 144 IRQ lines):
- gpio_chip0(0..31)
   |- irq_domain1
- gpio_chip1(32..63)
   |- irq_domain2
- gpio_chip2(64..95)
   |- irq_domain3
- gpio_chip3(96..127)
   |- irq_domain4
- gpio_chip4(128..143)
   |- irq_domain5

3) But in case of DT only one GPIO controller node will be created
Example:
gpio: gpio@1e26000 {
	compatible = "ti,dm6441-gpio";
	gpio-controller;
	reg = <0x226000 0x1000>;
	interrupt-parent = <&intc>;
	interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
		44 IRQ_TYPE_EDGE_BOTH 45 IRQ_TYPE_EDGE_BOTH
		46 IRQ_TYPE_EDGE_BOTH 47 IRQ_TYPE_EDGE_BOTH
		48 IRQ_TYPE_EDGE_BOTH 49 IRQ_TYPE_EDGE_BOTH
		50 IRQ_TYPE_EDGE_BOTH>;
	interrupt-controller;
	#interrupt-cells = <2>;
	ti,ngpio = <144>;
	ti,davinci-gpio-unbanked = <0>;
}

4) As result, to make GPIO bindings/mappings work - we'll need to 
implement .of_xlate() callback per GPIO chip, which will provide us with 
valid valid gpio_chip and offset of gpio inside chip
(It was discussed before and supposed to be done as next step).

For example, gpio_chip3 and offset=15 should be selected:
devA {
    gpios = <&gpio 111 GPIO_ACTIVE_HIGH>;
}

5) What should be done to make GPIO IRQ bindings/mappings work?

Example:
devB {
    interrupt-parent = <&gpio>;
    interrupts = <111 IRQ_TYPE_EDGE_BOTH>;
}

Should we implement one IRQ domain per all GPIO chips (per GPIO controller)?

Thanks.

Regards,
-Grygorii
