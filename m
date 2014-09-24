Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIXLRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:17:16 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39538 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIXLRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <5421670D.10200@ti.com>
References: <1410251533-4990-1-git-send-email-LW@KARO-electronics.de>
	<CACRpkdbTXtx+EU4Dw1fxeThRUG4s5XvcJnAJ9PJd8i4KKGC65A@mail.gmail.com>
	<5421670D.10200@ti.com>
Date: Wed, 24 Sep 2014 13:17:12 +0200
Message-ID: <CACRpkdYCsdMcJY7Y0gK4_zPxiWRFKkzi2TaZUi1Vn7Kp0Cbgzg@mail.gmail.com>
Subject: Re: [PATCH] gpio: pca953x: Fix warning when HW interrupts are
 rescheduled by the softirq tasklet
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 2:26 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 09/23/2014 03:04 PM, Linus Walleij wrote:
>> On Tue, Sep 9, 2014 at 10:32 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:

>>> @@ -567,6 +568,17 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>>>                                  "could not connect irqchip to gpiochip\n");
>>>                          return ret;
>>>                  }
>>> +
>>> +               for (i = 0; i < NBANK(chip); i++) {
>>> +                       int j;
>>> +
>>> +                       for (j = 0; j < BANK_SZ; j++) {
>>> +                               int gpio = gpio_chip->base + i * BANK_SZ + j;
>>> +                               int irq = gpio_to_irq(gpio);
>>> +
>>> +                               irq_set_parent(irq, client->irq);
>>> +                       }
>>> +               }
>>
>> While this is fixing the problem, but isn't the right fix to patch
>> the function gpiochip_irq_map() in gpiolib.c to call
>> irq_set_parent() for each IRQ as it gets mapped?
>>
>> This driver is using the gpiolib irqchip helpers...
>>
>> Then you fix not just this driver but all drivers, plus the complex
>> loop and calls to gpio_to_irq() etc goes away.
>
> The problem here is that:
> - we don't know parent IRQ number inside gpiolib irqchip;
> - there can be more then one Parent IRQ per GPIO chip

We could for the simple case:

void gpiochip_set_chained_irqchip(struct gpio_chip *gpiochip,
                  struct irq_chip *irqchip,
                  int parent_irq,
                  irq_flow_handler_t parent_handler)

Note parent_irq.

Just add a field for parent_irq in struct gpio_chip so the
mapping function has this around.

But the second case with multiple parents is a valid
counterargument, gpiolib irqchip helpers
is just for the simple case of a cascaded IRQ off a single
parent, not for complex scenarios.

So PCA cannot use gpiochip_set_chained_irqchip()?

Anyway I feel I should fix this as per above for all
chips using that function, right?

Yours,
Linus Walleij
