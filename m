Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3LLOip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:38:45 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36533 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3LLOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <52A57E55.40808@atmel.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
	<52A57E55.40808@atmel.com>
Date: Thu, 12 Dec 2013 15:38:42 +0100
Message-ID: <CACRpkdZCqgfokNzmG-Jmrf3k-a5XFUg=e0c6kCY1DcnBJnfJtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 9:24 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

>> -       dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__,
>> __LINE__, pin_id, *config);
>> +       *config = 0;
>> +       dev_dbg(info->dev, "%s:%d, pin_id=%d", __func__, __LINE__,
>> pin_id);
>>         pio = pin_to_controller(info, pin_to_bank(pin_id));
>>         pin = pin_id % MAX_NB_GPIO_PER_BANK;
>
>
> Beyond this patch, I must say that I am puzzled by this function.
>
> What I read from the prototype documentation and what I see in different
> implementations is different...


Yeah, we need to fix this mess.

> Linus, can we have a review of this function because it seems not in line
> with what is used for u300 (but on the other hand looks like the what is
> returned by pinctrl-exynos5440.c driver for example).

It is supposed to read out one config at the time, if and only if used
with the generic pin config.

Typically:

enum pin_config_param param = (enum pin_config_param) *config;

switch (param) {
    case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
            *config = 0;
            if (biasmode)
                    return 0;
            else
                    return -EINVAL;
            break;
(...)

return -ENOTSUPP;

However AT91 is *not* using generic pin config, so the semantics of
this call is driver-dependent. In your case the implementation get all
the configs at once, which is an efficient shortcut if you don't need
to be general and enumerat all possible configs.

> What would be the consequences if we change this function's behavior: I mean
> use of -EINVAL for pin configuration "available but disabled" as said in
> include/linux/pinctrl/pinconf.h?

That code will propagate back ... I guess you'd have to test it :-/

Yours,
Linus Walleij
