Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3F2XfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:35:04 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50662 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3F2XfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <1372247816-5590-1-git-send-email-simon.guinot@sequanux.org>
References: <1372247816-5590-1-git-send-email-simon.guinot@sequanux.org>
Date: Sun, 30 Jun 2013 01:35:00 +0200
Message-ID: <CACRpkda=BBo+yUcUorYQQasKaF68neSz8cVmq3PcwLGPY_FjtA@mail.gmail.com>
Subject: Re: [PATCH] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 1:56 PM, Simon Guinot <simon.guinot@sequanux.org> wrote:

> This patch adds support for the GPIOs found on the Fintek Super-I/O
> chips F71882FG and F71889F.
>
> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>

Please be more elaborate in the commit message. What kind of beast
is a Super-I/O chip? Which architecture is this? Some SoC?
ISA card? etc. References are made to ACPI so I'm just half-guessing...

> +++ b/drivers/gpio/gpio-f7188x.c

> +#define gpio_oe_reg(base) (base + 0)
> +#define gpio_od_reg(base) (base + 1)
> +#define gpio_st_reg(base) (base + 2)
> +#define gpio_de_reg(base) (base + 3)

What are these four things?

Output enable, open drain, ...?

> +static int __init
> +f7188x_gpio_device_add(const struct f7188x_sio *sio)
> +{
> +       int err;
> +
> +       f7188x_gpio_pdev = platform_device_alloc(DRVNAME, -1);
> +       if (!f7188x_gpio_pdev)
> +               return -ENOMEM;
> +
> +       err = platform_device_add_data(f7188x_gpio_pdev,
> +                                      sio, sizeof(*sio));
> +       if (err) {
> +               pr_err(DRVNAME "Platform data allocation failed\n");
> +               goto err;
> +       }
> +
> +       err = platform_device_add(f7188x_gpio_pdev);
> +       if (err) {
> +               pr_err(DRVNAME "Device addition failed\n");
> +               goto err;
> +       }
> +
> +       return 0;
> +
> +err:
> +       platform_device_put(f7188x_gpio_pdev);
> +
> +       return err;
> +}

You need to explain with some comment here what is happening
here. You auto-probe then spawn some devices?

> +static struct platform_driver f7188x_gpio_driver = {
> +       .driver = {
> +               .owner  = THIS_MODULE,
> +               .name   = DRVNAME,
> +       },
> +       .probe          = f7188x_gpio_probe,
> +       .remove         = f7188x_gpio_remove,
> +};
> +
> +static int __init f7188x_gpio_init(void)
> +{
> +       int err;
> +       struct f7188x_sio sio;
> +
> +       if (f7188x_find(0x2e, &sio) &&
> +           f7188x_find(0x4e, &sio))
> +               return -ENODEV;

This looks like the life on the ISA-bus. Is that not dangerous?

> +
> +       err = platform_driver_register(&f7188x_gpio_driver);
> +       if (!err) {
> +               err = f7188x_gpio_device_add(&sio);
> +               if (err)
> +                       platform_driver_unregister(&f7188x_gpio_driver);
> +       }
> +
> +       return err;
> +}
> +subsys_initcall(f7188x_gpio_init);

And this is called unconditionally. Don't you get hints from
ACPI (given you include that header) as to whether this needs
to be registered or not?

It looks quite backwards. Isn't there *any* way to tell if the
system actually has this thing?

Yours,
Linus Walleij
