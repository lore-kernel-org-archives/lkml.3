Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3JKOCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:02:22 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34963 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JKOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
Date: Fri, 11 Oct 2013 16:02:20 +0200
Message-ID: <CACRpkdY4HBmNUMAE6LzGEjR05x+XunxeQrazRk9JLAiHjOcz3A@mail.gmail.com>
Subject: Re: GPIO: Performance sensitive applications, gpiochip-level locking
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 7:29 PM, Darren Hart <dvhart@linux.intel.com> wrote:

> I'm currently working with a graphics driver that makes use of 2 GPIO
> pins for EDID communication (clock and data). In order to coexist
> peacefully with the driver for the GPIO chip, it must use gpiolib to
> request the lines, set direction, and set values. This results in a
> spinlock/unlock for every operation with this particular gpio driver.

Do you mean that this particular GPIO driver (which one?)
has a problem with this, or do you mean that there is something
in the gpiolib architecture that prevents you from augmenting
the GPIO driver to do what you want?

I can't see that we're taking any locks in the GPIOlib core.

> It would be preferable to lock the resources once, perform the EDID
> communication, then unlock the resources. The resources in this case are
> the value and direction registers off the PCI GPIO base address register
> which is shared with the other lines provided by the GPIO chip.
>
> Is there a best practice for dealing with this kind of configuration?

No.

> If not, would it make sense to add optional gpiochip-level lock/unlock
> and lockless direction and value operations to the gpiochip function
> block?

How do you imagine the API?

I can imagine something like:

gpio_bitbang_array(struct gpio_desc *desc, int value *, unsigned int values)
{
   /* Fall all the way through to the driver */
}

Or even:

struct bitbang_entry {
    unsigned int val;
    unsigned int delay_after;
}

gpio_bitbang_array(struct gpio_desc *desc,
                            struct bitbang_entry **,
                            int entries);

In either case (for the rough sketches) the gpiolib core has to fall back to
iterating over the array and just using set_value() if the accelerated ops
are not supported by the driver.

Possibly things can be learned from other parts of the kernel here.

Yours,
Linus Walleij
