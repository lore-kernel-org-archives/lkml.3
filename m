Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaCGL3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:29:41 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:40032 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaCGL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:29:39 -0500
Message-ID: <5319AD5C.7050301@st.com>
Date: Fri, 7 Mar 2014 12:28:28 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: srinivas kandagatla <srinivas.kandagatla@st.com>,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Cc: <lee.jones@linaro.org>
Subject: Re: [PATCH v2 3/5] pinctrl: st: Enhance the controller to manage
 unavailable registers
References: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com> <1394185272-26054-4-git-send-email-maxime.coquelin@st.com> <5319A263.6020201@st.com>
In-Reply-To: <5319A263.6020201@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

On 03/07/2014 11:41 AM, srinivas kandagatla wrote:
> Hi Peppe/Maxime,
> I missed a comment... :-)
>
>
> On 07/03/14 09:41, Maxime COQUELIN wrote:
>> From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>>
>> This patch adds a new logic inside the st pinctrl to manage
>> an unsupported scenario: some sysconfig are not available!
>>
>> This is the case of STiH407 where, although documented, the
>> following registers from SYSCFG_FLASH have been removed from the SoC.
>>
>> SYSTEM_CONFIG3040
>>     Output Enable pad control for all PIO Alternate Functions
>> and
>> SYSTEM_ CONFIG3050
>>     Pull Up pad control for all PIO Alternate Functions
>>
>> Without managing this condition an imprecise external abort
>> will be detect.
>>
>> To do this the patch also reviews the st_parse_syscfgs
>> and other routines to manipulate the registers only if
>> actually available.
>> In any case, for example the st_parse_syscfgs detected
>> an error condition but no action was made in the
>> st_pctl_probe_dt.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> ---
>>   drivers/pinctrl/pinctrl-st.c | 121 +++++++++++++++++++++++++++----------------
>>   1 file changed, 75 insertions(+), 46 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
>> index 9e9b6ea..d1886b4 100644
>> --- a/drivers/pinctrl/pinctrl-st.c
>> +++ b/drivers/pinctrl/pinctrl-st.c
>> @@ -390,6 +390,19 @@ static const struct st_pctl_data  stih416_data = {
>>   	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
>>   };
>>
>> +static const struct st_pctl_data  stih407_flashdata = {
>> +	.rt_style	= st_retime_style_none,
>> +	.input_delays	= stih416_delays,
>> +	.ninput_delays	= 14,
>> +	.output_delays	= stih416_delays,
>> +	.noutput_delays = 14,
>> +	.alt = 0,
>> +	.oe = -1, /* Not Available */
>> +	.pu = -1, /* Not Available */
>> +	.od = 60,
>> +	.rt = 100,
>> +};
>> +
>
> I think this stih407_flashdata go with the previous patch "pinctrl: st:
> add pinctrl support for the STiH407 SoC"
>
> So that this patch just adds new checks to pinctrl-driver and not
> stih407 related stuff.

Problem is that "oe" and "pu" takes -1 in that patch, and these values 
will be passed directly to devm_regmap_field_alloc without any check.

I propose to apply this patch before "pinctrl: st: add pinctrl support 
for the STiH407 SoC", and move stih407_flashdata as you recommend.

Is it fine for you?

Thanks for the review,
Maxime

>
> Other than that the patch looks good to me.
>
>>   }
>>
>>   /*
>> @@ -1583,7 +1612,7 @@ static struct of_device_id st_pctl_of_match[] = {
>>   	{ .compatible = "st,stih407-sbc-pinctrl", .data = &stih416_data},
>>   	{ .compatible = "st,stih407-front-pinctrl", .data = &stih416_data},
>>   	{ .compatible = "st,stih407-rear-pinctrl", .data = &stih416_data},
>> -	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih416_data},
>> +	{ .compatible = "st,stih407-flash-pinctrl", .data = &stih407_flashdata},
> Same as first comment.
>>   	{ /* sentinel */ }
>>   };
>>
>>
>
>
> Thanks,
> srini
>
