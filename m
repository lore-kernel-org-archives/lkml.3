Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaIEPkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:40:01 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:49454 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaIEPj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:39:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 5 Sep 2014 17:38:35 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 3/3] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20140905153835.GC13242@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 06:17:59PM +0300, Octavian Purdila wrote:

> +static int dln2_do_remove(struct dln2_gpio *dln2)
> +{
> +	/* When removing the DLN2 USB device, gpiochip_remove may fail
> +	 * due to i2c drivers holding a GPIO pin. However, the i2c bus
> +	 * will eventually be removed triggering an i2c driver remove
> +	 * which will release the GPIO pin. So retrying the operation
> +	 * later should succeed. */
> +	int ret = gpiochip_remove(&dln2->gpio);
> +	struct device *dev = dln2->gpio.dev;
> +
> +	if (ret < 0) {
> +		if (ret == -EBUSY)
> +			schedule_delayed_work(&dln2->remove_work.work, HZ/10);
> +		else
> +			dev_warn(dev, "error removing gpio chip: %d\n", ret);
> +	} else {
> +		kfree(dln2);
> +	}
> +
> +	return ret;
> +}

Apparently, the return value from gpiochip_remove is going away:

	"Start to kill off the return value from gpiochip_remove() by
	removing the __must_check attribute and removing all checks
	inside the drivers/gpio directory. The rationale is: well what
	were we supposed to do if there is an error code? Not much:
	print an error message. And gpiolib already does that. So make
	this function return void eventually."

	https://www.mail-archive.com/linux-gpio@vger.kernel.org/msg03468.html

Also, have you considered what happens if there are gpios exported
through sysfs? These may never be released.

In general, how well have these patches been tested with disconnect
events? At least gpiolib is known to blow up (sooner or later) when a
gpiochip is removed when having requested gpios.

Johan
