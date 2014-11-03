Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaKCPdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:33:18 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58210 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaKCPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141031132005.GB1273@saruman>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
	<1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
	<20141013191405.GB29810@saruman>
	<20141013192404.GB4034@psi-dev26.jf.intel.com>
	<20141013192632.GC29810@saruman>
	<20141013193618.GD29810@saruman>
	<CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
	<20141028144249.GD8123@saruman>
	<CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
	<20141031132005.GB1273@saruman>
Date: Mon, 3 Nov 2014 16:33:15 +0100
Message-ID: <CACRpkdY8wPbfx-1fZ_PbY=F_+tRMg_Xe9B9uFKO5AfE5P7PB0w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> [Me]

>> But another way to get rid of the dilemma is to set
>> .suppress_bind_attrs = true on the .driver field of the
>> device driver. The one can't unbind it through sysfs anymore.
>>
>>         .driver = {
>>                 .name   = "foo",
>>                 .suppress_bind_attrs = true,
>>         },
>>
>> So one of them need to be done.
>>
>> I suspect this is a kind of common problem...
>
> so instead of taking of taking a three-liner which just makes sure this
> can be used as "intended" you prefer to:
>
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e12e5b0..254ba81 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -587,16 +587,6 @@ static const struct acpi_device_id byt_gpio_acpi_match[] = {
>  };
>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
>
> -static int byt_gpio_remove(struct platform_device *pdev)
> -{
> -       struct byt_gpio *vg = platform_get_drvdata(pdev);
> -
> -       pm_runtime_disable(&pdev->dev);
> -       gpiochip_remove(&vg->chip);
> -
> -       return 0;
> -}
> -
>  static struct platform_driver byt_gpio_driver = {
>         .probe          = byt_gpio_probe,
>         .remove         = byt_gpio_remove,
> @@ -605,6 +595,7 @@ static struct platform_driver byt_gpio_driver = {
>                 .owner  = THIS_MODULE,
>                 .pm     = &byt_gpio_pm_ops,
>                 .acpi_match_table = ACPI_PTR(byt_gpio_acpi_match),
> +               .suppress_bind_attrs = true,
>         },
>  };

I don't know, if the driver *really* cannot be removed from sysfs
it is actually the right solution don't you think?

Else we're just leaving a nicely designed self-destruct
mechanism around.

Yours,
Linus Walleij
