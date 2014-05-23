Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaEWJnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:43:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60237 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaEWJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:43:01 -0400
Message-ID: <537F1821.4060109@linaro.org>
Date: Fri, 23 May 2014 10:42:57 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 14/14] mmc: mmci: Add Qcom specific pio_read function.
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400146684-30384-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdbQ_uNoZpW9w7Yf==wt44wun4e+P7WzMp_t0tuCVeUX_g@mail.gmail.com>
In-Reply-To: <CACRpkdbQ_uNoZpW9w7Yf==wt44wun4e+P7WzMp_t0tuCVeUX_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/05/14 10:31, Linus Walleij wrote:
> On Thu, May 15, 2014 at 11:38 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> MCIFIFOCNT register behaviour on Qcom chips is very different than the other
>> pl180 integrations. MCIFIFOCNT register contains the number of
>> words that are still waiting to be transferred through the FIFO. It keeps
>> decrementing once the host CPU reads the MCIFIFO. With the existing logic and
>> the MCIFIFOCNT behaviour, mmci_pio_read will loop forever, as the FIFOCNT
>> register will always return transfer size before reading the FIFO.
>>
>> Also the data sheet states that "This register is only useful for debug
>> purposes and should not be used for normal operation since it does not reflect
>> data which may or may not be in the pipeline".
>>
>> This patch implements qcom_pio_read function so as existing mmci_pio_read is
>> not suitable for Qcom SOCs. qcom_pio_read function is only selected
>> based on qcom_fifo flag in variant data structure.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> (...)
>
>> +static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
>> +                        unsigned int remain)
>> +{
>> +       uint32_t        *ptr = (uint32_t *) buffer;
>
Oops..

Sorry Linus, I think this change-set got something different than what I 
did. I remember your comments in the last review, I did take care of 
them but some how It got missed... I will fix these and send a new version.

> Just use u32 like the rest of the driver does.
>
>> +       int             fifo_size = variant->fifosize;
>> +
>> +       if (remain % 4)

>
> And another variant is to count the *number or words*
> to read from the FIFO rather than the number of bytes! I would do it
> like this:
>
> static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
>                          unsigned int remain)
> {
>         u32 *ptr = (u32*) buffer;
>         unsigned int count = 0;
>         unsigned int words;
>         unsigned int fifo_size = host->variant->fifosize;
>
>         words = DIV_ROUND_UP(remain, 4);
>         while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>                 *ptr = readl(host->base + MMCIFIFO + (count % fifo_size));
>                 ptr++;
>                 count += 4;
>                 remain--;
>                 if (!remain)
>                         break;
>         }
>         return count;
> }
>
> I guess you will run into additional problems when you come to doing
> SDIO. This function can return *more* bytes than asked for, as it rounds
> up. It won't happen with MMC/SD transfers since these are always
> divisible by 8, but it *will* happen on SDIO!
>
> If you look carefully at the comments in mmci_pio_read() you will
> see how this is handled. Are you sure this function cannot be
> augmented to handle the qcom variant as well so you don't get this
> problem further down the road?

I did try to customize the mmci_pio_read function but I failed all the 
time. The reason being the behaviour of MCI_FIFOCNT register which is 
totally different to the way the function is written. I will give a try 
again.

Thanks,
srini
>
> Yours,
> Linus Walleij
>
