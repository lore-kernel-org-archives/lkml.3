Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaAGSuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:50:55 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49733 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaAGSus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:50:48 -0500
MIME-Version: 1.0
In-Reply-To: <1389103548-23458-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1389103548-23458-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Tue, 7 Jan 2014 19:50:47 +0100
Message-ID: <CACRpkdYqLamX6P=0he2Swy=_io2u6SKjGHPNziMdDj2j+UR+Uw@mail.gmail.com>
Subject: Re: [PATCH] gpio: mcp23s08: Add irq functionality for i2c chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 3:05 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> This adds interrupt functionality for i2c chips to the driver.
> They can act as a interrupt-controller and generate interrupts, if
> the inputs change.
> This is tested on a mcp23017 chip.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
(...)
>         u8                      addr;
>
>         u16                     cache[11];
> +       u16                     irq_rise;
> +       u16                     irq_fall;
> +       int                     irq;
>         /* lock protects the cached values */
>         struct mutex            lock;
> +       struct mutex            irq_lock;
> +       struct irq_domain       *irq_domain;

(...)
> +static int mcp23s08_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct mcp23s08 *mcp = container_of(chip, struct mcp23s08, chip);
> +
> +       return irq_create_mapping(mcp->irq_domain, offset);

We have recently established that the mapping shall not be created in
gpio_to_irq().
Instead call irq_create_mapping() for all valid IRQ lines in probe() and
use irq_find_mapping() here.

> +static struct irq_chip mcp23s08_irq_chip = {
> +       .name = "gpio-mcp23xxx",
> +       .irq_mask = mcp23s08_irq_mask,
> +       .irq_unmask = mcp23s08_irq_unmask,
> +       .irq_set_type = mcp23s08_irq_set_type,
> +       .irq_bus_lock = mcp23s08_irq_bus_lock,
> +       .irq_bus_sync_unlock = mcp23s08_irq_bus_unlock,
> +};

Add irq_startup() and irq_shutdown() hooks in accordance with something
like this patch:
http://marc.info/?l=linux-gpio&m=138571851304612&w=2

The important thing is that you call
gpio_lock_as_irq()/gpio_unlock_as_irq()

Yours,
Linus Walleij
