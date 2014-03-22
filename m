Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaCVMhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:37:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:55044 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaCVMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:37:08 -0400
Message-ID: <532D83F1.5070001@linutronix.de>
Date: Sat, 22 Mar 2014 13:37:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: delicious quinoa <delicious.quinoa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>	<1395345324-18299-3-git-send-email-bigeasy@linutronix.de> <CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
In-Reply-To: <CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:20 PM, delicious quinoa wrote:
>> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
>> index 4d25a06b..0db0b94 100644
>> --- a/drivers/gpio/gpio-dwapb.c
>> +++ b/drivers/gpio/gpio-dwapb.c
>> @@ -263,9 +263,6 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>>         irq_set_chained_handler(irq, dwapb_irq_handler);
>>         irq_set_handler_data(irq, gpio);
>>
>> -       for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
>> -               irq_create_mapping(gpio->domain, hwirq);
>> -
>>         port->bgc.gc.to_irq = dwapb_gpio_to_irq;
>>  }
> 
> 
> Hi Sebastian,
> 
> I think this functionality has changed at some point or maybe
> everybody copied the same bad code over and over.  I see a lot of
> legacy gpio drivers calling irq_create_mapping in their to_irq()
> functions.  Linus Walleij asked me to create the mappings at probe
> time.  Please see https://lkml.org/lkml/2014/2/10/154 and the
> subsequent discussion in https://lkml.org/lkml/2014/2/24/232

Linus, I don't understand why you need the mapping upfront. I looked at
those two links and you quote gpio_to_irq() which is not required.
The mapping is created once irq_of_parse_and_map() is invoked or a
platform_device is created from the DT entry. The latter creates the
warning on my 3.13 tree:

WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171
of_device_alloc+0x164/0x168()
(of_device_alloc+0x164/0x168) from [<8029fc9c>]
(of_platform_device_create_pdata+0x30/0x9c)
(of_platform_device_create_pdata+0x30/0x9c) from [<8029fde0>]
(of_platform_bus_create+0xd8/0x294)
(of_platform_bus_create+0xd8/0x294) from [<8029fe2c>]
(of_platform_bus_create+0x124/0x294)
(of_platform_bus_create+0x124/0x294) from [<8029fff8>]
(of_platform_populate+0x5c/0x9c)
(of_platform_populate+0x5c/0x9c) from [<8048d048>]
(socfpga_cyclone5_init+0x30/0x158)
(socfpga_cyclone5_init+0x30/0x158) from [<80488820>]
(customize_machine+0x20/0x40)

because at the time the device is created (struct resources is
populated) the gpio controller isn't probed yet.

With or without the upfront mapping, the struct irq is not present in
struct resource.

> 
> Alan Tull
> aka
> delicious quinoa
> 
Sebastian
