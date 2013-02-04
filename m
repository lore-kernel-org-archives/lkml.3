Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3BDJY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:24:56 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44645 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3BDJYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <510F6CF8.3000700@gaisler.com>
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
	<CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com>
	<510F6CF8.3000700@gaisler.com>
Date: Mon, 4 Feb 2013 10:24:50 +0100
Message-ID: <CACRpkdYbJiBT5u0qJz+Krpky7W0WNqtSsO6Jo2TYZ2LRcyassA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC:ing Anton who wrote the generic GPIO. I might be wrong.)

On Mon, Feb 4, 2013 at 9:10 AM, Andreas Larsson <andreas@gaisler.com> wrote:
> On 2013-02-02 16:16, Linus Walleij wrote:
>>>
>>> +#if defined(__BIG_ENDIAN)
>>> +static inline u32 grgpio_read_reg(u32 __iomem *reg)
>>> +{
>>> +       return ioread32be(reg);
>>> +}
>>> +
>>> +static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
>>> +{
>>> +       iowrite32be(val, reg);
>>> +}
>>> +#else
>>> [...]
>>
>>
>> Where is this __BIG_ENDIAN flag coming from?
>>
>> And do you really have and test this regularly on both LE and BE hardware?
>> I am worrying a bit about maintenance...
>
> I am more than happy to drop that. I will most probably never test this on
> LE hardware.

Will someone else? I'm more thinking whether it is customary in
the SPARC drivers to do things like this, then we should follow
that pattern of course.

>>> +static void grgpio_set_sbit(struct grgpio_priv *priv, u32 __iomem *reg,
>>> +                          unsigned offset, int val, u32 *shadow)
>>> +{
>>> +       unsigned long flags;
>>> +
>>> +       spin_lock_irqsave(&priv->lock, flags);
>>> +
>>> +       if (val)
>>> +               *shadow |= (1 << offset);
>>> +       else
>>> +               *shadow &= ~(1 << offset);
>>> +       grgpio_write_reg(reg, *shadow);
>>> +
>>> +       spin_unlock_irqrestore(&priv->lock, flags);
>>> +}
>>
>>
>> This is all very basic stuff. Please make a best effort to reuse or
>> augment and reuse this:
>> drivers/gpio/gpio-generic.c
>>
>> IIRC this one also handles endianness issues, but I could be wrong.
>
> Sure, many of the initial functions do small basic tasks and resembles
> functions in gpio-generic. But that does not make the hardware itself a good
> candidate to use gpio-generic IMHO:
>
> 1) This core is generally running on SPARC, that is BE, but even on SPARC,
> readl and writel (that would be used in gprio-generic) deals with LE
> accesses and my registers are BE.

Yeah that's true. :-(

I think it's because read[lwb]/write[lwb] comes out of PCI and PCI
is LE.

Didn't think of this...

> 2) The grgpio_to_irq function is very hardware specific, and there is of
> course no gpio_to_irq support in gpio-generic.

Well, the idea about gpio-generic is to use the pieces you need
IIRC. You may override.

> 3) Running on SPARC, I get Open Firmware information from prom, so there is
> no platform data to access in the probe function. Of course general Open
> Firmware support could be added to gpio-generic, but in addition my probe
> needs to set up very hardware specific things for gpio_to_irq.

We should probably add some way to handle generic GPIO
with compatible strings etc, but that's way outside my competence
so OK. Maybe Rob or Grant can say something.

Yours,
Linus Walleij
