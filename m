Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaA0HBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:01:34 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56309 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaA0HBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:01:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zr-mcTcymK8CcUTYvzLLNDDVqM5bN5dF5vmdCmmTNx_g@mail.gmail.com>
References: <1389777042-2363-1-git-send-email-linus.walleij@linaro.org>
 <5EB3BFCD089AD643B9BB63439F5FD5E9012BC121C1@SHAASIEXM01.ASIA.ROOT.PRI> <CAGsJ_4zr-mcTcymK8CcUTYvzLLNDDVqM5bN5dF5vmdCmmTNx_g@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 27 Jan 2014 15:01:12 +0800
Message-ID: <CAGsJ_4wtD0Uy=Zai7v2CjEr2Di6SM30k_Zv5rM24tbJRETgUyQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: lock IRQs when starting them
To: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        Binghua Duan <Binghua.Duan@csr.com>
Cc: Rongjun Ying <rongjun.ying@csr.com>, guoying.zhang@csr.com,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-16 Barry Song <21cnbao@gmail.com>:
>
>> From: Linus Walleij [linus.walleij@linaro.org]
>> Sent: Wednesday, January 15, 2014 17:10
>> To: linux-kernel@vger.kernel.org; Barry Song
>> Cc: linux-gpio@vger.kernel.org; Linus Walleij
>> Subject: [PATCH] pinctrl: sirf: lock IRQs when starting them
>>
>> This uses the new API for tagging GPIO lines as in use by
>> IRQs. This enforces a few semantic checks on how the underlying
>> GPIO line is used.
>>
>> Also assign the gpio_chip.dev pointer to be used for error
>> messages.
>>
>> Cc: Barry Song <Baohua.Song@csr.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Hi Linus,
i read the patch "gpio: add API to be strict about GPIO IRQ usage"
again, it seems by checking if (test_bit(FLAG_USED_AS_IRQ,
&desc->flags)), we do be able to stop users setting irqline to output.
but my concern is actually that: when users use request_irq to get the
irq line from gpio, in that case, gpio_request() probably will not be
called at all, who will fix the availability of this pin if it is
muxed with other functionality except gpio?

for example, in case pin0 can be gpio0 and spi0, if we
request_irq(gpio0) without calling gpio_request(gpio0), and the other
people can still request the pin0 for spi0 since we didn't mark the
pin was used by irq or gpio yet.

but if gpio_request() is called, in it, pinctrl_request_gpio() is
called as well, which will mark the pin as not-free. so do you think
we need to call pinctrl_request_gpio() in startup() of irqline as
well? but this might be buggy again since people might call
gpio_request() before calling request_irq().

>
>> ---
>>  drivers/pinctrl/sirf/pinctrl-sirf.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>

-barry
