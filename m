Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3GHEfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 00:35:50 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:64757 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3GHEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <201307051751.20729.arnd@arndb.de>
References: <201307051751.20729.arnd@arndb.de>
Date: Mon, 8 Jul 2013 10:05:48 +0530
Message-ID: <CAK9yfHzVtQR1=cCiE3Se0FUUF68GEK5UeYE2gtOLZpaXaODVvQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: propagate errors from regulator_enable() to pxamci
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Mike Rapoport <mike@compulab.co.il>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 July 2013 21:21, Arnd Bergmann <arnd@arndb.de> wrote:
> The em_x270_mci_setpower() and em_x270_usb_hub_init() functions
> call regulator_enable(), which may return an error that must
> be checked.
>
> This changes the em_x270_usb_hub_init() function to bail out
> if it fails, and changes the pxamci_platform_data->setpower
> callback so that the a failed em_x270_mci_setpower call
> can be propagated by the pxamci driver into the mmc core.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Chris Ball <cjb@laptop.org>
>
> diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
> index f6726bb..f8062e4 100644
> --- a/arch/arm/mach-pxa/em-x270.c
> +++ b/arch/arm/mach-pxa/em-x270.c
> @@ -477,16 +477,24 @@ static int em_x270_usb_hub_init(void)
>         /* USB Hub power-on and reset */
>         gpio_direction_output(usb_hub_reset, 1);
>         gpio_direction_output(GPIO9_USB_VBUS_EN, 0);
> -       regulator_enable(em_x270_usb_ldo);
> +       err = regulator_enable(em_x270_usb_ldo);
> +       if (err)
> +               goto err_free_rst_gpio;
> +
>         gpio_set_value(usb_hub_reset, 0);
>         gpio_set_value(usb_hub_reset, 1);
>         regulator_disable(em_x270_usb_ldo);
> -       regulator_enable(em_x270_usb_ldo);
> +       if (err)
> +               goto err_free_rst_gpio;

Shouldn't this check be after the below (regulator_enable) statement?

> +
> +       err = regulator_enable(em_x270_usb_ldo);
>         gpio_set_value(usb_hub_reset, 0);
>         gpio_set_value(GPIO9_USB_VBUS_EN, 1);
>
>         return 0;
>
> +err_free_rst_gpio:
> +       gpio_free(usb_hub_reset);
>  err_free_vbus_gpio:
>         gpio_free(GPIO9_USB_VBUS_EN);
>  err_free_usb_ldo:
> @@ -592,7 +600,7 @@ err_irq:
>         return err;
>  }

-- 
With warm regards,
Sachin
