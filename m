Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3ENMRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:17:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47477 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3ENMRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <518C369F.2070505@codeaurora.org>
References: <518C369F.2070505@codeaurora.org>
Date: Tue, 14 May 2013 14:17:33 +0200
Message-ID: <CACRpkdZR-QFv52GXh6a5gXGeLWVCz5GDGiEG9+uP5=7DQ7d4wg@mail.gmail.com>
Subject: Re: [RFC] pinctrl: Alternative to gpio to pinctrl pin mapping via DT
From: Linus Walleij <linus.walleij@linaro.org>
To: hanumant <hanumant@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 1:51 AM, hanumant <hanumant@codeaurora.org> wrote:

> 1) total pins exported to pinctrl subsystem = num pins of type A +
>                                                 num pins of type B
>
> 2) Each pin type is a child node of the pinctrl node in device tree.
>
> 3) The starting pin number of each pin type on the pinctroller depends on
> the order in which it occurs in the device tree when the pinctrl driver is
> parsing the device tree.
>
> 4) In this case, if a pintype supports gpio functionality, I could have
> informed the pinctrl system of the pin range, based on the run time
> determined start pin of that pin type. (This would have involved the use of
> the now deprecated pinctrl_add_gpio_range())
>
> 5) The current way of notifying the pinctrl system of gpio functionality is
> by using the gpio-ranges attribute in the gpio chip device tree node. But in
> my case, this would require me to know run time what pin range is going to
> correspond to my pin type.
> In the above example, i could assume since the pin type A occurs first
> in order, the gpio-ranges = 0 to 99 for the corresponding. But that would
> mean ensuring that your pin type occurs at a certain order in Device tree.
(...)
> The pinctrl_add_gpio_range() would have really helped here in specifying the
> gpio range at device tree parsing time.
>
> Is there a more elegant option rather then hard coding the order of pin
> types.?

I think I just cannot follow what you are trying to do or what kind of problem
you are facing, there is something wrong with the concepts or I'm just
stupid :-(

pinctrl_add_gpio_range() is one way to add pins at runtime which
unfortunately has the problem that i refers to the global GPIO number
space, which is something we want to avoid.

Instead we recommend that gpiochip_add_pin_range() from
<linux/gpio.h> is used, which us using numbering relative to the
pin controller and GPIO controller as well, which is nice, since
it removed the reliance on the global GPIO number space.

One way to use the latter function while having pin numbers
be dynamic would be to make sure you are doing a combined
driver, i.e. do not try to artificially split the pinctrl and GPIO drivers
in two files, instanstiate one driver container for all of this
hardware and let that driver control both GPIO and pinctrl. This
way all numbering is transparent between the pinctrl and GPIO
parts of the driver and the driver can use pinctrl_add_gpio_range()
or (better) the device-tree based standard bindings to do this.

See the drivers/pinctrl/pinctrl-abx500.c driver for such a combined
driver (albeit it is not using device tree).

Yours,
Linus Walleij
