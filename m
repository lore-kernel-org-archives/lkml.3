Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaGHU1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:27:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59483 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753652AbaGHU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:27:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, rientjes@google.com, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3] ACPI/Battery: Retry to get Battery information if failed during probing
Date: Tue, 08 Jul 2014 22:45:52 +0200
Message-ID: <6200181.uMLNz9GBpL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404719232-17911-1-git-send-email-tianyu.lan@intel.com>
References: <1404719232-17911-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2014 03:47:12 PM Lan Tianyu wrote:
> Some machines'(E,G Lenovo Z480) ECs are not stable during boot up
> and causes battery driver fails to be loaded due to failure of getting
> battery information from EC sometimes. After several retries, the
> operation will work. This patch is to retry to get battery information 5
> times if the first try fails.
> 
> Reported-and-tested-by: naszar <naszar@ya.ru>
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75581
> Cc: stable@vger.kernel.org
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Queued up as a fix for 3.16, thanks!

> ---
> Change since V1:
> 	Change code style and add a comment.
> 
> Change since V2:
> 	Change code style.
> 
>  drivers/acpi/battery.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index e48fc98..cee5ee8 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -34,6 +34,7 @@
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
>  #include <linux/suspend.h>
> +#include <linux/delay.h>
>  #include <asm/unaligned.h>
>  
>  #ifdef CONFIG_ACPI_PROCFS_POWER
> @@ -1117,6 +1118,28 @@ static struct dmi_system_id bat_dmi_table[] = {
>  	{},
>  };
>  
> +/*
> + * Some machines'(E,G Lenovo Z480) ECs are not stable
> + * during boot up and this causes battery driver fails to be
> + * probed due to failure of getting battery information
> + * from EC sometimes. After several retries, the operation
> + * may work. So add retry code here and 20ms sleep between
> + * every retries.
> + */
> +static int acpi_battery_update_retry(struct acpi_battery *battery)
> +{
> +	int retry, ret;
> +
> +	for (retry = 5; retry; retry--) {
> +		ret = acpi_battery_update(battery, false);
> +		if (!ret)
> +			break;
> +
> +		msleep(20);
> +	}
> +	return ret;
> +}
> +
>  static int acpi_battery_add(struct acpi_device *device)
>  {
>  	int result = 0;
> @@ -1135,9 +1158,11 @@ static int acpi_battery_add(struct acpi_device *device)
>  	mutex_init(&battery->sysfs_lock);
>  	if (acpi_has_method(battery->device->handle, "_BIX"))
>  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
> -	result = acpi_battery_update(battery, false);
> +
> +	result = acpi_battery_update_retry(battery);
>  	if (result)
>  		goto fail;
> +
>  #ifdef CONFIG_ACPI_PROCFS_POWER
>  	result = acpi_battery_add_fs(device);
>  #endif
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
