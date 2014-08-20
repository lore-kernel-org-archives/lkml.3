Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaHTITS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:19:18 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:53296 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHTITP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:19:15 -0400
Date: Wed, 20 Aug 2014 09:19:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Drake <drake@endlessm.com>, Tobias Jakobi <Liquid.Acid@gmx.net>,
        Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH] mfd: max77686: make interrupts support optional
Message-ID: <20140820081909.GH4266@lee--X1>
References: <1408516009-22106-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408516009-22106-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Marek Szyprowski wrote:

> Commit 6f1c1e71d93 ("mfd: max77686: Convert to use regmap_irq") broke
> support for boards, which provide no irq for MAX 77686 PMIC. In such
> case, not all functions of PMIC are available, but the driver still
> should at least handle voltage regulators instead of failing to init.
> This patch restores previous behavior.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> Hello,
> 
> This patch fixes booting issues with recently merged support for
> Exynos4412 based Odroid X2/U3 boards. See
> http://www.spinics.net/lists/linux-samsung-soc/msg35773.html
> thread for more details.
> 
> Best regards
> Marek Szyprowski
> Samsung R&D Institute Poland
> ---
>  drivers/mfd/max77686.c | 46 +++++++++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 86e552348db4..525718c448c8 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c

[...]

> @@ -357,8 +363,10 @@ static int max77686_i2c_remove(struct i2c_client *i2c)
>  
>  	mfd_remove_devices(max77686->dev);
>  
> -	regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
> -	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
> +	if (max77686->irq)
> +		regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
> +	if (max77686->irq)
> +		regmap_del_irq_chip(max77686->irq, max77686->irq_data);

Looks like you rushed this patch and went a bit crazy with
copy-paste. :)

Please put these two regmap_del_irq_chip()'s as results of the same
conditional i.e:

  if (max77686->irq) {
	  regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
	  regmap_del_irq_chip(max77686->irq, max77686->irq_data);
  }

>  
>  	if (max77686->type == TYPE_MAX77686)
>  		i2c_unregister_device(max77686->rtc);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
