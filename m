Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3GHSqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:46:53 -0400
Received: from bosmailout03.eigbox.net ([66.96.185.3]:39149 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3GHSqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:46:52 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 14:46:52 EDT
X-Authority-Analysis: v=2.0 cv=bNyU0YCZ c=1 sm=1
 a=iRJo5KgT9k+0NMKN1UEGqQ==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=UC0SgWyaOEMA:10 a=8nJEP1OIZ-IA:10 a=XRpIeIZNc2sA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=t7CeM3EgAAAA:8 a=wggVRkVUAAAA:8
 a=pGLkceISAAAA:8 a=Op-mwl0xAAAA:8 a=KhRK3GZuga8TiTxqRmAA:9 a=wPNLvfGTeEIA:10
 a=JTMqrY5UvyEA:10 a=2e6ZYRoF4I4A:10 a=MSl-tDqOz04A:10 a=d4CUUju0HPYA:10
 a=9UqFsMnAB6EOkiq4MrOclQ==:117
X-EN-OrigOutIP: 10.20.18.19
X-EN-IMPSID: xtYw1l0050QhFXN01tYwky
Message-ID: <51DAFA21.8060708@yahoo.es>
Date: Tue, 09 Jul 2013 01:42:57 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Mike Rapoport <mike@compulab.co.il>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: pxa: propagate errors from regulator_enable() to
 pxamci
References: <201307051751.20729.arnd@arndb.de>
In-Reply-To: <201307051751.20729.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.144
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 7/5/2013 11:51 PM, Arnd Bergmann wrote:
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
>  	/* USB Hub power-on and reset */
>  	gpio_direction_output(usb_hub_reset, 1);
>  	gpio_direction_output(GPIO9_USB_VBUS_EN, 0);
> -	regulator_enable(em_x270_usb_ldo);
> +	err = regulator_enable(em_x270_usb_ldo);
> +	if (err)
> +		goto err_free_rst_gpio;
> +
>  	gpio_set_value(usb_hub_reset, 0);
>  	gpio_set_value(usb_hub_reset, 1);
>  	regulator_disable(em_x270_usb_ldo);
> -	regulator_enable(em_x270_usb_ldo);
> +	if (err)
> +		goto err_free_rst_gpio;
> +
> +	err = regulator_enable(em_x270_usb_ldo);

Didn't you mean the other way around:

 	regulator_disable(em_x270_usb_ldo);
-	regulator_enable(em_x270_usb_ldo);
+	err = regulator_enable(em_x270_usb_ldo);
+	if (err)
+		goto err_free_rst_gpio;
+

?

Hein

>  	gpio_set_value(usb_hub_reset, 0);
>  	gpio_set_value(GPIO9_USB_VBUS_EN, 1);
>
>  	return 0;
>
> +err_free_rst_gpio:
> +	gpio_free(usb_hub_reset);
>  err_free_vbus_gpio:
>  	gpio_free(GPIO9_USB_VBUS_EN);
>  err_free_usb_ldo:
> @@ -592,7 +600,7 @@ err_irq:
>  	return err;
>  }
> <snip>

