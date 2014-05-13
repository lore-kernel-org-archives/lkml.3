Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbaEMJjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:39:23 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60871 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759858AbaEMJjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:39:18 -0400
Message-ID: <5371E842.3030802@linaro.org>
Date: Tue, 13 May 2014 10:39:14 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 09/11] mmc: mmci: Add clock support for Qualcomm.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759651-13341-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdYtiTrnVSOz055KNs=DWM3ai5NhPBKXPm8bxFPxYov81Q@mail.gmail.com>
In-Reply-To: <CACRpkdYtiTrnVSOz055KNs=DWM3ai5NhPBKXPm8bxFPxYov81Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W,

On 13/05/14 09:28, Linus Walleij wrote:
>> code is conditioned on hw designer.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> (...)
>> +               if (host->hw_designer == AMBA_VENDOR_QCOM) {
>> +                       host->cclk = host->mclk;
>> +               } else if (desired >= host->mclk) {
>
> Again refrain from hard-checking the vendor everywhere.
>
> struct variant_data {
>          bool            qcom_cclk_is_mclk;
> (...)
>
Got it.. Will fix it in next version.
> As per example from st_clkdiv...
>
> Then
>
> if (host->vendor->qcom_cclk_is_mclk) {
>    (...)
> }
>
>> +       if (ios->clock != host->mclk &&
>> +               host->hw_designer == AMBA_VENDOR_QCOM) {
>> +               /* Qcom MCLKCLK register does not define bypass bits */
>> +               int rc = clk_set_rate(host->clk, ios->clock);
>> +               if (rc < 0) {
>> +                       dev_err(mmc_dev(host->mmc),
>> +                               "Error setting clock rate (%d)\n", rc);
>> +               } else {
>> +                       host->mclk = clk_get_rate(host->clk);
>> +                       host->cclk = host->mclk;
>> +               }
>> +       }
>
> For this I would define a vendor data like:
>
> struct variant_data {
>          bool            explicit_mclk_control;
> (...)
This looks good.
>
> Or something. It explains what is actually going on.
>
>>          if (plat->f_max)
>> -               mmc->f_max = min(host->mclk, plat->f_max);
>> +               mmc->f_max = (host->hw_designer == AMBA_VENDOR_QCOM) ?
>> +                               plat->f_max : min(host->mclk, plat->f_max);
>
> So rewrite like that:
>
> if (host->vendor->explicit_mclk_control)
>         mmc->f_max = plat->f_max;
> else
>        mmc->f_max = min(host->mclk, plat->f_max);
>

This looks much clean


> Yours,
> Linus Walleij
>
