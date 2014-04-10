Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965353AbaDJHg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:36:57 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56648 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaDJHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 10 Apr 2014 16:36:31 +0900
Message-ID: <CAAVeFu+XV_wy9JzewGs0bcSA-ivQg-kzygMh_kt434rsYRQwHQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] add gpio_chip_ops to hold GPIO operations
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 3:20 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> In the kernel there are basically two patterns to implement object
> oriented code in C. You can either embedded a set of function pointers

s/embedded/embed

> in a struct along with other members or have a separate virtual function
> table (vtable) structure that hold all the functions and only store a
> pointer to that vtable on our particular object.
>
> The struct gpio_chip uses the former approach, but I don't know if that
> is a design decision or is just that this code predates the fact that
> the separate structure pattern is now so popular. Since the having a
> the operations on a different structure has a number of benefits:

"Since having the operations" maybe?

>
> - A clean separation between state (fields) and operations (functions).
> - Size reduction of struct gpio_chip since will only hold one pointer.
> - These functions are not supposed to change at runtime so the const
>   qualifier can be used to prevent pointers modification during execution.
> - Similar drivers for a chip family can reuse their function vtable.
>
> There is a drawback though which is that now two memory accesses are
> needed to execute a GPIO operation since an additional level of
> indirection is introduced but that should be minimized due temporal and
> spatial memory locality.

I think I really do like this. Having ops in a separate structure is a
very common pattern in the kernel and makes things a lot cleaner. On
top of the advantages you listed, it also only requires a single
assignment in the driver's init function vs. a lot more today.

If no one complains about the additional memory access, I'd like to go
forward with this. I did much worse performance-hurting changes when
introducing gpiod, so I suppose it will be fine.

>
> So this is an RFC patch-set to add a virtual table to be used by
> GPIO chip controllers and consist of the following patches:
>
> Javier Martinez Canillas (5):
>   gpio: add a vtable to abstract GPIO controller operations
>   gpiolib: set gpio_chip operations on add using a gpio_chip_ops
>   gpio: omap: convert driver to use gpio_chip_ops
>   gpio: twl4030: convert driver to use gpio_chip_ops
>   gpio: switch to use struct struct gpio_chip_ops
>
>  drivers/gpio/gpio-omap.c    | 19 ++++++++-----
>  drivers/gpio/gpio-twl4030.c | 10 +++++--
>  drivers/gpio/gpiolib.c      | 64 ++++++++++++++++++++---------------------
>  include/linux/gpio/driver.h | 69 +++++++++++++++++++++++++++------------------
>  4 files changed, 93 insertions(+), 69 deletions(-)
>
> The patch-set is not a complete one though since only the GPIO OMAP
> and GPIO TWL4030 drivers have been converted so I could test it on
> my platform (DM3730 OMAP IGEPv2 board).
>
> But I preferred to send an early RFC than changing every single driver
> before discussing if doing the split is worth it or not.
>
> To not break git bisect-ability, I added some patches that are
> transitional changes. If you have a better suggestion on how to
> handle that please let me know.

We will probably need that transition phase. We will also need to
switch every single driver to your new scheme, so please wait until we
hear from Linus before proceeding. :)

Thanks,
Alex.
