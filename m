Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3GSFDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:03:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35433 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3GSFDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:03:05 -0400
Message-ID: <51E8C87A.3030007@ti.com>
Date: Fri, 19 Jul 2013 10:32:50 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Trent Piepho <tpiepho@gmail.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <linux-omap@vger.kernel.org>,
        <rnayak@ti.com>, <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>	<1374141687-10790-3-git-send-email-sourav.poddar@ti.com> <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com>
In-Reply-To: <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013 12:38 AM, Trent Piepho wrote:
> On Thu, Jul 18, 2013 at 3:01 AM, Sourav Poddar<sourav.poddar@ti.com>  wrote:
>> +Required properties:
>> +- compatible : should be "ti,dra7xxx-qspi".
>> +- reg: Should contain QSPI registers location and length.
>> +- #address-cells, #size-cells : Must be present if the device has sub-nodes
>> +- ti,hwmods: Name of the hwmod associated to the QSPI
> What is ti,hwmods?  It's not clear from the description.  It also
> doesn't appear to be used in the driver.  At least, I did not find any
> occurrence of "hwmods" in the driver code.
>
>> +static inline unsigned long ti_qspi_readl_data(struct ti_qspi *qspi,
>> +               unsigned long reg, int wlen)
> "readl" means read LONG.  That's what the L is for.  But this does
> different widths.
>
>> +{
>> +       switch (wlen) {
>> +       case 8:
>> +               return readw(qspi->base + reg);
>> +               break;
> wlen == 8, but readw == 16 bit read?
Yes, I need to change this. should be readb.
> The break after the return isn't necessary.
>
>> +       case 16:
>> +               return readb(qspi->base + reg);
>> +               break;
> wlen == 16, but readb == 8 bit read?
>
same here.
>> +       case 32:
>> +               return readl(qspi->base + reg);
> wlen == 32, readl == 32, this one makes sense, but....
>
>> +static inline void ti_qspi_writel_data(struct ti_qspi *qspi,
>> +               unsigned long val, unsigned long reg, int wlen)
>> +       case 32:
>> +               writeb(val, qspi->base + reg);
>> +               break;
> A 32 bit write uses an 8 bit write command, while read is 32 bits??
>
> This doesn't make a lot of sense.  If it's actually correct, there
> should be come kind of comment about it.
>
Yes, I will change this in the next version.
>> +
>> +static int ti_qspi_setup(struct spi_device *spi)
>> +{
>> +
>> +       clk_ctrl_reg = ti_qspi_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG);
>> +
>> +       clk_ctrl_reg&= ~QSPI_CLK_EN;
>> +
>> +       /* disable SCLK */
>> +       ti_qspi_writel(qspi, clk_ctrl_reg, QSPI_SPI_CLOCK_CNTRL_REG);
> Did you read this from Documentation/spi/spi-summary?
>                  ** BUG ALERT:  for some reason the first version of
>                  ** many spi_master drivers seems to get this wrong.
>                  ** When you code setup(), ASSUME that the controller
>                  ** is actively processing transfers for another device.
>
But I see in this documentation, that setup is usually used for setting up
device clock rate, modes etc.
So, what do you recommend here, should we move clk settings to prepare
hardware ?
>> +static int ti_qspi_probe(struct platform_device *pdev)
>> +{
>> +
>> +       master->mode_bits = SPI_CPOL | SPI_CPHA;
> Does your device support full duplex?  It doesn't look like it does.
> You should set the SPI_MASER_HALF_DUPLEX flag in master->flags.
>
hmm. Ok, will add.
>> +
>> +       if (!of_property_read_u32(np, "ti,spi-num-cs",&num_cs))
>> +               master->num_chipselect = num_cs;
> You didn't document this property.  How is this different than the
> "num-cs" property already documented in spi-bus bindings?
>
Actually, it is no different. This also means the total number of 
chipselects.
I used it from omap mcspi. I will make this property in accordance with the
generic binding.
Will also send a seperate patch for omap mcspi.
>> +       qspi->base = devm_ioremap_resource(&pdev->dev, r);
>> +       if (IS_ERR(qspi->base)) {
>> +               ret = -ENOMEM;
> Shouldn't that be ret = PTR_ERR(qspi->base)
hmm.will change.

