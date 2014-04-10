Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbaDJJe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:34:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42733 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935410AbaDJJet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:34:49 -0400
Message-ID: <534665B1.9090207@collabora.co.uk>
Date: Thu, 10 Apr 2014 11:34:41 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] add gpio_chip_ops to hold GPIO operations
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk> <CAAVeFu+XV_wy9JzewGs0bcSA-ivQg-kzygMh_kt434rsYRQwHQ@mail.gmail.com>
In-Reply-To: <CAAVeFu+XV_wy9JzewGs0bcSA-ivQg-kzygMh_kt434rsYRQwHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

Thanks a lot for your feedback.

On 04/10/2014 09:36 AM, Alexandre Courbot wrote:
> On Wed, Apr 9, 2014 at 3:20 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> In the kernel there are basically two patterns to implement object
>> oriented code in C. You can either embedded a set of function pointers
> 
> s/embedded/embed
> 
>> in a struct along with other members or have a separate virtual function
>> table (vtable) structure that hold all the functions and only store a
>> pointer to that vtable on our particular object.
>>
>> The struct gpio_chip uses the former approach, but I don't know if that
>> is a design decision or is just that this code predates the fact that
>> the separate structure pattern is now so popular. Since the having a
>> the operations on a different structure has a number of benefits:
> 
> "Since having the operations" maybe?
> 

Yes, since I'm not a native english speaker I sometimes miss some obvious
grammatical errors. I'll fix those when posting the final version with all the
drivers converted.

>>
>> - A clean separation between state (fields) and operations (functions).
>> - Size reduction of struct gpio_chip since will only hold one pointer.
>> - These functions are not supposed to change at runtime so the const
>>   qualifier can be used to prevent pointers modification during execution.
>> - Similar drivers for a chip family can reuse their function vtable.
>>
>> There is a drawback though which is that now two memory accesses are
>> needed to execute a GPIO operation since an additional level of
>> indirection is introduced but that should be minimized due temporal and
>> spatial memory locality.
> 
> I think I really do like this. Having ops in a separate structure is a
> very common pattern in the kernel and makes things a lot cleaner. On
> top of the advantages you listed, it also only requires a single
> assignment in the driver's init function vs. a lot more today.
> 
> If no one complains about the additional memory access, I'd like to go
> forward with this. I did much worse performance-hurting changes when
> introducing gpiod, so I suppose it will be fine.
> 
>>
>> So this is an RFC patch-set to add a virtual table to be used by
>> GPIO chip controllers and consist of the following patches:
>>
>> Javier Martinez Canillas (5):
>>   gpio: add a vtable to abstract GPIO controller operations
>>   gpiolib: set gpio_chip operations on add using a gpio_chip_ops
>>   gpio: omap: convert driver to use gpio_chip_ops
>>   gpio: twl4030: convert driver to use gpio_chip_ops
>>   gpio: switch to use struct struct gpio_chip_ops
>>
>>  drivers/gpio/gpio-omap.c    | 19 ++++++++-----
>>  drivers/gpio/gpio-twl4030.c | 10 +++++--
>>  drivers/gpio/gpiolib.c      | 64 ++++++++++++++++++++---------------------
>>  include/linux/gpio/driver.h | 69 +++++++++++++++++++++++++++------------------
>>  4 files changed, 93 insertions(+), 69 deletions(-)
>>
>> The patch-set is not a complete one though since only the GPIO OMAP
>> and GPIO TWL4030 drivers have been converted so I could test it on
>> my platform (DM3730 OMAP IGEPv2 board).
>>
>> But I preferred to send an early RFC than changing every single driver
>> before discussing if doing the split is worth it or not.
>>
>> To not break git bisect-ability, I added some patches that are
>> transitional changes. If you have a better suggestion on how to
>> handle that please let me know.
> 
> We will probably need that transition phase. We will also need to
> switch every single driver to your new scheme, so please wait until we
> hear from Linus before proceeding. :)
> 

I'm glad you agree with the idea, let's see what Linus thinks about it.

> Thanks,
> Alex.
> 

Best regards,
Javier
