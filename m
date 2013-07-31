Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab3GaIfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:35:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45323 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab3GaIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:35:05 -0400
Message-ID: <51F8CC35.1070704@collabora.co.uk>
Date: Wed, 31 Jul 2013 10:35:01 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com>
In-Reply-To: <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 01:44 AM, Linus Walleij wrote:
> On Tue, Jul 30, 2013 at 6:30 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> On Mon, Jul 29, 2013 at 6:36 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> To solve this dilemma, perform an interrupt consistency check
>>> when adding a GPIO chip: if the chip is both gpio-controller and
>>> interrupt-controller, walk all children of the device tree,
>>> check if these in turn reference the interrupt-controller, and
>>> if they do, loop over the interrupts used by that child and
>>> perform gpio_reques() and gpio_direction_input() on these,
>>> making them unreachable from the GPIO side.
>>
>> Ugh, that's pretty awful, and it doesn't actually solve the root
>> problem of the GPIO and IRQ subsystems not cooperating. It's also a
>> very DT-centric solution even though we're going to see the exact same
>> issue on ACPI machines.
> 
> The problem is that the patches for OMAP that I applied
> and now have had to revert solves it in an even uglier way,
> leading to breaking boards, as was noticed.
> 
> The approach in this patch has the potential to actually
> work without regressing a bunch of boards...
>
> Whether this is a problem in ACPI or not remains to be seen,
> but I'm not sure about that. Device trees allows for a GPIO line
> to be used as an interrupt source and GPIO line orthogonally,
> and that is the root of this problem. Does ACPI have the same
> problem, or does it impose natural restrictions on such use
> cases?
>

I agree with Linus here. The problem is that GPIO controllers that can work as
IRQ sources are treated in the kernel as if there where two separate controlers
that are rather orthogonal: an irq_chip and a gpio_chip.
But DT allows to use a GPIO line as an IRQ just by using an omap-gpio phandle as
"interrupt-parent".

So, there should be a place where both irq_chip and gpio_chip has to be related
somehow to properly configure a GPIO (request it and setting it as input) when
used as an IRQ by DT.

My patch for OMAP used an irq_domain_ops .map function handler to configure the
GPIO when a IRQ was mapped since that seemed to me as the best place to do it.
This worked well in OMAP2+ platforms but unfortunately broke OMAP1 platforms
since they are still using legacy domain mapping thus not call .map.

Linus' approach is much better IMHO since it is both generic and will only try
to setup an GPIO when a GPIO bank is added by the DT core. So checking there if
a GPIO line is being used as an IRQ and configuring the GPIO seems like a good
solution to me.

Old platforms like OMAP1 won't break since they don't (and probably never will)
have DT support.

>> We have to solve the problem in a better way than that. Rearranging
>> your patch description, here are some of the points you brought up so
>> I can comment on them...
>>
>>> This has the following undesired effects:
>>>
>>> - The GPIOlib subsystem is not aware that the line is in use
>>>   and willingly lets some other consumer perform gpio_request()
>>>   on it, leading to a complex resource conflict if it occurs.
>>
>> If a gpio line is being both requested as a gpio and used as an
>> interrupt line, then either a) it's a bug, or b) the gpio line needs
>> to be used as input only so it is compatible with irq usage. b) should
>> be supportable.
> 
> Yes this is what I'm saying too I think...
> 
> The bug in (a) manifested itself in the OMAP patch with
> no real solution in sight.
> 
>>> - The GPIO debugfs file claims this GPIO line is "free".
>>
>> Surely we can fix this. I still don't see a problem of having the
>> controller request the gpio when it is claimed as an irq if we can get
>> around the problem of another user performing a /valid/ request on the
>> same GPIO line. The solution may be to have a special form of request
>> or flag that allows it to be shared.
> 
> I don't see how sharing works here, or how another user,
> i.e. another one than the user wanting to recieve the IRQ,
> can validly request such a line? What would the usecase for
> that valid request be?
> 
> Basically I believe these two things need to be exclusive in
> the DT world:
> 
> A: request_irq(a resource passed from "interrupts");
>      -> core implicitly performs gpio_request()
>          gpio_direction_input()
> 
> B: gpio_request(a resource passed from "gpios");
>      gpio_direction_input()
>      request_irq(gpio_to_irq())
> 
> Never both. And IIUC that was what happened in the
> OMAP case.
>

Actually the OMAP case was not related to resource conflict but I'll explain the
issues we had with the OMAP patch in a moment. First I just want to say that I
don't think that makes sense that there are two users of a GPIO. There *could*
be two users for the same IRQ that is mapped to a GPIO but in that case there
will be only one user of the GPIO and that will be the IRQ controller even when
in practice is the same chip and the same driver. If the same GPIO line is used
for two devices in the DT, then gpio_request_one(gpio, GPIOF_IN, NULL) should be
called just once and that state has to be saved somewhere so whoever setups the
GPIO won't do it twice for the same IRQ.

But if a GPIO line is mapped as an IRQ and another user calls gpio_request()
then is correct that he gets an -EBUSY.

There are two issues that have to be solved at least for the OMAP case but they
seems to be general:

1) When a GPIO-IRQ mapping has to be created. e.g: call to irq_create_mapping()
2) When a GPIO-IRQ is setup.e.g: calling irq_set_chip_{data,and_handler,etc}()
3) When a GPIO line has to be requested and configured as input. e.g: call
gpio_request_one(gpio, GPIOF_IN, NULL)

For 1) in the DT case we don't need an explicit call to irq_create_mapping()
since it is called from irq_create_of_mapping() when an IRQ is mapped while
these explicit calls are needed for platforms that still use legacy boot.

The problem is that board files and drivers that has not not been completed
migrated to DT assumes (at least for OMAP) that *every* GPIO line is mapped as
an IRQ and they just do:

gpio_request(gpio,...);
gpio_direction_input()
request[_threaded]_irq(gpio_to_irq(gpio), ...);

My patch-set changed the gpio-omap driver to not map all GPIO lines but only the
ones that were really used as an IRQ and let the DT core to do the mapping from
irq_create_of_mapping(). The first problem reported with the OMAP patch was that
a driver was using the above sequence and that the GPIO had not been mapped.
This user was booting with DT and so this showed a bug in the driver and a DT
that did not conform with the standard schema used in mainline but this shows a
potential issue.

For 2) I moved all the GPIO-IRQ setup logic to the .map function handler since I
(wrongly) thought that .map will be called either when an explicit
irq_create_mapping() call was made and when the OF core handled it via
irq_create_of_mapping(). This was certainly true for OMAP2+ platforms and such
DT and legacy boot worked on my tests.

But it broke OMAP1 platforms since as I said still use legacy booting and thus
don't call the .map function handler. This was the reason why the patches got
reverted and not a resource conflict.

For 3) my patch called the gpio_request_one(gpio, GPIOF_IN, NULL) only if
chip->of_node was defined in the irqchip .map function handler.

But as we saw, this approach was a completely mess and we had to revert three
patches and bother Linus W on his holidays :)

So, I don't really know how to solve this issue and it seems I did more harm
than good when trying to do it. I think that Linus' approach is the least bad
solution but it seems to me that it just solves 3) but no 1) and 2).

>>> - The line direction of the interrupt GPIO line is not
>>>   explicitly set as input, even though it is obvious that such
>>>   a line need to be set up in this way, often making the system
>>>   depend on boot-on defaults for this kind of settings.
>>
>> Should also be solvable if the gpio request problem is solved.
> 
> Agreed...
>

+1

> Yours,
> Linus Walleij
> 

Thanks a lot and best regards,
Javier
