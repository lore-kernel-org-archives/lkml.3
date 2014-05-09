Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaEIL5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:57:11 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60439 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaEIL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zgQbsCZGXrAMqy6BbSvjtFUTYGw9px4UDRtUd=GUau=w@mail.gmail.com>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org>
	<1398287792-19831-3-git-send-email-linus.walleij@linaro.org>
	<CAGsJ_4zgQbsCZGXrAMqy6BbSvjtFUTYGw9px4UDRtUd=GUau=w@mail.gmail.com>
Date: Fri, 9 May 2014 13:57:06 +0200
Message-ID: <CACRpkdYU4ZXg+sYpeUFDqOhGhar5uJJzQJwJxNBbWdAMDcmUKw@mail.gmail.com>
Subject: Re: [PATCH 2/2] RFT: pinctrl: sirf: move sgpio lock into state container
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <baohua@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:40 PM, Barry Song <baohua@kernel.org> wrote:
> 2014-04-24 5:16 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:

>> Instead of referring to a global static variable for the sgpio
>> locking, use the state container to contain the lock.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> hi Linus, thanks! this looks very good only if we fix the
> gpiochip_add_pin_range() failure in patch 1:
>
> [    0.231658] pinmux-sirf b0120000.pinctrl: initialized SIRFSOC pinmux driver
> [    0.261200] bio: create slab <bio-0> at 0
> [    0.268264] GPIO chip /axi/peri-iobg/pinctrl@b0120000: could not
> create pin range
> [    0.276142] pinmux-sirf b0120000.pinctrl: could not add gpiochip pin range

Hm! This may mean that the pin controller is not there at this point,
so the pin controller needs to be probed first, before the gpiochip
and its range is probed.

What happens if you do this:

diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c
b/drivers/pinctrl/sirf/pinctrl-sirf.c
index 76502aab2cb1..ce7c3552398f 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -950,7 +950,7 @@ static int __init sirfsoc_gpio_init(void)

        return sirfsoc_gpio_probe(np);
 }
-subsys_initcall(sirfsoc_gpio_init);
+device_initcall(sirfsoc_gpio_init);

 MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
        "Yuping Luo <yuping.luo@csr.com>, "


Yours,
Linus Walleij
