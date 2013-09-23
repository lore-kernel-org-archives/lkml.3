Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3IWUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:15:52 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47120 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3IWUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 23 Sep 2013 22:15:48 +0200
Message-ID: <CACRpkdb35DouKsZ+9aWfQmER1vmAaK1dR7VXjoFHTLRR+hBezg@mail.gmail.com>
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 4:40 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> To use a GPIO pin as an interrupt line, two previous configurations
> have to be made:
>
> a) Map the GPIO pin as an interrupt line into the Linux irq space
> b) Enable the GPIO bank and configure the GPIO direction as input
>
> Most GPIO/IRQ chip drivers just create a mapping for every single
> GPIO pin with irq_create_mapping() on .probe so users usually can
> assume a) and only have to do b) by using the following sequence:
>
> gpio_request(gpio, "foo IRQ");
> gpio_direction_input(gpio);
>
> and then request a IRQ with:
>
> irq = gpio_to_irq(gpio);
> request_irq(irq, ...);

I guess I have to live with this approach, but I'd like to - if possible -
address my pet issue.

- It is OK that the HW get set up as GPIO input by the IRQ
  request function alone. (Through gpio_irq_type I guess).

- When a second caller calls omap_gpio_request() it should
  be OK as well, but only if the flags corresponds to the
  previously enabled input mode. Else it should be
  disallowed.

- The same should happen for _set_gpio_direction() if a pin
  previously set up for IRQ gets a request to be used as
  output.

If this cannot be tracked in the driver, it is certainly a candidate
for something that gpiolib should be doing. And then I'm open to
solutions to how we can do that.

If this needs to be applied pronto to fix the regression I'm
happy with that too, if we add a big boilerplate stating the above
problem and that it needs to be *fixed* at some point.

But in either case I want this to be tested on OMAP1 before
I apply it, as in a Tested-by tag.

Yours,
Linus Walleij
