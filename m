Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaBXC5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:57:31 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:42659 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBXC53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com>
Date: Mon, 24 Feb 2014 11:57:27 +0900
Message-ID: <CANqRtoSu7HMCkqeefBFdMgEPvVZNDEK8k7=1OHp1wf5GRizBvA@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-rcar: init at postcore level
From: Magnus Damm <magnus.damm@gmail.com>
To: vladimir.barinov@cogentembedded.com
Cc: SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

On Mon, Feb 24, 2014 at 1:37 AM,  <vladimir.barinov@cogentembedded.com> wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> This adds ability to use gpio API at board init_machine level.
>
> F.e. it can be used in the following situation.
> Many reference hardware has onboard switches that selects which periferals
> to connect to the system. The gpio input state from switches can be used
> in choosing platform devices runtime in board code instead of ifdefs/defconfig
> changes.
>
> Signed-off-by: <vladimir.barinov@cogentembedded.com>
>
> ---
>  drivers/gpio/gpio-rcar.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> Index: build/drivers/gpio/gpio-rcar.c
> ===================================================================
> --- build.orig/drivers/gpio/gpio-rcar.c 2014-02-22 23:21:51.456229152 +0400
> +++ build/drivers/gpio/gpio-rcar.c      2014-02-22 23:21:52.320229133 +0400
> @@ -485,7 +485,17 @@
>         }
>  };
>
> -module_platform_driver(gpio_rcar_device_driver);
> +static int __init gpio_rcar_init(void)
> +{
> +       return platform_driver_register(&gpio_rcar_device_driver);
> +}
> +postcore_initcall(gpio_rcar_init);
> +
> +static void __exit gpio_rcar_exit(void)
> +{
> +       platform_driver_unregister(&gpio_rcar_device_driver);
> +}
> +module_exit(gpio_rcar_exit);
>
>  MODULE_AUTHOR("Magnus Damm");
>  MODULE_DESCRIPTION("Renesas R-Car GPIO Driver");

Hi Vladimir,

Thanks for your help. Good to see that you are working on enabling the
dual role USB port on Koelsch.

Your current board code is checking some DIP switch value during boot,
and that kind of early use of GPIO would require a change in the probe
order like this patch implements. I do however believe that we should
not implement checking during boot like this.

If you for instance check the legacy Lager USBHS DIP switch code that
runs during driver probe() then that can run can use GPIO without the
need for a change like this. So your GPIO user code needs to be
adjusted.

So this patch will receive a NAK from me I'm afraid.

Thanks,

/ magnus
