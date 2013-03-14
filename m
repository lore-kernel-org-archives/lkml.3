Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab3CNELn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:11:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47633 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3CNELm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <11085187.4PsQNSVmtx@avalon>
References: <20130313113203.30133.49539.sendpatchset@w520>
	<20130313113213.30133.10066.sendpatchset@w520>
	<11085187.4PsQNSVmtx@avalon>
Date: Thu, 14 Mar 2013 13:11:39 +0900
Message-ID: <CANqRtoRL83r8nGVN6ngq2Sdnk-FiMiQrmx2fyLh_Pcz4_MpwBQ@mail.gmail.com>
Subject: Re: [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 10:14 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thanks for the patch.
>
> I've reviewed the result of squashing the 3 patches together, I just have one
> comment.
>
> On Wednesday 13 March 2013 20:32:13 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch is V2 of a GPIO driver for the R-Car series of
>> SoCs from Renesas. This driver is designed to be reusable
>> between multiple SoCs that share the same basic building block,
>> but so far it has only been used on R-Car H1 (r8a7779).
>>
>> Each driver instance handles 32 GPIOs with individually
>> maskable IRQs. The driver operates on a single I/O memory
>> range and the 32 GPIOs are hooked up a single interrupt.
>>
>> In the case of R-Car H1 either external IRQ pins or GPIOs
>> with interrupts can be used for on-board interupts. For
>> external IRQs 4 pins are supported, and in the case of GPIO
>> there are 202 GPIOS as 202 interrupts hooked up via 6 driver
>> instances and to the GIC and the Cortex-A9 Quad.
>>
>> At this point this driver is interfacing as a regular
>> platform device driver. In the future DT support will be
>> submitted as an incremental feature patch.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  Changes since V1:
>>  - Update based on most suggestions from review by Laurent, thanks!
>>
>>  Please note that in V2 the driver is reworked to reduce the number of
>>  lines and includes minor changes related to headers, printouts and
>>  data types. In V2 the register access order is kept the same as in V1,
>>  and to make that happen IRQCHIP_SET_TYPE_MASKED is omitted. The interface
>>  to the Linux kernel is unchanged except the use of dev_dbg() instead of
>>  pr_debug(). So from a hardware point of view V2 is a drop in replacement
>>  for V1 and there should be no additional dependencies since devm is
>>  kept as a separate patch as well. All this to make back porting easier.
>>
>>  drivers/gpio/Kconfig                    |    6
>>  drivers/gpio/Makefile                   |    1
>>  drivers/gpio/gpio-rcar.c                |  383 ++++++++++++++++++++++++++++
>>  include/linux/platform_data/gpio-rcar.h |   25 ++
>>  4 files changed, 415 insertions(+)
>
> [snip]
>
>> --- /dev/null
>> +++ work/drivers/gpio/gpio-rcar.c     2013-03-13 19:41:35.000000000 +0900
>> @@ -0,0 +1,383 @@
>> +/*
>> + * Renesas R-Car GPIO Support
>> + *
>> + *  Copyright (C) 2013 Magnus Damm
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>
> [snip]
>
>> +static int gpio_rcar_irq_domain_map(struct irq_domain *h, unsigned int
>> virq,
>> +                              irq_hw_number_t hw)
>> +{
>> +     struct gpio_rcar_priv *p = h->host_data;
>> +
>> +     dev_dbg(&p->pdev->dev, "map hw irq = %d, virq = %d\n", (int)hw, virq);
>> +
>> +     irq_set_chip_data(virq, h->host_data);
>> +     irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
>> +     set_irq_flags(virq, IRQF_VALID); /* kill me now */
>
> What is that comment about ?

I seem to have a habit of putting that comment in all IRQ code that I
write for ARM. See these threads for more info:

https://lkml.org/lkml/2013/2/19/246
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-January/008795.html

Cheers,

/ magnus
