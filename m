Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaAaQS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:18:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42092 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaQSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:18:25 -0500
Message-ID: <52EBCCCD.301@wwwdotorg.org>
Date: Fri, 31 Jan 2014 09:18:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
CC: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] spi: switch to devm_spi_alloc_master
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com> <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 03:23 AM, Maxime Ripard wrote:
> Make the existing users of devm_spi_register_master use the
> devm_spi_alloc_master function to avoid leaking memory.

> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c

> @@ -1087,14 +1085,13 @@ static int tegra_spi_probe(struct platform_device *pdev)
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
>  					tspi->irq);
> -		goto exit_free_master;
> +		return ret;
>  	}
>  
>  	tspi->clk = devm_clk_get(&pdev->dev, "spi");
>  	if (IS_ERR(tspi->clk)) {
>  		dev_err(&pdev->dev, "can not get clock\n");
> -		ret = PTR_ERR(tspi->clk);
> -		goto exit_free_irq;
> +		return PTR_ERR(tspi->clk);
>  	}
>  
>  	tspi->max_buf_size = SPI_FIFO_DEPTH << 2;
> @@ -1152,8 +1149,6 @@ exit_rx_dma_free:
>  	tegra_spi_deinit_dma_param(tspi, true);
>  exit_free_irq:
>  	free_irq(spi_irq, tspi);
> -exit_free_master:
> -	spi_master_put(master);
>  	return ret;

Doesn't that s/goto exit_free_irq/return/ leak spi_irq? It's only OK to
replace goto free_master with a direct return.

The other two Tegra drivers don't seem to have this problem.
