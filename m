Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaLBOZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:25:39 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61931 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLBOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:25:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141202002244.GB24551@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
	<1416527684-19017-2-git-send-email-bparrot@ti.com>
	<CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
	<20141202002244.GB24551@ti.com>
Date: Tue, 2 Dec 2014 15:25:36 +0100
Message-ID: <CACRpkdaVtkWXmf8ON=3Pa2CYZKWRw2am+ULfzsTBPmXjbP44PA@mail.gmail.com>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Parrot <bparrot@ti.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 1:22 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Alexandre Courbot <gnurou@gmail.com> wrote on Fri [2014-Nov-28 16:30:01 +0900]:
>> On Fri, Nov 21, 2014 at 8:54 AM, Benoit Parrot <bparrot@ti.com> wrote:

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

Yes, I think either we have separate nodes for each hogged line *OR*
we just put a list of hogs under the gpiochip, no special node at all.

The one-node-per-hog pattern has the upside of being usable
to also name the hogs. (Exporting them is dubious however!
I would add a special type of node for that.)

>> > +       if (err < 0)
>> > +               return err;
>> > +
>> > +       if (lflags & GPIO_ACTIVE_LOW)
>> > +               set_bit(FLAG_ACTIVE_LOW, &desc->flags);
>> > +       if (lflags & GPIO_OPEN_DRAIN)
>> > +               set_bit(FLAG_OPEN_DRAIN, &desc->flags);
>> > +       if (lflags & GPIO_OPEN_SOURCE)
>> > +               set_bit(FLAG_OPEN_SOURCE, &desc->flags);
>> > +
>> > +       /* No particular flag request, not really hogging then... */
>> > +       if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
>> > +               pr_warn("%s: GPIO %s: no hogging direction specified, bailing out\n",
>> > +                        __func__, name);
>> > +               err = -EINVAL;
>> > +               goto free_gpio;
>> > +       }
>> > +
>> > +       /* Process flags */
>> > +       if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
>> > +               err = gpiod_direction_output(desc,
>> > +                                            dflags & GPIOD_FLAGS_BIT_DIR_VAL);
>> > +       else
>> > +               err = gpiod_direction_input(desc);
>> > +
>> > +       if (err < 0) {
>> > +               pr_warn("%s: GPIO %s setting direction/value failed\n",
>> > +                        __func__, name);
>> > +               goto free_gpio;
>> > +       }
>>
>> I would suggest to factorize this code that is similar to the one
>> found in __gpiod_get_index(). Do all the DT parsing in a function that
>> just returns a descriptor and the
>
> I would tend to agree.
> But as Linus suggested I was trying to contain the changes to gpiolib_of.c only.

Yes I prefer we begin by supporting it in OF and then generalize it later
if more users (board files, ACPI) appear.

Not a big deal but I want to avoid big design up front unless it's
easy and a few alterations.
http://c2.com/cgi/wiki?BigDesignUpFront

Yours,
Linus Walleij
