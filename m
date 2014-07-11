Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaGKTgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:36:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43241 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaGKTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:36:52 -0400
Message-ID: <53C03CCA.6090207@linaro.org>
Date: Fri, 11 Jul 2014 20:36:42 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gross, Andy" <agross@quicinc.com>
Subject: Re: [RFC PATCH] mmc: mmci: Add qcom dml support to the driver.
References: <1405079306-1406-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdZdU3PBt+tCqhtWutjwaqdM9yWQi-3bzELV1Xnd9w_EEw@mail.gmail.com>
In-Reply-To: <CACRpkdZdU3PBt+tCqhtWutjwaqdM9yWQi-3bzELV1Xnd9w_EEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/14 14:49, Linus Walleij wrote:
> On Fri, Jul 11, 2014 at 1:48 PM, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>
>> On Qualcomm APQ8064 SOCs, SD card controller has an additional glue
>> called DML (Data Mover Local/Lite) to assist dma transfers.
>> This hardware needs to be setup before any dma transfer is requested.
>> DML itself is not a DMA engine, its just a gule between the SD card
>> controller and dma controller.
>>
>> Most of this code has been ported from qualcomm's 3.4 kernel.
>>
>> This patch adds the code necessary to intialize the hardware and setup
>> before doing any dma transfers.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Pretty cool :-)
>
>>   drivers/mmc/host/mmci.c     |  19 ++++-
>>   drivers/mmc/host/qcom_dml.c | 171 ++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/mmc/host/qcom_dml.h |  17 +++++
>
> Please call this file mmci-qcom-dml.c/h so we know that these files
> have a strong
> dependence.
>
>> +config MMC_QCOM_DML
>> +       tristate "Qualcomm Data Mover for SD Card Controller"
>> +       depends on MMC_ARMMMCI && ARCH_QCOM
>
> The way I get it is that this only makes sense when the qualcomm
> DMA engine is used so should it not be
>
> depends on MMC_ARMMMCI && QCOM_BAM_DMA
>
You are right, making it
depends on MMC_ARMMMCI && QCOM_BAM_DMA
makes more sense.
I will fix this in next version.

> ?
>
> Or maybe we should be less specific?
>
> depends on MMC_ARMMMCI && DMA_ENGINE
>
> ?
>
>>   /*
>> @@ -569,6 +579,7 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
>>          struct dma_async_tx_descriptor *desc;
>>          enum dma_data_direction buffer_dirn;
>>          int nr_sg;
>> +       u32 flags = DMA_CTRL_ACK;
>>
>>          if (data->flags & MMC_DATA_READ) {
>>                  conf.direction = DMA_DEV_TO_MEM;
>> @@ -593,9 +604,12 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
>>          if (nr_sg == 0)
>>                  return -EINVAL;
>>
>> +       if (host->variant->qcom_dml)
>> +               flags |= DMA_PREP_INTERRUPT;
>
> Is this correct? That augments every incoming DMA request to try to
> do an interrupt callback. Why is that necessary? The interrupt
> callback still isn't registered, so this isn't used for anything?
>
There is a special signalling going on between the DMA controller and 
IP, whose state machine is controlled by EOT (End of Transfer) 
interrupt. This special EOT flag is mapped to DMA_PREP_INTERRUPT in BAM 
DMA engine.

The EOT flag requests that the peripheral assert an end of transaction 
interrupt when that descriptor is complete. It also results in special 
signaling protocol that is used between the attached peripheral and the 
core using the DMA controller.

Recently Andy submitted a patch for this:
http://www.gossamer-threads.com/lists/linux/kernel/1935019

Added Andy to the loop as well.


thanks,
srini
> If it's still needed it would be a bug in the DMA engine I think.
>
> Yours,
> Linus Walleij
>
