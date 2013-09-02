Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3IBTZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:25:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57467 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab3IBTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:25:40 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 02 Sep 2013 14:25:37 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5224E62F.1050400@roeck-us.net>
Date: Mon, 02 Sep 2013 12:25:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Introduce hwmon_device_register_with_groups and
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 07:48 PM, Guenter Roeck wrote:
> This patch series introduces new hwmon API functions
> hwmon_device_register_with_groups() and devm_hwmon_device_register_with_groups().
>
> hwmon_device_register_with_groups() lets callers register hwmon devices
> as well as associated sysfs attributes with a single call. This simplifies
> hwmon device registration and avoids potential race conditions seen
> if sysfs attributes are created after the initial hwmon device was
> registered.
>
> devm_hwmon_device_register_with_groups() is the managed version of the same
> function.
>
Jean, any comments on this patch series ?

If you are ok with it, I would like to push the new API (patches 1 and 7 of the series)
into 3.12, and keep the rest for 3.13.

Thanks,
Guenter

> The rationale for the new API is that sysfs attributes should be created
> synchronously with device creation to avoid race conditions, as outlined in
> http://www.linuxfoundation.org/news-media/blogs/browse/2013/06/how-create-sysfs-file-correctly.
>
> The first patch of the series introduces hwmon_device_register_with_groups().
>
> Patches 2 to 6 convert some hwmon drivers to use the new API to show and
> test its use. Only the ds1621 and nct6775 patches have been tested at this time;
> the others are informational to show the potential of the new functions.
>
> Patch 7 introduces devm_hwmon_device_register_with_groups() and
> the matching function devm_hwmon_device_unregister(). Patch 8 and 9
> convert the nct6775 and ds1621 drivers drivers to use this function.
>
> hwmon attributes
>
> The old hwmon API attaches hwmon attributes to the parent device, not to the
> hwmon device itself. With the new API, hwmon attributes are attached to the
> hwmon device itself.
>
> Handling the 'name' attribute for hwmon drivers
>
> Since sysfs attributes are no longer attached to the parent device, the
> mandatory 'name' attribute has to be created explicitly. For some drivers,
> this was already the case. I2c drivers, however, create the 'name' attribute
> in the i2c core, and it was used by the hwmon driver.
>
> To simplify name attribute handling, the value of the 'name' attribute is
> passed as parameter to hwmon_device_register_with_groups(). The hwmon core
> creates and manages the attribute. If a NULL pointer is passed instead of
> a name, the attribute is not created.
>
> Unfortunately, since we need a variable to store the pointer to 'name',
> it was necessary to create an internal 'struct hwmon_device'. For this
> reason, device_create(), or rather device_create_with_groups() can no
> longer be used to create the actual device. device_register() is used
> instead, and the device data structures are managed locally.
> [ If there is a better solution for this problem, I am listening. ]
>
> The series is based on my hwmon-next branch and should apply to the top of
> linux-next.
>
> ---------
>
> v2: Rename API functions
> 	device_create_groups -> device_create_with_groups
>      	hwmon_device_register_groups -> hwmon_device_register_with_groups
>      Additional parameter 'void *drvdata' for hwmon_device_register_groups.
>      Additional parameter 'name' for hwmon_device_register_groups.
>      Introduce devm_hwmon_device_register_with_groups().
>      Various fixes in hwmon driver conversions.
>
>

