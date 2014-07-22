Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaGVFQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:16:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51309 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaGVFQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:16:49 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CDF3C0.1040000@roeck-us.net>
Date: Mon, 21 Jul 2014 22:16:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio: Add support for GPIOF_ACTIVE_LOW to gpio_request_one
References: <1405552260-30511-1-git-send-email-linux@roeck-us.net> <CAAVeFuLtUpKKVWAvJ-bw_b36jYFhrzaWeswnJKyehbwn=6y+4Q@mail.gmail.com> <53C76F3C.6090104@roeck-us.net> <CAAVeFuKC19AK8BjM7OBm=FWm0ua5YJXoGRkpOvM1TWkz9yOZ5Q@mail.gmail.com> <53C7DEE3.6060107@roeck-us.net> <CAAVeFuJigwAg09p4LQ+9g_LYusYe_G-y_aBWP0rr-AG-yz5V-A@mail.gmail.com>
In-Reply-To: <CAAVeFuJigwAg09p4LQ+9g_LYusYe_G-y_aBWP0rr-AG-yz5V-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 09:30 PM, Alexandre Courbot wrote:
> On Thu, Jul 17, 2014 at 11:34 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 07/17/2014 12:26 AM, Alexandre Courbot wrote:
>>>
>>> On Thu, Jul 17, 2014 at 3:37 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>> On 07/16/2014 11:09 PM, Alexandre Courbot wrote:
>>>>>
>>>>>
>>>>> On Thu, Jul 17, 2014 at 8:11 AM, Guenter Roeck <linux@roeck-us.net>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> The gpio include file and the gpio documentation declare and document
>>>>>> GPIOF_ACTIVE_LOW as one of the flags to be passed to gpio_request_one
>>>>>> and related functions. However, the flag is not evaluated or used.
>>>>>>
>>>>>> Check the flag in gpio_request_one and set the gpio internal flag
>>>>>> FLAG_ACTIVE_LOW if it is set.
>>>>>
>>>>>
>>>>>
>>>>> What is the point since the integer GPIO API has no clue of the
>>>>> active-low status of a GPIO? It is only used by the gpiod and sysfs
>>>>> interfaces.
>>>>>
>>>>
>>>> One can use gpio_request_one() to export a gpio pin to user space from
>>>> the kernel. That code path does use the flag, as you point out yourself
>>>> above.
>>>
>>>
>>> Ok, in that case I suppose it makes sense.
>>>
>>> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
>>>
>>>> One could also argue that the integer gpio API _should_ support this as
>>>> well,
>>>> but that is a different question.
>>>
>>>
>>> Probably not going to happen. The integer GPIO interface is deprecated
>>> and users who need new features should seriously consider switching to
>>> gpiod.
>>>
>>
>> The new API is unfortunately not equivalent to the old one. For example,
>> if I understand correctly, gpiod_get is expected to be used instead of
>> gpio_request_one.
>
> That is correct. The reason is to have a separate authority to assigns
> GPIOs and prevent drivers from arbitrarily requesting any GPIO they
> want, as long as everybody sticks to the gpiod interface.
>
>> That may work nicely in a world with full DT or ACPI
>> support, but doesn't work as well otherwise unless one drops the notion
>> of using platform specific drivers built as modules (gpiod_add_lookup_table
>> is not exported, and there is no remove function).
>>
>> Specifically, I don't see an easy way to convert mdio-gpio to use the new
>> model, and that driver could really use support for an API which supports
>> active-low pins.
>
> If you want to benefit from the active-low property but cannot use
> gpiod_get() for some reason, you can still request a GPIO by
> gpio_request_one() and then convert it to a descriptor with
> gpio_to_desc(), which is what I suspect your patch will allow you to
> do. But the real fix would be to work any limitations that gpiod has
> that prevent you from doing what you need.
>
> I am not familiar with mdio-gpio - could you explain what makes it
> impossible to convert this driver to the new model in your view?
>

gpiod_get has the notion of 'con_id'. That is all fine if you have
a system with acpi or devicetree to set this up, but the platform
data fallback is pretty clumsy (at least in my opinion). To convert
mdio-gpio such that it can provide the required platform data to gpio
would complicate the code so much that the conversion would not be worth
it. It would also require to convert all drivers _using_ mdio-gpio to the
new platform data format required by gpiod_get, or the mdio-gpio driver
would have to do some kind of internal conversion, both of which would
make the code even more complicated (and less likely to get it accepted).

My current solution is exactly what you suggested - to use gpio_request_one()
followed by gpio_to_desc(). I plan to submit the necessary patches
once this patch has been accepted.

Thanks,
Guenter

