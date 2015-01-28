Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbbA1V2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:28:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45520 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbbA1Usd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:33 -0500
Message-ID: <54C94B1E.7050304@codeaurora.org>
Date: Wed, 28 Jan 2015 12:48:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com> <54C6E753.606@codeaurora.org> <54C7928F.9090407@mm-sol.com>
In-Reply-To: <54C7928F.9090407@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/15 05:28, Stanimir Varbanov wrote:
> Hi Stephen,
>
> Thanks for the comments!
>
> On 01/27/2015 03:18 AM, Stephen Boyd wrote:
>> On 01/26/15 08:24, Stanimir Varbanov wrote:
>>
>>>  	return -ENOTSUPP;
>>>  }
>>>  
>>> @@ -276,9 +274,11 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
>>>  		val = readl(pctrl->regs + g->io_reg);
>>>  		arg = !!(val & BIT(g->in_bit));
>>>  		break;
>>> +	case PIN_CONFIG_INPUT_ENABLE:
>>> +		val = readl(pctrl->regs + g->io_reg);
>>> +		arg = !!(val & BIT(g->in_bit));
>>> +		break;
>> This bit is used to read the value of the gpio. If the gpio is high,
>> this bit will read back as a 1. If the gpio is low, this bit will read
>> back as a 0. I don't see how this is related to input-enable? Doesn't
> Maybe I had to split on few patches. The change in .pin_config_group_get
> is related to debugfs dump. The change which adds input-enable support
> is in .pin_config_group_set.
>
>> input-enable mean we configure the pin to accept input? In that sense,
>> configuring the pin to accept input would sort of be like configuring
>> the pin for function "gpio" so that we can read this bit and see if the
>> pin is high or low, but I don't know if we care to support that. I think
>> we rely on users configuring the pin for the gpio function though.
> Why you do not care, because you think that tlmm doesn't support it or
> because it is a driver responsibility to set up gpio function plus
> input/output configuration?

Ah ok, I see that the driver clears the output enable bit for
gpio_direction_input(). Technically that isn't even required because
from what I can recall the output enable bit only controls if the OE bit
is driven out on the line. We can always read what's there by reading
the IN bit even when the output is enabled.

>
> I can imagine usecase where the driver implements an 'idle' pinctrl
> state which configure its pins to be gpio input enabled to save power
> assuming that the previous 'default' pinctrl state it was gpio output.
> In that case the driver doesn't need to call gpio_direction_input() for
> every gpio, only call pinctrl_select_state('idle').
>
> What's wrong with this?

Yes that's fine. It sounds like you want to disabled the output and the
way that works today is by switching the gpio direction to input. I just
got caught up because in my mind the input is always enabled because we
can always read what's on the pin. I guess output-disable ==
input-enable. Either way, the implementation doesn't look right for this
part where we want to see if the input is enabled. Looks like Bjorn has
the right idea, so let's see how v2 goes.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

