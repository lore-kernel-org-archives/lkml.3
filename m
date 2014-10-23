Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaJWPWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:22:47 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40630 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaJWPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:22:44 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 23 Oct 2014 17:19:40 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v8 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20141023151940.GA21210@localhost>
References: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
 <1413384491-23703-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413384491-23703-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:48:09PM +0300, Octavian Purdila wrote:

> +static int dln2_i2c_xfer(struct i2c_adapter *adapter,
> +			 struct i2c_msg *msgs, int num)
> +{
> +	struct dln2_i2c *dln2 = i2c_get_adapdata(adapter);
> +	struct i2c_msg *pmsg;
> +	struct device *dev = &dln2->pdev->dev;

You want to use the i2c-adapter device here (not the platform device).

> +	int i;
> +
> +	for (i = 0; i < num; i++) {
> +		int ret;
> +
> +		pmsg = &msgs[i];
> +
> +		if (pmsg->len > DLN2_I2C_MAX_XFER_SIZE) {
> +			dev_warn(dev, "maximum transfer size exceeded\n");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (pmsg->flags & I2C_M_RD) {
> +			ret = dln2_i2c_read(dln2, pmsg->addr, pmsg->buf,
> +					    pmsg->len);
> +			if (ret < 0)
> +				return ret;
> +
> +			pmsg->len = ret;
> +		} else {
> +			ret = dln2_i2c_write(dln2, pmsg->addr, pmsg->buf,
> +					     pmsg->len);
> +			if (ret != pmsg->len)
> +				return -EPROTO;
> +		}
> +	}
> +
> +	return num;
> +}

[...]

> +static int dln2_i2c_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct dln2_i2c *dln2;
> +	struct device *dev = &pdev->dev;
> +	struct dln2_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +
> +	dln2 = devm_kzalloc(dev, sizeof(*dln2), GFP_KERNEL);
> +	if (!dln2)
> +		return -ENOMEM;
> +
> +	dln2->buf = devm_kmalloc(dev, DLN2_I2C_BUF_SIZE, GFP_KERNEL);
> +	if (!dln2->buf)
> +		return -ENOMEM;
> +
> +	dln2->pdev = pdev;
> +	dln2->port = pdata->port;
> +
> +	/* setup i2c adapter description */
> +	dln2->adapter.owner = THIS_MODULE;
> +	dln2->adapter.class = I2C_CLASS_HWMON;
> +	dln2->adapter.algo = &dln2_i2c_usb_algorithm;
> +	dln2->adapter.dev.parent = dev;
> +	i2c_set_adapdata(&dln2->adapter, dln2);
> +	snprintf(dln2->adapter.name, sizeof(dln2->adapter.name), "%s-%s-%d",
> +		 "dln2-i2c", dev_name(pdev->dev.parent), dln2->port);
> +
> +	platform_set_drvdata(pdev, dln2);
> +
> +	/* initialize the i2c interface */

No longer "initialisation" since you dropped the frequency setup?

> +	ret = dln2_i2c_enable(dln2, true);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to initialize adapter: %d\n", ret);

Same here.

> +		return ret;
> +	}
> +
> +	/* and finally attach to i2c layer */
> +	ret = i2c_add_adapter(&dln2->adapter);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to add I2C adapter: %d\n", ret);
> +		goto out_disable;
> +	}
> +
> +	return 0;
> +
> +out_disable:
> +	dln2_i2c_enable(dln2, false);
> +
> +	return ret;
> +}

Looks good otherwise.

Johan
