Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3JKLLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:11:55 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51801 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3JKLLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <1380635719-31171-1-git-send-email-zonque@gmail.com>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com>
Date: Fri, 11 Oct 2013 13:11:34 +0200
Message-ID: <CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Mack <zonque@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 3:55 PM, Daniel Mack <zonque@gmail.com> wrote:

> This patch adds a very simple driver that enables GPIO lines as wakeup
> sources. It only operates on information passed in via DT, and depends
> on CONFIG_OF && CONFIG_PM_SLEEP. It can for example be used to connect
> wake-on-LAN (WOL) signals or other electric wakeup networks.
>
> The driver accepts a list of GPIO nodes and claims them along with their
> interrupt line. During suspend, the interrupts will be enabled and
> selected as wakeup source. The driver doesn't do anything else with the
> GPIO lines, and will ignore occured interrupts silently.
>
> Signed-off-by: Daniel Mack <zonque@gmail.com>

This makes a weird kind of sense.
Hm hm hm.

But I really need the misc mainatiners' help here...
possibly also irqchip maintainers.

> +++ b/Documentation/devicetree/bindings/misc/gpio-wakeup.txt
> @@ -0,0 +1,16 @@
> +GPIO WAKEUP DRIVER BINDINGS
> +
> +Required:
> +
> +       compatible:     Must be "gpio-wakeup"
> +       gpios:          At list of GPIO nodes that are enabled as wakeup
> +                       sources.

Reword so this is OS independent. Describe what a wakeup source is
for example.

> +Example:
> +
> +       wake_up {
> +               compatible = "gpio-wakeup";
> +               gpios = <&gpio0 19 0>;
> +       };

This will not work if that GPIO chip is not capable of supporting
interrupts on that GPIO line right?

We have recently had a very long discussion about this: such
GPIO chips will also be marked "interrupt-controller" and you
should be able to just state interrupt-parent and
interrupts = <>; for this. (And it should accept an array.)

It *may* be that we have many GPIO drivers that do not accept
that you request an interrupt on them before you have done
request_gpio() followed by gpio_to_irq() on the pin. Then this
shall be treated like a bug and the GPIO driver fixed to handle
this. (That was the outcome of this discussion.)

Since what the driver will then eventually provide is to
flag an IRQ line as wakeup, I wonder if this should not just
simply go into the interrupt core, or atleast of/irq.c.

Yours,
Linus Walleij
