Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaIYBuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:50:23 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:62855 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751636AbaIYBuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:50:22 -0400
Message-ID: <542374D3.3080308@atmel.com>
Date: Thu, 25 Sep 2014 09:50:11 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Nikolaus Voss <n.voss@weinmann-emt.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: atmel-pwm: fix calculation of prescale value
References: <20140924055138.477E540656@mail.steuer-voss.de>
In-Reply-To: <20140924055138.477E540656@mail.steuer-voss.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikolaus Voss,

On 09/23/2014 09:30 PM, Nikolaus Voss wrote:
> The prescale value used for calculating the period was incremented
> afterwards, thus the resulting prescale value is by one too high.
> This resulted in a pwm frequency only half as high as requested.
>
> This patch moves the 64 bit division out of the prescale loop to
> correct the above issue and make the calculation more efficient.

Thanks for your patch.

> Signed-off-by: Nikolaus Voss <n.voss@weinmann-emt.de>

Tested-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Bo Shen <voice.shen@atmel.com>

> ---
>   drivers/pwm/pwm-atmel.c | 24 +++++++++++-------------
>   1 file changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 6e700a5..ff17b5d 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -102,7 +102,7 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>   			    int duty_ns, int period_ns)
>   {
>   	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> -	unsigned long clk_rate, prd, dty;
> +	unsigned long prd, dty;
>   	unsigned long long div;
>   	unsigned int pres = 0;
>   	u32 val;
> @@ -113,20 +113,18 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>   		return -EBUSY;
>   	}
>
> -	clk_rate = clk_get_rate(atmel_pwm->clk);
> -	div = clk_rate;
> +	/* Calculate the period cycles and prescale value */
> +	div = (unsigned long long)clk_get_rate(atmel_pwm->clk) * period_ns;
> +	do_div(div, (int)1e9);
>
> -	/* Calculate the period cycles */
>   	while (div > PWM_MAX_PRD) {
> -		div = clk_rate / (1 << pres);
> -		div = div * period_ns;
> -		/* 1/Hz = 100000000 ns */
> -		do_div(div, 1000000000);
> -
> -		if (pres++ > PRD_MAX_PRES) {
> -			dev_err(chip->dev, "pres exceeds the maximum value\n");
> -			return -EINVAL;
> -		}
> +		div >>= 1;
> +		++pres;
> +	}
> +
> +	if (pres > PRD_MAX_PRES) {
> +		dev_err(chip->dev, "pres exceeds the maximum value\n");
> +		return -EINVAL;
>   	}
>
>   	/* Calculate the duty cycles */
>

Best Regards,
Bo Shen
