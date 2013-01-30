Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3A3UKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:10:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59140 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3A3UKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:10:33 -0500
Message-ID: <51097E35.6080100@wwwdotorg.org>
Date: Wed, 30 Jan 2013 13:10:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] pinctrl/abx500: destroy mutex if returning early
 due to error
References: <1359574822-15729-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1359574822-15729-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 12:40 PM, Linus Walleij wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> Current failure path neglects to mutex_destroy() before returning
> an error due to an invalid parameter or an error received from
> gpiochip_add(). This patch aims to remedy that behaviour.

> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c

> @@ -1155,11 +1155,13 @@ static int abx500_gpio_probe(struct platform_device *pdev)
>  	default:
>  		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
>  				(int) platid->driver_data);
> +		mutex_destroy(&pct->lock);
>  		return -EINVAL;

Especially given there's already a label out_free which performs this
mutex_destroy(), those last two lines would be better as:

ret = -EINVAL;
goto out_free;

>  	}
>  
>  	if (!pct->soc) {
>  		dev_err(&pdev->dev, "Invalid SOC data\n");
> +		mutex_destroy(&pct->lock);
>  		return -EINVAL;

Same there.

>  	}
>  
> @@ -1176,6 +1178,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
>  	ret = gpiochip_add(&pct->chip);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
> +		mutex_destroy(&pct->lock);
>  		goto out_rem_irq;

And here, just change the goto target to out_free rather than adding the
mutex_destroy() call.

