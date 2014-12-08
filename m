Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaLHXfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:35:19 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15887 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaLHXfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:35:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,541,1413270000"; 
   d="scan'208";a="52562605"
Message-ID: <548635B1.5060705@broadcom.com>
Date: Mon, 8 Dec 2014 15:35:13 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, <linus.walleij@linaro.org>,
        <gnurou@gmail.com>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH] gpio: bcm-kona: memory corruption fix
References: <1418074473-10811-1-git-send-email-olof@lixom.net>
In-Reply-To: <1418074473-10811-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/8/2014 1:34 PM, Olof Johansson wrote:
> In one instance the base address of the internal controller state
> structure is passed into a function doing writel to an offset of
> the pointer passed in is used, instead of the register base.
>
> Once I found the bug, I also went back to check for other sparse
> warnings in the file, but found none. This one, however, triggered:
>
> drivers/gpio/gpio-bcm-kona.c:552:47: warning: incorrect type in argument 1 (different address spaces)
> drivers/gpio/gpio-bcm-kona.c:552:47:    expected void [noderef] <asn:2>*reg_base
> drivers/gpio/gpio-bcm-kona.c:552:47:    got struct bcm_kona_gpio *kona_gpio
> drivers/gpio/gpio-bcm-kona.c:556:47: warning: incorrect type in argument 1 (different address spaces)
> drivers/gpio/gpio-bcm-kona.c:556:47:    expected void [noderef] <asn:2>*reg_base
> drivers/gpio/gpio-bcm-kona.c:556:47:    got struct bcm_kona_gpio *kona_gpio
>
> As far as I can tell, this bug has been here for a long time and is
> not new, but I found it when hunting down another heisenbug on this
> platform.
>
> Not marking for stable since I am unaware of any upstream user of kona
> on a product that would benefit from it.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Ray Jui <rjui@broadcom.com>

> ---
>   drivers/gpio/gpio-bcm-kona.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
> index de0801e..d552cca 100644
> --- a/drivers/gpio/gpio-bcm-kona.c
> +++ b/drivers/gpio/gpio-bcm-kona.c
> @@ -549,11 +549,11 @@ static void bcm_kona_gpio_reset(struct bcm_kona_gpio *kona_gpio)
>   	/* disable interrupts and clear status */
>   	for (i = 0; i < kona_gpio->num_bank; i++) {
>   		/* Unlock the entire bank first */
> -		bcm_kona_gpio_write_lock_regs(kona_gpio, i, UNLOCK_CODE);
> +		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, i, UNLOCK_CODE);
>   		writel(0xffffffff, reg_base + GPIO_INT_MASK(i));
>   		writel(0xffffffff, reg_base + GPIO_INT_STATUS(i));
>   		/* Now re-lock the bank */
> -		bcm_kona_gpio_write_lock_regs(kona_gpio, i, LOCK_CODE);
> +		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, i, LOCK_CODE);
>   	}
>   }
>
>
