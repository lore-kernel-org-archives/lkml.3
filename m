Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3DWIvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:51:35 -0400
Received: from antcom.de ([188.40.178.216]:39038 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab3DWIve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:51:34 -0400
Message-ID: <51764B94.80700@antcom.de>
Date: Tue, 23 Apr 2013 10:51:32 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH RFT 2/2] pwm: lpc32xx: Don't change PWM_ENABLE
 bit in lpc32xx_pwm_config
References: <1366696891.28314.1.camel@phoenix> <1366696969.28314.3.camel@phoenix>
In-Reply-To: <1366696969.28314.3.camel@phoenix>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:02 AM, Axel Lin wrote:
> lpc32xx_pwm_config() is supposed to set duty_ns and period_ns,
> it should not change PWM_ENABLE bit.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Tested-by: Roland Stigge <stigge@antcom.de>

> ---
>  drivers/pwm/pwm-lpc32xx.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index 1a5075e..e936202 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -37,6 +37,7 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
>  	unsigned long long c;
>  	int period_cycles, duty_cycles;
> +	u32 val;
>  
>  	c = clk_get_rate(lpc32xx->clk) / 256;
>  	c = c * period_ns;
> @@ -68,8 +69,10 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  		c = 255;
>  	duty_cycles = 256 - c;
>  
> -	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
> -		lpc32xx->base + (pwm->hwpwm << 2));
> +	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
> +	val &= ~0xFFFF;
> +	val |= PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles);
> +	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
>  
>  	return 0;
>  }

