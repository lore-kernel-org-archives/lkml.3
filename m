Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3IJQ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:26:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60981 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab3IJQ0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:26:15 -0400
Message-ID: <522F47FE.1080903@ti.com>
Date: Tue, 10 Sep 2013 11:25:34 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
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
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk> <522EC392.8070002@ti.com> <522F1BF0.8080608@collabora.co.uk> <522F3408.6050608@ti.com> <522F3F3F.9020306@collabora.co.uk>
In-Reply-To: <522F3F3F.9020306@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 10:48 AM, Javier Martinez Canillas wrote:
> On 09/10/2013 05:00 PM, Joel Fernandes wrote:
>> On 09/10/2013 08:17 AM, Javier Martinez Canillas wrote:
>>> On 09/10/2013 09:00 AM, Joel Fernandes wrote:
>>>> On 07/31/2013 03:35 AM, Javier Martinez Canillas wrote:
>>>>> On 07/31/2013 01:44 AM, Linus Walleij wrote:
>>>>>> On Tue, Jul 30, 2013 at 6:30 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>>>>>> On Mon, Jul 29, 2013 at 6:36 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>>>>>> To solve this dilemma, perform an interrupt consistency check
>>>>>>>> when adding a GPIO chip: if the chip is both gpio-controller and
>>>>>>>> interrupt-controller, walk all children of the device tree,
>>>>>>>> check if these in turn reference the interrupt-controller, and
>>>>>>>> if they do, loop over the interrupts used by that child and
>>>>>>>> perform gpio_reques() and gpio_direction_input() on these,
>>>>>>>> making them unreachable from the GPIO side.
>>>>>>>
>>>>>>> Ugh, that's pretty awful, and it doesn't actually solve the root
>>>>>>> problem of the GPIO and IRQ subsystems not cooperating. It's also a
>>>>>>> very DT-centric solution even though we're going to see the exact same
>>>>>>> issue on ACPI machines.
>>>>>>
>>>>>> The problem is that the patches for OMAP that I applied
>>>>>> and now have had to revert solves it in an even uglier way,
>>>>>> leading to breaking boards, as was noticed.
>>>>>>
>>>>>> The approach in this patch has the potential to actually
>>>>>> work without regressing a bunch of boards...
>>>>>>
>>>>>> Whether this is a problem in ACPI or not remains to be seen,
>>>>>> but I'm not sure about that. Device trees allows for a GPIO line
>>>>>> to be used as an interrupt source and GPIO line orthogonally,
>>>>>> and that is the root of this problem. Does ACPI have the same
>>>>>> problem, or does it impose natural restrictions on such use
>>>>>> cases?
>>>>>>
>>>>>
>>>>> I agree with Linus here. The problem is that GPIO controllers that can work as
>>>>> IRQ sources are treated in the kernel as if there where two separate controlers
>>>>> that are rather orthogonal: an irq_chip and a gpio_chip.
>>>>> But DT allows to use a GPIO line as an IRQ just by using an omap-gpio phandle as
>>>>> "interrupt-parent".
>>>>>
>>>>> So, there should be a place where both irq_chip and gpio_chip has to be related
>>>>> somehow to properly configure a GPIO (request it and setting it as input) when
>>>>> used as an IRQ by DT.
>>>>>
>>>>> My patch for OMAP used an irq_domain_ops .map function handler to configure the
>>>>> GPIO when a IRQ was mapped since that seemed to me as the best place to do it.
>>>>> This worked well in OMAP2+ platforms but unfortunately broke OMAP1 platforms
>>>>> since they are still using legacy domain mapping thus not call .map.
>>>>
>>>> Just wondering- why .map not called for omap1? irq_create_mapping does seem to
>>>> call  -> irq_domain_associate which calls map function. For omap case, GPIO
>>>> driver does call irq_create_mapping, just like omap2+ no?
>>>>
>>>
>>> That is what I understood too when writing the patch but I remember someone
>>> mentioning legacy domain mapping not calling the .map function handler as a
>>> possible cause for the OMAP1 regression and since Linus decided to revert the
>>> patches in favor of a more general solution I didn't care to check if that was
>>> true or not. Now looking at irq_create_mapping() I see that my assumption was
>>> correct so I don't know what was the bug that caused the OMAP1 regression.
>>
>> Only stuff you deleted from the chip_init function was:
>>
>> -       for (j = 0; j < bank->width; j++) {
>> -               int irq = irq_create_mapping(bank->domain, j);
>> -               irq_set_lockdep_class(irq, &gpio_lock_class);
>> -               irq_set_chip_data(irq, bank);
>> -               if (bank->is_mpuio) {
>> -                       omap_mpuio_alloc_gc(bank, irq, bank->width);
>> -               } else {
>> -                       irq_set_chip_and_handler(irq, &gpio_irq_chip,
>> -                                                handle_simple_irq);
>> -                       set_irq_flags(irq, IRQF_VALID);
>> -               }
>>
>> and you moved all of it to the .map function in your patch. Not sure what could
>> be breaking OMAP1 cases.
>> You could potentially add that back with some #ifdef for OMAP1?
>>
>> Either way, map should be called looks like. If its not called, then the above
>> block can be explicity called for OMAP1 case in omap_chip_gpio_init.
>>
>> What was strange is one person reported that mappings were not created for
>> OMAP1. But I am wondering what you changed could result in not creating that
>> mapping. Really nothing..
>>
>> I think your initial patch is much better than fixing up DT but then I may be
>> missing other problems with your patch that Linus's patch addresses.
>>
>>>> Further, if for any reason the .map is not called. Can you not call gpio_request
>>>> yourself direct in omap_gpio_chip_init function?
>>>>
>>>
>>> No, since you can't request a GPIO for all GPIO pins in the bank. Users have to
>>> do it explicitly (or implicitly in the case of GPIO mapped as IRQ in DT).
>>
>> Ah since you split the patch up into 2, I missed the gpio_request stuff. Ok,
>> that makes sense.
>>
>>>> Does it really matter if you call gpio_request from .map or from the chip_init
>>>> function?
>>>>
>>>
>>> Yes it does, because in DT the core calls irq_create_of_mapping() ->
>>> irq_create_mapping() -> .map(). That way only are requested the GPIO pins that
>>> are mapped as IRQ and not all of them.
>>
>>>> Also on a different note.. this would call gpio_request for *every* gpio line,
>>>> but isn't that what your original patch that got reverted was doing in
>>>> omap_gpio_chip_init:
>>>>
>>>> +       if (!bank->chip.of_node)
>>>> +               for (j = 0; j < bank->width; j++)
>>>> +                       irq_create_mapping(bank->domain, j);
>>>>
>>>
>>> No it won't. This is only needed for the legacy (non-DT) boot since no one calls
>>> irq_create_mapping() so it has to be called explicitly.
>>>
>>> And in that case .map will be called but gpio_request() won't since the call is
>>> made only when bank->chip.of_node is not NULL.
>>
>> Ok, thanks for the explanation. That makes sense to me.
>>
> 
> I'm glad that it helped to you to better understand the approach but you
> shouldn't spend time on this since Linus W had made very clear that he doesn't
> want a local solution that would be replicated on each platform since this is
> not an OMAP only issue.

Ok.

> If you are interested in this problem you should joining the thread "Re: [PATCH
> v3] gpio: interrupt consistency check for OF GPIO IRQs" [1] were is currently
> being discussed this approach.

Ok, if possible if you could CC me on this thread as well, would be grateful.
Thanks.


Regards,

-Joel

