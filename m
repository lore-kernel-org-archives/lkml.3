Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaAOPC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:02:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:27208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaAOPCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="467093172"
Date: Wed, 15 Jan 2014 17:08:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
Message-ID: <20140115150834.GX2494@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:46:37PM +0800, Zhang Rui wrote:
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3a94b79..2f4aea2 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -677,7 +677,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
>  			     char *buf)
>  {
>  	struct platform_device	*pdev = to_platform_device(dev);
> -	int len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
> +	int len;
> +
> +	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);

Here you have PAGE_SIZE -1...

> +	if (len != -ENODEV)
> +		return len;
> +
> +	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
>  
>  	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
>  }
> @@ -699,6 +705,10 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>  	if (rc != -ENODEV)
>  		return rc;
>  
> +	rc = acpi_device_uevent_modalias(dev, env);
> +	if (rc != -ENODEV)
> +		return rc;
> +
>  	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
>  			pdev->name);
>  	return 0;
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d74c0b3..c4c5588 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -104,6 +104,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct i2c_client	*client = to_i2c_client(dev);
> +	int rc;
> +
> +	rc = acpi_device_uevent_modalias(dev, env);
> +	if (rc != -ENODEV)
> +		return rc;
>  
>  	if (add_uevent_var(env, "MODALIAS=%s%s",
>  			   I2C_MODULE_PREFIX, client->name))
> @@ -409,6 +414,12 @@ static ssize_t
>  show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> +	int len;
> +
> +	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);

and here

> +	if (len != -ENODEV)
> +		return len;
> +
>  	return sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
>  }
>  
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 349ebba..ab70eda 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -58,6 +58,11 @@ static ssize_t
>  modalias_show(struct device *dev, struct device_attribute *a, char *buf)
>  {
>  	const struct spi_device	*spi = to_spi_device(dev);
> +	int len;
> +
> +	len = acpi_device_modalias(dev, buf, PAGE_SIZE);

but here it is PAGE_SIZE.

Perhaps it should be PAGE_SIZE in all sites?
