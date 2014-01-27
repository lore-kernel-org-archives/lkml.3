Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaA0KCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:02:17 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43687 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA0KCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4wtD0Uy=Zai7v2CjEr2Di6SM30k_Zv5rM24tbJRETgUyQ@mail.gmail.com>
References: <1389777042-2363-1-git-send-email-linus.walleij@linaro.org>
	<5EB3BFCD089AD643B9BB63439F5FD5E9012BC121C1@SHAASIEXM01.ASIA.ROOT.PRI>
	<CAGsJ_4zr-mcTcymK8CcUTYvzLLNDDVqM5bN5dF5vmdCmmTNx_g@mail.gmail.com>
	<CAGsJ_4wtD0Uy=Zai7v2CjEr2Di6SM30k_Zv5rM24tbJRETgUyQ@mail.gmail.com>
Date: Mon, 27 Jan 2014 11:02:15 +0100
Message-ID: <CACRpkdbNRYbooTkf+coiPL8Au_JV3z9QmGAWqgrdyxnN9VMNrA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: lock IRQs when starting them
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Binghua Duan <Binghua.Duan@csr.com>,
        Rongjun Ying <rongjun.ying@csr.com>, guoying.zhang@csr.com,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 8:01 AM, Barry Song <21cnbao@gmail.com> wrote:

> i read the patch "gpio: add API to be strict about GPIO IRQ usage"
> again, it seems by checking if (test_bit(FLAG_USED_AS_IRQ,
> &desc->flags)), we do be able to stop users setting irqline to output.

Yes that is the specific use of that flag right now.

> but my concern is actually that: when users use request_irq to get the
> irq line from gpio, in that case, gpio_request() probably will not be
> called at all,

This question has come up a lot recently as we recently established
that irqchip and gpiolib APIs are orthogonal, just like you say.

> who will fix the availability of this pin if it is
> muxed with other functionality except gpio?

So the problem is with the established semantic that
irqchips and gpiochips are orthogonal, not with this
particular patch, right?

Muxing is the responsibility of the pin control pin mux
subsystem and not GPIO.

If you require pinctrl_request_gpio() to be called from the
gpiolib driver for the pin to be muxed in, then this function must
be called from the irqchip side as well, e.g. from .irq_startup().

> but if gpio_request() is called, in it, pinctrl_request_gpio() is
> called as well, which will mark the pin as not-free. so do you think
> we need to call pinctrl_request_gpio() in startup() of irqline as
> well?

I think so.

> but this might be buggy again since people might call
> gpio_request() before calling request_irq().

Hm, you should study this problem and suggest the best
solution. In general I do not think it hurts to call
pinctrl_request_gpio() multiple times, and if it does maybe
that is something we want to fix?

Yours,
Linus Walleij
