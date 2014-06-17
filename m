Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaFQLR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:17:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59264 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752082AbaFQLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:17:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, naszar@ya.ru, rientjes@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ACPI/Battery: Retry to get Battery information if failed during probing
Date: Tue, 17 Jun 2014 13:35:27 +0200
Message-ID: <1474004.fDjayHqHT9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402988994-27067-1-git-send-email-tianyu.lan@intel.com>
References: <1402988994-27067-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 17, 2014 03:09:54 PM Lan Tianyu wrote:
> Some machines'(E,G Lenovo Z480) ECs are not stable during boot up
> and causes battery driver fails to be loaded due to failure of getting
> battery information from EC sometimes. After several retries, the
> operation will work. This patch is to retry to get battery information 5
> times if the first try fails.
> 
> Reported-and-tested-by: naszar <naszar@ya.ru>
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75581
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
> Change since V2:
> 	Change code style and add comment.
> 
>  drivers/acpi/battery.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index e48fc98..8ed93a3 100644
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
> @@ -1119,7 +1120,7 @@ static struct dmi_system_id bat_dmi_table[] = {
>  
>  static int acpi_battery_add(struct acpi_device *device)
>  {
> -	int result = 0;
> +	int result = 0, retry = 5;
>  	struct acpi_battery *battery = NULL;
>  
>  	if (!device)
> @@ -1135,9 +1136,20 @@ static int acpi_battery_add(struct acpi_device *device)
>  	mutex_init(&battery->sysfs_lock);
>  	if (acpi_has_method(battery->device->handle, "_BIX"))
>  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
> -	result = acpi_battery_update(battery, false);
> +
> +	/*
> +	 * Some machines'(E,G Lenovo Z480) ECs are not stable
> +	 * during boot up and this causes battery driver fails to be
> +	 * probed due to failure of getting battery information
> +	 * from EC sometimes. After several retries, the operation
> +	 * may work. So add retry code here and 20ms sleep between
> +	 * every retries.
> +	 */
> +	while ((result = acpi_battery_update(battery, false)) && retry--)
> +		msleep(20);
>  	if (result)
>  		goto fail;

Why not to write this as

	for (;;) {
		result = acpi_battery_update(battery, false);
		if (!result)
			break;
		else if (!--retry)
			goto fail;

		msleep(20);
	}

> +
>  #ifdef CONFIG_ACPI_PROCFS_POWER
>  	result = acpi_battery_add_fs(device);
>  #endif
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
