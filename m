Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3KNJAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:00:54 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37876 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3KNJAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <3148793.m2Our7kMkU@avalon>
References: <20131106234737.8971.37405.sendpatchset@w520>
	<1777251.JReTVdX0Pd@avalon>
	<CANqRtoRkMO8Xcno+ZPDPddPp3FNHT_E+6B=i7K_ixELzseRcFw@mail.gmail.com>
	<3148793.m2Our7kMkU@avalon>
Date: Thu, 14 Nov 2013 18:00:49 +0900
Message-ID: <CANqRtoQYefyi9Rja3rBgJ2Zc6_2yTQeGk00AFdiPJHa7pUnhdg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Nov 14, 2013 at 8:55 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Thursday 14 November 2013 08:49:16 Magnus Damm wrote:
>> On Wed, Nov 13, 2013 at 9:03 PM, Laurent Pinchart wrote:
>> > Hi Magnus,
>> >
>> > Thank you for the patch.
>> >
>> > Please read below for a couple of comments in addition to Linus' review.
>> >
>> > On Thursday 07 November 2013 08:47:37 Magnus Damm wrote:
>> >> From: Magnus Damm <damm@opensource.se>
>> >>
>> >> This patch adds a GPIO driver for the RZ series of SoCs from
>> >> Renesas. The driver can be used as platform device with dynamic
>> >> or static GPIO assignment or via DT using dynamic GPIOs.
>> >>
>> >> The hardware allows control of GPIOs in blocks of up to 16 pins,
>> >> and once device may span multiple blocks. Interrupts are not
>> >> included in this hardware block, if interrupts are needed then
>> >> the PFC needs to be configured to a IRQ pin function which is
>> >> handled by the GIC hardware.
>> >>
>> >> Tested with yet-to-be-posted platform device and DT devices on
>> >> r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.
>> >>
>> >> Signed-off-by: Magnus Damm <damm@opensource.se>
>> >> ---
>> >>
>> >>  drivers/gpio/Kconfig                  |    6
>> >>  drivers/gpio/Makefile                 |    1
>> >>  drivers/gpio/gpio-rz.c                |  241 +++++++++++++++++++++++++++
>> >>  include/linux/platform_data/gpio-rz.h |   13 +
>> >>  4 files changed, 261 insertions(+)
>
> [snip]
>
>> >> --- /dev/null
>> >> +++ work/drivers/gpio/gpio-rz.c       2013-11-06 14:20:02.000000000 +0900
>> >> @@ -0,0 +1,241 @@
>
> [snip]
>
>> >> +static inline unsigned long rz_gpio_read_ppr(struct rz_gpio_priv *p, int
>> >> offs)
>> >> +{
>> >> +     unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
>> >> +     int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
>> >
>> > offs and offset are unsigned, you can make them unsigned int.
>>
>> Ok!
>>
>> >> +     return ioread32(p->io[REG_PPR] + offset) & msk;
>> >
>> > I believe you should return !!(...) here, or in the caller, to make sure
>> > the gpio_get_value() operation returns either 0 or 1. I would do it here
>> > and return a u32 instead of unsigned long.
>>
>> I disagree with the !! because it is just pure overhead, please see
>> the __gpio_get_value() comment, it says returning zero or nonzero. So
>> I left this portion as-is.
>
> OK, good point. Linus, what's the best practice rule for GPIO drivers ? Should
> they just return any non-zero value, or is any specific value preferred ?

I too would like to hear Linus opinion. From my side, the other two
GPIO drivers that I've written follow this rule. If someone for some
unknown reason want to change things around then perhaps the interface
should also be updated to instead return a bool?

Regardless, since other drivers follow this style (see for instance
davinci_gpio_get()) perhaps this kind of interface adjustment simply
could be handled as a separate discussion with potential incremental
changes?

>> >> +static int rz_gpio_probe(struct platform_device *pdev)
>> >> +{
>> >> +     struct gpio_rz_config *pdata = dev_get_platdata(&pdev->dev);
>> >> +     struct rz_gpio_priv *p;
>> >> +     struct resource *io[3];
>> >> +     struct gpio_chip *gpio_chip;
>> >> +     struct device_node *np = pdev->dev.of_node;
>> >> +     struct of_phandle_args args;
>> >> +     int number_of_pins, gpio_base;
>> >> +     int k, nr;
>> >
>> > unsigned ?
>>
>> Ok!
>>
>> > By the way, what's wrong with i as a loop index ? :-)
>>
>> Nothing, but I left it as-is anyway! =)
>
> Good to know it's not wrong. But it's still an int in v2 ;-)

Ok-ok, gotcha, will use unsigned there too.

As for "i" vs "k", my tired old eyes prefer to see "k" over "i", "I",
"1", "|"...

Thanks,

/ magnus
