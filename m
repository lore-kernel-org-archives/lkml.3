Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795Ab3BOOrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:47:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53258 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935488Ab3BOOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:47:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND 1/6 v13] gpio: Add a block GPIO API to gpiolib
To: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1358250716-21986-2-git-send-email-stigge@antcom.de>
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-2-git-send-email-stigge@antcom.de>
Date: Fri, 15 Feb 2013 14:47:00 +0000
Message-Id: <20130215144700.35A1F3E044B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 12:51:51 +0100, Roland Stigge <stigge@antcom.de> wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
> 
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
> Once requested, it provides access to a group of GPIOs which can range over
> multiple GPIO chips.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---
> 
>  Documentation/gpio.txt     |   58 +++++++++++
>  drivers/gpio/gpiolib.c     |  227 +++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |   17 +++
>  include/linux/gpio.h       |   97 +++++++++++++++++++
>  4 files changed, 399 insertions(+)
> 
> --- linux-2.6.orig/Documentation/gpio.txt
> +++ linux-2.6/Documentation/gpio.txt
> @@ -481,6 +481,64 @@ exact name string of pinctrl device has
>  argument to this routine.

Hi Roland,

The first thing that jumps out at me on this is that it really is two
separate concepts implemented in one patch.
1) allow individual chips to expose a block API for that single controller.
2) creating a global block gpio interface for multiple arbitrary
groupings of chips

The first is relatively noncontroversial. It is easy to implement and
there are there are real performance issues that it addresses. If you
split that out as a separate patch it is something I think I can merge.
I do have some minor comments on this feature, but I'll put the details
below.

The second I'm not that thrilled with, or at least I think the
implementation is more complex than it needs to be. The big problem is
that it tries to abstract the fact that GPIOs may or may not be on the
same controller, and in doing so it has to do a bunch of housekeeping to
map 'virtual' gpio numbers to real gpios. I recognized that the feature
is needed to take advantage of gpiochip block access, but I'd like to
suggest a different implementation.

Instead of keeping track of separate block_gpio chip references, how
about an API that consolidates GPIO operations. For example (rough
sketch, and using the new gpiodesc infrastructure):

struct gpiocmd {
	struct gpio_desc *gpio;
	int data;
}

int gpio_set_sequence(struct gpiocmd *gpiocmd, int count)
{
	struct gpio_chip *gc = GPIO_DESC_TO_GPIOCHIP(gpiocmd->gpio);
	int bit = GPIO_DESC_TO_BIT(gpiocmd->gpio);
	unsigned long data, mask;

	/*
	 * Consolidate and execute the gpio commands. A little naive,
	 * but you get the idea.
	 *
	 * GPIO_DESC_TO_GPIOCHIP() and GPIO_DESC_TO_BIT() are fictions
	 * at the moment; something will need to be implemented here.
	 */
	mask = 1 << bit;
	data = gpiocmd->data << bit;
	for (i = 1; i < count; i++, gpiocmd++) {
		struct gpio_chip *nextgc = GPIO_DESC_TO_GPIOCHIP(gpiocmd->gpio):
		bit = GPIO_DESC_TO_BIT(gpiocmd->gpio);

		/* Consolidate if same gpio_chip and go to next iteration */
		if (gc == nextgc) {
			mask &= 1 << bit
			data &= gpiocmd->data << bit
			continue;
		}

		gc->set_block(gc, mask, data);

		gc = nextgc;
		mask = 1 << bit;
		data = gpiocmd->data << bit;
	}

	/* Last one because the loop alwasy exits with at least one more
	 * thing to do */
	gc->set_block(gc, mask, data);
}

And that's it. It maintains the abstraction that GPIOs are separate and
that assumptions cannot be made about how there are wired together, but
still allows any driver to take advantage of speedups with consolidating
operations. Drivers also get to use the same handles they are currently
using instead of a separate gpio_block namespace which means it
interworks nicely with the existing API.

It also should be lighter weight when it comes to speed of processing.
Normally I'm not too worried about that, but when it comes to GPIOs and
bitbanging it can end up having a really big cost.

Naturally the thing I hacked together above is just a draft. It can
certainly be refined. It might make sense for it to be a bitbang
statemachine that can handle both set, get and barrier/delay operations.
That might actually be simpler and better than having separate set & get
sequences with callers handing the bitbanging.

For performance, it might make sense to separate the consolidation pass
from the execution pass.

g.

