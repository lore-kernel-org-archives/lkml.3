Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaE3Lon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:44:43 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57429 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaE3Lom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:44:42 -0400
Message-ID: <53886F25.8060509@linaro.org>
Date: Fri, 30 May 2014 12:44:37 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 13/13] mmc: mmci: Add Qcom specific pio_read function.
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>	<1401284886-16978-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFpto10x7ZFbozkmnPhmTH3dkENEJetD_c08bgzytKa_xw@mail.gmail.com>
In-Reply-To: <CAPDyKFpto10x7ZFbozkmnPhmTH3dkENEJetD_c08bgzytKa_xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 30/05/14 12:27, Ulf Hansson wrote:
> On 28 May 2014 15:48,  <srinivas.kandagatla@linaro.org> wrote:
...

>>          .f_max                  = 208000000,
>>          .explicit_mclk_control  = true,
>> +       .qcom_fifo              = true,
>>   };
>>
>>   static int mmci_card_busy(struct mmc_host *mmc)
>> @@ -1006,6 +1009,40 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
>>          }
>>   }
>>
>> +static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
>> +                       unsigned int remain)
>> +{
>> +       u32 *ptr = (u32 *) buffer;
>
> Instead of u32 ptr above, I suggest to use a char *ptr. You need it
> anyway further down below where you move in step of bytes instead of
> words.
>
>> +       unsigned int count = 0;
>> +       unsigned int words, bytes;
>> +       unsigned int fsize = host->variant->fifosize;
>> +
>> +       words = remain >> 2;
>> +       bytes = remain % 4;
>> +       /* read full words followed by leftover bytes */
>> +       if (words) {
>> +               while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>
> How about while (words && (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL)
>
> That would make it possible the remove the "if", both above and below.

That sounds sensible.. I will try it.
>
>> +                       *ptr = readl(host->base + MMCIFIFO + (count % fsize));
>
> This looks strange. :-) Depending on the count you will read an offset
> into the FIFO? Seems like a very awkward implementation of a FIFO in
> the HW. :-)
>
I got into weird issues when I tried using the mmci_pio_read, the fifo 
implementation seems to be different. I dont have full details on the 
fifo behaviour.

Most of this logic is inherited from 3.4 qcom andriod kernel.

> BTW, what does "MCI_RXDATAAVLBL" actually mean for the Qcom variant?

It means, At least 1 word in the RX FIFO. SW can read 1 word only from 
the FIFO.

> How much data could you expect in the FIFO when this status is
> triggered?

> Are there no option of reading a number of words, depending on what
> type FIFO IRQ that was raised?
There are RXFIFO_HALF_FULL and RXFIFO_FULL bits in status register, but 
I never tried to use them. Might be worth a try before I send next 
version patches.


I will give a try and keep you posted.
Thanks,
srini
>
>> +                       ptr++;
>> +                       count += 4;
>> +                       words--;
>> +                       if (!words)
>> +                               break;
>> +               }
>> +       }
>> +
>> +       if (bytes) {
>> +               unsigned char buf[4];
>> +               if (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
>> +                       *buf = readl(host->base + MMCIFIFO + (count % fsize));
>> +                       memcpy(ptr, buf, bytes);
>> +                       count += bytes;
>> +               }
>> +       }
>> +
>> +       return count;
>> +}
>> +

>>
>
> Kind regards
> Ulf Hansson
>
