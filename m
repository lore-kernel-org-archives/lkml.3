Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaGWDKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:10:53 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52100 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaGWDKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140722201740.GA11459@roeck-us.net>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
 <1406013463-19218-4-git-send-email-acourbot@nvidia.com> <20140722201740.GA11459@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 23 Jul 2014 12:10:31 +0900
Message-ID: <CAAVeFuJAudOY-s3x38sv13SNo8zfofLWKOKBhKQPYAm1fAj4kw@mail.gmail.com>
Subject: Re: [PATCH 3/5] gpio: make gpiochip_get_desc() gpiolib-private
To: Guenter Roeck <linux@roeck-us.net>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 5:17 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Jul 22, 2014 at 04:17:41PM +0900, Alexandre Courbot wrote:
>> As GPIO descriptors are not going to remain unique anymore, having this
>> function public is not safe. Restrain its use to gpiolib since we have
>> no user outside of it.
>>
> If I implement a gpio chip driver built as module, and I want to use
> gpiochip_request_own_desc(), how am I supposed to get desc ?
>
> I understand that there is still gpio_to_desc(), but I would have thought
> that
>         desc = gpiochip_get_desc(chip, pin);
> would be better than
>         desc = gpio_to_desc(chip->base + pin);
>
> Not that it makes much of a difference for me, just asking.

Actually I was thinking of changing the prototype of
gpiochip_request_own_desc(), and your comment definitely strenghtens
that idea. gpiochip functions should not work with descriptors,
especially since we are going to switch to a multiple-consumer scheme
where there won't be any canonical descriptor anymore. Thus, how about
turning gpiochip_request_own_desc() into this:

struct gpio_desc *
gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum, const char *label);

which would basically do both the gpiochip_get_desc() and former
gpiochip_request_own_desc() in one call. I think it should satisfy
everybody and removes the need to have gpiochip_get_desc() (a not very
useful function by itself) exposed out of gpiolib.

I will send a patch taking care of this if you agree that makes sense.
