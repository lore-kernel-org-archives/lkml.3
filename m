Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaCKK5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:57:00 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:56719 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbaCKK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:56:58 -0400
Message-ID: <531EEBB9.1050405@st.com>
Date: Tue, 11 Mar 2014 11:55:53 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/5] pinctrl: st: Enhance the controller to manage
 unavailable registers
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>	<1394203251-25361-3-git-send-email-maxime.coquelin@st.com>	<20140310091707.GD14976@lee--X1> <531EC6C0.4080202@st.com>
In-Reply-To: <531EC6C0.4080202@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/11/2014 09:18 AM, Maxime Coquelin wrote:
>
>
> On 03/10/2014 10:17 AM, Lee Jones wrote:
>>> From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>>>
>>> This patch adds a new logic inside the st pinctrl to manage
>>> an unsupported scenario: some sysconfig are not available!
>>>
>>> This is the case of STiH407 where, although documented, the
>>> following registers from SYSCFG_FLASH have been removed from the SoC.
>>>
>>> SYSTEM_CONFIG3040
>>>     Output Enable pad control for all PIO Alternate Functions
>>> and
>>> SYSTEM_ CONFIG3050
>>>     Pull Up pad control for all PIO Alternate Functions
>>>
>>> Without managing this condition an imprecise external abort
>>> will be detect.
>>>
>>> To do this the patch also reviews the st_parse_syscfgs
>>> and other routines to manipulate the registers only if
>>> actually available.
>>> In any case, for example the st_parse_syscfgs detected
>>> an error condition but no action was made in the
>>> st_pctl_probe_dt.
>>>
>>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>>
>> These two SOBs need reordering.
> Right,
> this will be changed here and everywhere else in the series.
>
>>
>>> ---
>>>   drivers/pinctrl/pinctrl-st.c | 106
>>> +++++++++++++++++++++++++------------------
>>>   1 file changed, 61 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
>>> index 9fb66aa..1721611 100644
>>> --- a/drivers/pinctrl/pinctrl-st.c
>>> +++ b/drivers/pinctrl/pinctrl-st.c

<snip>

>>>
>>> -static int st_parse_syscfgs(struct st_pinctrl *info,
>>> -        int bank, struct device_node *np)
>>> +
>>> +static struct regmap_field *st_pc_get_value(struct device *dev,
>>> +                        struct regmap *regmap, int bank,
>>> +                        int data, int lsb, int msb)
>>> +{
>>> +    struct reg_field reg = REG_FIELD((data + bank) * 4, lsb, msb);
>>> +
>>> +    if (data < 0)
>>> +        return NULL;
>>
>> What happens is data < 0 and it's used in REG_FIELD?
> Nothing bad, but I agree this is not crystal clear.
>
>>
>> Would it make more sense to make this check before calling REG_FIELD?
> Yes, it will be done in the v4.

Finally, I have to keep it as it was if I want this patch to compile.

>
> <snip>
>
> Thanks,
> Maxime
>
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel
