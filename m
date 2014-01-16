Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaAPIEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:04:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:20278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaAPIEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:04:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459697655"
Message-ID: <1389859475.3010.5.camel@rzhang1-mobl4>
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
From: Zhang Rui <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com
Date: Thu, 16 Jan 2014 16:04:35 +0800
In-Reply-To: <20140115150834.GX2494@intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
	 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
	 <20140115150834.GX2494@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 17:08 +0200, Mika Westerberg wrote:
> On Tue, Jan 14, 2014 at 04:46:37PM +0800, Zhang Rui wrote:
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b79..2f4aea2 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -677,7 +677,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
> >  			     char *buf)
> >  {
> >  	struct platform_device	*pdev = to_platform_device(dev);
> > -	int len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
> > +	int len;
> > +
> > +	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
> 
> Here you have PAGE_SIZE -1...
> 
> > +	if (len != -ENODEV)
> > +		return len;
> > +
> > +	len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
> >  
> >  	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
> >  }
> > @@ -699,6 +705,10 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  	if (rc != -ENODEV)
> >  		return rc;
> >  
> > +	rc = acpi_device_uevent_modalias(dev, env);
> > +	if (rc != -ENODEV)
> > +		return rc;
> > +
> >  	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> >  			pdev->name);
> >  	return 0;
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index d74c0b3..c4c5588 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -104,6 +104,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
> >  static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  {
> >  	struct i2c_client	*client = to_i2c_client(dev);
> > +	int rc;
> > +
> > +	rc = acpi_device_uevent_modalias(dev, env);
> > +	if (rc != -ENODEV)
> > +		return rc;
> >  
> >  	if (add_uevent_var(env, "MODALIAS=%s%s",
> >  			   I2C_MODULE_PREFIX, client->name))
> > @@ -409,6 +414,12 @@ static ssize_t
> >  show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
> >  {
> >  	struct i2c_client *client = to_i2c_client(dev);
> > +	int len;
> > +
> > +	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
> 
> and here
> 
> > +	if (len != -ENODEV)
> > +		return len;
> > +
> >  	return sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
> >  }
> >  
> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> > index 349ebba..ab70eda 100644
> > --- a/drivers/spi/spi.c
> > +++ b/drivers/spi/spi.c
> > @@ -58,6 +58,11 @@ static ssize_t
> >  modalias_show(struct device *dev, struct device_attribute *a, char *buf)
> >  {
> >  	const struct spi_device	*spi = to_spi_device(dev);
> > +	int len;
> > +
> > +	len = acpi_device_modalias(dev, buf, PAGE_SIZE);
> 
> but here it is PAGE_SIZE.
> 
good catch.

> Perhaps it should be PAGE_SIZE in all sites?

dev_attr_show() will give a warning message if modalias_show() returns
PAGE_SIZE, thus I'd prefer to use PAGE_SIZE - 1 for all sites.

thanks,
rui


