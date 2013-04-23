Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3DWIvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:51:19 -0400
Received: from antcom.de ([188.40.178.216]:39012 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab3DWIvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:51:17 -0400
Message-ID: <51764B80.80200@antcom.de>
Date: Tue, 23 Apr 2013 10:51:12 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH RFT 1/2] pwm: lpc32xx: Properly set PWM_ENABLE
 bit in lpc32xx_pwm_[enable|disable]
References: <1366696891.28314.1.camel@phoenix>
In-Reply-To: <1366696891.28314.1.camel@phoenix>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:01 AM, Axel Lin wrote:
> According to the LPC32x0 User Manual [1]:
> 
> For both PWM1 and PWM2 Control Registers:
> BIT 31:
> This bit gates the PWM_CLK signal and enables the external output pin
> to the PWM_PIN_STATE logical level.
> 
> 0 = PWM disabled. (Default)
> 1 = PWM enabled
> 
> So in lpc32xx_pwm_enable(), we should set PWM_ENABLE bit.
> In lpc32xx_pwm_disable(), we should just clear PWM_ENABLE bit rather than
> write 0 to the register which will also clear PWMx_RELOADV and PWMx_DUTY bits.
> 
> [1] http://www.nxp.com/documents/user_manual/UM10326.pdf
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Tested-by: Roland Stigge <stigge@antcom.de>

> ---
> Hi,
> I don't have this hardware handy so I'd appreciate if someone can test this
> patch serial.
> 
> This patch serial was sent on https://lkml.org/lkml/2013/3/30/104
> Seems no feedback so far.
> So I just try again, maybe someone can help testing it.
> Thanks,
> Axel
> 
>  drivers/pwm/pwm-lpc32xx.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index b3f0d0d..1a5075e 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -77,15 +77,29 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>  {
>  	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
> +	u32 val;
> +	int ret;
> +
> +	ret = clk_enable(lpc32xx->clk);
> +	if (ret)
> +		return ret;
>  
> -	return clk_enable(lpc32xx->clk);
> +	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
> +	val |= PWM_ENABLE;
> +	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
> +
> +	return 0;
>  }
>  
>  static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>  {
>  	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
> +	u32 val;
> +
> +	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
> +	val &= ~PWM_ENABLE;
> +	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
>  
> -	writel(0, lpc32xx->base + (pwm->hwpwm << 2));
>  	clk_disable(lpc32xx->clk);
>  }
>  

