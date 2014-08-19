Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaHSKWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:22:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:52603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaHSKWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:22:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="470251811"
Date: Tue, 19 Aug 2014 13:22:26 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-lynxpoint: enable input sensing in resume
Message-ID: <20140819102226.GM1660@lahna.fi.intel.com>
References: <1408444228-23733-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408444228-23733-1-git-send-email-mathias.nyman@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 01:30:28PM +0300, Mathias Nyman wrote:
> It appears that input sensing bit might be reset during
> suspend/resume. Set input sensing again for all requested gpios
> in resume
> 
> Tested-by: Jerome Blin <jerome.blin@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/gpio/gpio-lynxpoint.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
> index ff9eb91..4165672 100644
> --- a/drivers/gpio/gpio-lynxpoint.c
> +++ b/drivers/gpio/gpio-lynxpoint.c
> @@ -407,9 +407,33 @@ static int lp_gpio_runtime_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static int lp_gpio_suspend(struct device *dev)
> +{
> +	return 0;
> +}

If this function doesn't do anything why it needs to be defined here?

> +
> +static int lp_gpio_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lp_gpio *lg = platform_get_drvdata(pdev);
> +	unsigned long reg;
> +	int i;
> +
> +	/* on some hardware suspend clears input sensing, re-enable it here */
> +	for (i = 0; i < lg->chip.ngpio; i++) {
> +		if (gpiochip_is_requested(&lg->chip, i) != NULL) {
> +			reg = lp_gpio_reg(&lg->chip, i, LP_CONFIG2);
> +			outl(inl(reg) & ~GPINDIS_BIT, reg);
> +		}
> +	}
> +	return 0;
> +}
> +
>  static const struct dev_pm_ops lp_gpio_pm_ops = {
>  	.runtime_suspend = lp_gpio_runtime_suspend,
>  	.runtime_resume = lp_gpio_runtime_resume,
> +	.suspend = lp_gpio_suspend,
> +	.resume = lp_gpio_resume,
>  };
>  
>  static const struct acpi_device_id lynxpoint_gpio_acpi_match[] = {
> -- 
> 1.8.3.2
