Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599Ab3DCLaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:30:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62341 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520Ab3DCLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130401131207.GI18636@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
	<1363157014-9615-3-git-send-email-ks.giri@samsung.com>
	<20130401131207.GI18636@opensource.wolfsonmicro.com>
Date: Wed, 3 Apr 2013 17:00:04 +0530
Message-ID: <CAKrE-KdWe6aCg0p99BFEeQP-P2nwvdhs2itH3XnHsJMCUjWPAA@mail.gmail.com>
Subject: Re: [PATCH V3 2/5] spi: s3c64xx: added support for polling mode
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 6:42 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Mar 13, 2013 at 12:13:31PM +0530, Girish K S wrote:
>
>> Some SoC's that adopt this controller might not have have dma
>> interface. This patch adds support for complete polling mode
>> and gives flexibity for the user to select poll/dma mode.
>
> Ouch, that sounds like a regression.
>
>> @@ -419,6 +422,27 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
>>
>>       cs = spi->controller_data;
>>       gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
>> +
>> +     /* Start the signals */
>> +     writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
>> +}
>> +
>
> This looks odd and not obviously related to the rest of the change -
> does it belong as part of some of your other commits adding support for
> using the controller /CS functionality?  In general it feels like this
> ought to be broken down a bit - there's some refactoring as well as the
> new functionality.

it is part of this patch. It is just the movement of slave active bit from
s3c64xx_spi_config to enable_cs and disable_cs function respectively.
It is not part of chip select gpio patch.

>
>> +static u32 wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
>> +                                     int timeout_ms)
>> +{
>> +     void __iomem *regs = sdd->regs;
>> +     unsigned long val;
>> +     u32 status;
>> +     /* max fifo depth available */
>> +     u32 max_fifo = (FIFO_LVL_MASK(sdd) >> 1) + 1;
>> +
>> +     val = msecs_to_loops(timeout_ms);
>> +     do {
>> +             status = readl(regs + S3C64XX_SPI_STATUS);
>> +     } while (RX_FIFO_LVL(status, sdd) < max_fifo && --val);
>> +
>> +     /* return the actual received data length */
>> +     return RX_FIFO_LVL(status, sdd);
>
> This is really wait_for_fifo_empty_with_timeout() isn't it?  It feels
> like there ought to be at least a cpu_relax() in the busy wait too.

This code existed in the older version, I just made it as a separate function.
Will check it and make necessary change.

>
>> +             /*
>> +              * If the receive length is bigger than the controller fifo
>> +              * size, calculate the loops and read the fifo as many times.
>> +              * loops = length / max fifo size (calculated by using the
>> +              * fifo mask).
>> +              * For any size less than the fifo size the below code is
>> +              * executed atleast once.
>> +              */
>> +             loops = xfer->len / ((FIFO_LVL_MASK(sdd) >> 1) + 1);
>> +             buf = xfer->rx_buf;
>> +             do{
>
> Coding style.

Will change it

>
>> -     if (!sdd->pdev->dev.of_node) {
>> +     if (!sdd->pdev->dev.of_node && !is_polling(sdd)) {
>>               res = platform_get_resource(pdev, IORESOURCE_DMA,  0);
>>               if (!res) {
>>                       dev_err(&pdev->dev, "Unable to get SPI tx dma "
>
> It seems like it'd be sensible to also handle failure to get the DMA
> resource by going into polling mode.

There are 2 cases currently i have identified and handled,
1. The SoC's dont have DMA support for spi controller. For such SoC's we
 would not add the dma resource in the spi dts node. In this case the probe
 would return error if failure for DMA resuorce is handled.

2. The SoC has a DMA support for SPI controller, but due to some x
reason(H/W bug),
 the driver would force polling mode by enabling
S3C64XX_SPI_QUIRK_POLL in driver
 data. For such SoC's there would be a dma entry in the spi controller
dts node, and
 probe can handle failure for DMA resource successfully.

To handle above both situations successfully if
(!sdd->pdev->dev.of_node && !is_polling(sdd)) is used.
