Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaI2PjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:39:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36793 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaI2Pi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:38:59 -0400
Message-ID: <54297D10.9050907@linaro.org>
Date: Mon, 29 Sep 2014 16:38:56 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav.etc@gmail.com>
CC: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: st: Fix Sparse error
References: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>	<542970CF.6040405@linaro.org> <CAMf-jSmdNibSK+ffBOdcuVjyhmHFcfi5s4nQzctrS0dK889+FA@mail.gmail.com>
In-Reply-To: <CAMf-jSmdNibSK+ffBOdcuVjyhmHFcfi5s4nQzctrS0dK889+FA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/09/14 16:05, Pramod Gurav wrote:
>> >I think the correct fix is:
>> >
>> >diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
>> >index 5475374..4060c30 100644
>> >--- a/drivers/pinctrl/pinctrl-st.c
>> >+++ b/drivers/pinctrl/pinctrl-st.c
>> >@@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl
>> >*info,
>> >                                              gpio_irq, st_gpio_irq_handler);
>> >         }
>> >
>> >-       if (info->irqmux_base > 0 || gpio_irq > 0) {
>> >+       if (!IS_ERR(info->irqmux_base) || gpio_irq > 0) {
>> >                 err = gpiochip_irqchip_add(&bank->gpio_chip,
> But if I am not wrong in function st_pctl_probe_dt, This is already done:
>
> if (IS_ERR(info->irqmux_base))
>              return PTR_ERR(info->irqmux_base);
>
> That is the reason I thought there is no need to recheck the pointer
> info->irqmux_base.
> Am I misunderstanding something?

Ok, we want to add the irqchip only when there is a valid irqmux_base or 
a valid gpio_irq per bank.

As st_gpiolib_register_bank() is used by both types of irq wirings and 
it does not know if irqmux or gpio irq is in use, so we need this 
explicit check. Also we want to make sure that atleast one type is valid 
before adding irqchip.

If you just check for only gpio_irq in this code, you would miss the 
case where irqmux is used.

As Dan pointed you could check if irqmux_base is valid and not remove it 
totally. Removing it will *break* the irqmux support as I explained.

thanks,
srini



>> >&st_gpio_irqchip,
>> >                                            0, handle_simple_irq,
>> >                                            IRQ_TYPE_LEVEL_LOW);
>> >
>> >
