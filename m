Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaKMBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:16:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65529 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753147AbaKMBQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:16:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v11 5/6] dmaengine: pl330: Add PM sleep support
Date: Thu, 13 Nov 2014 02:37:52 +0100
Message-ID: <1642105.slZZIy9b79@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415802748-30530-6-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com> <1415802748-30530-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2014 03:32:27 PM Krzysztof Kozlowski wrote:
> Add system suspend/resume capabilities to the pl330 driver so the amba
> bus clock could be also unprepared to conserve energy.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/dma/pl330.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index c3bd3584f261..fd71777fc565 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2627,6 +2627,42 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
>  	return 0;
>  }
>  
> +/*
> + * Runtime PM callbacks are provided by amba/bus.c driver.
> + *
> + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
> + * bus driver will only disable/enable the clock in runtime PM callbacks.
> + */
> +static int __maybe_unused pl330_suspend(struct device *dev)
> +{
> +	struct amba_device *pcdev = to_amba_device(dev);
> +
> +	if (!pm_runtime_status_suspended(dev)) {

It generally isn't safe to call that in .suspend(), because the status may still
change in theory.  On the other hand, if you do that in .suspend_late(), you'll
be safe from that.

> +		/* amba did not disable the clock */
> +		amba_pclk_disable(pcdev);
> +	}
> +	amba_pclk_unprepare(pcdev);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused pl330_resume(struct device *dev)
> +{
> +	struct amba_device *pcdev = to_amba_device(dev);
> +	int ret;
> +
> +	ret = amba_pclk_prepare(pcdev);
> +	if (ret)
> +		return ret;
> +
> +	if (!pm_runtime_status_suspended(dev))
> +		ret = amba_pclk_enable(pcdev);
> +
> +	return ret;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> +
>  static int
>  pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  {
> @@ -2853,6 +2889,7 @@ static struct amba_driver pl330_driver = {
>  	.drv = {
>  		.owner = THIS_MODULE,
>  		.name = "dma-pl330",
> +		.pm = &pl330_pm,
>  	},
>  	.id_table = pl330_ids,
>  	.probe = pl330_probe,
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
