Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaFTWy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:54:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaFTWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:54:28 -0400
Date: Fri, 20 Jun 2014 15:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Raghavendra Ganiga <ravi23ganiga@gmail.com>, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc: add support of nvram for maxim dallas
 rtc ds1343
Message-Id: <20140620155426.1c4d0a9936859d1b20679bdf@linux-foundation.org>
In-Reply-To: <1400947473-19955-1-git-send-email-ravi23ganiga@gmail.com>
References: <1400947473-19955-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2014 21:34:33 +0530 Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:

> This is a patch to add support of nvram for maxim dallas
> rtc ds1343
> 
> ...
>
> --- a/drivers/rtc/rtc-ds1343.c
> +++ b/drivers/rtc/rtc-ds1343.c
> @@ -4,6 +4,7 @@
>   * Real Time Clock
>   *
>   * Author : Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
> + *	    Ankur Srivastava <sankurece@gmail.com> : DS1343 Nvram Support
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -45,6 +46,9 @@
>  #define DS1343_CONTROL_REG	0x0F
>  #define DS1343_STATUS_REG	0x10
>  #define DS1343_TRICKLE_REG	0x11
> +#define DS1343_NVRAM		0x20
> +
> +#define DS1343_NVRAM_LEN	96
>  
>  /* DS1343 Control Registers bits */
>  #define DS1343_EOSC		0x80
> @@ -149,6 +153,64 @@ static ssize_t ds1343_store_glitchfilter(struct device *dev,
>  static DEVICE_ATTR(glitch_filter, S_IRUGO | S_IWUSR, ds1343_show_glitchfilter,
>  			ds1343_store_glitchfilter);
>  
> +static ssize_t ds1343_nvram_write(struct file *filp, struct kobject *kobj,
> +			struct bin_attribute *attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	int ret;
> +	unsigned char address;
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct ds1343_priv *priv = dev_get_drvdata(dev);
> +
> +	if (unlikely(!count))
> +		return count;
> +
> +	if ((count + off) > DS1343_NVRAM_LEN)

I worry about what happens if (count + off) wraps through zero.

> +		count = DS1343_NVRAM_LEN - off;

We might end up with an enormous value in `count'?

> +	address = DS1343_NVRAM + off;
> +
> +	ret = regmap_bulk_write(priv->map, address, buf, count);
> +	if (ret < 0)
> +		dev_err(&priv->spi->dev, "Error in nvram write %d", ret);
> +
> +	return (ret < 0) ? ret : count;
> +}
> +
> +
> +static ssize_t ds1343_nvram_read(struct file *filp, struct kobject *kobj,
> +				struct bin_attribute *attr,
> +				char *buf, loff_t off, size_t count)
> +{
> +	int ret;
> +	unsigned char address;
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct ds1343_priv *priv = dev_get_drvdata(dev);
> +
> +	if (unlikely(!count))
> +		return count;
> +
> +	if ((count + off) > DS1343_NVRAM_LEN)
> +		count = DS1343_NVRAM_LEN - off;

Here too.

> +	address = DS1343_NVRAM + off;
> +
> +	ret = regmap_bulk_read(priv->map, address, buf, count);
> +	if (ret < 0)
> +		dev_err(&priv->spi->dev, "Error in nvram read %d\n", ret);
> +
> +	return (ret < 0) ? ret : count;
> +}
> +
> +

