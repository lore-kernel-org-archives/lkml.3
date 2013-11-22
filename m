Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3KVIqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:46:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:37481 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3KVIqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,750,1378882800"; 
   d="scan'208";a="437864292"
Message-ID: <528F1B7E.7010601@intel.com>
Date: Fri, 22 Nov 2013 10:53:18 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mmc: sdhci-acpi: covert to use GPIO descriptor API
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com> <1385045153-25160-3-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385045153-25160-3-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/13 16:45, Mika Westerberg wrote:
> The new descriptor based GPIO interface is now the recommend and more safer

"recommend and more safer" -> "recommended and safer"

> way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
> use that interface.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/mmc/host/sdhci-acpi.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
> index ef19874fcd1f..379ddfe14bc7 100644
> --- a/drivers/mmc/host/sdhci-acpi.c
> +++ b/drivers/mmc/host/sdhci-acpi.c
> @@ -31,10 +31,9 @@
>  #include <linux/bitops.h>
>  #include <linux/types.h>
>  #include <linux/err.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/interrupt.h>
>  #include <linux/acpi.h>
> -#include <linux/acpi_gpio.h>
>  #include <linux/pm.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
> @@ -199,22 +198,19 @@ static irqreturn_t sdhci_acpi_sd_cd(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static int sdhci_acpi_add_own_cd(struct device *dev, int gpio,
> -				 struct mmc_host *mmc)
> +static int sdhci_acpi_add_own_cd(struct device *dev, struct mmc_host *mmc)
>  {
> +	struct gpio_desc *desc;
>  	unsigned long flags;
>  	int err, irq;
>  
> -	if (gpio < 0) {
> -		err = gpio;
> +	desc = devm_gpiod_get_index(dev, NULL, 0);

I notice that:

	devm_gpio_request_one(.., label)
		-> gpio_request_one(..., label)
			-> gpiod_request(..., label)

but:

	devm_gpiod_get_index(..., con_id, ...)
		-> gpiod_get_index(..., con_id, ...)
			-> gpiod_request(..., con_id)

which suggests that 'con_id' is equivalent to 'label'.
i.e. "sd_cd".  Is it?

> +	if (IS_ERR(desc)) {
> +		err = PTR_ERR(desc);
>  		goto out;
>  	}
>  
> -	err = devm_gpio_request_one(dev, gpio, GPIOF_DIR_IN, "sd_cd");
> -	if (err)
> -		goto out;
> -
> -	irq = gpio_to_irq(gpio);
> +	irq = gpiod_to_irq(desc);
>  	if (irq < 0) {
>  		err = irq;
>  		goto out_free;
> @@ -228,7 +224,7 @@ static int sdhci_acpi_add_own_cd(struct device *dev, int gpio,
>  	return 0;
>  
>  out_free:
> -	devm_gpio_free(dev, gpio);
> +	devm_gpiod_put(dev, desc);
>  out:
>  	dev_warn(dev, "failed to setup card detect wake up\n");
>  	return err;
> @@ -254,7 +250,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
>  	struct resource *iomem;
>  	resource_size_t len;
>  	const char *hid;
> -	int err, gpio;
> +	int err;
>  
>  	if (acpi_bus_get_device(handle, &device))
>  		return -ENODEV;
> @@ -279,8 +275,6 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
>  	if (IS_ERR(host))
>  		return PTR_ERR(host);
>  
> -	gpio = acpi_get_gpio_by_index(dev, 0, NULL);
> -
>  	c = sdhci_priv(host);
>  	c->host = host;
>  	c->slot = sdhci_acpi_get_slot(handle, hid);
> @@ -338,7 +332,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
>  		goto err_free;
>  
>  	if (sdhci_acpi_flag(c, SDHCI_ACPI_SD_CD)) {
> -		if (sdhci_acpi_add_own_cd(dev, gpio, host->mmc))
> +		if (sdhci_acpi_add_own_cd(dev, host->mmc))
>  			c->use_runtime_pm = false;
>  	}
>  
> 

