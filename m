Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3BBPQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:16:11 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53525 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab3BBPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
Date: Sat, 2 Feb 2013 16:16:06 +0100
Message-ID: <CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:28 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP core
> library.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

OK...

> +#if defined(__BIG_ENDIAN)
> +static inline u32 grgpio_read_reg(u32 __iomem *reg)
> +{
> +       return ioread32be(reg);
> +}
> +
> +static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
> +{
> +       iowrite32be(val, reg);
> +}
> +#else
> +static inline u32 grgpio_read_reg(u32 __iomem *reg)
> +{
> +       return ioread32(reg);
> +}
> +
> +static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
> +{
> +       iowrite32(val, reg);
> +}
> +#endif

Where is this __BIG_ENDIAN flag coming from?

And do you really have and test this regularly on both LE and BE hardware?
I am worrying a bit about maintenance...

> +static void grgpio_set_sbit(struct grgpio_priv *priv, u32 __iomem *reg,
> +                          unsigned offset, int val, u32 *shadow)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&priv->lock, flags);
> +
> +       if (val)
> +               *shadow |= (1 << offset);
> +       else
> +               *shadow &= ~(1 << offset);
> +       grgpio_write_reg(reg, *shadow);
> +
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +}

This is all very basic stuff. Please make a best effort to reuse or
augment and reuse this:
drivers/gpio/gpio-generic.c

IIRC this one also handles endianness issues, but I could be wrong.

Yours,
Linus Walleij
