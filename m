Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaLQINp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:13:45 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49042 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaLQINm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLSq8w_9LoRNni1jiqtY=PjLn7xu2xFxvgSg4Ay=PHjDw@mail.gmail.com>
References: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
	<CAAVeFuLSq8w_9LoRNni1jiqtY=PjLn7xu2xFxvgSg4Ay=PHjDw@mail.gmail.com>
Date: Wed, 17 Dec 2014 09:13:39 +0100
X-Google-Sender-Auth: Ad0hBWhLcwVymUSnAqpjra3pZuY
Message-ID: <CAMuHMdU1dmD5zTNmBEgCuJLY2LkZMKATVJ8RvUOv-gtzQGpdTw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pcf857x: Propagate wake-up setting to parent
 irq controller
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-SH <linux-sh@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Wed, Dec 17, 2014 at 7:01 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Dec 10, 2014 at 10:36 PM, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>> The pcf857x GPIO and interrupt controller uses dummy_irq_chip, which
>> does not implement irq_chip.irq_set_wake() and does not set
>> IRQCHIP_SKIP_SET_WAKE.
>>
>> This causes two s2ram issues if wake-up is enabled for the pcf857x GPIO
>> pins:
>>   1. During resume from s2ram, the following warning is printed:
>>
>>      WARNING: CPU: 0 PID: 1046 at kernel/irq/manage.c:537 irq_set_irq_wake+0x9c/0xf8()
>>      Unbalanced IRQ 113 wake disable
>>
>>   2. Wake-up through the pcf857x GPIO pins may fail, as the parent
>>      interrupt controller may be suspended.
>>
>> Migrate the pcf857x GPIO and interrupt controller from dummy_irq_chip to
>> its own irq_chip. This irq chip implements irq_chip.irq_set_wake() to
>> propagate its wake-up setting to the parent interrupt controller.
>>
>> This fixes wake-up through gpio-keys on sh73a0/kzm9g, where the pcf857x
>> interrupt is cascaded to irq-renesas-intc-irqpin, and the latter must
>> not be suspended when wake-up is enabled.
>
> I am not very familiar with the IRQ subsystem, but wouldn't it be
> possible (and better) to try and fix/adapt dummy_irq_chip so it
> displays the right behavior? At least your first point looks like an
> issue with it.

I fixed dummy_irq_chip in the second patch of the series ("[PATCH 2/2] [RFC]
genirq: Set IRQCHIP_SKIP_SET_WAKE for no_irq_chip and dummy_irq_chip:).
But please note that that would fix the warning (issue 1) only.

Pcf857x still needs to propagate the wake-up setting to the parent interrupt
controller to avoid the parent from being suspended if wake-up is enabled
(issue 2). That cannot be done in dummy_irq_chip, as dummy_irq_chip doesn't
know it is cascaded to a parent interrupt controller, nor about the interrupt
number that is used for the cascade. That information is specific to the child
driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
