Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaF0J0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:26:21 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40613 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0J0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:26:19 -0400
Date: Fri, 27 Jun 2014 10:26:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/14] regulator: Add driver for Maxim 77802 PMIC
 regulators
Message-ID: <20140627092611.GI19645@lee--X1>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-11-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403806546-31122-11-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Javier Martinez Canillas wrote:
> The MAX77802 PMIC has 10 high-efficiency Buck and 32 Low-dropout
> (LDO) regulators. This patch adds support for all these regulators
> found on the MAX77802 PMIC and is based on a driver added by Simon
> Glass to the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> 
> Changes since v4: None
> 
> Changes since v3:
>  - Set the supply_name for regulators to lookup their parent supply node.
>    Suggested by Mark Brown.
>  - Change Exyno5 for Exynos5420/Exynos5800 in regulator driver Kconfig.
>    Suggested by Doug Anderson.
> 
> Changes since v2:
>  - Use dev_warn() instead pr_warn(). Suggested by Mark Brown.
>  - Add a generic function to regmap core to copy registers instead of
>    having a driver-specific function. Suggested by Mark Brown.
>  - Remove unnecessary probe debug log. Suggested by Mark Brown.
>  - Set struct regulator_config dev field to MFD instead of the platform dev.
>    Suggested by Mark Brown.
>  - Read the regulators operational mode from the hardware registers instead
>    of setting to normal as default on probe. Suggested by Mark Brown.
>  - Remove unnecessary cross-subsystem dependencies. Suggested by Lee Jones.
> 
> Changes since v1:
>  - Remove unneeded check if num_regulators != MAX77802_MAX_REGULATORS.
>  - Fix .set_suspend_mode handler comment and split regulators ops for
>    regulators that behave differently. Suggested by Mark Brown.
>  - Use module_platform_driver() instead of having init/exit functions.
>    Suggested by Mark Brown.
>  - Use the new descriptor-based GPIO interface instead of the deprecated
>    integer based GPIO one. Suggested by Mark Brown.
>  - Look for "regulators" child node instead of "voltage-regulators" to be
>    consistent with other PMIC drivers. Suggested by Mark Brown.
> 
>  drivers/mfd/max77802.c               |   8 +-
>  drivers/regulator/Kconfig            |   9 +
>  drivers/regulator/Makefile           |   1 +
>  drivers/regulator/max77802.c         | 694 +++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max77802-private.h |   3 -
>  5 files changed, 711 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/regulator/max77802.c
> 
> diff --git a/drivers/mfd/max77802.c b/drivers/mfd/max77802.c
> index 3d477fb..79d36b6 100644
> --- a/drivers/mfd/max77802.c
> +++ b/drivers/mfd/max77802.c
> @@ -228,7 +228,7 @@ static int max77802_i2c_probe(struct i2c_client *i2c,
>  
>  	max77802 = devm_kzalloc(&i2c->dev, sizeof(struct max77802_dev),
>  				GFP_KERNEL);
> -	if (max77802 == NULL)
> +	if (!max77802)
>  		return -ENOMEM;
>  
>  	i2c_set_clientdata(i2c, max77802);
> @@ -315,6 +315,12 @@ static int max77802_suspend(struct device *dev)
>  	if (device_may_wakeup(dev))
>  		enable_irq_wake(max77802->irq);
>  
> +	/*
> +	 * The IRQ must be disabled during suspend since due wakeup
> +	 * ordering issues it may be possible that the I2C controller
> +	 * is still suspended when the interrupt happens so the IRQ
> +	 * handler will fail to read the I2C bus.
> +	 */

Please re-word this, the English is a little off.

>  	disable_irq(max77802->irq);
>  
>  	return 0;

Please separate the MFD changes out.  There is no need for them to be
munged in with regulator changes.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
