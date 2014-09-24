Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaIXM3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:29:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51742 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaIXM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:28:59 -0400
Message-ID: <5422B8F0.9060803@ti.com>
Date: Wed, 24 Sep 2014 15:28:32 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@karo-electronics.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Fix warning when HW interrupts are rescheduled
 by the softirq tasklet
References: <1410251533-4990-1-git-send-email-LW@KARO-electronics.de>	<CACRpkdbTXtx+EU4Dw1fxeThRUG4s5XvcJnAJ9PJd8i4KKGC65A@mail.gmail.com>	<5421670D.10200@ti.com> <CACRpkdYCsdMcJY7Y0gK4_zPxiWRFKkzi2TaZUi1Vn7Kp0Cbgzg@mail.gmail.com>
In-Reply-To: <CACRpkdYCsdMcJY7Y0gK4_zPxiWRFKkzi2TaZUi1Vn7Kp0Cbgzg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 02:17 PM, Linus Walleij wrote:
> On Tue, Sep 23, 2014 at 2:26 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 09/23/2014 03:04 PM, Linus Walleij wrote:
>>> On Tue, Sep 9, 2014 at 10:32 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> 
>>>> @@ -567,6 +568,17 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>>>>                                   "could not connect irqchip to gpiochip\n");
>>>>                           return ret;
>>>>                   }
>>>> +
>>>> +               for (i = 0; i < NBANK(chip); i++) {
>>>> +                       int j;
>>>> +
>>>> +                       for (j = 0; j < BANK_SZ; j++) {
>>>> +                               int gpio = gpio_chip->base + i * BANK_SZ + j;
>>>> +                               int irq = gpio_to_irq(gpio);
>>>> +
>>>> +                               irq_set_parent(irq, client->irq);
>>>> +                       }
>>>> +               }
>>>
>>> While this is fixing the problem, but isn't the right fix to patch
>>> the function gpiochip_irq_map() in gpiolib.c to call
>>> irq_set_parent() for each IRQ as it gets mapped?
>>>
>>> This driver is using the gpiolib irqchip helpers...
>>>
>>> Then you fix not just this driver but all drivers, plus the complex
>>> loop and calls to gpio_to_irq() etc goes away.
>>
>> The problem here is that:
>> - we don't know parent IRQ number inside gpiolib irqchip;
>> - there can be more then one Parent IRQ per GPIO chip
> 
> We could for the simple case:
> 
> void gpiochip_set_chained_irqchip(struct gpio_chip *gpiochip,
>                    struct irq_chip *irqchip,
>                    int parent_irq,
>                    irq_flow_handler_t parent_handler)
> 
> Note parent_irq.
> 
> Just add a field for parent_irq in struct gpio_chip so the
> mapping function has this around.
> 
> But the second case with multiple parents is a valid
> counterargument, gpiolib irqchip helpers
> is just for the simple case of a cascaded IRQ off a single
> parent, not for complex scenarios.
> 
> So PCA cannot use gpiochip_set_chained_irqchip()?

Yes. It can't - pca is i2c device.

> 
> Anyway I feel I should fix this as per above for all
> chips using that function, right?

Pls note, the gpiochip_irqchip_add() is called before
gpiochip_set_chained_irqchip() in all places now.

Also seems, we should assume that gpiochip_set_chained_irqchip() can be called 
few times and it could be unsafe to use it for storing parent_irq.

So maybe it would be enough to just adding field for parent_irq
in struct gpio_chip + fix for gpiochip_irq_map() to re-use it
(to fix simple cases :).

regards,
-grygorii
 
