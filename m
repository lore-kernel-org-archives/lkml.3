Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3I2PyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:54:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50964 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234Ab3I2PyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:54:17 -0400
Message-ID: <52484D1A.20402@free-electrons.com>
Date: Sun, 29 Sep 2013 17:54:02 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PWM: atmel-pwm: use request/free instead of enable/disable
References: <1380312628-6564-1-git-send-email-alexandre.belloni@free-electrons.com> <5247FCF5.9090501@atmel.com>
In-Reply-To: <5247FCF5.9090501@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/2013 12:12, Bo Shen wrote:
> Hi Alexandre,
>
> On 9/28/2013 04:10, Alexandre Belloni wrote:
>> I found that disabling a pwm while it is at a low level will actually
>> put it
>> back at a high level. The main symptom is that leds-pwm is calling
>> pwm_disable()
>> after setting the duty cycle to 0. Hence, instead of getting a
>> switched off LED,
>> you get an LED lit up at full brightness.
>>
>> Solve that by using the request and free callbacks to enable and
>> disable the
>> pwm channels and the clock.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>
>> This patch applies after:
>>    [PATCH v4] PWM: atmel-pwm: add PWM controller driver
>>
>>   drivers/pwm/pwm-atmel.c | 14 +++++---------
>>   1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
>> index 6af7a50..4526e71 100644
>> --- a/drivers/pwm/pwm-atmel.c
>> +++ b/drivers/pwm/pwm-atmel.c
>> @@ -209,7 +209,7 @@ static int atmel_pwm_set_polarity(struct pwm_chip
>> *chip, struct pwm_device *pwm,
>>       return 0;
>>   }
>>
>> -static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device
>> *pwm)
>> +static int atmel_pwm_request(struct pwm_chip *chip, struct
>> pwm_device *pwm)
>>   {
>>       struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>>       int ret;
>> @@ -225,23 +225,19 @@ static int atmel_pwm_enable(struct pwm_chip
>> *chip, struct pwm_device *pwm)
>>       return 0;
>>   }
>>
>> -static void atmel_pwm_disable(struct pwm_chip *chip, struct
>> pwm_device *pwm)
>> +static void atmel_pwm_free(struct pwm_chip *chip, struct pwm_device
>> *pwm)
>>   {
>>       struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> -    u32 val;
>>
>>       atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
>> -
>> -    val = atmel_pwm_readl(atmel_pwm, PWM_SR);
>> -    if ((val & PWM_SR_ALL_CH_ON) == 0)
>> -        clk_disable(atmel_pwm->clk);
>> +    clk_disable(atmel_pwm->clk);
>>   }
>>
>>   static const struct pwm_ops atmel_pwm_ops = {
>>       .config = atmel_pwm_config,
>>       .set_polarity = atmel_pwm_set_polarity,
>> -    .enable = atmel_pwm_enable,
>> -    .disable = atmel_pwm_disable,
>> +    .request = atmel_pwm_request,
>> +    .free = atmel_pwm_free,
>
> This will cause pwmadd_chip failure.
>
> Code from <drivers/pwm/core.c>, in function: pwmadd_chip()
> ---8>---
> if (!chip || !chip->dev || !chip->ops || !chip->ops->config ||
>     !chip->ops->enable || !chip->ops->disable)
>     return -EINVAL;
> ---<8---
>

You are right, I tested with dummy pwm_enable/pwm_disable functions and
removed them before sending the patch, thinking they weren't needed.
I'll respin that patch.

>>       .owner = THIS_MODULE,
>>   };
>>
>
> Best Regards,
> Bo Shen
>


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

