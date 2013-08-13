Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3HMPXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:23:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51872 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3HMPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:23:02 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Tue, 13 Aug 2013 08:22:58 -0700
In-Reply-To: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de> (Lars
	Poeschel's message of "Tue, 13 Aug 2013 11:46:35 +0200")
Message-ID: <87eh9xobsd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Poeschel <larsi@wh2.tu-dresden.de> writes:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> Currently the kernel is ambigously treating GPIOs and interrupts
> from a GPIO controller: GPIOs and interrupts are treated as
> orthogonal. This unfortunately makes it unclear how to actually
> retrieve and request a GPIO line or interrupt from a GPIO
> controller in the device tree probe path.
>
> In the non-DT probe path it is clear that the GPIO number has to
> be passed to the consuming device, and if it is to be used as
> an interrupt, the consumer shall performa a gpio_to_irq() mapping
> and request the resulting IRQ number.
>
> In the DT boot path consumers may have been given one or more
> interrupts from the interrupt-controller side of the GPIO chip
> in an abstract way, such that the driver is not aware of the
> fact that a GPIO chip is backing this interrupt, and the GPIO
> side of the same line is never requested with gpio_request().
> A typical case for this is ethernet chips which just take some
> interrupt line which may be a "hard" interrupt line (such as an
> external interrupt line from an SoC) or a cascaded interrupt
> connected to a GPIO line.
>
> This has the following undesired effects:
>
> - The GPIOlib subsystem is not aware that the line is in use
>   and willingly lets some other consumer perform gpio_request()
>   on it, leading to a complex resource conflict if it occurs.

And another reason, which happens on OMAP (not that the others aren't
already enough to make the case):

 - Platform-specific power management code may gate clocks or power to
   unused GPIO banks resulting in faults when accessing a GPIO that
   has not been properly requested via gpio_request().

> - The GPIO debugfs file claims this GPIO line is "free".
>
> - The line direction of the interrupt GPIO line is not
>   explicitly set as input, even though it is obvious that such
>   a line need to be set up in this way, often making the system
>   depend on boot-on defaults for this kind of settings.

Kevin
