Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254AbaDJJbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:31:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34803 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbaDJJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yfCcQoMmUD08HBJDkXSPUOuUP-Sj9EZAJZ8grpodReiw@mail.gmail.com>
References: <1396960077-30599-1-git-send-email-linus.walleij@linaro.org> <CAGsJ_4yfCcQoMmUD08HBJDkXSPUOuUP-Sj9EZAJZ8grpodReiw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 10 Apr 2014 17:30:29 +0800
X-Google-Sender-Auth: huzjkMORSz65ovPtxJNWnkkulGU
Message-ID: <CAGsJ_4wEbDhcYa5sK0e6eVKOyHRJA4HSZWsd_83WGbAsviEToQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: sirf: switch driver to use gpiolib irqchip helpers
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        linux-gpio@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-10 11:48 GMT+08:00 Barry Song <baohua@kernel.org>:
> 2014-04-08 20:27 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
>> This switches the Sirf pinctrl driver over to using the gpiolib
>> irqchip helpers simplifying some of the code.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> This really needs testing on real hardware before I dare to
>> merge it, but the driver seems simple and straight-forward to
>> convert.
>
> Linus, this  broke the irq/gpio mapping. for example:
>
> without this:
> # cat /proc/interrupts
>            CPU0
>  16:        181  irq_sirfsoc   0  sirfsoc_timer0
> ...
>  62:          0  sirf-gpio-irq  45  extcon-gpio
> ...
>
> with this:
> # cat /proc/interrupts
>            CPU0
>  16:        944  irq_sirfsoc   0  sirfsoc_timer0
> ...
> 105:          0  sirf-gpio-irq  13  extcon-gpio
> ...
>
> i will do a debug to find why. any idea from you?

hi linus, after reading the source codes of GPIOLIB_IRQCHIP, i think
the new irq number after applying your patch should not be a problem.
the reason is that you create irq mapping earlier in
gpiochip_irqchip_add(), but the old codes did it later on demand in
sirfsoc_gpio_to_irq().

the real problem here is that we have several gpio banks, but there is
only one device node, so i think this should be not good and will make
the gpiochip_irq_reqres(), gpiochip_irq_relres() fail since
sub-devices can only point its interrupt parent to the only gpio node,
this makes hwirq bigger than the size of the gpio bank.

so will you wait for me to send a patch to merge all banks into one
gpio_chip just as i have done by commit
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8daeffb058f78deb0b0ef2cb67ef741c38788bf9
to merge irq_domain?

then i think your patch will work. thank you!

-barry
