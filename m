Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3H3BvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:51:00 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45929 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3H3Bu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkday6zMGSKvc4HTVKP3oezTdR5x_MHaK8nvDHWwu260B=A@mail.gmail.com>
References: <521CFB38.8080705@gmail.com> <CACRpkday6zMGSKvc4HTVKP3oezTdR5x_MHaK8nvDHWwu260B=A@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 30 Aug 2013 10:50:38 +0900
Message-ID: <CAAVeFuJCCpzRjzekMnzfDkou3VKJO5Hivvpn9Ez1jutGDzJg=g@mail.gmail.com>
Subject: Re: RFC: Bug in error handling in gpiolib.c
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tim Bird <tbird20d@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <tim.bird@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 2:45 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Aug 27, 2013 at 9:17 PM, Tim Bird <tbird20d@gmail.com> wrote:
>
>> Hi all,
>>
>> There appears to be a bug in the error handling in
>> drivers/gpi/gpiolib.c  In certain error cases
>> desc_to_gpio() is called to get the gpio number
>> for an error message, but this may happen on code
>> paths where desc->chip is NULL.  This causes a panic
>> on my system in gpiod_request(), as follows:
> (...)
>> Here's my patch:
>> Subject: [PATCH] gpio: avoid panic on NULL desc->chip in gpiod_request
>
> Patch applied. Unless we come up with something better,
> there is some parallel discussion on how to handle NULL
> descriptors.
>
> Alexandre: OK to apply this?

For this particular case I think the following would be preferable:

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ff0fd65..d900bf1 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1398,7 +1398,7 @@ static int gpiod_request(struct gpio_desc *desc,
const char *label)
        int                     status = -EPROBE_DEFER;
        unsigned long           flags;

-       if (!desc) {
+       if (!desc || !desc->chip) {
                pr_warn("%s: invalid GPIO\n", __func__);
                return -EINVAL;
        }
@@ -1406,8 +1406,6 @@ static int gpiod_request(struct gpio_desc *desc,
const char *label)
        spin_lock_irqsave(&gpio_lock, flags);

        chip = desc->chip;
-       if (chip == NULL)
-               goto done;

        if (!try_module_get(chip->owner))
                goto done;

Since we are going to fail because the chip is missing anyway, we can
as well do it from the start. A descriptor without a chip is invalid
anyway.

But this (and the other thread) stresses the fact that error handling
in gpiolib needs some more love. I'm convinced it can be simplified -
will try to look at it sometime soon.

Alex.
