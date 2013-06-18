Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3FRJVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:21:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:42909 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab3FRJVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:21:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="351596691"
Message-ID: <51C02664.2050603@intel.com>
Date: Tue, 18 Jun 2013 17:20:36 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Drop two functions that are not used any
 more
References: <6895318.cKDBc4OdI0@vostro.rjw.lan> <2934743.cl2LaccKZx@vostro.rjw.lan>
In-Reply-To: <2934743.cl2LaccKZx@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 08:33 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Two functions defined in device_pm.c, acpi_dev_pm_add_dependent()
> and acpi_dev_pm_remove_dependent(), have no callers and may be
> dropped, so drop them.

Please hold on for a moment, I would like to discuss the ATA ACPI
binding with you and Tejun, the current binding with SCSI device tree
doesn't buy us anything but introduced some nasty consequences. I think
we should bind ACPI handle with ATA port/device, I have a draft patch
for this and will send out soon. If we go binding with ATA port/device,
then the two functions will be needed :-)

Thanks,
Aaron

> 
> Moreover, they are the only functions adding entries to and removing
> entries from the power_dependent list in struct acpi_device, so drop
> that list and the loop walking it in acpi_power_resume_dependent()
> too.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/device_pm.c |   56 -----------------------------------------------
>  drivers/acpi/power.c     |    3 --
>  drivers/acpi/scan.c      |    1 
>  include/acpi/acpi_bus.h  |    7 -----
>  4 files changed, 67 deletions(-)
> 
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -308,7 +308,6 @@ struct acpi_device {
>  	struct list_head physical_node_list;
>  	struct mutex physical_node_lock;
>  	DECLARE_BITMAP(physical_node_id_bitmap, ACPI_MAX_PHYSICAL_NODE);
> -	struct list_head power_dependent;
>  	void (*remove)(struct acpi_device *);
>  };
>  
> @@ -461,8 +460,6 @@ acpi_status acpi_add_pm_notifier(struct
>  acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
>  				    acpi_notify_handler handler);
>  int acpi_pm_device_sleep_state(struct device *, int *, int);
> -void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev);
> -void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev);
>  #else
>  static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
>  					       acpi_notify_handler handler,
> @@ -482,10 +479,6 @@ static inline int acpi_pm_device_sleep_s
>  
>  	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
>  }
> -static inline void acpi_dev_pm_add_dependent(acpi_handle handle,
> -					     struct device *depdev) {}
> -static inline void acpi_dev_pm_remove_dependent(acpi_handle handle,
> -						struct device *depdev) {}
>  #endif
>  
>  #ifdef CONFIG_PM_RUNTIME
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c
> +++ linux-pm/drivers/acpi/device_pm.c
> @@ -994,60 +994,4 @@ void acpi_dev_pm_detach(struct device *d
>  	}
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_pm_detach);
> -
> -/**
> - * acpi_dev_pm_add_dependent - Add physical device depending for PM.
> - * @handle: Handle of ACPI device node.
> - * @depdev: Device depending on that node for PM.
> - */
> -void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev)
> -{
> -	struct acpi_device_physical_node *dep;
> -	struct acpi_device *adev;
> -
> -	if (!depdev || acpi_bus_get_device(handle, &adev))
> -		return;
> -
> -	mutex_lock(&adev->physical_node_lock);
> -
> -	list_for_each_entry(dep, &adev->power_dependent, node)
> -		if (dep->dev == depdev)
> -			goto out;
> -
> -	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
> -	if (dep) {
> -		dep->dev = depdev;
> -		list_add_tail(&dep->node, &adev->power_dependent);
> -	}
> -
> - out:
> -	mutex_unlock(&adev->physical_node_lock);
> -}
> -EXPORT_SYMBOL_GPL(acpi_dev_pm_add_dependent);
> -
> -/**
> - * acpi_dev_pm_remove_dependent - Remove physical device depending for PM.
> - * @handle: Handle of ACPI device node.
> - * @depdev: Device depending on that node for PM.
> - */
> -void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev)
> -{
> -	struct acpi_device_physical_node *dep;
> -	struct acpi_device *adev;
> -
> -	if (!depdev || acpi_bus_get_device(handle, &adev))
> -		return;
> -
> -	mutex_lock(&adev->physical_node_lock);
> -
> -	list_for_each_entry(dep, &adev->power_dependent, node)
> -		if (dep->dev == depdev) {
> -			list_del(&dep->node);
> -			kfree(dep);
> -			break;
> -		}
> -
> -	mutex_unlock(&adev->physical_node_lock);
> -}
> -EXPORT_SYMBOL_GPL(acpi_dev_pm_remove_dependent);
>  #endif /* CONFIG_PM */
> Index: linux-pm/drivers/acpi/power.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/power.c
> +++ linux-pm/drivers/acpi/power.c
> @@ -253,9 +253,6 @@ static void acpi_power_resume_dependent(
>  	list_for_each_entry(pn, &adev->physical_node_list, node)
>  		pm_request_resume(pn->dev);
>  
> -	list_for_each_entry(pn, &adev->power_dependent, node)
> -		pm_request_resume(pn->dev);
> -
>  	mutex_unlock(&adev->physical_node_lock);
>  }
>  
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -1018,7 +1018,6 @@ int acpi_device_add(struct acpi_device *
>  	INIT_LIST_HEAD(&device->wakeup_list);
>  	INIT_LIST_HEAD(&device->physical_node_list);
>  	mutex_init(&device->physical_node_lock);
> -	INIT_LIST_HEAD(&device->power_dependent);
>  
>  	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
>  	if (!new_bus_id) {
> 

