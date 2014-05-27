Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaE0Ndt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:33:49 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53104 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaE0Ndq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <1400864617-27909-1-git-send-email-berthe.ab@gmail.com>
References: <1400864617-27909-1-git-send-email-berthe.ab@gmail.com>
Date: Tue, 27 May 2014 15:33:45 +0200
Message-ID: <CACRpkdZg559ogf5koyxA_urM949ee-+upauYWQmo-sPUQn-g2w@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpiolib: set gpiochip_remove retval to void
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 7:03 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

> This avoids handling gpiochip remove error in device
> remove handler.
>
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

In general this is the right thing to do.

>         for (id = 0; id < chip->ngpio; id++) {
> -               if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
> -                       status = -EBUSY;
> -                       break;
> -               }
> -       }
> -       if (status == 0) {
> -               for (id = 0; id < chip->ngpio; id++)
> -                       chip->desc[id].chip = NULL;
> -
> -               list_del(&chip->list);
> +               if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
> +                       panic("gpiolib.c: gpiochip is still requested\n");

panic("gpio: removing gpiochip with gpios still requested\");
is more helpful.

But I want a patch that also removes *ALL* users of the return value
from this function in the *same* patch to avoid bisectability issues.

$ git grep gpiochip_remove

Then fix all of them or use coccinelle.

Yours,
Linus Walleij
