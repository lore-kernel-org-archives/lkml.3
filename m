Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3K0EAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:00:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51584 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3K0EAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:00:32 -0500
Message-ID: <52956E08.9020606@ti.com>
Date: Wed, 27 Nov 2013 09:29:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 4/6] gpio: davinci: add OF support
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <1385057731-4348-5-git-send-email-prabhakar.csengg@gmail.com> <52932DB9.4090805@ti.com> <5294950A.9070007@ti.com> <5294D692.3080100@ti.com> <5294F95F.9020509@ti.com>
In-Reply-To: <5294F95F.9020509@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013 01:11 AM, Grygorii Strashko wrote:
> On 11/26/2013 07:12 PM, Sekhar Nori wrote:
>> On Tuesday 26 November 2013 06:03 PM, Grygorii Strashko wrote:
>>> On 11/25/2013 01:00 PM, Sekhar Nori wrote:
>>>> On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
>>>>> From: KV Sujith <sujithkv@ti.com>
>>>>>
>>>>> This patch adds OF parser support for davinci gpio
>>>>> driver and also appropriate documentation in gpio-davinci.txt
>>>>> located at Documentation/devicetree/bindings/gpio/.
>>>>>
>>>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>>>> Signed-off-by: KV Sujith <sujithkv@ti.com>
>>>>> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>>>>> [prabhakar.csengg@gmail.com: simplified the OF code, removed
>>>>>         unnecessary DT property and also simplified
>>>>>         the commit message]
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>> ---
>>>>>    .../devicetree/bindings/gpio/gpio-davinci.txt      |   41
>>>>> ++++++++++++++
>>>>>    drivers/gpio/gpio-davinci.c                        |   57
>>>>> ++++++++++++++++++--
>>>>>    2 files changed, 95 insertions(+), 3 deletions(-)
>>>>>    create mode 100644
>>>>> Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>>>>
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>>>> b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>>>> new file mode 100644
>>>>> index 0000000..a2e839d
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>>>>> @@ -0,0 +1,41 @@
>>>>> +Davinci GPIO controller bindings
>>>>> +
>>>>> +Required Properties:
>>>>> +- compatible: should be "ti,dm6441-gpio"
>>>>> +
>>>>> +- reg: Physical base address of the controller and the size of
>>>>> memory mapped
>>>>> +       registers.
>>>>> +
>>>>> +- gpio-controller : Marks the device node as a gpio controller.
>>>>> +
>>>>> +- interrupt-parent: phandle of the parent interrupt controller.
>>>>> +
>>>>> +- interrupts: Array of GPIO interrupt number. Only banked or
>>>>> unbanked IRQs are
>>>>> +          supported at a time.
>>>>
>>>> If this is true..
>>>>
>>>>> +
>>>>> +- ti,ngpio: The number of GPIO pins supported.
>>>>> +
>>>>> +- ti,davinci-gpio-unbanked: The number of GPIOs that have an
>>>>> individual interrupt
>>>>> +                     line to processor.
>>>>
>>>> .. then why do you need to maintain this separately? Number of elements
>>>> in interrupts property should give you this answer, no?
>>>>
>>>> There can certainly be devices (past and future) which use a mixture of
>>>> banked and unbanked IRQs. So a binding which does not take care of this
>>>> is likely to change in future and that is a problem since it brings in
>>>> backward compatibility of the binding into picture.
>>>>
>>>> The right thing would be to define the DT node per-bank similar to what
>>>> is done on OMAP rather than for all banks together. That way there can
>>>> be a separate property which determines whether that bank supports
>>>> direct-mapped or banked IRQs (or that could be inferred if the
>>>> number of
>>>> tuples in the interrupts property is more than one).
>>>
>>> Number of IRQ can't be simply used to determine type of IRQ - need to
>>> handle IRQ names,
>>> because each bank(32 gpios) may have up to 2 banked IRQs (one per 16
>>> GPIO).
>>
>> Okay. That's why I inserted that comment in parenthesis :)
>>
>>>
>>> Few things here:
>>> - The mixed banked/unbanked functionality has never been supported
>>> before.
>>
>> True. I actually misread the driver before.
>>
>>> - The Davinci GPIO IP is different from OMAP and has common
>>>    control registers for all banks.
>>
>> Well the only common register I can see is BINTEN - bank interrupt
>> enable. This register can simply be initialized to enable interrupts
>> from all banks possible as until the rising and falling edge triggers
>> are programmed, there wont be any actual interrupts generated.
>>
>>> - The proposed approach is more less easy to implement for DT case,
>>> but for not-DT
>>>    case - the platform data will need to be changed significantly (.
>>>    So, from this point of view, that would be a big change (actually
>>> the total driver rewriting).
>>
>> Well, I certainly don't think its a complete driver re-write. It will
>> take a bit of effort agreed, but I think the driver will also come out a
>> lot cleaner.
>>
>> Honestly, I am not so much worried about the kernel code here. Its the
>> bindings I am worried about. Once the bindings go in assuming there will
>> never be banked and unbanked GPIO IRQs on the same SoC, changing them to
>> do something else will be very painful with the need to keep backward
>> compatibility and support for both semantics.
>>
>> That said, because there is no present hardware which needs both banked
>> and unbanked at the same time, I wont press for this to be done
>> endlessly.
>>
>>> Do you have any thoughts about how it can be done in a simpler way?
>>
>> I don't know if there is a "simpler" way, but I don't think there is too
>> much effort too. I leave it to those implementing it though.
> 
> Oh. I see no problem to implement it for DT, but this change require to
> convert one device to the tree of devices:
>  GPIO controller
>  |- GPIO bank1
> ...
>  |- GPIO bankX
> 
> And that's will need to be handled somehow from platform code (which is
> non-DT and which I can't verify and which I don't want to touch actually
> ;).

May be you can take care of the DT case, upload the patches to some tree
and I can help you handle the non-DT case?

> 
>>
>>>
>>> Actually, the same was proposed by Linus, but we've tried avoid such
>>> huge rework -
>>> by switching to one irq_domain per all banks for example.
>>
>> I didn't really read that proposal from Linus so if two people
>> independently suggested the same thing, there must be something worth
>> considering there :)
> 
> I'm thinking more and more about new DT only compatible driver, so there
> will be no problem with non-DT code ("no regression") and even about
> moving the old driver back to the platform. :) Just thinking aloud.

Having two drivers is really a step backwards. NAK :)

Thanks,
Sekhar

