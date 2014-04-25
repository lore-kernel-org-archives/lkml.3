Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaDYLu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:50:28 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61468 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaDYLuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140425094343.GA3160@swsaberg01>
References: <cover.1398335771.git.anders.berg@lsi.com>
	<2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
	<CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
	<20140424174741.GA23444@swsaberg01>
	<CACRpkdZ1CA4mqcd5MA5HFmXSeGp-wspA0M6wnPbAsgL_gX76Fw@mail.gmail.com>
	<20140425094343.GA3160@swsaberg01>
Date: Fri, 25 Apr 2014 13:50:25 +0200
Message-ID: <CACRpkdaqPx3=qvUtsg44rBk+ZiscUg54HmNgETcei0LzfE9uOQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ARM: dts: Device tree for AXM55xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Anders Berg <anders.berg@lsi.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 11:43 AM, Anders Berg <anders.berg@lsi.com> wrote:
> On Fri, Apr 25, 2014 at 11:16:18AM +0200, Linus Walleij wrote:
>> On Thu, Apr 24, 2014 at 7:47 PM, Anders Berg <anders.berg@lsi.com> wrote:
>> > On Thu, Apr 24, 2014 at 03:24:14PM +0200, Linus Walleij wrote:
>>
>> >> One interrupt per CPU core?
>> >>
>> >> The drivers for these blocks will really just grab the first IRQ and
>> >> then I guess they
>> >> will only be able to execute on CPU0.
>> >>
>> >> It's definately correct to list all the IRQs here, but how do you envision
>> >> the drivers making use of them in the long run?
>> >
>> > It's one interrupt line per input pin (so with the current driver only the first pin
>> > is usable as interrupt source).
>>
>> Hm I'm not sure I understand what a "pin" is in this concept ...
>> being maintainer of the pin control subsystem and all that really
>> triggers my interest.
>>
>
> Ok, maybe should replace "pin" with "GPIO" in my previous comment.
>
> So, a clarification. In one of the PL061 blocks (named gpio0 in the dts) there
> is a separate interrupt per GPIO (I assume the motivation here is to enable to
> control irq affinity per GPIO), where as the other block has a more standard
> configuration with a single interrupt for all 8 GPIOs in that block.

OK! I get it. Thus this is not a stock PL061, but a version modified to
generate a separate IRQ line per GPIO line.

This means that you can only get a proper, working IRQ from the
first line on gpio0 right? All other IRQs will be ignored.

I see no problem in augmenting the driver to handle this
if #irqs == 8, the big change needs to happen in drivers/amba/bus.c
that has no way to pass any more than two IRQs atm.

I guess the best is to augment struct amba_device with a field
struct resource *resource and num_resources like platform_device
instead of the hard-coded single resource for iomem and two
hardcoded IRQ placeholders, so that an arbitrary amount of
resources can be added to an amba_device as well. But that
may be quite a lot of work. (Russell will know which direction to
take here.)

A simpler, local approach is to add some custom DT parsing
code to handle this in the pl061 driver, but that feels a bit
hacky.

Yours,
Linus Walleij
