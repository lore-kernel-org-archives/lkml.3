Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaEZVip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:38:45 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53960 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaEZVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:38:42 -0400
Message-ID: <5383B44F.30608@linaro.org>
Date: Mon, 26 May 2014 22:38:23 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 10/13] mmc: mmci: add Qcom specifics of clk and datactrl
 registers.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849556-7501-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFpyZU207A515T9xd153DBWGpjP8cqiAZfwvkx7Drefc5A@mail.gmail.com>
In-Reply-To: <CAPDyKFpyZU207A515T9xd153DBWGpjP8cqiAZfwvkx7Drefc5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

Thanks for the comments.

On 26/05/14 14:05, Ulf Hansson wrote:
> On 23 May 2014 14:52,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds specifics of clk and datactrl register on Qualcomm SD
>> Card controller. This patch also populates the Qcom variant data with
>> these new values specific to Qualcomm SD Card Controller.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>   drivers/mmc/host/mmci.c |  4 ++++
>>   drivers/mmc/host/mmci.h | 24 ++++++++++++++++++++++++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index 17e7f6a..6434f5b1 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -185,6 +185,10 @@ static struct variant_data variant_qcom = {
>>          .fifosize               = 16 * 4,
>>          .fifohalfsize           = 8 * 4,
>>          .clkreg                 = MCI_CLK_ENABLE,
>> +       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
>> +                                 MCI_QCOM_CLK_FEEDBACK_CLK,
>
> Obviously I don't have the in-depth knowledge about the Qcom variant,
> but comparing the ST variant here made me think.
>
> Using the feeback clock internal logic in the ST variant, requires the
> corresponding feedback clock pin signal on the board, to be
> routed/connected. Typically we used this for SD cards, which involved
> using an external level shifter circuit.
>
> Is it correct to enable this bit for all cases, including eMMC?
>
You are correct, FBCLK should specific to the board, and I will try to 
do something on the same lines as ST variant in next version.

> If it is board specific configurations, you should add a DT binding
> for it - like there are for the ST variant.
>
>> +       .clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
>> +       .datactrl_mask_ddrmode  = MCI_QCOM_CLK_DDR_MODE,
>>          .blksz_datactrl4        = true,
>>          .datalength_bits        = 24,
>>          .blksz_datactrl4        = true,
>> diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
>> index cd83ca3..1b93ae7 100644
>> --- a/drivers/mmc/host/mmci.h
>> +++ b/drivers/mmc/host/mmci.h
>> @@ -41,6 +41,22 @@
>>   /* Modified PL180 on Versatile Express platform */
>>   #define MCI_ARM_HWFCEN         BIT(12)
>>
>> +/* Modified on Qualcomm Integrations */
>> +#define MCI_QCOM_CLK_WIDEBUS_4 (2 << 10)
>
> This is the same as BIT(11), please use MCI_4BIT_BUS instead.
>
This is not used in the code, I will clean it up as you suggested, just 
to be more consistent.

>> +#define MCI_QCOM_CLK_WIDEBUS_8 (3 << 10)
>
> Since you converted to use the "BIT" macro a few patches ago, I
> suggest we should stick to it. How about something below:
>
> #define MCI_QCOM_CLK_WIDEBUS_8 BIT (BIT(10) | BIT(11))
>
Sounds good, I will fix all such instances in next version.

> Please adopt all defines added in this patch to use the BIT macro.
>
>> +#define MCI_QCOM_CLK_FLOWENA   BIT(12)
>> +#define MCI_QCOM_CLK_INVERTOUT BIT(13)
>> +
>> +/* select in latch data and command */
>> +#define MCI_QCOM_CLK_SEL_IN_SHIFT      (14)
>
> BIT (14)?
>
>> +#define MCI_QCOM_CLK_SEL_MASK          (0x3)
>> +#define MCI_QCOM_CLK_SEL_RISING_EDGE   (1)
>
> BIT(1)?
>
>> +#define MCI_QCOM_CLK_FEEDBACK_CLK      (2 << 14)
>> +#define MCI_QCOM_CLK_DDR_MODE          (3 << 14)
>> +
>> +/* mclk selection */
>> +#define MCI_QCOM_CLK_SEL_MCLK          (2 << 23)
>
> Does this correspond to MCI_CLK_BYPASS? If so, we should maybe state
> this in a comment?
>
No, this is not same as MCI_CLK_BYPASS, its selection between 
FBCLK/gated MCLK/freerunning MCLK.

Thanks,
srini
