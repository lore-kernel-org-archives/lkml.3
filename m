Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZNSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:18:13 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26257 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3FZNSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:18:12 -0400
Date: Wed, 26 Jun 2013 15:15:43 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] pinctrl: elaborate a bit on arrangements in doc
Message-ID: <20130626131543.GD7095@ab42.lan>
References: <1372169952-22439-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1372169952-22439-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:19:12PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This elaborates a bit on the pinctrl vs GPIO arangements
> in the hardware.
> 
> Inspired by some drawings in a mail from Christian
> Ruppert.
> 
> Cc: Rob Landley <rob@landley.net>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt | 37 ++++++++++++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 447fd4c..41ecad0 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -784,11 +784,38 @@ special GPIO-handler is registered.
>  GPIO mode pitfalls
>  ==================
>  
> -Sometime the developer may be confused by a datasheet talking about a pin
> -being possible to set into "GPIO mode". It appears that what hardware
> -engineers mean with "GPIO mode" is not necessarily the use case that is
> -implied in the kernel interface <linux/gpio.h>: a pin that you grab from
> -kernel code and then either listen for input or drive high/low to
> +The GPIO portions of a pin and its relation to a certain pin controller
> +logic can be constructed in several ways. Here are three examples:
> +
> +(A)
> +
> +                                         +- SPI
> +     Physical pins --- GPIO --- pinctrl -+- I2C
> +                                         +- mmc
> +
> +(B)
> +                    +- GPIO
> +     Physical pins -+           +- SPI
> +                    +- pinctrl -+- I2C
> +                                +- mmc
> +
> +(C)
> +                                +- SPI
> +     Physical pins --- pinctrl -+- I2C
> +                                +- mmc
> +                                +- GPIO
> +
> +In (A) the GPIO-like functionality of the pin is *always* available.
> +For example it is possible to read the GPIO input register to "spy" on
> +the SPI, I2C or MMC line while it is being used by the peripheral.
> +In (B) the GPIO functionality is orthogonal to any device using the
> +pin, and in (C) the GPIO case is the same as "some peripheral".
> +
> +For this reason the developer may be confused by a datasheet talking
> +about a pin being possible to set into "GPIO mode". It appears that what
> +hardware engineers mean with "GPIO mode" is not necessarily the use case
> +that is implied in the kernel interface <linux/gpio.h>: a pin that you
> +grab from kernel code and then either listen for input or drive high/low to
>  assert/deassert some external line.
>  
>  Rather hardware engineers think that "GPIO mode" means that you can
> -- 
> 1.7.11.3

In my experience, in hardware engineering terminology, GPIO/General
Purpose I/O just means a physical pad macro cell which can be
dynamically configured in different modes, e.g. as an input or as an
output, as an open drain driver etc. This configuration is done through
hardware signals and controlled by digital logic. This logic might
either be a GPIO controller or some other hardware block, e.g. an I2C
controller block.

Hardware GPIOs have nothing to do with the concept of GPIOs from the
Linux kernel point of view where a GPIO is a swoftware controllable pin
with a similar configuration space as "hardware GPIOs". To put it
simple, a software GPIO is a hardware GPIO plus some digital logic which
implements a register interface to drive all the hardware GPIO's control
lines from software.

In some cases, both modes are combined, e.g. one can imagine an SPI
interface where the output levels are driven from an SPI controller
hardware block and other parameters such as the drive strength or
integrated pull-up/pull-down resistors are controlled through some
independent mechanism. The parameters controlled through that
independent mechanism are sometimes referred to as the GPIO mode of the
pin.

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
