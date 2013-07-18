Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974Ab3GRTIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:08:32 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34235 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3GRTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
	<1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
Date: Thu, 18 Jul 2013 12:08:30 -0700
Message-ID: <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
From: Trent Piepho <tpiepho@gmail.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: broonie@kernel.org, spi-devel-general@lists.sourceforge.net,
        grant.likely@linaro.org, linux-omap@vger.kernel.org, rnayak@ti.com,
        linux-kernel@vger.kernel.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 3:01 AM, Sourav Poddar <sourav.poddar@ti.com> wrote:
> +Required properties:
> +- compatible : should be "ti,dra7xxx-qspi".
> +- reg: Should contain QSPI registers location and length.
> +- #address-cells, #size-cells : Must be present if the device has sub-nodes
> +- ti,hwmods: Name of the hwmod associated to the QSPI

What is ti,hwmods?  It's not clear from the description.  It also
doesn't appear to be used in the driver.  At least, I did not find any
occurrence of "hwmods" in the driver code.

> +static inline unsigned long ti_qspi_readl_data(struct ti_qspi *qspi,
> +               unsigned long reg, int wlen)

"readl" means read LONG.  That's what the L is for.  But this does
different widths.

> +{
> +       switch (wlen) {
> +       case 8:
> +               return readw(qspi->base + reg);
> +               break;
wlen == 8, but readw == 16 bit read?

The break after the return isn't necessary.

> +       case 16:
> +               return readb(qspi->base + reg);
> +               break;
wlen == 16, but readb == 8 bit read?

> +       case 32:
> +               return readl(qspi->base + reg);

wlen == 32, readl == 32, this one makes sense, but....

> +static inline void ti_qspi_writel_data(struct ti_qspi *qspi,
> +               unsigned long val, unsigned long reg, int wlen)

> +       case 32:
> +               writeb(val, qspi->base + reg);
> +               break;

A 32 bit write uses an 8 bit write command, while read is 32 bits??

This doesn't make a lot of sense.  If it's actually correct, there
should be come kind of comment about it.

> +
> +static int ti_qspi_setup(struct spi_device *spi)
> +{

> +
> +       clk_ctrl_reg = ti_qspi_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG);
> +
> +       clk_ctrl_reg &= ~QSPI_CLK_EN;
> +
> +       /* disable SCLK */
> +       ti_qspi_writel(qspi, clk_ctrl_reg, QSPI_SPI_CLOCK_CNTRL_REG);

Did you read this from Documentation/spi/spi-summary?
                ** BUG ALERT:  for some reason the first version of
                ** many spi_master drivers seems to get this wrong.
                ** When you code setup(), ASSUME that the controller
                ** is actively processing transfers for another device.

> +static int ti_qspi_probe(struct platform_device *pdev)
> +{
> +
> +       master->mode_bits = SPI_CPOL | SPI_CPHA;

Does your device support full duplex?  It doesn't look like it does.
You should set the SPI_MASER_HALF_DUPLEX flag in master->flags.

> +
> +       if (!of_property_read_u32(np, "ti,spi-num-cs", &num_cs))
> +               master->num_chipselect = num_cs;

You didn't document this property.  How is this different than the
"num-cs" property already documented in spi-bus bindings?

> +       qspi->base = devm_ioremap_resource(&pdev->dev, r);
> +       if (IS_ERR(qspi->base)) {
> +               ret = -ENOMEM;

Shouldn't that be ret = PTR_ERR(qspi->base)
