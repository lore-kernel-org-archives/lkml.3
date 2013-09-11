Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3IKQPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:15:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38658 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3IKQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:15:13 -0400
Message-ID: <523096FE.8080901@collabora.co.uk>
Date: Wed, 11 Sep 2013 18:14:54 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de>
In-Reply-To: <52308C91.2000105@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:30 PM, Alexander Holler wrote:
> Am 22.08.2013 00:02, schrieb Linus Walleij:
>> On Tue, Aug 20, 2013 at 12:04 AM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> On Wednesday 31 July 2013 01:44:53 Linus Walleij wrote:
>> 
>>>> I don't see how sharing works here, or how another user, i.e. another one
>>>> than the user wanting to recieve the IRQ, can validly request such a line?
>>>> What would the usecase for that valid request be?
>>>
>>> When the GPIO is wired to a status signal (such as an MMC card detect signal)
>>> the driver might want to read the state of the signal independently of the
>>> interrupt handler.
>> 
>> That is true. But for such a complex usecase I think it's reasonable that
>> we only specify the GPIO in the device tree, and the driver utilizing the
>> IRQ need to take that and perform gpio_to_irq() on it, and then it still
>> works to use it both ways.
> 
> Hmm, the problem is that DT is seen as fixed. So if someone marks a GPIO
> as an IRQ, it can never be used otherwise. So if you really go this way,
> you should make this pretty clear in the documentation.
> 

DT is fixed because that describes the hardware which is fixed of course. So if
a chip IRQ line is connected to a GPIO pin in a controller that should be
described in the DT and that pin can't be used for anything else.

> Looking from the other side, why do you want to mark GPIOs as IRQs in
> the DT at all? 

Because from the component point-of-view that is wired to the SoC, that GPIO is
an IRQ line and so it has to be described.

> And how will this be done? I found the way it was done in
> the reverted patch very confusing because it needed an IRQ number. That
> IRQ number depends on the mapping and isn't hw specific (and currently
> just human doable because of the simple mapping).
> 

That's is not true. You don't define an IRQ number what you define is a GPIO
number that is mapped as IRQ. The GPIO number does not depend on the mapping and
it only depends on the GPIO controller.

This has absolutely nothing to do with the reverted patches and is described in
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.

The only difference is that the reverted patches did actually take an action
when a GPIO pin was mapped as an IRQ (requesting the GPIO and as input).

So for example in an OMAP board DT you can define something like this:

ethernet@5,0 {
        compatible = "smsc,lan9221", "smsc,lan9115";
        interrupt-parent = <&gpio6>;
        interrupts = <16 8>;
};

Since each OMAP GPIO bank has 32 GPIO pins, then what you are defining is that
the GPIO 176 (5 * 32 + 16) will be mapped as the IRQ line for the ethernet
controller.

I explained the exact use case I'm trying to solve in the thread "Re: [PATCH v3]
gpio: interrupt consistency check for OF GPIO IRQs" [1] if you need more
context. I'm sure others cc'ed in this thread have different (but similar)
requirements.

> Regards,
> 
> Alexander Holler
>

Thanks a lot and best regards,
Javier


[1]: http://www.kernelhub.org/?p=2&msg=326503

