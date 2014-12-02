Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaLBOKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:10:33 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52214 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaLBOK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:10:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141202002244.GB24551@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com> <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141202002244.GB24551@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 2 Dec 2014 23:10:07 +0900
Message-ID: <CAAVeFuJWPvdmO_KPXP2LrkAy4SQDZ+f7pvE6U8r7gPH+jE3Lrw@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 9:22 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > +       }
>> > +
>> > +       if (tmp > MAX_PHANDLE_ARGS) {
>> > +               desc = ERR_PTR(-EINVAL);
>> > +               goto out;
>> > +       }
>> > +
>> > +       gg_data.gpiospec.args_count = tmp;
>> > +       gg_data.gpiospec.np = chip_np;
>> > +       for (i = 0; i < tmp; i++) {
>> > +               ret = of_property_read_u32(np, "gpios",
>> > +                                          &gg_data.gpiospec.args[i]);
>> > +               if (ret) {
>> > +                       desc = ERR_PTR(ret);
>> > +                       goto out;
>> > +               }
>> > +       }
>> > +
>> > +       gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
>>
>> This seems to work but only supports one GPIO per hog node. It would
>> be nice to be able to specify several GPIOs to which the same settings
>> need to be applied.
>
> This is on purpose following Linus Walleij's comment.

Could you point me to his comment? My bad for not remembering what he
said, but I'd like to understand why.

>> Using this function means that a GPIO chip module cannot be unloaded
>> if it uses GPIO hogs. Is it the intended behavior? If not, please use
>> gpiochip_request_own_desc() instead, and make sure to call
>> gpiochip_free_own_desc() for each hog when the driver is unloaded.
>
> So I guess we could add a undo_gpio_hog() function and hook it up under of_gpiochip_remove().
> Now instead of maintaining a seperate structure just to keep track of hogged descriptor,
> would it be acceptable to add a new "gpio_desc.flags" value in gpiolib.h says:
>
>    #define FLAG_GPIO_IS_HOGGED 10
>
> And key on that at removal time instead of creating a list and having to maintain that?

Definitely, that would be even better I think.

>> I would suggest to factorize this code that is similar to the one
>> found in __gpiod_get_index(). Do all the DT parsing in a function that
>> just returns a descriptor and the
>
> I would tend to agree.
> But as Linus suggested I was trying to contain the changes to gpiolib_of.c only.

If we add a FLAG_GPIO_IS_HOGGED and undo the hogs when the chip is
unloaded, I would say that this becomes a gpiolib feature. Moving it
here would also allow non-DT GPIO providers to implement hogs (it
should be particularly easy to implement for platform data). Linus, do
you agree?
