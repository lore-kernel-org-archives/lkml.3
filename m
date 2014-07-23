Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbaGWXri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:47:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbaGWXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:47:36 -0400
Message-ID: <53D04996.2030902@codeaurora.org>
Date: Wed, 23 Jul 2014 16:47:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO parameters
 definitions
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com> <1405626085-14069-1-git-send-email-iivanov@mm-sol.com> <20140722214643.GH19700@sonymobile.com>
In-Reply-To: <20140722214643.GH19700@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/14 14:46, Bjorn Andersson wrote:
> For pm8941 the valid power supply values are:
>  GPIO 1-14
>    0: VPH
>    2: SMPS3
>    3: LDO6
>
>  GPIO 15-18
>   2: SMPS3
>   3: LDO6
>
>  GPIO 19-36
>   0: VPH
>   1: VDD_TORCH
>   2: SPMS3
>   3: LDO6
>
>  MPP 1-8
>   0: VPH
>   1: LDO1
>   2: SPMS3
>   3: LDO6
>
> For pma8084 the valid power supply values are:
>  GPIO 1-22
>   0: VPH
>   2: SPMS4
>   3: LDO6
>
>  MPP 1-8
>   0: VPH
>   1: LDO1
>   2: SMPS4
>   3: LDO6
>
> Please add these constants to the table of valid power-source values and use
> something like I did to translate them to register values - it makes the DT
> much more readable.

The DT could be similarly readable if we had a bunch of #defines for the
different VIN settings that resolved to the final register value for
that pmic. Something like PM8921_GPIO1_14_VPH, PM8921_GPIO19_36_VPH,
etc. There would be a lot of them, but then the driver could be really
simple and just jam whatever value is in the DT into the register
without having to bounce through a mapping table in software to figure
out the register value. If we did this for the functions also then I
believe we achieve readability without requiring a bunch of drivers for
each and every single pmic?

>
>>         Value type: <string>
>>         Definition: Specify the alternative function to be configured for the
>> -                   specified pins.  Valid values are:
>> -                       "normal",
>> -                       "paired",
>> -                       "func1",
>> -                       "func2",
>> -                       "dtest1",
>> -                       "dtest2",
>> -                       "dtest3",
>> -                       "dtest4"
>> +                   specified pins.  Valid values is: "gpio"
>>
>>  - bias-disable:
>>         Usage: optional
>> @@ -99,18 +95,6 @@ to specify in a pin configuration subnode:
>>         Value type: <none>
>>         Definition: The specified pins should be configued as pull down.
>>
>> -- bias-pull-up:
>> -       Usage: optional
>> -       Value type: <u32> (optional)
>> -       Definition: The specified pins should be configued as pull up. An
>> -                   optional argument can be used to configure the strength.
>> -                   Valid values are; as defined in
>> -                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
>> -                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
>> -                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
>> -                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
>> -                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
>> -
> As described above, I belive we should make this:
>
> - bias-pull-up:
> 	Usage: optional
> 	Value type: <empty>
> 	Definition: The specified pins should be configured as pull up.
>
> - qcom,pull-up-strength:
> 	Usage: optional
> 	Value type: <u32>
> 	Definition: Specifies the strength to use for pull up, if selected.
>                     Valid values are; as defined in
>                     <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
>                     1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
>                     2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
>                     3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
>                     4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
> 		    If this property is ommited 30uA strength will be used if
> 		    pull up is selected.

Why is 30uA special? Just because most drivers use it? I'd prefer we
always be explicit about which pull-up we want so that nothing is left
up to the driver implementation.

Also according to the hw folks the 1.5uA + 30uA boost has never been
used so I say let's drop that feature. If we need it one day we can
always add a qcom,pull-up-boost or something (I highly doubt we'll need
it). Doing that allows us to specify this in actual SI units. Maybe even
allowing us to have a generic pull-up-strength (or
bias-pull-up-strength) specified in SI units of mA?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

