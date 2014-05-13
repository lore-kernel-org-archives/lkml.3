Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbaEMJO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:14:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39552 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912AbaEMJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:14:23 -0400
Message-ID: <5371E265.4020603@linaro.org>
Date: Tue, 13 May 2014 10:14:13 +0100
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
Subject: Re: [PATCH v1 06/11] mmc: mmci: Qcomm: Add 3 clock cycle delay after
 register write
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759614-13217-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdab4OT_Yzoijgdc7RFBapN8rrN56LYGLeO1vMjb=bu4Mg@mail.gmail.com>
In-Reply-To: <CACRpkdab4OT_Yzoijgdc7RFBapN8rrN56LYGLeO1vMjb=bu4Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W for reviewing the patches.

On 13/05/14 08:29, Linus Walleij wrote:
> On Tue, Apr 29, 2014 at 10:20 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> Most of the Qcomm SD card controller registers must be updated to the MCLK
>> domain so subsequent writes to registers will be ignored until 3 clock cycles
>> have passed.
>>
>> This patch adds a 3 clock cycle delay required after writing to controller
>> registers on Qualcomm SOCs. Without this delay all the register writes are not
>> successfull, resulting in not detecting cards.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Sounds like someone decided to clock the internal state machine
> in the MMCI using MCLK instead of PCLK :-(
>
> A bit nasty if this ends up in the fastpath (irq) though. Which it
> invariably does, right?
yes, Its going to for Qcom SOC.
>
>> +       /*
>> +        * On QCom SD card controller, registers must be updated to the
>> +        * MCLK domain so subsequent writes to this register will be ignored
>> +        * for 3 clk cycles.
>> +        */
>> +       if (host->hw_designer == AMBA_VENDOR_QCOM)
>> +               udelay(1 + ((3 * USEC_PER_SEC)/host->mclk));
>
> Add a new field in vendor data instead, and use DIV_ROUND_UP():
>
yes, that makes sense..

> static struct variant_data variant_qcom = {
>           .mclk_delayed_writes  = true,
> (...)
>
> if (host->vendor->mclk_delayed_writes)
>      udelay(DIV_ROUND_UP((3 * USEC_PER_SEC), host->mclk));
>
> You get the idea.
>
Got it.

> Yours,
> Linus Walleij
>
