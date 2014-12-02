Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaLBKc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:32:27 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:65397 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaLBKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZV-nQPXDnxiBgPTZTpyQ2eiKNL8qJY9jRq=A5foc-xmw@mail.gmail.com>
References: <1416383487-15993-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdZV-nQPXDnxiBgPTZTpyQ2eiKNL8qJY9jRq=A5foc-xmw@mail.gmail.com>
Date: Tue, 2 Dec 2014 11:32:20 +0100
X-Google-Sender-Auth: BMMjYRwdiHJh-b9hQtn8zco2-c0
Message-ID: <CAMuHMdUQ+rPasUWuGCc0AnV-g6J9zf9HbozuodHaYpy36Khcpg@mail.gmail.com>
Subject: Re: [PATCH] gpio: remove gpio_descs global array
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Alexandre,

On Fri, Nov 28, 2014 at 11:29 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Nov 19, 2014 at 8:51 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Replace the ARCH_NR_GPIOS-sized static array of GPIO descriptors by
>> dynamically-allocated arrays for each GPIO chip.
>>
>> This change makes gpio_to_desc() perform in O(n) (where n is the number
>> of GPIO chips registered) instead of O(1), however since n is rarely
>> bigger than 1 or 2 no noticeable performance issue is expected.
>> Besides this provides more incentive for GPIO consumers to move to the
>> gpiod interface. One could use a O(log(n)) structure to link the GPIO
>> chips together, but considering the low limit of n the hypothetical
>> performance benefit is probably not worth the added complexity.
>>
>> This patch uses kcalloc() in gpiochip_add(), which removes the ability
>> to add a chip before kcalloc() can operate. I am not aware of such
>> cases, but if someone bisects up to this patch then I will be proven
>> wrong...
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> OK patch applied. Let's see if the world explodes.

This patch changes a return value from -EPROBE_DEFER to -EINVAL in
regulator-gpio when a GPIO cannot be found yet, causing probe failures
on r8a7791/koelsch:

 of_get_named_gpiod_flags: can't parse 'enable-gpio' property of node
'/regulator@1[0]'
 of_get_named_gpiod_flags: parsed 'gpios' property of node
'/regulator@1[0]' - status (-517)
-gpio-0 (?): gpiod_request: status -517
-gpio-regulator regulator@1: Could not obtain regulator setting GPIOs: -517
-platform regulator@1: Driver gpio-regulator requests probe deferral
+------------[ cut here ]------------
+WARNING: CPU: 0 PID: 1 at
/scratch/geert/linux/linux-renesas/drivers/gpio/gpiolib.c:80
gpio_to_desc+0x94/0xac()
+invalid GPIO 0
+Modules linked in:
+CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.18.0-rc7-koelsch-05803-ge7a5d822abfc727e #634
+Hardware name: Generic R8A7791 (Flattened Device Tree)
+Backtrace:
+[<c0012118>] (dump_backtrace) from [<c0012338>] (show_stack+0x18/0x1c)
+ r6:c04608f7 r5:00000009 r4:00000000 r3:00200040
+[<c0012320>] (show_stack) from [<c0386e48>] (dump_stack+0x78/0x94)
+[<c0386dd0>] (dump_stack) from [<c0026b84>] (warn_slowpath_common+0x70/0x94)
+ r4:eec53d10 r3:c04f3390
+[<c0026b14>] (warn_slowpath_common) from [<c0026be0>]
(warn_slowpath_fmt+0x38/0x40)
+ r8:eed4a600 r7:00000001 r6:00000000 r5:00000000 r4:c04f9430
+[<c0026bac>] (warn_slowpath_fmt) from [<c01dd700>] (gpio_to_desc+0x94/0xac)
+ r3:00000000 r2:c0460931
+[<c01dd66c>] (gpio_to_desc) from [<c01df200>] (gpio_request_one+0x18/0xc4)
+ r5:00000000 r4:00000000
+[<c01df1e8>] (gpio_request_one) from [<c01df2d4>]
(gpio_request_array+0x28/0x60)
+ r6:00000004 r5:00000000 r4:eed5a4c0 r3:00000002
+[<c01df2ac>] (gpio_request_array) from [<c0201b20>]
(gpio_regulator_probe+0x424/0x5a4)
+ r7:eed4a610 r6:00000004 r5:eed464d0 r4:eed5a5d0
+[<c02016fc>] (gpio_regulator_probe) from [<c022a81c>]
(platform_drv_probe+0x50/0xa0)
+ r10:00000000 r9:c0509f80 r8:c04fa648 r7:00000000 r6:c04fa648 r5:eed4a610
+ r4:ffffffed
+[<c022a7cc>] (platform_drv_probe) from [<c0229000>]
(driver_probe_device+0xc0/0x204)
+ r6:00000000 r5:c054ae0c r4:eed4a610 r3:c022a7cc
+[<c0228f40>] (driver_probe_device) from [<c0229200>]
(__driver_attach+0x70/0x94)
+ r8:c04ee560 r7:c04fe4b0 r6:c04fa648 r5:eed4a644 r4:eed4a610 r3:00000000
+[<c0229190>] (__driver_attach) from [<c02276bc>] (bus_for_each_dev+0x74/0x98)
+ r6:c0229190 r5:c04fa648 r4:00000000 r3:00000001
+[<c0227648>] (bus_for_each_dev) from [<c0228b5c>] (driver_attach+0x20/0x28)
+ r6:eed52300 r5:00000000 r4:c04fa648
+[<c0228b3c>] (driver_attach) from [<c02287f4>] (bus_add_driver+0xe8/0x1d0)
+[<c022870c>] (bus_add_driver) from [<c022989c>] (driver_register+0xa4/0xe8)
+ r7:c04ee560 r6:00000000 r5:c04c0498 r4:c04fa648
+[<c02297f8>] (driver_register) from [<c022a750>]
(__platform_driver_register+0x50/0x64)
+ r5:c04c0498 r4:eed5a800
+[<c022a700>] (__platform_driver_register) from [<c04c04b0>]
(gpio_regulator_init+0x18/0x20)
+[<c04c0498>] (gpio_regulator_init) from [<c0009778>]
(do_one_initcall+0x108/0x1b8)
+[<c0009670>] (do_one_initcall) from [<c04a9e10>]
(kernel_init_freeable+0x11c/0x1e4)
+ r9:c0509f80 r8:c0509f80 r7:c04dfcf0 r6:c04d7c2c r5:0000006d r4:00000004
+[<c04a9cf4>] (kernel_init_freeable) from [<c0384538>] (kernel_init+0x10/0xec)
+ r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0384528 r4:00000000
+[<c0384528>] (kernel_init) from [<c000ee58>] (ret_from_fork+0x14/0x3c)
+ r4:00000000 r3:eec52000
+---[ end trace e95579bdd1fdbe74 ]---
+gpiod_request: invalid GPIO
+gpio-regulator regulator@1: Could not obtain regulator setting GPIOs: -22
+gpio-regulator: probe of regulator@1 failed with error -22

Reverting commit 14e85c0e69d5c7fdbd963edbbec1dc5cdd385200
("gpio: remove gpio_descs global array") fixes the issue.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
