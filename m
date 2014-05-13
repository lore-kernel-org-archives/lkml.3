Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbaEMJnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:43:01 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57294 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744AbaEMJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:42:58 -0400
Message-ID: <5371E91F.7000807@linaro.org>
Date: Tue, 13 May 2014 10:42:55 +0100
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
Subject: Re: [PATCH v1 11/11] mmc: mmci: Add Qcom specific pio_read function.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759674-13421-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdY_NzRaz5fiWJDF=rZY6WizmwbDZG6c_+FR+L9Aix8peQ@mail.gmail.com>
In-Reply-To: <CACRpkdY_NzRaz5fiWJDF=rZY6WizmwbDZG6c_+FR+L9Aix8peQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/05/14 09:34, Linus Walleij wrote:
> On Tue, Apr 29, 2014 at 10:21 AM,  <srinivas.kandagatla@linaro.org> wrote:
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
>> not suitable for Qcom SOCs.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> (...)
>
>> +static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
>> +                        unsigned int remain)
>> +{
>> +       uint32_t        *ptr = (uint32_t *) buffer;
>
> Just use u32 for this.
>
>> +       int             count = 0;
>> +       struct variant_data *variant = host->variant;
>> +       int             fifo_size = variant->fifosize;
>> +
>> +       if (remain % 4)
>> +               remain = ((remain >> 2) + 1) << 2;
>
> Explain in a comment exactly what is happening here or noone will
> understand the code.

Ok, I will add more comments here.
>
>> +       while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>> +               *ptr = readl(host->base + MMCIFIFO + (count % fifo_size));
>> +               ptr++;
>> +               count += sizeof(uint32_t);
>> +               remain -=  sizeof(uint32_t);
>
>
> sizeof(u32) or just 4 works for these...
>
Yes, Will fix it in next version.
> count += 4;
> remain -= 4;
>
> Is easier to parse and understand I think.
>
>> +               if (remain == 0)
>> +                       break;
>
> if (!remain)
>    break;
>
yep.

>> +       }
>> +       return count;
>> +}
>
>> -               if (status & MCI_RXACTIVE)
>> -                       len = mmci_pio_read(host, buffer, remain);
>> +               if (status & MCI_RXACTIVE) {
>> +                       if (host->hw_designer == AMBA_VENDOR_QCOM)
>> +                               len = mmci_qcom_pio_read(host, buffer, remain);
>> +                       else
>> +                               len = mmci_pio_read(host, buffer, remain);
>> +               }
>
> Use something like bool qcom_fifo; in vendor data instead.
>
Ok, make sense, I will fix this in next version.

--srini

> Yours,
> Linus Walleij
>
