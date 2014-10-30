Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbaJ3A3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:29:25 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38892 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbaJ3A3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141029162105.GA29965@ti.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <CAAVeFuK4PaFbbYjUsvA-oO78P5qmQvyGqG+Ov4GLghoC=yPAoA@mail.gmail.com> <20141029162105.GA29965@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 30 Oct 2014 09:29:03 +0900
Message-ID: <CAAVeFu+ZMdMH4YQxUrzRaCRndxff_REOZHi3jVHyOTKGUMqTEQ@mail.gmail.com>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 1:21 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > +
>> >         if (status)
>> >                 goto fail;
>> >
>> > @@ -1742,6 +1757,72 @@ struct gpio_desc *__must_check __gpiod_get_index_optional(struct device *dev,
>> >  EXPORT_SYMBOL_GPL(__gpiod_get_index_optional);
>> >
>> >  /**
>> > + * gpiod_get_hog_index - obtain a GPIO from a multi-index GPIO hog
>> > + * @dev:       GPIO consumer
>> > + * @idx:       index of the GPIO to obtain
>> > + *
>> > + * This should only be used by the gpiochip_add to request/set GPIO initial
>> > + * configuration.
>> > + *
>> > + * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
>> > + */
>> > +struct gpio_desc *__must_check gpiod_get_hog_index(struct device *dev,
>> > +                                                  unsigned int idx)
>> > +{
>> > +       struct gpio_desc *desc = NULL;
>> > +       int err;
>> > +       unsigned long flags;
>> > +       const char *name;
>> > +
>> > +       /* Using device tree? */
>> > +       if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
>> > +               desc = of_get_gpio_hog(dev->of_node, idx, &name, &flags);
>> > +
>> > +       if (!desc)
>> > +               return ERR_PTR(-ENOTSUPP);
>> > +       else if (IS_ERR(desc))
>> > +               return desc;
>> > +
>> > +       dev_dbg(dev, "gpio-hog: GPIO:%d (%s) as %s%s\n",
>> > +               desc_to_gpio(desc), name, (flags&GPIOF_DIR_IN)?"input":"output",
>> > +               (flags&GPIOF_DIR_IN)?"":(flags&GPIOF_INIT_HIGH)?"/high":"/low");
>> > +
>>
>> ...
>
> I guess this means to remove the dev_dbg code?

No, it was just to delimitate the code which I suggested to factorize
into its own function below. :) This dev_dbg  is fine IMHO.
