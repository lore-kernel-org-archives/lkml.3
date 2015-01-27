Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbbA0BSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:18:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47499 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbA0BSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:18:14 -0500
Message-ID: <54C6E753.606@codeaurora.org>
Date: Mon, 26 Jan 2015 17:18:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/15 08:24, Stanimir Varbanov wrote:
> Enables generic pinconf support and add handling for 'input-enable'
> pinconf property.
>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  drivers/pinctrl/qcom/pinctrl-msm.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index e730935..4a47eb1 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -193,11 +193,11 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
>  		*mask = 7;
>  		break;
>  	case PIN_CONFIG_OUTPUT:
> +	case PIN_CONFIG_INPUT_ENABLE:
>  		*bit = g->oe_bit;
>  		*mask = 1;
>  		break;
>  	default:
> -		dev_err(pctrl->dev, "Invalid config param %04x\n", param);

Is this removed because the generic framework already takes care of
printing this information on such errors?

>  		return -ENOTSUPP;
>  	}
>  
> @@ -208,14 +208,12 @@ static int msm_config_get(struct pinctrl_dev *pctldev,
>  			  unsigned int pin,
>  			  unsigned long *config)
>  {
> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");

Same for here.

>  	return -ENOTSUPP;
>  }
>  
>  static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
>  				unsigned long *configs, unsigned num_configs)
>  {
> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");

And here.

>  	return -ENOTSUPP;
>  }
>  
> @@ -276,9 +274,11 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
>  		val = readl(pctrl->regs + g->io_reg);
>  		arg = !!(val & BIT(g->in_bit));
>  		break;
> +	case PIN_CONFIG_INPUT_ENABLE:
> +		val = readl(pctrl->regs + g->io_reg);
> +		arg = !!(val & BIT(g->in_bit));
> +		break;

This bit is used to read the value of the gpio. If the gpio is high,
this bit will read back as a 1. If the gpio is low, this bit will read
back as a 0. I don't see how this is related to input-enable? Doesn't
input-enable mean we configure the pin to accept input? In that sense,
configuring the pin to accept input would sort of be like configuring
the pin for function "gpio" so that we can read this bit and see if the
pin is high or low, but I don't know if we care to support that. I think
we rely on users configuring the pin for the gpio function though.

>  	default:
> -		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
> -			param);
>  		return -EINVAL;
>  	}
>  
> @@ -348,6 +348,10 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
>  			/* enable output */
>  			arg = 1;
>  			break;
> +		case PIN_CONFIG_INPUT_ENABLE:
> +			/* disable output */
> +			arg = 0;
> +			break;
>  		default:
>  			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
>  				param);
> @@ -372,6 +376,9 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
>  }
>  
>  static const struct pinconf_ops msm_pinconf_ops = {
> +#ifdef CONFIG_GENERIC_PINCONF
> +	.is_generic		= true,
> +#endif

Shouldn't we have set this when we started this driver? I guess this
only makes debugfs output change, but it seems like this is a "fix" of
some kind that is different from input-enable support.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

