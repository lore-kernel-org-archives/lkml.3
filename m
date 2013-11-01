Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3KAWwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:52:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53891 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753859Ab3KAWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:52:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] power: Add legacy pm ops usage warning
Date: Sat, 02 Nov 2013 00:04:50 +0100
Message-ID: <7710681.pPuGuuagq2@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383318424-4072-1-git-send-email-shuah.kh@samsung.com>
References: <1383318424-4072-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 01, 2013 09:07:04 AM Shuah Khan wrote:
> Add legacy pm_ops usage checks to device_pm_add() when a device gets added
> to PM core's list of active devices. If legacy pm_ops usage is found at its
> class, bus, driver level, print warning message to indicate the driver code
> needs updating to use dev pm ops interfaces. This will help serve as a way
> to track drivers that still use legacy pm ops and fix them.

I think it would be much better to do these checks during bus type, class or
driver registration, because if you register a bus type with legacy PM, for
example, the check in device_pm_add() will trigger for all devices with that
bus type.

Thanks!

> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/power/main.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 9f098a8..4dc26dc 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -112,6 +112,23 @@ void device_pm_unlock(void)
>  }
>  
>  /**
> + * check for lgeacy pm_ops usage and warn
> + */
> +static void device_legacy_pm_ops_check(struct device *dev)
> +{
> +	char *info = "Please update driver to use dev pm_ops";
> +
> +	if (dev->class && (dev->class->suspend || dev->class->resume))
> +		dev_warn(dev, "Driver uses legacy class pm ops - %s\n", info);
> +
> +	if (dev->bus && (dev->bus->suspend || dev->bus->resume))
> +		dev_warn(dev, "Driver uses legacy bus pm ops - %s\n", info);
> +
> +	if (dev->driver && (dev->driver->suspend || dev->driver->resume))
> +		dev_warn(dev, "Driver uses legacy pm ops - %s\n", info);
> +}
> +
> +/**
>   * device_pm_add - Add a device to the PM core's list of active devices.
>   * @dev: Device to add to the list.
>   */
> @@ -123,6 +140,7 @@ void device_pm_add(struct device *dev)
>  	if (dev->parent && dev->parent->power.is_prepared)
>  		dev_warn(dev, "parent %s should not be sleeping\n",
>  			dev_name(dev->parent));
> +	device_legacy_pm_ops_check(dev);
>  	list_add_tail(&dev->power.entry, &dpm_list);
>  	mutex_unlock(&dpm_list_mtx);
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
