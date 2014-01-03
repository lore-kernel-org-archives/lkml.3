Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaACLHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:07:45 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:53258 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaACLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYyFXt1g-fL9dUTwQLnT4senUjvRpehc6yuQ9rV4ztwSA@mail.gmail.com>
References: <20131221104920.GA3626@rashika> <CACRpkdYyFXt1g-fL9dUTwQLnT4senUjvRpehc6yuQ9rV4ztwSA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 3 Jan 2014 20:07:22 +0900
Message-ID: <CAAVeFuJug5wNZrSr5UcP8w8E0a3iYF=bcNEzJgQaZ=u4CX8Daw@mail.gmail.com>
Subject: Re: [PATCH] drivers: Remove unused devm_*_put functions
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        josh@joshtriplett.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 10:07 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Dec 21, 2013 at 11:49 AM, Rashika Kheria
> <rashika.kheria@gmail.com> wrote:
>> -/**
>> - * devm_gpiod_put - Resource-managed gpiod_put()
>> - * @desc:      GPIO descriptor to dispose of
>> - *
>> - * Dispose of a GPIO descriptor obtained with devm_gpiod_get() or
>> - * devm_gpiod_get_index(). Normally this function will not be called as the GPIO
>> - * will be disposed of by the resource management code.
>> - */
>> -void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
>> -{
>> -       WARN_ON(devres_release(dev, devm_gpiod_release, devm_gpiod_match,
>> -               &desc));
>> -}
>> -EXPORT_SYMBOL(devm_gpiod_put);
>
> Alexandre what do you think about this? Can we think of a scenario
> where explicit garbage collection is going to be needed or should we
> remove this for now?

Sorry for the delayed reply, I quickly saw the patch and then the
holidays got in the way. :)

I think all these functions should be kept. It is true that they are
seldomly used, and that the purpose of devm is to garbage-collect
resources upon driver removal, but they might (actually, probably
will) become needed by someone at some point in the future. One
example I can think of is two drivers that collaborate to share the
same GPIO line. If they acquire the GPIO through devm_gpiod_get() they
will need devm_gpiod_put() to release it so the other driver can
acquire it.

On a more general note, devm_clk_put(), devm_regulator_put(),
devm_pinctrl_put() and probably others devm_*_put() functions are
actively used in the kernel, to  support the idea that a devm removal
function makes sense. That not all the subsystem-provided functions
are used by mainline drivers does not necessary mean they should be
removed, especially if they serve a purpose. We should keep our APIs
consistent and future-proof, not to mention out-of-tree drivers that
may use them.

So this patch is a nack as far as I'm concerned, not only the GPIO
part, but the whole of it.
