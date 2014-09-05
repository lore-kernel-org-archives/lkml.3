Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaIEIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:25:06 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:65347 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIEIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <1409484115-1974-4-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409484115-1974-4-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:25:03 +0200
Message-ID: <CACRpkdadxr5Kibap3TsVmorSJzRBdKJ=j=vwM3mM7QaGpbJhJg@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 1:21 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch removes a call to panic function when gpiochio_irqchip_add
> fails and just returns the error to the calling function.
> Same return value is used to handle the error case and adds to lable
> to release resources on error.
>
> This also changes first argument to function at91_gpio_of_irq_setup from
> struct device_node to struct platform_device. Because The device_node
> argument was anyway not being used. Passed pdev so that on failure dev_err
> can use &pdev->dev and log can be associated with proper device.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
(...)

> @@ -1470,9 +1470,11 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
>                                    0,
>                                    handle_edge_irq,
>                                    IRQ_TYPE_EDGE_BOTH);
> -       if (ret)
> -               panic("at91_gpio.%d: couldn't allocate irq domain (DT).\n",
> +       if (ret) {
> +               dev_err(&pdev->dev, "at91_gpio.%d: couldn't allocate irq domain (DT).\n",
>                         at91_gpio->pioc_idx);
> +               return ret;
> +       }

If you're fixing this, also fix the error message. It's unable to allocate
a GPIOchip irqchip, not an irq domain. (Caused by other patch, but
please fix this if you're playing around here.)

Yours,
Linus Walleij
