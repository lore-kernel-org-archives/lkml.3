Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3A0MTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:19:12 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:59233 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab3A0MSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <510126E7.5090802@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-7-git-send-email-stigge@antcom.de>
	<CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
	<510126E7.5090802@antcom.de>
Date: Sun, 27 Jan 2013 13:18:48 +0100
Message-ID: <CAOY=C6F0ExS1gtmA=4QMzXUMRjAH5o7K9KDwTjdU-dYHA1fF=g@mail.gmail.com>
Subject: Re: [PATCH 6/6 v14] gpio: Add block gpio to several gpio drivers
From: Stijn Devriendt <highguy@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 1:19 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 01/24/2013 01:02 PM, Stijn Devriendt wrote:
>>> +static void lpc32xx_gpio_set_block_p3(struct gpio_chip *chip,
>>> +                                     unsigned long mask,
>>> +                                     unsigned long values)
>>> +{
>>> +       struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
>>> +       u32 set_bits = values & mask;
>>> +       u32 clr_bits = ~values & mask;
>>> +
>>> +       /* States of GPIO 0-5 start at bit 25 */
>>> +       set_bits <<= 25;
>>> +       clr_bits <<= 25;
>>> +
>>> +       /* Note: On LPC32xx, GPOs can only be set at once or cleared at once,
>>> +        *       but not set and cleared at once
>>> +        */
>>> +       if (set_bits)
>>> +               __raw_writel(set_bits, group->gpio_grp->outp_set);
>>> +       if (clr_bits)
>>> +               __raw_writel(clr_bits, group->gpio_grp->outp_clr);
>>> +}
>>> +
>>
>> In my patch, I go out of the way of this kind of thing for a simple reason:
>> You may generate incorrect timing by doing this.
>
> You are right, certain things like synchronous on+off is not really
> possible.
>
> However, the above at least supports switching on simulaneously, and
> switching off simultaneously, which is an improvement in certain cases
> (and this certain hardware part doesn't support more). Maybe this
> certain driver behaviour can be documented even better than just in the
> driver source.
>

The question here is: do you expect a user of the block-GPIO API to
go look into the base-driver code to see what will be supported?

In my version of the patch this means:
- do not provide a single GPIO-block that crosses multiple base-drivers
- only provide gpio_block_get/set for GPIO drivers that support the complete
operation in a single go. (for example, in the above example there would be
no gpio_block_set() function)

Perhaps the best approach is to make this explicit: Allow drivers to expose
their capabilities wrt timing and allow users to request strict-timing or
loose-timing. Loose-timing allows multiple gpio-drivers to be combined and
allows drivers with separate set/clear, hi/lo registers to be used.
Of course, for a first version you may as well leave it out. Perhaps the
use-cases for cross-GPIO-driver blocks are not worth the extra complexity
as of today?

Regards,
Stijn

> If there is consensus that everything else in the patch set is settled,
> and we just don't want to support behaviour like the above - well, we
> can still drop it.
>
> Thanks for the note,
>
> Roland
>
