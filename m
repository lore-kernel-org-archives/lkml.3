Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3BSP1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:27:16 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38103 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab3BSP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:27:14 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <tony@atomide.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>
Subject: Re: [PATCH v3 2/3] arm: gpmc: Low power transition support
References: <1361278219-23108-1-git-send-email-avinashphilip@ti.com>
	<1361278219-23108-3-git-send-email-avinashphilip@ti.com>
Date: Tue, 19 Feb 2013 07:27:10 -0800
In-Reply-To: <1361278219-23108-3-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Tue, 19 Feb 2013 18:20:18 +0530")
Message-ID: <87bobgz5m9.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Avinash <avinashphilip@ti.com> writes:

> With GPMC converted to platform driver recently, adds low power
> transition support in driver itself.
>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	Module disable & enable added using pm_runtime support.
>
>  arch/arm/mach-omap2/gpmc.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index b1cd6c1..cc57988 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -1361,9 +1361,29 @@ static __devexit int gpmc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM

This should be CONFIG_PM_SLEEP for suspend/resume specific stuff.

> +static int gpmc_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	omap3_gpmc_save_context();
> +	pm_runtime_put_sync(&pdev->dev);
> +	return 0;
> +}
> +
> +static int gpmc_resume(struct platform_device *pdev)
> +{
> +	pm_runtime_get_sync(&pdev->dev);
> +	omap3_gpmc_restore_context();
> +	return 0;
> +}
> +#endif
> +
>  static struct platform_driver gpmc_driver = {
>  	.probe		= gpmc_probe,
>  	.remove		= __devexit_p(gpmc_remove),
> +#ifdef CONFIG_PM
> +	.suspend	= gpmc_suspend,
> +	.resume		= gpmc_resume,
> +#endif

These are the legacy PM operations, you need to use the ones in the
drivers struct dev_pm_ops.

>  	.driver		= {
>  		.name	= DEVICE_NAME,
>  		.owner	= THIS_MODULE,

Kevin
