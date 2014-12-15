Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaLOVfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:35:52 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:36602 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:35:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,581,1413270000"; 
   d="scan'208";a="52972842"
Message-ID: <548F5433.5090901@broadcom.com>
Date: Mon, 15 Dec 2014 13:35:47 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com> <1918116.UxUgDPTmcq@wuerfel> <CAAVeFuL2MKRA7YLm_wsyftNy-sxgEYPrmqBm8XTRZQb66YF-qw@mail.gmail.com> <1628217.66frkAqHMc@wuerfel>
In-Reply-To: <1628217.66frkAqHMc@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 7:28 AM, Arnd Bergmann wrote:
> On Friday 12 December 2014 22:05:37 Alexandre Courbot wrote:
>> On Fri, Dec 12, 2014 at 9:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thursday 11 December 2014 16:05:04 Ray Jui wrote:
>>>> +
>>>> +- linux,gpio-base:
>>>> +    Base GPIO number of this controller
>>>> +
>>>>
>>>
>>> We've NAK'ed properties like this multiple times before, and it
>>> doesn't get any better this time. What are you trying to achieve
>>> here?
>>
>> I am to blame for suggesting using this property to Ray, and I am
>> fully aware that this has been rejected before, but look at what
>> people came with recently to palliate the lack of control over the
>> GPIO number space for DT platforms:
>>
>> http://www.spinics.net/lists/arm-kernel/msg384847.html
>> https://lkml.org/lkml/2014/12/10/133
>>
>> Right now GPIO numbering for platforms using DT is a very inconsistent
>> process, subject to change by the simple action of adjusting the value
>> of ARCH_NR_GPIOS (which we did recently, btw), adding a new GPIO
>> controller, or changing the probe order of devices. For users of the
>> integer or sysfs interfaces, this results in GPIO numbers that change,
>> and drivers and/or user-space programs that behave incorrectly.
>> Ironically, the only way to have consistent numbers is to use the old
>> platform files, where you can specify the base number of a gpio_chip.
>>
>> DT is actually probably not such a bad place to provide consistency in
>> GPIO numbering. It has a global vision of the system layout, including
>> all GPIO controllers and the number of GPIOs they include, and thus
>> can make informed decisions. It provides a consistent result
>> regardless of probe order. And allowing it to assign GPIO bases to
>> controllers will free us from the nonsensical dependency of some
>> arbitrary upper-bound for GPIO numbers that ARCH_NR_GPIOS imposes on
>> us. Also about ARCH_NR_GPIOS, the plan is to eventually remove it
>> since we don't need it anymore after the removal of the global
>> gpio_descs array. This will again interfere with the numbering of GPIO
>> chips that do not have a base number provided.
>>
>> Note that I don't really like this, either - but the problem is the
>> GPIO integer interface. Until everyone has upgraded to gpiod and we
>> have a replacement for the current sysfs interface (this will take a
>> while) we have to cope with this. This issue has been bothering users
>> for years, so this time I'd like to try and solve it the less ugly
>> way. If there is a better solution, of course I'm all for it.
>
> I think the scheme will fail if you ever get gpio controllers that are
> not part of the DT: We have hotpluggable devices (PCI, USB, ...) that
> are not represented in DT and that may also provide GPIOs for internal
> uses.
>
> The current state of affairs is definitely problematic, but defining
> the GPIO numbers in DT properties would only be a relative improvement,
> not a solution, and I fear it would make it harder to change the kernel
> to remove the gpio numbers eventually.
>
> I wonder if we could instead come up with an approach that completely
> randomizes the gpio numbers (as a compile-time option) to find any
> places that still rely on specific numbers.
>
> 	Arnd
>
Okay, if people think defining the GPIO base number in DT properties as 
a temporary, transient solution is not acceptable, I can switch the 
driver to use dynamic GPIO number allocation (by setting gpio base to a 
negative number and let gpiochip_add find a usable base number).

Like I said previously, dynamic GPIO allocation works fine in the 
kernel, as long as all of our GPIO clients in the kernel use gpiod based 
API, which is what we will enforce going forward. The only problem is 
with some of our customers who use GPIO through sysfs and expect fixed 
global GPIO numbers. Thinking about this more, it's probably not that 
difficult to add a script for those customers to convert/map the GPIO 
numbers based on readings parsed from sysfs, so I guess that's fine.

I'll submit v6 patchset with DT property "linux,gpio-base" removed.
