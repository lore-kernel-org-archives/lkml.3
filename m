Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaENHDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:03:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:39814 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaENHDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1050,1389772800"; 
   d="scan'208";a="431884094"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm: lpss: remove dependency on clk framework
Thread-Topic: [PATCH] pwm: lpss: remove dependency on clk framework
Thread-Index: AQHPa2HlssGmNDZgIEys6Mqka80XEps/rNfA
Date: Wed, 14 May 2014 07:00:59 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0B004D2D@PGSMSX108.gar.corp.intel.com>
References: <1399624521-26175-1-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1399624521-26175-1-git-send-email-heikki.krogerus@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Unlike other Intel LPSS devices, the PWM does not have the clock dividers or
> the gate. All we get from the clock is the rate. Since PCI case uses the driver
> data to get the rate, we can drop the clk and use the same data also in case of
> ACPI. The frequency is the same.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/pwm/pwm-lpss.c | 32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c index
> 44ce6c6..4df994f 100644
> --- a/drivers/pwm/pwm-lpss.c
> +++ b/drivers/pwm/pwm-lpss.c
> @@ -14,7 +14,6 @@
>   */
> 
>  #include <linux/acpi.h>
> -#include <linux/clk.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -37,7 +36,6 @@ static int pci_drv, plat_drv;	/* So we know which drivers
> registered */
>  struct pwm_lpss_chip {
>  	struct pwm_chip chip;
>  	void __iomem *regs;
> -	struct clk *clk;
>  	unsigned long clk_rate;
>  };
> 
> @@ -97,11 +95,6 @@ static int pwm_lpss_enable(struct pwm_chip *chip,
> struct pwm_device *pwm)  {
>  	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
>  	u32 ctrl;
> -	int ret;
> -
> -	ret = clk_prepare_enable(lpwm->clk);
> -	if (ret)
> -		return ret;
> 
>  	ctrl = readl(lpwm->regs + PWM);
>  	writel(ctrl | PWM_ENABLE, lpwm->regs + PWM); @@ -116,8 +109,6
> @@ static void pwm_lpss_disable(struct pwm_chip *chip, struct pwm_device
> *pwm)
> 
>  	ctrl = readl(lpwm->regs + PWM);
>  	writel(ctrl & ~PWM_ENABLE, lpwm->regs + PWM);
> -
> -	clk_disable_unprepare(lpwm->clk);
>  }
> 
>  static const struct pwm_ops pwm_lpss_ops = { @@ -142,17 +133,7 @@ static
> struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
>  	if (IS_ERR(lpwm->regs))
>  		return ERR_CAST(lpwm->regs);
> 
> -	if (info) {
> -		lpwm->clk_rate = info->clk_rate;
> -	} else {
> -		lpwm->clk = devm_clk_get(dev, NULL);
> -		if (IS_ERR(lpwm->clk)) {
> -			dev_err(dev, "failed to get PWM clock\n");
> -			return ERR_CAST(lpwm->clk);
> -		}
> -		lpwm->clk_rate = clk_get_rate(lpwm->clk);
> -	}
> -
> +	lpwm->clk_rate = info->clk_rate;
>  	lpwm->chip.dev = dev;
>  	lpwm->chip.ops = &pwm_lpss_ops;
>  	lpwm->chip.base = -1;
> @@ -221,12 +202,19 @@ static struct pci_driver pwm_lpss_driver_pci = {
> 
>  static int pwm_lpss_probe_platform(struct platform_device *pdev)  {
> +	const struct pwm_lpss_boardinfo *info;
> +	const struct acpi_device_id *id;
>  	struct pwm_lpss_chip *lpwm;
>  	struct resource *r;
> 
> +	id = acpi_match_device(pdev->dev.driver->acpi_match_table, &pdev-
> >dev);
> +	if (!id)
> +		return -ENODEV;
> +
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 
> -	lpwm = pwm_lpss_probe(&pdev->dev, r, NULL);
> +	info = (struct pwm_lpss_boardinfo *)id->driver_data;
> +	lpwm = pwm_lpss_probe(&pdev->dev, r, info);
>  	if (IS_ERR(lpwm))
>  		return PTR_ERR(lpwm);
> 
> @@ -242,7 +230,7 @@ static int pwm_lpss_remove_platform(struct
> platform_device *pdev)  }
> 
>  static const struct acpi_device_id pwm_lpss_acpi_match[] = {
> -	{ "80860F09", 0 },
> +	{ "80860F09", (unsigned long)&byt_info },
>  	{ },
>  };

Heikki,
For ACPI mode, the clock rate information for PWM is being setup in the acpi_lpss.c layer.
Thus, only PCI mode depends on the driver_data to pass in the clock rate information.


>  MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match);
> --
> 2.0.0.rc2

