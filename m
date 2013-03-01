Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3CAAYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:24:05 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35714 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3CAAYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:24:03 -0500
MIME-Version: 1.0
In-Reply-To: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
Date: Fri, 1 Mar 2013 01:24:01 +0100
Message-ID: <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and support
 custom accessors with gpio-generic
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 8:24 AM, Andreas Larsson <andreas@gaisler.com> wrote:

> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
> core library from Aeroflex Gaisler.
>
> This also adds support to gpio-generic for using custom accessor
> functions. The grgpio driver uses this to use ioread32be and iowrite32be
> for big endian register accesses.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Can you split this in two patches: one that adds the custom accessors
and one that adds the driver?

Grant is currently thinking about optimizations on the call graph
depths of the GPIO functions and may want to take this opportunity
to alter something there.

> +++ b/drivers/gpio/gpio-grgpio.c
(...)
> +struct grgpio_priv {
> +       struct bgpio_chip bgc;
> +       struct grgpio_regs __iomem *regs;
> +
> +       u32 imask;      /* irq mask shadow register */
> +       s32 *irqmap;    /* maps offset to irq or -1 if no irq */

irqmap? Argh what is this... I think you want to use irqdomain
for this instead. (Documentation/IRQ-domain.txt)

Check other GPIO drivers (e.g. STMPE or TC3589x) for some
example of how to use irqdomain.

> +static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
> +       int index, irq;

This is wher you should use irq_create_mapping(domain, hwirq);

Yours,
Linus Walleij
