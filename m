Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3G3Xo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:44:56 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57127 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3G3Xoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com>
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org>
	<CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com>
Date: Wed, 31 Jul 2013 01:44:53 +0200
Message-ID: <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 6:30 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Mon, Jul 29, 2013 at 6:36 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> To solve this dilemma, perform an interrupt consistency check
>> when adding a GPIO chip: if the chip is both gpio-controller and
>> interrupt-controller, walk all children of the device tree,
>> check if these in turn reference the interrupt-controller, and
>> if they do, loop over the interrupts used by that child and
>> perform gpio_reques() and gpio_direction_input() on these,
>> making them unreachable from the GPIO side.
>
> Ugh, that's pretty awful, and it doesn't actually solve the root
> problem of the GPIO and IRQ subsystems not cooperating. It's also a
> very DT-centric solution even though we're going to see the exact same
> issue on ACPI machines.

The problem is that the patches for OMAP that I applied
and now have had to revert solves it in an even uglier way,
leading to breaking boards, as was noticed.

The approach in this patch has the potential to actually
work without regressing a bunch of boards...

Whether this is a problem in ACPI or not remains to be seen,
but I'm not sure about that. Device trees allows for a GPIO line
to be used as an interrupt source and GPIO line orthogonally,
and that is the root of this problem. Does ACPI have the same
problem, or does it impose natural restrictions on such use
cases?

> We have to solve the problem in a better way than that. Rearranging
> your patch description, here are some of the points you brought up so
> I can comment on them...
>
>> This has the following undesired effects:
>>
>> - The GPIOlib subsystem is not aware that the line is in use
>>   and willingly lets some other consumer perform gpio_request()
>>   on it, leading to a complex resource conflict if it occurs.
>
> If a gpio line is being both requested as a gpio and used as an
> interrupt line, then either a) it's a bug, or b) the gpio line needs
> to be used as input only so it is compatible with irq usage. b) should
> be supportable.

Yes this is what I'm saying too I think...

The bug in (a) manifested itself in the OMAP patch with
no real solution in sight.

>> - The GPIO debugfs file claims this GPIO line is "free".
>
> Surely we can fix this. I still don't see a problem of having the
> controller request the gpio when it is claimed as an irq if we can get
> around the problem of another user performing a /valid/ request on the
> same GPIO line. The solution may be to have a special form of request
> or flag that allows it to be shared.

I don't see how sharing works here, or how another user,
i.e. another one than the user wanting to recieve the IRQ,
can validly request such a line? What would the usecase for
that valid request be?

Basically I believe these two things need to be exclusive in
the DT world:

A: request_irq(a resource passed from "interrupts");
     -> core implicitly performs gpio_request()
         gpio_direction_input()

B: gpio_request(a resource passed from "gpios");
     gpio_direction_input()
     request_irq(gpio_to_irq())

Never both. And IIUC that was what happened in the
OMAP case.

>> - The line direction of the interrupt GPIO line is not
>>   explicitly set as input, even though it is obvious that such
>>   a line need to be set up in this way, often making the system
>>   depend on boot-on defaults for this kind of settings.
>
> Should also be solvable if the gpio request problem is solved.

Agreed...

Yours,
Linus Walleij
