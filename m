Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaLCJS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:18:57 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44493 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbaLCJSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:18:53 -0500
From: Ajit Pal SINGH <ajitpal.singh@st.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime COQUELIN <maxime.coquelin@st.com>
Date: Wed, 3 Dec 2014 17:18:42 +0800
Subject: RE: [PATCH] pwm: sti: Maintain a bitmap of configured devices
Thread-Topic: [PATCH] pwm: sti: Maintain a bitmap of configured devices
Thread-Index: Ac/9ntWQeiAgSz+2RhGQzdMvaeVKhwROzSBA
Message-ID: <7C5AEAE2DCC6B24D92612A29E172F04A59034539BD@EAPEX1MAIL2.st.com>
References: <ajitpal.singh@st.com>
 <1415702267-3471-1-git-send-email-ajitpal.singh@st.com>
In-Reply-To: <1415702267-3471-1-git-send-email-ajitpal.singh@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-03_05:2014-12-02,2014-12-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Can you please have a look at this patch.

Regards
Ajitpal Singh

> -----Original Message-----
> From: Ajit Pal SINGH
> Sent: Tuesday, November 11, 2014 4:08 PM
> To: thierry.reding@gmail.com; linux-pwm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Maxime COQUELIN
> Cc: Ajit Pal SINGH
> Subject: [PATCH] pwm: sti: Maintain a bitmap of configured devices
> 
> This patch introduces a bitmap which is used to keep track of the pwm channels
> which have been configured in a pwm chip.
> 
> The method used earlier to find the number of configured channels, was to count
> the pwmdevices with PWMF_REQUESTED field set and period value configured.
> This was not correct and failed when of_pwm_get()/pwm_get() and then
> pwm_config() was used.
> 
> Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
> ---
>  drivers/pwm/pwm-sti.c |   30 +++++++++++-------------------
>  1 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c index
> b95115c..92abbd5 100644
> --- a/drivers/pwm/pwm-sti.c
> +++ b/drivers/pwm/pwm-sti.c
> @@ -57,6 +57,7 @@ struct sti_pwm_chip {
>  	struct regmap_field *pwm_int_en;
>  	struct pwm_chip chip;
>  	struct pwm_device *cur;
> +	unsigned long configured;
>  	unsigned int en_count;
>  	struct mutex sti_pwm_lock; /* To sync between enable/disable calls */
>  	void __iomem *mmio;
> @@ -102,24 +103,6 @@ static int sti_pwm_get_prescale(struct sti_pwm_chip *pc,
> unsigned long period,
>  	return 0;
>  }
> 
> -/* Calculate the number of PWM devices configured with a period. */ -static
> unsigned int sti_pwm_count_configured(struct pwm_chip *chip) -{
> -	struct pwm_device *pwm;
> -	unsigned int ncfg = 0;
> -	unsigned int i;
> -
> -	for (i = 0; i < chip->npwm; i++) {
> -		pwm = &chip->pwms[i];
> -		if (test_bit(PWMF_REQUESTED, &pwm->flags)) {
> -			if (pwm_get_period(pwm))
> -				ncfg++;
> -		}
> -	}
> -
> -	return ncfg;
> -}
> -
>  /*
>   * For STiH4xx PWM IP, the PWM period is fixed to 256 local clock cycles.
>   * The only way to change the period (apart from changing the PWM input clock)
> @@ -141,7 +124,7 @@ static int sti_pwm_config(struct pwm_chip *chip, struct
> pwm_device *pwm,
>  	unsigned int ncfg;
>  	bool period_same = false;
> 
> -	ncfg = sti_pwm_count_configured(chip);
> +	ncfg = hweight_long(pc->configured);
>  	if (ncfg)
>  		period_same = (period_ns == pwm_get_period(cur));
> 
> @@ -197,6 +180,7 @@ static int sti_pwm_config(struct pwm_chip *chip, struct
> pwm_device *pwm,
> 
>  		ret = regmap_field_write(pc->pwm_int_en, 0);
> 
> +		set_bit(pwm->hwpwm, &pc->configured);
>  		pc->cur = pwm;
> 
>  		dev_dbg(dev, "prescale:%u, period:%i, duty:%i, pwmvalx:%u\n",
> @@ -254,10 +238,18 @@ static void sti_pwm_disable(struct pwm_chip *chip, struct
> pwm_device *pwm)
>  	mutex_unlock(&pc->sti_pwm_lock);
>  }
> 
> +static void sti_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct sti_pwm_chip *pc = to_sti_pwmchip(chip);
> +
> +	clear_bit(pwm->hwpwm, &pc->configured); }
> +
>  static const struct pwm_ops sti_pwm_ops = {
>  	.config = sti_pwm_config,
>  	.enable = sti_pwm_enable,
>  	.disable = sti_pwm_disable,
> +	.free = sti_pwm_free,
>  	.owner = THIS_MODULE,
>  };
> 
> --
> 1.7.5.4

