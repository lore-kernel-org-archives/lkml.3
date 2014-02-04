Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaBDTWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:22:49 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50003 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaBDTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:22:45 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 05/17] mmc: mmci: Put the device into low power state at system suspend
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-6-git-send-email-ulf.hansson@linaro.org>
Date: Tue, 04 Feb 2014 11:22:42 -0800
In-Reply-To: <1391529538-21685-6-git-send-email-ulf.hansson@linaro.org> (Ulf
	Hansson's message of "Tue, 4 Feb 2014 16:58:46 +0100")
Message-ID: <8738jyu1h9.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> Due to the available runtime PM callbacks, we are now able to put our
> device into low power state at system suspend.
>
> Earlier we could not accomplish this without trusting a power domain
> for the device to take care of it. Now we are able to cope with
> scenarios both with and without a power domain.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/mmci.c |   45 +++++++++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index c88da1c..074e0cb 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -1723,33 +1723,38 @@ static int mmci_remove(struct amba_device *dev)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_SUSPEND
> -static int mmci_suspend(struct device *dev)
> +#ifdef CONFIG_PM_SLEEP
> +static int mmci_suspend_late(struct device *dev)
>  {
> -	struct amba_device *adev = to_amba_device(dev);
> -	struct mmc_host *mmc = amba_get_drvdata(adev);
> +	int ret = 0;
>  
> -	if (mmc) {
> -		struct mmci_host *host = mmc_priv(mmc);
> -		pm_runtime_get_sync(dev);
> -		writel(0, host->base + MMCIMASK0);
> -	}
> +	if (pm_runtime_status_suspended(dev))
> +		return 0;
>  
> -	return 0;
> +	if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
> +		ret = dev->pm_domain->ops.runtime_suspend(dev);
> +	else
> +		ret = dev->bus->pm->runtime_suspend(dev);
> +
> +	if (!ret)
> +		pm_runtime_set_suspended(dev);

Isn't this basically open-coding pm_runtime_suspend()...

> +	return ret;
>  }
>  
> -static int mmci_resume(struct device *dev)
> +static int mmci_resume_early(struct device *dev)
>  {
> -	struct amba_device *adev = to_amba_device(dev);
> -	struct mmc_host *mmc = amba_get_drvdata(adev);
> +	int ret = 0;
>  
> -	if (mmc) {
> -		struct mmci_host *host = mmc_priv(mmc);
> -		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
> -		pm_runtime_put(dev);
> -	}
> +	if (pm_runtime_status_suspended(dev))
> +		return 0;
>  
> -	return 0;
> +	if (dev->pm_domain && dev->pm_domain->ops.runtime_resume)
> +		ret = dev->pm_domain->ops.runtime_resume(dev);
> +	else
> +		ret = dev->bus->pm->runtime_resume(dev);
> +
> +	return ret;

...and this is pm_runtime_resume()? (though both terribly simplified.)

This is starting to show that building with PM_SLEEP but not PM_RUNTIME
is going to force open-coding a lot of stuff that the runtime PM
framework already provides.  So either we need some helper functions so
we're not sprinkling manual calls to bus/pm_domain callbacks all over
the place, or maybe where we need to go is have a way for platforms that
really are "runtime PM centric" to declare that even PM_SLEEP depends on
PM_RUNTIME.  

I'm trying to thing of a good reason to not make PM_SLEEP depend on
PM_RUNTIME for platforms like this.

Kevin

