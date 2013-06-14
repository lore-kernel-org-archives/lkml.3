Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3FNWLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:11:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37770 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3FNWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:11:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
Date: Sat, 15 Jun 2013 00:21:02 +0200
Message-ID: <8220093.o4hXWiX0st@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371238081-32260-3-git-send-email-jiang.liu@huawei.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <1371238081-32260-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 03:27:59 AM Jiang Liu wrote:
> This is a preparation for next patch to avoid breaking bisecting.
> If next patch is applied without this one, it will cause deadlock
> as below:
> 
> Case 1:
> [   31.015593]  Possible unsafe locking scenario:
> 
> [   31.018350]        CPU0                    CPU1
> [   31.019691]        ----                    ----
> [   31.021002]   lock(&dock_station->hp_lock);
> [   31.022327]                                lock(&slot->crit_sect);
> [   31.023650]                                lock(&dock_station->hp_lock);
> [   31.025010]   lock(&slot->crit_sect);
> [   31.026342]
> 
> Case 2:
>         hotplug_dock_devices()
>                 mutex_lock(&ds->hp_lock)
>                         dd->ops->handler()
>                                 register_hotplug_dock_device()
>                                         mutex_lock(&ds->hp_lock)
> [   34.316570] [ INFO: possible recursive locking detected ]
> [   34.316573] 3.10.0-rc4 #6 Tainted: G         C
> [   34.316575] ---------------------------------------------
> [   34.316577] kworker/0:0/4 is trying to acquire lock:
> [   34.316579]  (&dock_station->hp_lock){+.+.+.}, at:
> [<ffffffff813c766b>] register_hotplug_dock_device+0x6a/0xbf
> [   34.316588]
> but task is already holding lock:
> [   34.316590]  (&dock_station->hp_lock){+.+.+.}, at:
> [<ffffffff813c7270>] hotplug_dock_devices+0x2c/0xda
> [   34.316595]
> other info that might help us debug this:
> [   34.316597]  Possible unsafe locking scenario:
> 
> [   34.316599]        CPU0
> [   34.316601]        ----
> [   34.316602]   lock(&dock_station->hp_lock);
> [   34.316605]   lock(&dock_station->hp_lock);
> [   34.316608]
>  *** DEADLOCK ***
> 
> So fix this deadlock by not taking ds->hp_lock in function
> register_hotplug_dock_device(). This patch also fixes a possible
> race conditions in function dock_event() because previously it
> accesses ds->hotplug_devices list without holding ds->hp_lock.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 3.8+
> ---
>  drivers/acpi/dock.c                | 109 ++++++++++++++++++++++---------------
>  drivers/pci/hotplug/acpiphp_glue.c |  15 +++++
>  include/acpi/acpi_drivers.h        |   2 +
>  3 files changed, 82 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 02b0563..602bce5 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -66,7 +66,7 @@ struct dock_station {
>  	spinlock_t dd_lock;
>  	struct mutex hp_lock;
>  	struct list_head dependent_devices;
> -	struct list_head hotplug_devices;
> +	struct klist hotplug_devices;
>  
>  	struct list_head sibling;
>  	struct platform_device *dock_device;
> @@ -76,12 +76,18 @@ static int dock_station_count;
>  
>  struct dock_dependent_device {
>  	struct list_head list;
> -	struct list_head hotplug_list;
> +	acpi_handle handle;
> +};
> +
> +struct dock_hotplug_info {
> +	struct klist_node node;
>  	acpi_handle handle;
>  	const struct acpi_dock_ops *ops;
>  	void *context;
>  };

Can we please relax a bit and possibly take a step back?

So since your last reply to me wasn't particularly helpful, I went through the
code in dock.c and acpiphp_glue.c and I simply think that the whole
hotplug_list thing is simply redundant.

It looks like instead of using it (or the klist in this patch), we can add a
"hotlpug_device" flag to dock_dependent_device and set that flag instead of
adding dd to hotplug_devices or clear it instead of removing dd from that list.

That would allow us to avoid the deadlock, because we wouldn't need the hp_lock
any more and perhaps we could make the code simpler instead of making it more
complex.

How does that sound?

Rafael


> +#define node_to_info(n)	container_of((n), struct dock_hotplug_info, node)
> +
>  #define DOCK_DOCKING	0x00000001
>  #define DOCK_UNDOCKING  0x00000002
>  #define DOCK_IS_DOCK	0x00000010
> @@ -111,7 +117,6 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
>  
>  	dd->handle = handle;
>  	INIT_LIST_HEAD(&dd->list);
> -	INIT_LIST_HEAD(&dd->hotplug_list);
>  
>  	spin_lock(&ds->dd_lock);
>  	list_add_tail(&dd->list, &ds->dependent_devices);
> @@ -120,36 +125,19 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
>  	return 0;
>  }
>  
> -/**
> - * dock_add_hotplug_device - associate a hotplug handler with the dock station
> - * @ds: The dock station
> - * @dd: The dependent device struct
> - *
> - * Add the dependent device to the dock's hotplug device list
> - */
> -static void
> -dock_add_hotplug_device(struct dock_station *ds,
> -			struct dock_dependent_device *dd)
> +static void hotplug_info_get(struct klist_node *node)
>  {
> -	mutex_lock(&ds->hp_lock);
> -	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
> -	mutex_unlock(&ds->hp_lock);
> +	struct dock_hotplug_info *info = node_to_info(node);
> +
> +	info->ops->get(info->context);
>  }
>  
> -/**
> - * dock_del_hotplug_device - remove a hotplug handler from the dock station
> - * @ds: The dock station
> - * @dd: the dependent device struct
> - *
> - * Delete the dependent device from the dock's hotplug device list
> - */
> -static void
> -dock_del_hotplug_device(struct dock_station *ds,
> -			struct dock_dependent_device *dd)
> +static void hotplug_info_put(struct klist_node *node)
>  {
> -	mutex_lock(&ds->hp_lock);
> -	list_del(&dd->hotplug_list);
> -	mutex_unlock(&ds->hp_lock);
> +	struct dock_hotplug_info *info = node_to_info(node);
> +
> +	info->ops->put(info->context);
> +	kfree(info);
>  }
>  
>  /**
> @@ -354,15 +342,22 @@ static void dock_remove_acpi_device(acpi_handle handle)
>  static void hotplug_dock_devices(struct dock_station *ds, u32 event)
>  {
>  	struct dock_dependent_device *dd;
> +	struct klist_iter iter;
> +	struct klist_node *node;
> +	struct dock_hotplug_info *info;
>  
>  	mutex_lock(&ds->hp_lock);
>  
>  	/*
>  	 * First call driver specific hotplug functions
>  	 */
> -	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
> -		if (dd->ops && dd->ops->handler)
> -			dd->ops->handler(dd->handle, event, dd->context);
> +	klist_iter_init(&ds->hotplug_devices, &iter);
> +	while ((node = klist_next(&iter))) {
> +		info = node_to_info(node);
> +		if (info->ops && info->ops->handler)
> +			info->ops->handler(info->handle, event, info->context);
> +	}
> +	klist_iter_exit(&iter);
>  
>  	/*
>  	 * Now make sure that an acpi_device is created for each
> @@ -384,7 +379,9 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
>  	struct device *dev = &ds->dock_device->dev;
>  	char event_string[13];
>  	char *envp[] = { event_string, NULL };
> -	struct dock_dependent_device *dd;
> +	struct klist_iter iter;
> +	struct klist_node *node;
> +	struct dock_hotplug_info *info;
>  
>  	if (num == UNDOCK_EVENT)
>  		sprintf(event_string, "EVENT=undock");
> @@ -398,9 +395,13 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
>  	if (num == DOCK_EVENT)
>  		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>  
> -	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
> -		if (dd->ops && dd->ops->uevent)
> -			dd->ops->uevent(dd->handle, event, dd->context);
> +	klist_iter_init(&ds->hotplug_devices, &iter);
> +	while ((node = klist_next(&iter))) {
> +		info = node_to_info(node);
> +		if (info->ops && info->ops->handler)
> +			info->ops->handler(info->handle, event, info->context);
> +	}
> +	klist_iter_exit(&iter);
>  
>  	if (num != DOCK_EVENT)
>  		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> @@ -580,12 +581,16 @@ register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops
>  			     void *context)
>  {
>  	struct dock_dependent_device *dd;
> +	struct dock_hotplug_info *info;
>  	struct dock_station *dock_station;
>  	int ret = -EINVAL;
>  
>  	if (!dock_station_count)
>  		return -ENODEV;
>  
> +	if (ops == NULL || ops->get == NULL || ops->put == NULL)
> +		return -EINVAL;
> +
>  	/*
>  	 * make sure this handle is for a device dependent on the dock,
>  	 * this would include the dock station itself
> @@ -598,9 +603,18 @@ register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops
>  		 */
>  		dd = find_dock_dependent_device(dock_station, handle);
>  		if (dd) {
> -			dd->ops = ops;
> -			dd->context = context;
> -			dock_add_hotplug_device(dock_station, dd);
> +			info = kzalloc(sizeof(*info), GFP_KERNEL);
> +			if (!info) {
> +				unregister_hotplug_dock_device(handle);
> +				ret = -ENOMEM;
> +				break;
> +			}
> +
> +			info->ops = ops;
> +			info->context = context;
> +			info->handle = dd->handle;
> +			klist_add_tail(&info->node,
> +				       &dock_station->hotplug_devices);
>  			ret = 0;
>  		}
>  	}
> @@ -615,16 +629,22 @@ EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
>   */
>  void unregister_hotplug_dock_device(acpi_handle handle)
>  {
> -	struct dock_dependent_device *dd;
>  	struct dock_station *dock_station;
> +	struct klist_iter iter;
> +	struct klist_node *node;
> +	struct dock_hotplug_info *info;
>  
>  	if (!dock_station_count)
>  		return;
>  
>  	list_for_each_entry(dock_station, &dock_stations, sibling) {
> -		dd = find_dock_dependent_device(dock_station, handle);
> -		if (dd)
> -			dock_del_hotplug_device(dock_station, dd);
> +		klist_iter_init(&dock_station->hotplug_devices, &iter);
> +		while ((node = klist_next(&iter))) {
> +			info = node_to_info(node);
> +			if (info->handle == handle)
> +				klist_del(&info->node);
> +		}
> +		klist_iter_exit(&iter);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
> @@ -951,7 +971,8 @@ static int __init dock_add(acpi_handle handle)
>  	mutex_init(&dock_station->hp_lock);
>  	spin_lock_init(&dock_station->dd_lock);
>  	INIT_LIST_HEAD(&dock_station->sibling);
> -	INIT_LIST_HEAD(&dock_station->hotplug_devices);
> +	klist_init(&dock_station->hotplug_devices,
> +		   hotplug_info_get, hotplug_info_put);
>  	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  	INIT_LIST_HEAD(&dock_station->dependent_devices);
>  
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 716aa93..5d696f5 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -145,9 +145,24 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
>  	return NOTIFY_OK;
>  }
>  
> +static void acpiphp_dock_get(void *data)
> +{
> +	struct acpiphp_func *func = data;
> +
> +	get_bridge(func->slot->bridge);
> +}
> +
> +static void acpiphp_dock_put(void *data)
> +{
> +	struct acpiphp_func *func = data;
> +
> +	put_bridge(func->slot->bridge);
> +}
>  
>  static const struct acpi_dock_ops acpiphp_dock_ops = {
>  	.handler = handle_hotplug_event_func,
> +	.get = acpiphp_dock_get,
> +	.put = acpiphp_dock_put,
>  };
>  
>  /* Check whether the PCI device is managed by native PCIe hotplug driver */
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index e6168a2..8fcc9ac 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -115,6 +115,8 @@ void pci_acpi_crs_quirks(void);
>  struct acpi_dock_ops {
>  	acpi_notify_handler handler;
>  	acpi_notify_handler uevent;
> +	void (*get)(void *data);
> +	void (*put)(void *data);
>  };
>  
>  #if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
