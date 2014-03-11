Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaCKPxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:53:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53859 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaCKPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:53:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
Date: Tue, 11 Mar 2014 16:55:15 +0100
Message-ID: <1802214.NxZUiJcWLG@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394531952-3905-2-git-send-email-geert@linux-m68k.org>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org> <1394531952-3905-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

Does this require drivers/sh/pm_runtime.c to be compiled in ?

On Tuesday 11 March 2014 10:59:11 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> ---
>  drivers/spi/spi-sh-msiof.c |   25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
> index 739eb2f12ecc..e850d03e7190 100644
> --- a/drivers/spi/spi-sh-msiof.c
> +++ b/drivers/spi/spi-sh-msiof.c
> @@ -448,9 +448,6 @@ static int sh_msiof_prepare_message(struct spi_master
> *master, struct sh_msiof_spi_priv *p = spi_master_get_devdata(master);
>  	const struct spi_device *spi = msg->spi;
> 
> -	pm_runtime_get_sync(&p->pdev->dev);
> -	clk_enable(p->clk);
> -
>  	/* Configure pins before asserting CS */
>  	sh_msiof_spi_set_pin_regs(p, !!(spi->mode & SPI_CPOL),
>  				  !!(spi->mode & SPI_CPHA),
> @@ -460,16 +457,6 @@ static int sh_msiof_prepare_message(struct spi_master
> *master, return 0;
>  }
> 
> -static int sh_msiof_unprepare_message(struct spi_master *master,
> -				      struct spi_message *msg)
> -{
> -	struct sh_msiof_spi_priv *p = spi_master_get_devdata(master);
> -
> -	clk_disable(p->clk);
> -	pm_runtime_put(&p->pdev->dev);
> -	return 0;
> -}
> -
>  static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
>  				  void (*tx_fifo)(struct sh_msiof_spi_priv *,
>  						  const void *, int, int),
> @@ -742,12 +729,6 @@ static int sh_msiof_spi_probe(struct platform_device
> *pdev) goto err1;
>  	}
> 
> -	ret = clk_prepare(p->clk);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "unable to prepare clock\n");
> -		goto err1;
> -	}
> -
>  	p->pdev = pdev;
>  	pm_runtime_enable(&pdev->dev);
> 
> @@ -768,8 +749,8 @@ static int sh_msiof_spi_probe(struct platform_device
> *pdev) master->num_chipselect = p->info->num_chipselect;
>  	master->setup = sh_msiof_spi_setup;
>  	master->prepare_message = sh_msiof_prepare_message;
> -	master->unprepare_message = sh_msiof_unprepare_message;
>  	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 32);
> +	master->auto_runtime_pm = true;
>  	master->transfer_one = sh_msiof_transfer_one;
> 
>  	ret = devm_spi_register_master(&pdev->dev, master);
> @@ -782,7 +763,6 @@ static int sh_msiof_spi_probe(struct platform_device
> *pdev)
> 
>   err2:
>  	pm_runtime_disable(&pdev->dev);
> -	clk_unprepare(p->clk);
>   err1:
>  	spi_master_put(master);
>  	return ret;
> @@ -790,10 +770,7 @@ static int sh_msiof_spi_probe(struct platform_device
> *pdev)
> 
>  static int sh_msiof_spi_remove(struct platform_device *pdev)
>  {
> -	struct sh_msiof_spi_priv *p = platform_get_drvdata(pdev);
> -
>  	pm_runtime_disable(&pdev->dev);
> -	clk_unprepare(p->clk);
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

