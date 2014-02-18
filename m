Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaBRAvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:51:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65517 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754141AbaBRAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:51:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch v1 1/6] acpi_pad: simplify notify handler by using acpi_drv_ops->notify
Date: Tue, 18 Feb 2014 02:06:03 +0100
Message-ID: <8893595.ITmXn6Kgg5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com> <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 01:02:48 PM Jiang Liu wrote:
> Use callback acpi_drv_ops->notify to simplify acpi_pad driver's
> notification handling code.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

There is a plan to move away from using struct acpi_driver objects and
this change will need to be reverted then.  I'm not sure if that's really
useful?

> ---
>  drivers/acpi/acpi_pad.c |   25 +++++--------------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index df96a0f..1e3ce76 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -443,14 +443,11 @@ static void acpi_pad_handle_notify(acpi_handle handle)
>  	mutex_unlock(&isolated_cpus_lock);
>  }
>  
> -static void acpi_pad_notify(acpi_handle handle, u32 event,
> -	void *data)
> +static void acpi_pad_notify(struct acpi_device *device, u32 event)
>  {
> -	struct acpi_device *device = data;
> -
>  	switch (event) {
>  	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
> -		acpi_pad_handle_notify(handle);
> +		acpi_pad_handle_notify(device->handle);
>  		acpi_bus_generate_netlink_event(device->pnp.device_class,
>  			dev_name(&device->dev), event, 0);
>  		break;
> @@ -462,22 +459,10 @@ static void acpi_pad_notify(acpi_handle handle, u32 event,
>  
>  static int acpi_pad_add(struct acpi_device *device)
>  {
> -	acpi_status status;
> -
>  	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
>  	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
>  
> -	if (acpi_pad_add_sysfs(device))
> -		return -ENODEV;
> -
> -	status = acpi_install_notify_handler(device->handle,
> -		ACPI_DEVICE_NOTIFY, acpi_pad_notify, device);
> -	if (ACPI_FAILURE(status)) {
> -		acpi_pad_remove_sysfs(device);
> -		return -ENODEV;
> -	}
> -
> -	return 0;
> +	return acpi_pad_add_sysfs(device);
>  }
>  
>  static int acpi_pad_remove(struct acpi_device *device)
> @@ -486,9 +471,8 @@ static int acpi_pad_remove(struct acpi_device *device)
>  	acpi_pad_idle_cpus(0);
>  	mutex_unlock(&isolated_cpus_lock);
>  
> -	acpi_remove_notify_handler(device->handle,
> -		ACPI_DEVICE_NOTIFY, acpi_pad_notify);
>  	acpi_pad_remove_sysfs(device);
> +
>  	return 0;
>  }
>  
> @@ -505,6 +489,7 @@ static struct acpi_driver acpi_pad_driver = {
>  	.ops = {
>  		.add = acpi_pad_add,
>  		.remove = acpi_pad_remove,
> +		.notify = acpi_pad_notify,
>  	},
>  };
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
