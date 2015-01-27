Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbbA0SFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:05:12 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9926 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759171AbbA0SFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:05:09 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Tue, 27 Jan 2015 10:05:04 -0800
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
Message-ID: <20150127180503.GG11960@sonymobile.com>
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com>
 <54C6E753.606@codeaurora.org>
 <54C7928F.9090407@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54C7928F.9090407@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27 Jan 05:28 PST 2015, Stanimir Varbanov wrote:

> Hi Stephen,
> 
> Thanks for the comments!
> 
> On 01/27/2015 03:18 AM, Stephen Boyd wrote:
> > On 01/26/15 08:24, Stanimir Varbanov wrote:
> >> Enables generic pinconf support and add handling for 'input-enable'
> >> pinconf property.
> >>
> >> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >> ---

Hi Stanimir,

Good stuff, but please split this into (although I think you already figured it out):
* one patch that introduces input-enable
* one that enable the usage of pinconf-generic debugfs (is_generic + drop the prints)
* one that drops the msm_config_get/msm_config_set

> >>  drivers/pinctrl/qcom/pinctrl-msm.c |   17 ++++++++++++-----
> >>  1 files changed, 12 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> >> index e730935..4a47eb1 100644
> >> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> >> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> >> @@ -193,11 +193,11 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
> >>  		*mask = 7;
> >>  		break;
> >>  	case PIN_CONFIG_OUTPUT:
> >> +	case PIN_CONFIG_INPUT_ENABLE:

Looks good.

> >>  		*bit = g->oe_bit;
> >>  		*mask = 1;
> >>  		break;
> >>  	default:
> >> -		dev_err(pctrl->dev, "Invalid config param %04x\n", param);
> > 
> > Is this removed because the generic framework already takes care of
> > printing this information on such errors?
> 
> yes, more or less. These error messages just floods the screen when
> using debugfs entries. Even more ENOTSUPP is legal error for generic
> pinconf.
> 
> > 

[..]

> >>  
> >> @@ -276,9 +274,11 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
> >>  		val = readl(pctrl->regs + g->io_reg);
> >>  		arg = !!(val & BIT(g->in_bit));
> >>  		break;
> >> +	case PIN_CONFIG_INPUT_ENABLE:
> >> +		val = readl(pctrl->regs + g->io_reg);
> >> +		arg = !!(val & BIT(g->in_bit));
> >> +		break;
> > 
> > This bit is used to read the value of the gpio. If the gpio is high,
> > this bit will read back as a 1. If the gpio is low, this bit will read
> > back as a 0. I don't see how this is related to input-enable? Doesn't
> 
> Maybe I had to split on few patches. The change in .pin_config_group_get
> is related to debugfs dump. The change which adds input-enable support
> is in .pin_config_group_set.
> 
> > input-enable mean we configure the pin to accept input? In that sense,
> > configuring the pin to accept input would sort of be like configuring
> > the pin for function "gpio" so that we can read this bit and see if the
> > pin is high or low, but I don't know if we care to support that. I think
> > we rely on users configuring the pin for the gpio function though.
> 
> Why you do not care, because you think that tlmm doesn't support it or
> because it is a driver responsibility to set up gpio function plus
> input/output configuration?
> 
> I can imagine usecase where the driver implements an 'idle' pinctrl
> state which configure its pins to be gpio input enabled to save power
> assuming that the previous 'default' pinctrl state it was gpio output.
> In that case the driver doesn't need to call gpio_direction_input() for
> every gpio, only call pinctrl_select_state('idle').
> 
> What's wrong with this?
> 

It makes a lot of sense to be able to have a input-enabled state that you can
switch to. Such state would specify function = "gpio" and input-enable;

I do however think that querying PIN_CONFIG_INPUT_ENABLE should not return the
value of the pin, but rather !(readl(g->ctl_reg) & BIT(g->oe_bit)) to indicate
if the pin is configured in input enable or not.

> > 
> >>  	default:
> >> -		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
> >> -			param);

Is this part of the debugfs cleanup?

> >>  		return -EINVAL;
> >>  	}
> >>  
> >> @@ -348,6 +348,10 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
> >>  			/* enable output */
> >>  			arg = 1;
> >>  			break;
> >> +		case PIN_CONFIG_INPUT_ENABLE:
> >> +			/* disable output */
> >> +			arg = 0;
> >> +			break;

Looks good.

> >>  		default:
> >>  			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
> >>  				param);
> >> @@ -372,6 +376,9 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
> >>  }
> >>  
> >>  static const struct pinconf_ops msm_pinconf_ops = {
> >> +#ifdef CONFIG_GENERIC_PINCONF
> >> +	.is_generic		= true,
> >> +#endif
> > 
> > Shouldn't we have set this when we started this driver? I guess this
> > only makes debugfs output change, but it seems like this is a "fix" of
> > some kind that is different from input-enable support.
> > 
> 
> yes, it should be different fix, I will split this on separate patch.
> 

PINCTRL_MSM does "select GENERIC_PINCONF", so the #ifdef is not needed. And
Stephen you're right, it should have been there in my original version.

Regards,
Bjorn
