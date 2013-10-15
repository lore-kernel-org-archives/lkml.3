Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab3JOWCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 18:02:13 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60005 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab3JOWCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 18:02:11 -0400
MIME-Version: 1.0
In-Reply-To: <1381771798.9489.87.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
	<CACRpkdY4HBmNUMAE6LzGEjR05x+XunxeQrazRk9JLAiHjOcz3A@mail.gmail.com>
	<1381771798.9489.87.camel@dvhart-mobl4.amr.corp.intel.com>
Date: Wed, 16 Oct 2013 00:02:10 +0200
Message-ID: <CACRpkdYJV0QYikap4hW2qGKaneZbpAnhDcySXCgy2dQYS4-9iA@mail.gmail.com>
Subject: Re: GPIO: Performance sensitive applications, gpiochip-level locking
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 7:29 PM, Darren Hart <dvhart@linux.intel.com> wrote:

> In the case of the gpio-sch driver, each operation for direction and
> value require a lock/unlock. There is no API in gpiolib to lock the chip
> as a whole and then make lockless calls.

I don't see why the gpiolib should handle a lock? The lock in this
driver seems to be there for this type of read/modify/write sequence:

spin_lock
val = inb()
val &= ~mask;
val |= set;
outb(val)
spin_unlock

It's quite far away from the gpiochip as such ... In the case of ARM
we are now looking at implementing atomic read/modify/write calls
so we don't have to use any locks like this, so it's something that
is not going to be useful for everyone it seems.

> We could do this for this
> specific driver, but it seems to me it would better to do so at the
> gpiolib layer. For some chips these operations might be no-ops, for
> others, like the gpio-sch chip, they could avoid the lock/unlock for
> every call and allow for some performance improvement.

Yeah, we just need to figure out how to do that properly.

> Full disclosure here, I don't yet know if the lock/unlock presents a
> performance bottleneck. I've asked the graphics driver developers to try
> with the existing API and see if it is adequate.

OK seems like a good idea. You need a lot of GPIO
traffic for this to come into effect I believe, the cycles on the
io-port bus will be the major time consumer, right? Or are
these fast?

> My thinking was more
> along the lines of:
>
> gpio_lock_chip(struct gpio_chip *chip)
> gpio_direction_input_locked(gpio)
> val = gpio_get_value_locked(gpio)
> ...
> gpio_direction_output_locked(gpio
> gpio_set_value_locked(gpio, val)
> ...
> gpio_unlock_chip(struct gpio_chip *chip)
>
> I like the possibility of your suggestion, but I wonder if it will be
> flexible enough.

Argh, all these accessors with gpiod_* accesors already
being added this kernel cycle, it's going to be a *lot*
of duplicated APIs isn't it?

But will the above be flexible? It's just some big anonymous
lock and doesn't encourage fine-grained locking. It's like a
"big GPIO lock" and that's maybe not desireable.

Yours,
Linus Walleij
