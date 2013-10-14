Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3JNR37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:29:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:40365 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab3JNR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="392784790"
Message-ID: <1381771798.9489.87.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: GPIO: Performance sensitive applications, gpiochip-level locking
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Date: Mon, 14 Oct 2013 10:29:58 -0700
In-Reply-To: <CACRpkdY4HBmNUMAE6LzGEjR05x+XunxeQrazRk9JLAiHjOcz3A@mail.gmail.com>
References: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
	 <CACRpkdY4HBmNUMAE6LzGEjR05x+XunxeQrazRk9JLAiHjOcz3A@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 16:02 +0200, Linus Walleij wrote:
> On Mon, Sep 30, 2013 at 7:29 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> 
> > I'm currently working with a graphics driver that makes use of 2 GPIO
> > pins for EDID communication (clock and data). In order to coexist
> > peacefully with the driver for the GPIO chip, it must use gpiolib to
> > request the lines, set direction, and set values. This results in a
> > spinlock/unlock for every operation with this particular gpio driver.
> 
> Do you mean that this particular GPIO driver (which one?)

gpio-sch

> has a problem with this, or do you mean that there is something
> in the gpiolib architecture that prevents you from augmenting
> the GPIO driver to do what you want?
> 
> I can't see that we're taking any locks in the GPIOlib core.

Right, this is going to be driver specific. Each driver, as I understand
it, is responsible for setting up any necessary locking since some may
share registers, others may not. However, if memory serves, a shared for
all pins for direction, enable, and value is not uncommon, and requires
a mutual exclusion mechanism.

In the case of the gpio-sch driver, each operation for direction and
value require a lock/unlock. There is no API in gpiolib to lock the chip
as a whole and then make lockless calls. We could do this for this
specific driver, but it seems to me it would better to do so at the
gpiolib layer. For some chips these operations might be no-ops, for
others, like the gpio-sch chip, they could avoid the lock/unlock for
every call and allow for some performance improvement.

Full disclosure here, I don't yet know if the lock/unlock presents a
performance bottleneck. I've asked the graphics driver developers to try
with the existing API and see if it is adequate.


> 
> > It would be preferable to lock the resources once, perform the EDID
> > communication, then unlock the resources. The resources in this case are
> > the value and direction registers off the PCI GPIO base address register
> > which is shared with the other lines provided by the GPIO chip.
> >
> > Is there a best practice for dealing with this kind of configuration?
> 
> No.
> 
> > If not, would it make sense to add optional gpiochip-level lock/unlock
> > and lockless direction and value operations to the gpiochip function
> > block?
> 
> How do you imagine the API?
> 
> I can imagine something like:
> 
> gpio_bitbang_array(struct gpio_desc *desc, int value *, unsigned int values)
> {
>    /* Fall all the way through to the driver */
> }
> 
> Or even:
> 
> struct bitbang_entry {
>     unsigned int val;
>     unsigned int delay_after;
> }
> 
> gpio_bitbang_array(struct gpio_desc *desc,
>                             struct bitbang_entry **,
>                             int entries);
> 
> In either case (for the rough sketches) the gpiolib core has to fall back to
> iterating over the array and just using set_value() if the accelerated ops
> are not supported by the driver.
> 
> Possibly things can be learned from other parts of the kernel here.

Hrm... I hadn't considered something like that. My thinking was more
along the lines of:

gpio_lock_chip(struct gpio_chip *chip)
gpio_direction_input_locked(gpio)
val = gpio_get_value_locked(gpio)
...
gpio_direction_output_locked(gpio
gpio_set_value_locked(gpio, val)
...
gpio_unlock_chip(struct gpio_chip *chip)

I like the possibility of your suggestion, but I wonder if it will be
flexible enough.

Thanks,

Darren

> 
> Yours,
> Linus Walleij

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


