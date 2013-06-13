Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3FMS1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:27:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36365 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3FMS1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:27:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX 8/9] ACPI: introduce several helper functions
Date: Thu, 13 Jun 2013 20:36:33 +0200
Message-ID: <2169298.y9CSVzb8SU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371141152-9468-9-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1371141152-9468-9-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 12:32:31 AM Jiang Liu wrote:
> Introduce several helper functions, which will be used to simplify code.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Again, this is not 3.10 material.

And you could easily say "three" instead of "several" in the changelog. :-)

Thanks,
Rafael


> ---
>  drivers/acpi/utils.c    | 74 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |  5 ++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 74437130..cb66fce 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -495,3 +495,77 @@ acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
>  	kfree(buffer.pointer);
>  }
>  EXPORT_SYMBOL(acpi_handle_printk);
> +
> +/**
> + * acpi_evaluate_ej0: Evaluate _EJ0 method for hotplug operations
> + * @handle: ACPI device handle
> + *
> + * Evaluate device's _EJ0 method for hotplug operations.
> + */
> +acpi_status acpi_evaluate_ej0(acpi_handle handle)
> +{
> +	acpi_status status;
> +	union acpi_object arg;
> +	struct acpi_object_list arg_list;
> +
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = 1;
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
> +	if (status == AE_NOT_FOUND) {
> +		acpi_handle_warn(handle, "No _EJ0 support for device\n");
> +	} else if (ACPI_FAILURE(status)) {
> +		acpi_handle_warn(handle, "Eject failed (0x%x)\n", status);
> +	}
> +
> +	return status;
> +}
> +
> +/**
> + * acpi_evaluate_lck: Evaluate _LCK method to lock/unlock device
> + * @handle: ACPI device handle
> + * @lock: lock device if non-zero, otherwise unlock device
> + *
> + * Evaluate device's _LCK method if present to lock/unlock device
> + */
> +acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
> +{
> +	acpi_status status;
> +	union acpi_object arg;
> +	struct acpi_object_list arg_list;
> +
> +	arg_list.count = 1;
> +	arg_list.pointer = &arg;
> +	arg.type = ACPI_TYPE_INTEGER;
> +	arg.integer.value = !!lock;
> +	status = acpi_evaluate_object(handle, "_LCK", &arg_list, NULL);
> +	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> +		if (lock)
> +			acpi_handle_warn(handle,
> +				"Locking device failed (0x%x)\n", status);
> +		else
> +			acpi_handle_warn(handle,
> +				"Unlocking device failed (0x%x)\n", status);
> +	}
> +
> +	return status;
> +}
> +
> +/**
> + * acpi_has_method: Check whether @handle has a method named @name
> + * @handle: ACPI device handle
> + * @name: name of object or method
> + *
> + * Check whether @handle has a method named @name.
> + */
> +int acpi_has_method(acpi_handle handle, char *name)
> +{
> +	acpi_status status;
> +	acpi_handle tmp;
> +
> +	status = acpi_get_handle(handle, name, &tmp);
> +
> +	return ACPI_FAILURE(status) ? 0 : 1;
> +}
> +EXPORT_SYMBOL(acpi_has_method);
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 636c59f..5df5f89 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -56,6 +56,11 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
>  
>  acpi_status
>  acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
> +
> +acpi_status acpi_evaluate_ej0(acpi_handle handle);
> +acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
> +int acpi_has_method(acpi_handle handle, char *name);
> +
>  #ifdef CONFIG_ACPI
>  
>  #include <linux/proc_fs.h>
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
