Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaGGOwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:52:00 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41312 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaGGOv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
	<5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
Date: Mon, 7 Jul 2014 16:51:56 +0200
Message-ID: <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 5:36 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> I did some of the changes for this v2 and a few things are not clear to
> me.
>
> The first is, how is userspace supposed to find the correct offset for a
> GPIO pin.

The sysfs interface to GPIO is *NOT* *GOOD* this is universally
agreed upon.

This needs someone to step in and provide a replacement, my preferred
mechanism would be a /dev/gpiochip0/... hierarchy using char devices.

> E.g. let's say GPIO 10 of this SOC-internal GPIO controller is
> something I want to control. So, I'd export GPIO (chip-base + 10). But
> this chip-base seems pretty variable. v1 of this patch had it hardcoded
> to 0, which resulted in a predictable offset, but apparently was utterly
> wrong. Now I see an offset of 138 for this chip when using my config.
> And when I use multi_v7_defconfig the offset is somewhere in the 800s,
> IIRC. The best I found was the 'label' in the gpiochip's sysfs entry,
> but documentation says that is not necessarily unique, and parsing labes
> seems sub-optimal too.

You see. It is badly designed and needs to be rewritten.

It was merged into the kernel at a time when the GPIO subsystem
was unmaintained, sadly.

> The second issue is a stack trace (below) I see when triggering
> interrupts (e.g. echo rising > edge; and then pushing the connected
> button). Looking at the stack trace, I don't see an obvious error (I
> think I pretty much copied the IRQ registration from the gpio-pl061.c
> driver you mentioned). Is this an issue in this driver or the core code?

Probably.

Using GPIOs for IRQs in userspace is an even worse idea than using
GPIOs from userspace in general :-D

But before you add any hairy code in userspace, please have a look
at Documentation/gpio/sysfs.txt:

"Note that standard kernel drivers exist for common "LEDs and Buttons"
 GPIO tasks:  "leds-gpio" and "gpio_keys", respectively. Use those
 instead of talking directly to the GPIOs; they integrate with kernel
 frameworks better than your userspace code could."

So: what is the usecase for these GPIOs?

Yours,
Linus Walleij
