Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaJAINR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:13:17 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59480 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaJAINL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:13:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Date: Wed, 01 Oct 2014 10:13:04 +0200
Message-ID: <2780318.hxubhI9Rvq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4835699.XutTNxriDg@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <4835699.XutTNxriDg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NAPkV9keFeFBP6hSzddPNdKmJNIUKMNedtcp3lCAg+/
 xQkEPG5TCgG8IKaOZDbeuUi5tyaG//8KKqP3G8P0MJk0eIH83K
 h9jwfdPUVWbLX4FfjTDN16eASssjuXT7Ojgeg+mFeaajzz7dTy
 a3MTEUhRQ3GCh3ZF0aVTpfO+uj9TKRTBf5bJXBN0OSWALCut+K
 osfczssd1BDjiAdznjlKPj8wTryG+fwTu7JwU+Ew/sz5z1cHp/
 hzJwEs1LBT9UBpsO8+W/227T0WGHbUWge8IvmbNMFVcsdMloWS
 6+cri5Y3cC3rBY1b+f158H1DRvk94LosJ7A5nUzJe0HgicR27u
 ZYDFVsHxRSiqfsBis61M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:17:02 Rafael J. Wysocki wrote:
> Index: linux-pm/drivers/leds/leds-gpio.c
> ===================================================================
> --- linux-pm.orig/drivers/leds/leds-gpio.c
> +++ linux-pm/drivers/leds/leds-gpio.c
> @@ -231,6 +231,13 @@ static const struct of_device_id of_gpio
>  
>  MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
>  
> +static const struct acpi_device_id acpi_gpio_leds_match[] = {
> +       { "PRP0001" }, /* Device Tree shoehorned into ACPI */
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match);
> +
>  static int gpio_led_probe(struct platform_device *pdev)
>  {
>         struct gpio_led_platform_data *pdata = dev_get_platdata(&pdev->dev);
> @@ -286,6 +293,7 @@ static struct platform_driver gpio_led_d
>                 .name   = "leds-gpio",
>                 .owner  = THIS_MODULE,
>                 .of_match_table = of_gpio_leds_match,
> +               .acpi_match_table = acpi_gpio_leds_match,
>         },
>  };

Is this something you'd have to do in every driver you want to support
_PRP based probing? For the ".acpi_match_table =" reference, I think
you could actually provide a generic acpi_device_id table exported from
core code that you refer to, so each driver just does

	.acpi_match_table = acpi_match_by_of_compatible,

(or whatever you want to call it).

Regarding the MODULE_DEVICE_TABLE, I suspect the above won't work the
way you are hoping for, because once you get to dozens or hundreds of
drivers doing this, each device will show up with the same string,
so udev will try to load all the modules that list "PRP0001". That
doesn't look right. With the code from patch 3, you can probably drop
the acpi MODULE_DEVICE_TABLE() entirely and get the correct behavior.

	Arnd
