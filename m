Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaJ0PX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:23:26 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:55924 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaJ0PXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFobcRL7_+ZiEkWFGXxq5Hznf5fZcpqUP+Z6VxW67mWBEw@mail.gmail.com>
References: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1413534398-22645-2-git-send-email-alexandre.belloni@free-electrons.com>
	<CAPDyKFobcRL7_+ZiEkWFGXxq5Hznf5fZcpqUP+Z6VxW67mWBEw@mail.gmail.com>
Date: Mon, 27 Oct 2014 16:23:23 +0100
Message-ID: <CAPDyKFr-pyTT=N7p+rU7mnzMg8F_rQOZvDva9GGmwy4J2t3F6Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] mmc: atmel-mci: move mache header to platform_data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2014 15:46, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 17 October 2014 10:26, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
>> Move the mach header that can come either from arm/mach-at91 or avr32 to
>> platform_data to be able to switch the AT91 platforms to multiplatform.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>
> Thanks! Applied for next!

Actually this one caused a compiler error due to a moved header from
the below commit.

3d598f47e804 dmaengine: dw: move dw_dmac.h to where it belongs to

I decided to fix it myself and fold the change into this patch, see below.

>
> Kind regards
> Uffe
>
>> ---
>>  drivers/mmc/host/atmel-mci.c                |  2 +-
>>  include/linux/platform_data/mmc-atmel-mci.h | 22 ++++++++++++++++++++++
>>  2 files changed, 23 insertions(+), 1 deletion(-)
>>  create mode 100644 include/linux/platform_data/mmc-atmel-mci.h
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index bb585d940901..b1231835b031 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -29,11 +29,11 @@
>>  #include <linux/stat.h>
>>  #include <linux/types.h>
>>  #include <linux/platform_data/atmel.h>
>> +#include <linux/platform_data/mmc-atmel-mci.h>
>>
>>  #include <linux/mmc/host.h>
>>  #include <linux/mmc/sdio.h>
>>
>> -#include <mach/atmel-mci.h>
>>  #include <linux/atmel-mci.h>
>>  #include <linux/atmel_pdc.h>
>>
>> diff --git a/include/linux/platform_data/mmc-atmel-mci.h b/include/linux/platform_data/mmc-atmel-mci.h
>> new file mode 100644
>> index 000000000000..ebe7ae4f72e4
>> --- /dev/null
>> +++ b/include/linux/platform_data/mmc-atmel-mci.h
>> @@ -0,0 +1,22 @@
>> +#ifndef __MMC_ATMEL_MCI_H
>> +#define __MMC_ATMEL_MCI_H
>> +
>> +#include <linux/platform_data/dma-atmel.h>
>> +#include <linux/dw_dmac.h>

Changed to:

<linux/platform_data/dma-dw.h>

>> +
>> +/**
>> + * struct mci_dma_data - DMA data for MCI interface
>> + */
>> +struct mci_dma_data {
>> +#ifdef CONFIG_ARM
>> +       struct at_dma_slave     sdata;
>> +#else
>> +       struct dw_dma_slave     sdata;
>> +#endif
>> +};
>> +
>> +/* accessor macros */
>> +#define        slave_data_ptr(s)       (&(s)->sdata)
>> +#define find_slave_dev(s)      ((s)->sdata.dma_dev)
>> +
>> +#endif /* __MMC_ATMEL_MCI_H */
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
