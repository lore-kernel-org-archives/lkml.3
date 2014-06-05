Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaFEK1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:27:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33604 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaFEK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:27:40 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 5/7] i2c: Make I2C ID tables non-mandatory for DT'ed
 and/or ACPI'ed devices
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1401883796-17841-6-git-send-email-lee.jones@linaro.org>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
	<1401883796-17841-6-git-send-email-lee.jones@linaro.org>
Date: Thu, 05 Jun 2014 11:27:37 +0100
Message-Id: <20140605102737.4ED08C40A4D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jun 2014 13:09:54 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> Currently the I2C framework insists on devices supplying an I2C ID
> table.  Many of the devices which do so unnecessarily adding quite a
> few wasted lines to kernel code.  This patch allows drivers a means
> to 'not' supply the aforementioned table and match on either DT
> and/or ACPI match tables instead.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks okay to me. I've not applied or tested in any way though.

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/i2c/i2c-core.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index e8c2cba..71970da 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -100,7 +100,7 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  
>  
>  	/* Attempt an OF style match */
> -	if (of_driver_match_device(dev, drv))
> +	if (i2c_of_match_device(drv->of_match_table, dev))
>  		return 1;
>  
>  	/* Then ACPI style match */
> @@ -268,7 +268,18 @@ static int i2c_device_probe(struct device *dev)
>  		return 0;
>  
>  	driver = to_i2c_driver(dev->driver);
> -	if (!driver->probe || !driver->id_table)
> +	if (!driver->probe)
> +		return -EINVAL;
> +
> +	/*
> +	 * An I2C ID table is not mandatory, if and only if, a suitable Device
> +	 * Tree and/or ACPI match table entry is supplied for the probing
> +	 * device.
> +	 *
> +	 * TODO: Provide 'device type' to 'ACPI node' call and match here.
> +	 */
> +	if (!driver->id_table &&
> +	    !i2c_of_match_device(dev->driver->of_match_table, dev))
>  		return -ENODEV;
>  
>  	if (!device_can_wakeup(&client->dev))
> -- 
> 1.8.3.2
> 

