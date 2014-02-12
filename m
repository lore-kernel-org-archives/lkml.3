Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaBLCtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:49:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34313 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBLCtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:49:07 -0500
Date: Tue, 11 Feb 2014 18:49:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 09/12] hwmon: vexpress: Use devm helper for hwmon device
 registration
Message-ID: <20140212024904.GA19352@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:10:33PM +0000, Pawel Moll wrote:
> Use devm_hwmon_device_register_with_groups instead of
> the old-style manual attributes and hwmon device registration.
> 

[ ... ]

>  static int vexpress_hwmon_probe(struct platform_device *pdev)
>  {
> -	int err;
>  	const struct of_device_id *match;
>  	struct vexpress_hwmon_data *data;
> +	const char *name;
> +	const struct attribute_group **groups;
>  
>  	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>  	if (!data)
> @@ -176,42 +151,19 @@ static int vexpress_hwmon_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  

There is a leftover platform_set_drvdata() above which you can remove;
attributes are now attached to the hwmon device and no longer
to the platform device.

>  
> -	match = of_match_device(vexpress_hwmon_of_match, &pdev->dev);
> -	sysfs_remove_group(&pdev->dev.kobj, match->data);
> +	name = of_get_property(pdev->dev.of_node, "compatible", NULL);

Couple of problems, two of which escaped me earlier.

First, can of_get_property ever return NULL ? I think not, just wondering.

Second is a real problem. You have a '-' in the compatible property which is
illegal for the 'name' attribute in hwmon devices. It messes up libsensors
and thus every application using it. Not sure what a good fix (or name)
would be; simplest might be to copy the name string and replace it with '_'.
Sorry for not noticing this earlier; it might actually make sense to submit
a separate patch to address this so we can apply it to the current kernel
and if necessary patch it into earlier kernels.

Third, I noticed that the 'label' attribute is always created but returns  
-ENOENT if there is no label. A much better implementation would be to use
.is_visible and not create the label attribute if its devicetree entry
does not exist. I don't know how libsensors reacts to -ENOENT on a read,
but no matter how it does react, it is pretty much undefined.
Again, that should be handled in a separate patch.

I agree with Arnd that it would be nice to get rid of the local macro,
but I won't mandate that.

Thanks,
Guenter
