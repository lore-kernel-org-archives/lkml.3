Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab3BSSQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:16:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab3BSSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:16:46 -0500
Message-ID: <5123C18A.9010604@wwwdotorg.org>
Date: Tue, 19 Feb 2013 11:16:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        broonie@opensource.wolfsonmicro.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH] spi: tegra114: add spi driver
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 06:38 AM, Laxman Dewangan wrote:
> Add spi driver for NVIDIA's Tegra114 spi controller. This controller
> is different than the older SoCs spi controller in internal design as
> well as register interface.

Nit: SPI should be capitalized. Also in Kconfig below.

> diff --git a/Documentation/devicetree/bindings/spi/nvidia,spi-tegra114.txt b/Documentation/devicetree/bindings/spi/nvidia,spi-tegra114.txt

This file should be named nvidia,tegra114-spi.txt, so that it matches
the compatible value it describes.

> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig

> +config SPI_TEGRA114
> +	tristate "Nvidia Tegra114 SPI Controller"

NVIDIA should be capitalized. Also in the help description below.

> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile

>  obj-$(CONFIG_SPI_SIRF)		+= spi-sirf.o
>  obj-$(CONFIG_SPI_TEGRA20_SFLASH)	+= spi-tegra20-sflash.o
> +obj-$(CONFIG_SPI_TEGRA114)			+= spi-tegra114.o
>  obj-$(CONFIG_SPI_TEGRA20_SLINK)		+= spi-tegra20-slink.o
>  obj-$(CONFIG_SPI_TI_SSP)		+= spi-ti-ssp.o

The Makefile should be sorted; Tegra114 comes before Tegra20*.

> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c

> +static unsigned tegra_spi_calculate_curr_xfer_param(
...
> +	bits_per_word = t->bits_per_word ? t->bits_per_word :
> +						spi->bits_per_word;

I thought I'd seen patches so this conditional wasn't needed any more;
isn't t->bit_per_word always set correctly by the SPI core now?
Certainly the existing spi-tegra20-slink.c doesn't seem to have any
conditional here.

A similar comment applies in tegra_spi_read_rx_fifo_to_client_rxbuf()
and tegra_spi_copy_spi_rxbuf_to_client_rxbuf().

> +		total_fifo_words = (max_len + 3)/4;

Need spaces around /. The same comment applies in some other places;
please search for them. Was checkpatch run? I'm not sure if catches this.

spi-tegra20-slink.c doesn't have that rounding; is just says:

    total_fifo_words = max_len / 4;

Is that a bug in the old driver?

> +static int tegra_spi_start_dma_based_transfer(
> +		struct tegra_spi_data *tspi, struct spi_transfer *t)
...
> +	if (tspi->cur_direction & DATA_DIR_TX) {
> +		tegra_spi_copy_client_txbuf_to_spi_txbuf(tspi, t);
> +		ret = tegra_spi_start_tx_dma(tspi, len);

In spi-tegra20-slink.c, there's a wmb() right between those last two
lines. Is it needed here?

> +static int tegra_spi_start_transfer_one(struct spi_device *spi,
> +		struct spi_transfer *t, bool is_first_of_msg,
> +		bool is_single_xfer)
...
> +		/* possibly use the hw based chip select */
> +		command1 |= SPI_CS_SW_HW;
> +		if (spi->mode & SPI_CS_HIGH)
> +			command1 |= SPI_CS_SS_VAL;
> +		else
> +			command1 &= ~SPI_CS_SS_VAL;

Why "possibly"; the code seems to always use HW chip select.

> +static int tegra_spi_transfer_one_message(struct spi_master *master,
> +			struct spi_message *msg)
...
> +	ret = pm_runtime_get_sync(tspi->dev);
> +	if (ret < 0) {
> +		dev_err(tspi->dev, "runtime PM get failed: %d\n", ret);
> +		msg->status = ret;
> +		spi_finalize_current_message(master);
> +		return ret;
> +	}

In the older Tegra SPI drivers, the PM runtime logic was was of
master->{un,}prepare_transfer. I'm curious why it's implemented
differently here.

> +static void tegra_spi_parse_dt(struct platform_device *pdev,
> +	struct tegra_spi_data *tspi)
...
> +	prop = of_get_property(np, "spi-max-frequency", NULL);
> +	if (prop)
> +		tspi->spi_max_frequency = be32_to_cpup(prop);

The following might be better:

        if (of_property_read_u32(np, "spi-max-frequency",
                                        &tspi->spi_max_frequency))
                tspi->spi_max_frequency = 25000000; /* 25MHz */

(and you can remove the check of !tspi->spi_max_frequency from probe()
then too)

> +static int tegra_spi_probe(struct platform_device *pdev)
...
> +	if (!pdev->dev.of_node) {
> +		dev_err(&pdev->dev, "Driver support DT registration only\n");
> +		return -ENODEV;
> +	}

I don't think there's much point checking that; see the Tegra20 SPI
cleanup patches I posted a couple days ago.

> +	tspi->base = devm_request_and_ioremap(&pdev->dev, r);
> +	if (!tspi->base) {

The existing Tegra20 driver checks if (IS_ERR(tspi->base)) here. Which
is wrong?

> +	tspi->clk = devm_clk_get(&pdev->dev, "spi");

Does this HW block use multiple clocks? If not, I think s/"spi"/NULL/
there, just like the Tegra20 driver.

As an overall comment, this driver is textually perhaps 80-90% the same
as spi-tegra20-slink.c. Instead of creating a completely new driver, how
nasty would a unified driver look; one which contained some runtime
conditionals for the register layout and programming differences? It
might be worth looking at, although perhaps it would turn out to be a
crazy mess, so a separate driver really is appropriate.
