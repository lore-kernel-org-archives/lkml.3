Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaDBFx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:53:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46505 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaDBFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:53:54 -0400
Date: Wed, 2 Apr 2014 07:53:50 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140402055350.GX17250@pengutronix.de>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:47:03 up 220 days, 15:17, 53 users,  load average: 0.04, 0.11,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 09:48:58AM +0100, Lothar Waﬂmann wrote:
> Change the pwm chip driver registration, so that a chip driver that
> supports polarity inversion can still be used with DTBs that don't
> provide the 'PWM_POLARITY' flag.
> 
> This is done to provide polarity inversion support for the pwm-imx
> driver without having to modify all existing DTS files.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  drivers/pwm/core.c |   46 ++++++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 30 deletions(-)
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index a804713..dc15543 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -131,12 +131,12 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
>  	return 0;
>  }
>  
> -struct pwm_device *
> -of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
> +struct pwm_device *of_pwm_xlate(struct pwm_chip *pc,
> +				const struct of_phandle_args *args)
>  {
>  	struct pwm_device *pwm;
>  
> -	if (pc->of_pwm_n_cells < 3)
> +	if (pc->of_pwm_n_cells < 2)
>  		return ERR_PTR(-EINVAL);
>  
>  	if (args->args[0] >= pc->npwm)
> @@ -148,6 +148,9 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
>  
>  	pwm_set_period(pwm, args->args[1]);
>  
> +	if (pc->of_pwm_n_cells < 3)
> +		return pwm;
> +
>  	if (args->args[2] & PWM_POLARITY_INVERTED)
>  		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
>  	else
> @@ -155,27 +158,14 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
>  
>  	return pwm;
>  }
> -EXPORT_SYMBOL_GPL(of_pwm_xlate_with_flags);
>  
> -static struct pwm_device *
> -of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
> +struct pwm_device *
> +of_pwm_xlate_with_flags(struct pwm_chip *pc,
> +			const struct of_phandle_args *args)
>  {
> -	struct pwm_device *pwm;
> -
> -	if (pc->of_pwm_n_cells < 2)
> -		return ERR_PTR(-EINVAL);
> -
> -	if (args->args[0] >= pc->npwm)
> -		return ERR_PTR(-EINVAL);
> -
> -	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
> -	if (IS_ERR(pwm))
> -		return pwm;
> -
> -	pwm_set_period(pwm, args->args[1]);
> -
> -	return pwm;
> +	return of_pwm_xlate(pc, args);
>  }
> +EXPORT_SYMBOL_GPL(of_pwm_xlate_with_flags);
>  
>  static void of_pwmchip_add(struct pwm_chip *chip)
>  {
> @@ -183,8 +173,11 @@ static void of_pwmchip_add(struct pwm_chip *chip)
>  		return;
>  
>  	if (!chip->of_xlate) {
> -		chip->of_xlate = of_pwm_simple_xlate;
> -		chip->of_pwm_n_cells = 2;
> +		chip->of_xlate = of_pwm_xlate;
> +		if (chip->ops->set_polarity)
> +			chip->of_pwm_n_cells = 3;
> +		else
> +			chip->of_pwm_n_cells = 2;

I think the presence of the set_polarity callback shouldn't influence
the number of cells the parser expects. As commented on 2/2 this doesn't
actually mean the device actually support polarity inversion. Also,
polarity inversion could still be done in software for hardware that
doesn't support it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
