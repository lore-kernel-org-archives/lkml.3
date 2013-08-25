Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3HYTjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:39:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab3HYTjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:39:46 -0400
Message-ID: <521A5D7C.4050208@ti.com>
Date: Mon, 26 Aug 2013 01:09:40 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Francesco Lavra <francescolavra.fl@gmail.com>
CC: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: omap_hsmmc: clear status flags before starting a
 new command
References: <51CE7DC8.2070905@gmail.com>
In-Reply-To: <51CE7DC8.2070905@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 June 2013 11:55 AM, Francesco Lavra wrote:
> Commit 1f6b9fa40e76fffaaa0b3bd6a0bfdcf1cdc06efa consolidated writes to
> the STAT register in one location, moving them from omap_hsmmc_do_irq()
> to omap_hsmmc_irq(). This move has the unwanted side effect that the
> controller status flags are potentially cleared after a new command has
> been started as a consequence of reading the previous status flags.
> This means that if the new command changes the status flags before the
> IRQ routine returns, those flags may be cleared without handling the
> event which asserted them, and thus missing the event.
> Move the writing of the STAT register back in omap_hsmmc_do_irq(),
> before handling the status flags which generated the interrupt.
>
> Signed-off-by: Francesco Lavra <francescolavra.fl@gmail.com>

Reviewed and Tested-by: Balaji T K <balajitk@ti.com>

> ---
>   drivers/mmc/host/omap_hsmmc.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index eccedc7..301cb7e 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1041,6 +1041,7 @@ static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
>   		}
>   	}
>
> +	OMAP_HSMMC_WRITE(host->base, STAT, status);
>   	if (end_cmd || ((status & CC_EN) && host->cmd))
>   		omap_hsmmc_cmd_done(host, host->cmd);
>   	if ((end_trans || (status & TC_EN)) && host->mrq)
> @@ -1060,7 +1061,6 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
>   		omap_hsmmc_do_irq(host, status);
>
>   		/* Flush posted write */
> -		OMAP_HSMMC_WRITE(host->base, STAT, status);
>   		status = OMAP_HSMMC_READ(host->base, STAT);
>   	}
>
>
