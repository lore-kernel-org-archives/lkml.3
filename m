Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3BENMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:12:12 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47638 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3BENML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:12:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] spi: tegra: remove checks for valid speed
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1357325235-25485-2-git-send-email-ldewangan@nvidia.com>
References: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com> <1357325235-25485-2-git-send-email-ldewangan@nvidia.com>
Date: Tue, 05 Feb 2013 13:12:04 +0000
Message-Id: <20130205131204.6D47D3E0E27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2013 00:17:15 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> SPI core make sure that all transfer has proper speed set
> before calling low level spi transfer. Hence, it is not
> require to have check in spi driver.
> 
> Remove the check for speed validity from transfer and use it directly.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-tegra20-sflash.c |   14 +++++++++++---
>  drivers/spi/spi-tegra20-slink.c  |    6 +++---
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
> index 448a8cc..9a42c15 100644
> --- a/drivers/spi/spi-tegra20-sflash.c
> +++ b/drivers/spi/spi-tegra20-sflash.c
> @@ -269,9 +269,7 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
>  	u32 speed;
>  	unsigned long command;
>  
> -	speed = t->speed_hz ? t->speed_hz : spi->max_speed_hz;
> -	if (!speed)
> -		speed = tsd->spi_max_frequency;
> +	speed = t->speed_hz;
>  	if (speed != tsd->cur_speed) {
>  		clk_set_rate(tsd->clk, speed);
>  		tsd->cur_speed = speed;
> @@ -319,6 +317,15 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
>  	return  tegra_sflash_start_cpu_based_transfer(tsd, t);
>  }
>  
> +static int tegra_sflash_setup(struct spi_device *spi)
> +{
> +	struct tegra_sflash_data *tsd = spi_master_get_devdata(spi->master);
> +
> +	/* Set speed to the spi max fequency if spi device has not set */
> +	spi->max_speed_hz = spi->max_speed_hz ? : tsd->spi_max_frequency;
> +	return 0;
> +}
> +
>  static int tegra_sflash_transfer_one_message(struct spi_master *master,
>  			struct spi_message *msg)
>  {
> @@ -492,6 +499,7 @@ static int tegra_sflash_probe(struct platform_device *pdev)
>  
>  	/* the spi->mode bits understood by this driver: */
>  	master->mode_bits = SPI_CPOL | SPI_CPHA;
> +	master->setup = tegra_sflash_setup;
>  	master->transfer_one_message = tegra_sflash_transfer_one_message;
>  	master->num_chipselect = MAX_CHIP_SELECT;
>  	master->bus_num = -1;
> diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
> index 651167f..29039f1 100644
> --- a/drivers/spi/spi-tegra20-slink.c
> +++ b/drivers/spi/spi-tegra20-slink.c
> @@ -728,9 +728,7 @@ static int tegra_slink_start_transfer_one(struct spi_device *spi,
>  	unsigned long command2;
>  
>  	bits_per_word = t->bits_per_word;
> -	speed = t->speed_hz ? t->speed_hz : spi->max_speed_hz;
> -	if (!speed)
> -		speed = tspi->spi_max_frequency;
> +	speed = t->speed_hz;
>  	if (speed != tspi->cur_speed) {
>  		clk_set_rate(tspi->clk, speed * 4);
>  		tspi->cur_speed = speed;
> @@ -841,6 +839,8 @@ static int tegra_slink_setup(struct spi_device *spi)
>  
>  	BUG_ON(spi->chip_select >= MAX_CHIP_SELECT);
>  
> +	/* Set speed to the spi max fequency if spi device has not set */
> +	spi->max_speed_hz = spi->max_speed_hz ? : tspi->spi_max_frequency;
>  	ret = pm_runtime_get_sync(tspi->dev);
>  	if (ret < 0) {
>  		dev_err(tspi->dev, "pm runtime failed, e = %d\n", ret);
> -- 
> 1.7.1.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
