Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaDHNUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:20:11 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46638 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaDHNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140325211708.GA31203@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
	<1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
	<CANk1AXTjuBWa_DdKaV2dCPjhbKRHE9bR2uHyuoCYtt_-zk7EoQ@mail.gmail.com>
	<532D83F1.5070001@linutronix.de>
	<CACRpkdYxeieES5Y5tbCRfSe=Cnj2QsoU5KvSPZ99XsJ9AUrEmw@mail.gmail.com>
	<20140325211708.GA31203@linutronix.de>
Date: Tue, 8 Apr 2014 15:20:05 +0200
Message-ID: <CACRpkdbdQHpv8gcgd+_5yp-3axeBiDFcoZS15DcJJTxey66g8w@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: delicious quinoa <delicious.quinoa@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:17 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Linus Walleij | 2014-03-25 21:43:49 [+0100]:
>
>>> I looked at
>>> those two links and you quote gpio_to_irq() which is not required.
>>
>>In a *lot* of drivers it is implicitly required that gpio_to_irq()
>>is called first because they only call irq_create_mapping()
>>there. (And not in subsequent interrupt handlers etc.)
>
> so
>
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -68,7 +68,7 @@ static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>                                                     dwapb_gpio_port, bgc);
>         struct dwapb_gpio *gpio = port->gpio;
>
> -       return irq_find_mapping(gpio->domain, offset);
> +       return irq_create_mapping(gpio->domain, offset);
>  }
>
>  static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
>
> would fix the problem then.

No.

This only gets called if some GPIO consumer decides to call
gpio_to_irq() to find out the interrupt number before using the
interrupt.

There is no requirement that consumers do that!

It is perfectly legal for a GPIO irq comsumer to just use
some hard-coded IRQ number from a board file or similar,
or to just use an IRQ from a DT or ACPI entity without any
such translation.

So the mappings must be created in probe().

Yours,
Linus Walleij
