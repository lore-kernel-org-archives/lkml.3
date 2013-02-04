Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3BDIKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:10:42 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:10352 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753893Ab3BDIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:10:40 -0500
Message-ID: <510F6CF8.3000700@gaisler.com>
Date: Mon, 04 Feb 2013 09:10:32 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com> <CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com>
In-Reply-To: <CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-02 16:16, Linus Walleij wrote:
>> +#if defined(__BIG_ENDIAN)
>> +static inline u32 grgpio_read_reg(u32 __iomem *reg)
>> +{
>> +       return ioread32be(reg);
>> +}
>> +
>> +static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
>> +{
>> +       iowrite32be(val, reg);
>> +}
>> +#else
>> [...]
>
> Where is this __BIG_ENDIAN flag coming from?
>
> And do you really have and test this regularly on both LE and BE hardware?
> I am worrying a bit about maintenance...

I am more than happy to drop that. I will most probably never test this 
on LE hardware.


>> +static void grgpio_set_sbit(struct grgpio_priv *priv, u32 __iomem *reg,
>> +                          unsigned offset, int val, u32 *shadow)
>> +{
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&priv->lock, flags);
>> +
>> +       if (val)
>> +               *shadow |= (1 << offset);
>> +       else
>> +               *shadow &= ~(1 << offset);
>> +       grgpio_write_reg(reg, *shadow);
>> +
>> +       spin_unlock_irqrestore(&priv->lock, flags);
>> +}
>
> This is all very basic stuff. Please make a best effort to reuse or
> augment and reuse this:
> drivers/gpio/gpio-generic.c
>
> IIRC this one also handles endianness issues, but I could be wrong.

Sure, many of the initial functions do small basic tasks and resembles 
functions in gpio-generic. But that does not make the hardware itself a 
good candidate to use gpio-generic IMHO:

1) This core is generally running on SPARC, that is BE, but even on 
SPARC, readl and writel (that would be used in gprio-generic) deals with 
LE accesses and my registers are BE.

2) The grgpio_to_irq function is very hardware specific, and there is of 
course no gpio_to_irq support in gpio-generic.

3) Running on SPARC, I get Open Firmware information from prom, so there 
is no platform data to access in the probe function. Of course general 
Open Firmware support could be added to gpio-generic, but in addition my 
probe needs to set up very hardware specific things for gpio_to_irq.


Thank you for the feedback!

Cheers,
Andreas Larsson

