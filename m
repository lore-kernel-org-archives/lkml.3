Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbaKNNbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:31:20 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40857 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbaKNNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:31:18 -0500
MIME-Version: 1.0
In-Reply-To: <1415955033-29093-6-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
	<1415955033-29093-6-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 14 Nov 2014 14:31:17 +0100
Message-ID: <CAPDyKFr+DVd0qZ=ra5W-HxHDqauX6ZwBK8S8t_fboJfk_BUTaA@mail.gmail.com>
Subject: Re: [PATCH v12 5/6] dmaengine: pl330: Add PM sleep support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2014 09:50, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Add system suspend/resume capabilities to the pl330 driver so the amba
> bus clock could be also unprepared to conserve energy.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/dma/pl330.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index c3bd3584f261..e499bb118f0a 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2627,6 +2627,46 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
>         return 0;
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
> +       struct amba_device *pcdev = to_amba_device(dev);
> +
> +       pm_runtime_disable(dev);
> +
> +       if (!pm_runtime_status_suspended(dev)) {
> +               /* amba did not disable the clock */
> +               amba_pclk_disable(pcdev);
> +       }
> +       amba_pclk_unprepare(pcdev);

I would also invoke pm_runtime_set_suspended() here, to reflect that's
the current runtime PM state of the device.

I guess I sounds like broken record :-), but using
pm_runtime_force_suspend() would help to prevent some code duplication
here.

Something like this:

pm_runtime_force_suspend()
if (pm_runtime_is_irq_safe())
   amba_pclk_unprepare(pcdev);


Kind regards
Uffe

> +
> +       return 0;
> +}
> +
> +static int __maybe_unused pl330_resume(struct device *dev)
> +{
> +       struct amba_device *pcdev = to_amba_device(dev);
> +       int ret;
> +
> +       ret = amba_pclk_prepare(pcdev);
> +       if (ret)
> +               return ret;
> +
> +       if (!pm_runtime_status_suspended(dev))
> +               ret = amba_pclk_enable(pcdev);
> +
> +       pm_runtime_enable(dev);
> +
> +       return ret;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> +
>  static int
>  pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  {
> @@ -2853,6 +2893,7 @@ static struct amba_driver pl330_driver = {
>         .drv = {
>                 .owner = THIS_MODULE,
>                 .name = "dma-pl330",
> +               .pm = &pl330_pm,
>         },
>         .id_table = pl330_ids,
>         .probe = pl330_probe,
> --
> 1.9.1
