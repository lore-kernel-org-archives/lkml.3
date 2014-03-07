Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaCGCtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:49:06 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39301 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaCGCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:49:04 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de>
References: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com>
	<alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de>
Date: Fri, 7 Mar 2014 10:49:02 +0800
Message-ID: <CACRpkdZ6D1XfDBdJEcR8G2HWkNcZSfz08Yvx8f0s+CqTUmybkg@mail.gmail.com>
Subject: Re: [PATCH] irq: Consider a negative return value of irq_startup() as
 an error
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 6:15 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 25 Feb 2014, Jean-Jacques Hiblot wrote:
>
> The whole drviers/gpio directory is full of this gpio_lock_as_irq()
> called from the guts of irq_chip callbacks braindamage.

OK then we need to figure out where to place this call to lock
the lines as used by IRQs properly.

The whole thing came out as a result of the resolution of a
discussion about semantic dependencies in drivers/gpio, as drivers
were not handling gpio_* calls to gpiolib and irqchip stuff
orthogonally instead relying on implicit handling of call
dependencies.

Anyway, using a GPIO line as an IRQ makes some other usecases
(like setting it to output and bitbanging it as an I2C) impossible,
and the gpiolib definately needs to be aware that it is used as
an IRQ. And some usecases (like the line being an output)
are impossible so the use as IRQ need to be denied.

> The comment above gpiod_lock_as_irq() is so wrong it's not even funny
> anymore.

Sent a patch to fix this.

> The whole idiocy starts with commit d468bf9e, which tells people to
> call this from irq_startup/enable. But it fails to tell, that this is
> pointless because it wont prevent the interrupt from starting up.

The call is still useful for the gpiolib intrinsics, we would be better off
even if the error to lock the line as IRQ was just printed and then
ignored, as then atleast the error message would tell users that they
are trying to do something that is impossible. Before they had no clue
and were debugging their GPIO irqs for days...

> So 11 SoC lemmings followed and added this completely pointless
> nonsense to their drivers.

Maybe for the irq subsystem, but the gpio subsystem is very
happy about now knowing if a GPIO is used as IRQ or not.
It has implications for the (horrid) sysfs API to GPIO for example.

> Dammit, I told you folks often enough that workarounds in some
> subsystem do not actually cure a shortcoming in the core code. When
> the core code was written, the GPIO case which might actually fail was
> definitly not thought of. But that's not a reason for adding
> tasteless and useless workarounds to the GPIO subsystem.

So while it is true that the situation where the locking to IRQ
fails was not handled properly, this was not added to workaround
shortcomings in other subsystems, but rather to make gpiolib
aware that a certain line is used for IRQs so as to stop people
from shooting themselves in the foot using the gpiolib.

> Of course you encouraged people to copy that nonsense all over the
> place.

Not Jean-Jacques! I take the sole honor for that :-)

> All startup functions do the same thing:
>
>     if (gpio_lock_as_irq() < 0)
>        dev_err("BLA");
>     unmask_irq();
>
> Plus the shutdown functions having the gpio_unlock_as_irq() +
> mask_irq() sequence. Sigh.
>
> So the proper solution to the problem if we want to use irq_startup()
> is:
>
>   Change the return value of the irq_startup() callback to int and
>   fixup all existing implementations. This wants to be done with a
>   coccinelle script. If you hurry up, I might squeeze it into 3.14 as
>   there is no risk at all. Otherwise this is going to happen after the
>   3.15 merge window closes.

I think Jean-Jacques says he's onto this so great.

>   After that's done, remove all the copies of startup/shutdown
>   nonsense in drivers/gpio and force all gpio chips to call
>   gpio_set_irq_chip*() instead of irq_set_irq_chip*() and add generic
>   irq_startup/shutdown callbacks which are implemented in the gpiolib
>   core code.

We probably need to mirror irq_set_chip_and_handler() too since
most drivers use this, but I like this idea.

> There is a less intrusive alternative solution:
>
>   Mark the interrupt as GPIO based in the core and let the core call
>   conditonally the gpio_[un]lock_as_irq functions.

I think the first one is better actually.

I'll see what Jean-Jacques comes up with and take it from there unless
he's interested in taking it all the way.

Yours,
Linus Walleij
