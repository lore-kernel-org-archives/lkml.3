Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3I2KP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 06:15:56 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:42474 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890Ab3I2KPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 06:15:53 -0400
Message-ID: <5247FCF5.9090501@atmel.com>
Date: Sun, 29 Sep 2013 18:12:05 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] PWM: atmel-pwm: use request/free instead of enable/disable
References: <1380312628-6564-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1380312628-6564-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 9/28/2013 04:10, Alexandre Belloni wrote:
> I found that disabling a pwm while it is at a low level will actually put it
> back at a high level. The main symptom is that leds-pwm is calling pwm_disable()
> after setting the duty cycle to 0. Hence, instead of getting a switched off LED,
> you get an LED lit up at full brightness.
>
> Solve that by using the request and free callbacks to enable and disable the
> pwm channels and the clock.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>
> This patch applies after:
>    [PATCH v4] PWM: atmel-pwm: add PWM controller driver
>
>   drivers/pwm/pwm-atmel.c | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 6af7a50..4526e71 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -209,7 +209,7 @@ static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>   	return 0;
>   }
>
> -static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +static int atmel_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
>   {
>   	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>   	int ret;
> @@ -225,23 +225,19 @@ static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>   	return 0;
>   }
>
> -static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +static void atmel_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
>   {
>   	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> -	u32 val;
>
>   	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
> -
> -	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
> -	if ((val & PWM_SR_ALL_CH_ON) == 0)
> -		clk_disable(atmel_pwm->clk);
> +	clk_disable(atmel_pwm->clk);
>   }
>
>   static const struct pwm_ops atmel_pwm_ops = {
>   	.config = atmel_pwm_config,
>   	.set_polarity = atmel_pwm_set_polarity,
> -	.enable = atmel_pwm_enable,
> -	.disable = atmel_pwm_disable,
> +	.request = atmel_pwm_request,
> +	.free = atmel_pwm_free,

This will cause pwmadd_chip failure.

Code from <drivers/pwm/core.c>, in function: pwmadd_chip()
---8>---
if (!chip || !chip->dev || !chip->ops || !chip->ops->config ||
     !chip->ops->enable || !chip->ops->disable)
     return -EINVAL;
---<8---

>   	.owner = THIS_MODULE,
>   };
>

Best Regards,
Bo Shen

