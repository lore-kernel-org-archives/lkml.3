Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3F0WAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:00:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35197 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3F0WAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:00:53 -0400
Message-ID: <51CCB611.6010709@wwwdotorg.org>
Date: Thu, 27 Jun 2013 16:00:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [PATCH v2] pinctrl: elaborate a bit on arrangements in doc
References: <1372326887-6497-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1372326887-6497-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:54 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This elaborates a bit on the pin control and pin muxing
> logic vs GPIO arangements in the hardware.
> 
> Inspired by some drawings in a mail from Christian Ruppert.
> Both arrangements are confirmed to exist in practice.

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt

> +The GPIO portions of a pin and its relation to a certain pin controller
> +configuration and muxing logic can be constructed in several ways. Here
> +are three examples:

s/three/two/ now:-)

> +(A)
...
> +Here some electrical properties of the pin can be configured no matter if the
> +pin is used for GPIO or not. After multiplexing GPIO onto the pin, you can
> +also drive it high/low from a certain bitset named "GPIO". Or the line can be
> +controlled by a certain peripheral, while still applying desired pin config
> +properties. GPIO functionality is thus orthogonal to any other device using the
> +pad/pin.

I'd make a few minor tweaks to that:

-----
Here some electrical properties of the pin can be configured no matter
whether the pin is used for GPIO or not. If you multiplex a GPIO onto a
pin, you can also drive it high/low from "GPIO" registers.
Alternatively, the pin can be controlled by a certain peripheral, while
still applying desired pin config properties. GPIO functionality is thus
orthogonal to any other device using the pin.
-----

> +In this arrangement the registers for the GPIO portions of the pin controller

That slightly assumes that GPIO is part of the pin controller HW module,
and then this paragraph is simply saying that the registers are likely
to be segmented within that HW module. To more explicitly allow for
entirely separate GPIO and pin controller HW modules, I would add the
following immediately after that line:

, or the registers for the GPIO HW module,

> +are likely to reside in a separate memory range only intended for GPIO
> +driving, and the register range dealing with pin config and pin multiplexing
> +get placed into a different memory range and a separate section of the data
> +sheet.

> +(B)
...
> +In this arrangement, the GPIO functionality can always be enabled, such that
> +e.g. a GPIO input can be used to "spy" on the SPI/I2C/MMC signal while it is
> +pulsed out. It is likely possible to disrupt the traffic on the pin by doing
> +wrong things on the GPIO block, as it is never really disconnected.
(added a line break here)
> +It is
> +likely that the GPIO, pin config and pin multiplex registers are placed into
> +the same memory range and the same section of the data sheet.

Well, I guess the one example we have of this HW structure is that way,
but I don't see any HW reason that has to be true. I would vote to
either remove that last sentence, or perhaps re-write it as:

-----
It is possible that the GPIO, pin config and pin multiplex registers are
placed into the same memory range and the same section of the data
sheet, although that need not be the case.
-----

> +From a kernel point of view, however, these are different aspects of the
> +hardware and shall be put into different subsystems.
> +
> +Electrical properties of the pin such as biasing and drive strength
> +may be placed at some pin-specific register in all cases or as part
> +of the GPIO register in case (B) especially. This doesn't mean that such
> +properties necessarily pertain to what the Linux kernel calls "GPIO".

Is it worth explaining which Linux subsystem each of the three aspects
are controlled by. Something like:

-----
Registers (or fields within registers) that control electrical
properties of the pin such as biasing and drive strength should be
exposed through the pinctrl subsystem, as "pin configuration" settings.

Registers (or fields within registers) that control muxing of signals
from various other HW blocks (e.g. I2C, MMC, or GPIO) onto pins should
be exposed through the pinctrl subssytem, as mux functions.

Registers (or fields within registers) that control GPIO functionality
such as setting a GPIO's output value, reading a GPIO's input value, or
setting GPIO pin direction should be exposed through the GPIO subsystem.

Depending on the exact HW register design, some functions exposed by the
GPIO subsystem may call into the pinctrl subsystem in order to
co-ordinate register settings across HW modules. In particular, this may
be needed for HW with separate GPIO and pin controller HW modules, where
e.g. GPIO direction is determined by a register in the pin controller HW
module rather than the GPIO HW module.
-----

Otherwise, this patch seems good. Reading this version, it's much more
obvious to me what the intent of the patch is, for some reason:-)
