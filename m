Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3CZNI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:08:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42955 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab3CZNIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:08:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH] ACPI: Update _OST handling for notify
Date: Tue, 26 Mar 2013 14:16:20 +0100
Message-ID: <2434755.bmXlRn8ZR6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362522811-29063-1-git-send-email-toshi.kani@hp.com>
References: <1362522811-29063-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 05, 2013 03:33:31 PM Toshi Kani wrote:
> When the kernel calls _OSC with OSC_SB_HOTPLUG_OST_SUPPORT bit
> set at boot-time, the OS is responsible for calling _OST for
> ACPI hotplug events.  However, when hotplug.enabled attribute
> is unset for ACPI scan drivers, their notify handlers are removed
> and _OST is not called for ACPI hotplug events as a result.
> 
> This patch keeps the notify handler of ACPI scan drivers,
> acpi_hotplug_notify_cb(), installed regardless of the state of
> hotplug.enabled.  The notify handler then checks if hotplug.enabled
> is set for the associated scan handler.  If unset, the notify
> handler calls _OST with a proper error code.  The patch also
> eliminates ACPI namespace walk when hotplug.enabled is changed
> via sysfs.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
> 
> This patch applies on top of the following patchset.
> https://lkml.org/lkml/2013/3/4/455
> 
> ---
>  drivers/acpi/scan.c |   87 +++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 3f6ec0d..dfdbcfd 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -259,11 +259,43 @@ static void acpi_scan_device_check(void *context)
>  				   ACPI_NOTIFY_DEVICE_CHECK);
>  }
>  
> -static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *not_used)
> +static void acpi_hotplug_unsupported(acpi_handle handle, u32 type)
> +{
> +	u32 ost_status;
> +
> +	switch (type) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +		acpi_handle_debug(handle,
> +			"ACPI_NOTIFY_BUS_CHECK event: unsupported\n");
> +		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
> +		break;
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		acpi_handle_debug(handle,
> +			"ACPI_NOTIFY_DEVICE_CHECK event: unsupported\n");
> +		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
> +		break;
> +	case ACPI_NOTIFY_EJECT_REQUEST:
> +		acpi_handle_debug(handle,
> +			"ACPI_NOTIFY_EJECT_REQUEST event: unsupported\n");
> +		ost_status = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> +		break;
> +	default:
> +		/* non-hotplug event; possibly handled by other handler */
> +		return;
> +	}
> +
> +	acpi_evaluate_hotplug_ost(handle, type, ost_status, NULL);
> +}
> +
> +static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
>  {
>  	acpi_osd_exec_callback callback;
> +	struct acpi_scan_handler *handler = data;
>  	acpi_status status;
>  
> +	if (!handler->hotplug.enabled)
> +		return acpi_hotplug_unsupported(handle, type);
> +
>  	switch (type) {
>  	case ACPI_NOTIFY_BUS_CHECK:
>  		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
> @@ -1715,61 +1747,14 @@ static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
>  	return NULL;
>  }
>  
> -static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
> -					    u32 lvl_not_used, void *data,
> -					    void **ret_not_used)
> -{
> -	struct acpi_device_pnp pnp = {};
> -	struct acpi_scan_handler *tgt_handler = data, *handler;
> -	struct acpi_hardware_id *hwid;
> -	unsigned long long sta_not_used;
> -	int type;
> -	bool match = false;
> -
> -	if (acpi_bus_type_and_status(handle, &type, &sta_not_used))
> -		return AE_OK;
> -
> -	INIT_LIST_HEAD(&pnp.ids);
> -	acpi_set_pnp_ids(handle, &pnp, type);
> -
> -	if (!pnp.type.hardware_id)
> -		return AE_OK;
> -
> -	list_for_each_entry(hwid, &pnp.ids, list) {
> -		handler = acpi_scan_match_handler(hwid->id, NULL);
> -		if (handler && handler == tgt_handler) {
> -			match = true;
> -			break;
> -		}
> -	}
> -	if (!match)
> -		goto out;
> -
> -	if (handler->hotplug.enabled)
> -		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -					    acpi_hotplug_notify_cb, NULL);
> -	else
> -		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -					   acpi_hotplug_notify_cb);
> -
> -out:
> -	acpi_free_pnp_ids(&pnp);
> -	return AE_OK;
> -}
> -
>  void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val)
>  {
> -	struct acpi_scan_handler *handler;
> -
>  	if (!!hotplug->enabled == !!val)
>  		return;
>  
>  	mutex_lock(&acpi_scan_lock);
>  
>  	hotplug->enabled = val;
> -	handler = container_of(hotplug, struct acpi_scan_handler, hotplug);
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
> -			    acpi_scan_hotplug_modify, NULL, handler, NULL);
>  
>  	mutex_unlock(&acpi_scan_lock);
>  }
> @@ -1793,10 +1778,8 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
>  	list_for_each_entry(hwid, &pnp.ids, list) {
>  		handler = acpi_scan_match_handler(hwid->id, NULL);
>  		if (handler) {
> -			if (handler->hotplug.enabled)
> -				acpi_install_notify_handler(handle,
> -					ACPI_SYSTEM_NOTIFY,
> -					acpi_hotplug_notify_cb, NULL);
> +			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					acpi_hotplug_notify_cb, handler);
>  			break;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
