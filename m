Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaFBQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:08:36 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:43439 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaFBQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:08:35 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/3] i2c: Make I2C ID tables non-mandatory for DT'ed
 and/or ACPI'ed devices
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wsa@the-dreams.de
Cc: linus.walleij@linaro.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1401716463-23457-4-git-send-email-lee.jones@linaro.org>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
	<1401716463-23457-4-git-send-email-lee.jones@linaro.org>
Date: Mon, 02 Jun 2014 17:08:29 +0100
Message-Id: <20140602160829.F3519C40476@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 14:41:03 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> Currently the I2C framework insists on devices supplying an I2C ID
> table.  Many of the devices which do so unnecessarily adding quite a
> few wasted lines to kernel code.  This patch allows drivers a means
> to 'not' supply the aforementioned table and match on either DT
> and/or ACPI match tables instead.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks reasonable.

g.

> ---
>  drivers/i2c/i2c-core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d0c7180..811b78f 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -271,7 +271,18 @@ static int i2c_device_probe(struct device *dev)
>  		return 0;
>  
>  	driver = to_i2c_driver(dev->driver);
> -	if (!driver->probe || !driver->id_table)
> +	if (!driver->probe)
> +		return -EINVAL;
> +
> +	/*
> +	 * An I2C ID table is not madatory, if and only if, a suitable Device
> +	 * Tree and/or ACPI match table entry is supplied for the probing
> +	 * device.
> +	 *
> +	 * TODO: Provide 'device type' to 'ACPI node' call and match here.
> +	 */
> +	if (!driver->id_table &&
> +	    !of_match_device(dev->driver->of_match_table, dev))
>  		return -ENODEV;
>  
>  	if (!device_can_wakeup(&client->dev))
> -- 
> 1.8.3.2
> 

