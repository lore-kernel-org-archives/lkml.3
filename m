Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3FCKbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:31:45 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62146 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3FCKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <51ac5610.87ebc20a.4198.ffffdc38SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com> <51ac5610.87ebc20a.4198.ffffdc38SMTPIN_ADDED_BROKEN@mx.google.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 3 Jun 2013 12:31:22 +0200
Message-ID: <CACQ1gAgYj7tPqQ01oYiRZiuMAS3XQhsp9t3t4boPjZCV2wtBBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi: atmel: convert to dma_request_slave_channel_compat()
To: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ludovic.desroches@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/3 Ludovic Desroches <ludovic.desroches@atmel.com>:
> On Fri, May 31, 2013 at 05:01:59PM +0200, Richard Genoud wrote:
>> Use generic DMA DT helper.
>> Platforms booting with or without DT populated are both supported.
>>
>> Based on Ludovic Desroches <ludovic.desroches@atmel.com> patchset
>> "ARM: at91: move to generic DMA device tree binding"
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>
> Looks fine for me to so
> Acked-by: Ludovic Desroches <ludovic.desroches@gmail.com>
>
> One comment below
>
Response below.
>> ---
>>  drivers/spi/spi-atmel.c |   42 +++++++++++++++++++++++++++---------------
>>  1 file changed, 27 insertions(+), 15 deletions(-)
>>
>> rebased on linux-next next-20130531
>>
>> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
>> index 31cfc87..ea1ec00 100644
>> --- a/drivers/spi/spi-atmel.c
>> +++ b/drivers/spi/spi-atmel.c
>> @@ -424,10 +424,15 @@ static int atmel_spi_dma_slave_config(struct atmel_spi *as,
>>       return err;
>>  }
>>
>> -static bool filter(struct dma_chan *chan, void *slave)
>> +static bool filter(struct dma_chan *chan, void *pdata)
>>  {
>> -     struct  at_dma_slave *sl = slave;
>> +     struct atmel_spi_dma *sl_pdata = pdata;
>> +     struct at_dma_slave *sl;
>>
>> +     if (!sl_pdata)
>> +             return false;
>> +
>> +     sl = &sl_pdata->dma_slave;
>>       if (sl->dma_dev == chan->device->dev) {
>
> I am wondering if a null pointer dereference can happen here. In
> atmel_spi_configure_dma sdata was checked so maybe sl should be check
> here.

sdata was checked, but there was no point checking it:
if as is not null, as->dma.dma_slave is defined ; so its address is not null.
it's the same in the filter function now:
if sl_pdata is not null, sl_pdata->dma_slave is defined ; so its
address is not null.

I added a check on sl_pdata in this patch, maybe a (BUG|WARN)_ON()
would have been better, as it really should not happen.


>>               chan->private = sl;
>>               return true;
>> @@ -438,24 +443,31 @@ static bool filter(struct dma_chan *chan, void *slave)
>>
>>  static int atmel_spi_configure_dma(struct atmel_spi *as)
>>  {
>> -     struct at_dma_slave *sdata = &as->dma.dma_slave;
>>       struct dma_slave_config slave_config;
>> +     struct device *dev = &as->pdev->dev;
>>       int err;
>>
>> -     if (sdata && sdata->dma_dev) {
>> -             dma_cap_mask_t mask;
>> +     dma_cap_mask_t mask;
>> +     dma_cap_zero(mask);
>> +     dma_cap_set(DMA_SLAVE, mask);
>>
>> -             /* Try to grab two DMA channels */
>> -             dma_cap_zero(mask);
>> -             dma_cap_set(DMA_SLAVE, mask);
>> -             as->dma.chan_tx = dma_request_channel(mask, filter, sdata);
>> -             if (as->dma.chan_tx)
>> -                     as->dma.chan_rx =
>> -                             dma_request_channel(mask, filter, sdata);
>> +     as->dma.chan_tx = dma_request_slave_channel_compat(mask, filter,
>> +                                                        &as->dma,
>> +                                                        dev, "tx");
>> +     if (!as->dma.chan_tx) {
>> +             dev_err(dev,
>> +                     "DMA TX channel not available, SPI unable to use DMA\n");
>> +             err = -EBUSY;
>> +             goto error;
>>       }
>> -     if (!as->dma.chan_rx || !as->dma.chan_tx) {
>> -             dev_err(&as->pdev->dev,
>> -                     "DMA channel not available, SPI unable to use DMA\n");
>> +
>> +     as->dma.chan_rx = dma_request_slave_channel_compat(mask, filter,
>> +                                                        &as->dma,
>> +                                                        dev, "rx");
>> +
>> +     if (!as->dma.chan_rx) {
>> +             dev_err(dev,
>> +                     "DMA RX channel not available, SPI unable to use DMA\n");
>>               err = -EBUSY;
>>               goto error;
>>       }
>> --
>> 1.7.10.4
>>

Best regards,

Richard.
