Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbbA0N24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:28:56 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:46625 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbbA0N2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:28:53 -0500
Message-ID: <54C7928F.9090407@mm-sol.com>
Date: Tue, 27 Jan 2015 15:28:47 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com> <54C6E753.606@codeaurora.org>
In-Reply-To: <54C6E753.606@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the comments!

On 01/27/2015 03:18 AM, Stephen Boyd wrote:
> On 01/26/15 08:24, Stanimir Varbanov wrote:
>> Enables generic pinconf support and add handling for 'input-enable'
>> pinconf property.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  drivers/pinctrl/qcom/pinctrl-msm.c |   17 ++++++++++++-----
>>  1 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
>> index e730935..4a47eb1 100644
>> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
>> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
>> @@ -193,11 +193,11 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
>>  		*mask = 7;
>>  		break;
>>  	case PIN_CONFIG_OUTPUT:
>> +	case PIN_CONFIG_INPUT_ENABLE:
>>  		*bit = g->oe_bit;
>>  		*mask = 1;
>>  		break;
>>  	default:
>> -		dev_err(pctrl->dev, "Invalid config param %04x\n", param);
> 
> Is this removed because the generic framework already takes care of
> printing this information on such errors?

yes, more or less. These error messages just floods the screen when
using debugfs entries. Even more ENOTSUPP is legal error for generic
pinconf.

> 
>>  		return -ENOTSUPP;
>>  	}
>>  
>> @@ -208,14 +208,12 @@ static int msm_config_get(struct pinctrl_dev *pctldev,
>>  			  unsigned int pin,
>>  			  unsigned long *config)
>>  {
>> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> 
> Same for here.
> 
>>  	return -ENOTSUPP;
>>  }
>>  
>>  static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
>>  				unsigned long *configs, unsigned num_configs)
>>  {
>> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> 
> And here.
> 
>>  	return -ENOTSUPP;
>>  }
>>  
>> @@ -276,9 +274,11 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
>>  		val = readl(pctrl->regs + g->io_reg);
>>  		arg = !!(val & BIT(g->in_bit));
>>  		break;
>> +	case PIN_CONFIG_INPUT_ENABLE:
>> +		val = readl(pctrl->regs + g->io_reg);
>> +		arg = !!(val & BIT(g->in_bit));
>> +		break;
> 
> This bit is used to read the value of the gpio. If the gpio is high,
> this bit will read back as a 1. If the gpio is low, this bit will read
> back as a 0. I don't see how this is related to input-enable? Doesn't

Maybe I had to split on few patches. The change in .pin_config_group_get
is related to debugfs dump. The change which adds input-enable support
is in .pin_config_group_set.

> input-enable mean we configure the pin to accept input? In that sense,
> configuring the pin to accept input would sort of be like configuring
> the pin for function "gpio" so that we can read this bit and see if the
> pin is high or low, but I don't know if we care to support that. I think
> we rely on users configuring the pin for the gpio function though.

Why you do not care, because you think that tlmm doesn't support it or
because it is a driver responsibility to set up gpio function plus
input/output configuration?

I can imagine usecase where the driver implements an 'idle' pinctrl
state which configure its pins to be gpio input enabled to save power
assuming that the previous 'default' pinctrl state it was gpio output.
In that case the driver doesn't need to call gpio_direction_input() for
every gpio, only call pinctrl_select_state('idle').

What's wrong with this?

> 
>>  	default:
>> -		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
>> -			param);
>>  		return -EINVAL;
>>  	}
>>  
>> @@ -348,6 +348,10 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
>>  			/* enable output */
>>  			arg = 1;
>>  			break;
>> +		case PIN_CONFIG_INPUT_ENABLE:
>> +			/* disable output */
>> +			arg = 0;
>> +			break;
>>  		default:
>>  			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
>>  				param);
>> @@ -372,6 +376,9 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
>>  }
>>  
>>  static const struct pinconf_ops msm_pinconf_ops = {
>> +#ifdef CONFIG_GENERIC_PINCONF
>> +	.is_generic		= true,
>> +#endif
> 
> Shouldn't we have set this when we started this driver? I guess this
> only makes debugfs output change, but it seems like this is a "fix" of
> some kind that is different from input-enable support.
> 

yes, it should be different fix, I will split this on separate patch.


-- 
regards,
Stan
