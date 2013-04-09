Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936205Ab3DIPOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:14:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.15]:20542 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935378Ab3DIPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:14:38 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1365520475!22790711!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51643053.7030302@digi.com>
Date: Tue, 9 Apr 2013 17:14:27 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <linux-mmc@vger.kernel.org>, <kernel@pengutronix.de>, <cjb@laptop.org>,
        <aletes.xgr@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 2/2] mmc: mxs-mmc: add non-removable property
References: <1365166070-9370-1-git-send-email-mkl@pengutronix.de> <1365166070-9370-3-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1365166070-9370-3-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Marc Kleine-Budde,

On 04/05/2013 02:47 PM, Marc Kleine-Budde wrote:
> Some boards have non removable cards like eMMC. Handle such case.
>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> changes since v1:
> - fix removeable typo
>
>   drivers/mmc/host/mxs-mmc.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 0cdf1f6..c231881 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -73,6 +73,7 @@ struct mxs_mmc_host {
>   	int				wp_gpio;
>   	bool				wp_inverted;
>   	bool				cd_inverted;
> +	bool				non_removable;
>   };
>
>   static int mxs_mmc_get_ro(struct mmc_host *mmc)
> @@ -96,8 +97,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>   	struct mxs_mmc_host *host = mmc_priv(mmc);
>   	struct mxs_ssp *ssp = &host->ssp;
>
> -	return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
> -		 BM_SSP_STATUS_CARD_DETECT)) ^ host->cd_inverted;
> +	return host->non_removable ||
> +		!(readl(ssp->base + HW_SSP_STATUS(ssp)) &
> +		  BM_SSP_STATUS_CARD_DETECT) ^ host->cd_inverted;
>   }
>
>   static void mxs_mmc_reset(struct mxs_mmc_host *host)
> @@ -687,8 +689,10 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>   		mmc->caps |= MMC_CAP_4_BIT_DATA;
>   	else if (bus_width == 8)
>   		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
> +	host->non_removable = of_property_read_bool(np, "non-removable");
> +	if (host->non_removable)
> +		mmc->caps |= MMC_CAP_NONREMOVABLE;
>   	host->wp_gpio = of_get_named_gpio_flags(np, "wp-gpios", 0, &flags);
> -
>   	if (flags & OF_GPIO_ACTIVE_LOW)
>   		host->wp_inverted = 1;
>
>

It looks like Alexander and I were looking at the same in different threads:
   http://comments.gmane.org/gmane.linux.kernel.mmc/19964
   http://comments.gmane.org/gmane.linux.kernel/1471409

The following completes your 2/2 patch with broken-cd support as well (in both cases 
system must assume card is always present):

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 206fe49..7a60097 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -72,6 +72,8 @@ struct mxs_mmc_host {
         int                             sdio_irq_en;
         int                             wp_gpio;
         bool                            wp_inverted;
+       bool                            broken_cd;
+       bool                            non_removable;
  };

  static int mxs_mmc_get_ro(struct mmc_host *mmc)
@@ -95,7 +97,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
         struct mxs_mmc_host *host = mmc_priv(mmc);
         struct mxs_ssp *ssp = &host->ssp;

-       return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
+       return host->non_removable || host->broken_cd ||
+              !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
                  BM_SSP_STATUS_CARD_DETECT);
  }

@@ -686,8 +689,11 @@ static int mxs_mmc_probe(struct platform_device *pdev)
                 mmc->caps |= MMC_CAP_4_BIT_DATA;
         else if (bus_width == 8)
                 mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
+       host->broken_cd = of_property_read_bool(np, "broken-cd");
+       host->non_removable = of_property_read_bool(np, "non-removable");
+       if (host->non_removable)
+               mmc->caps |= MMC_CAP_NONREMOVABLE;
         host->wp_gpio = of_get_named_gpio_flags(np, "wp-gpios", 0, &flags);
-
         if (flags & OF_GPIO_ACTIVE_LOW)
                 host->wp_inverted = 1;


Regards,
-- 
Héctor Palacios

