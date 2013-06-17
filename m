Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3FQBt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 21:49:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:8180 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab3FQBty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 21:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,877,1363158000"; 
   d="scan'208";a="255909867"
Message-ID: <51BE6B5C.70803@intel.com>
Date: Mon, 17 Jun 2013 09:50:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Liu Jiang <liuj97@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Liu Jiang <liu97@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com>
In-Reply-To: <1371265368-7334-1-git-send-email-liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 11:02 AM, Liu Jiang wrote:
> From: Liu Jiang <liu97@gmail.com>
> 
> Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
> removed ACPI dock notification related code, but there's some dead
> code left, so clean up it.

I never noticed this, but it looks to be the case...

I'm not sure the dock notification code is removed intentionally or
mistakenly though, if it is a mistake, then instead of removing the left
code here, we probably should add the dock notification code back.

But I have no test system or any knowledge about how ata dock works, so
I may be wrong :-)

Thanks,
Aaron

> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Aaron Lu <aaron.lu@intel.com>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
> ---
>  drivers/ata/libata-acpi.c | 123 ----------------------------------------------
>  1 file changed, 123 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 87f2f39..e50c987 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -91,129 +91,6 @@ acpi_handle ata_dev_acpi_handle(struct ata_device *dev)
>  }
>  EXPORT_SYMBOL(ata_dev_acpi_handle);
>  
> -/* @ap and @dev are the same as ata_acpi_handle_hotplug() */
> -static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
> -{
> -	if (dev)
> -		dev->flags |= ATA_DFLAG_DETACH;
> -	else {
> -		struct ata_link *tlink;
> -		struct ata_device *tdev;
> -
> -		ata_for_each_link(tlink, ap, EDGE)
> -			ata_for_each_dev(tdev, tlink, ALL)
> -				tdev->flags |= ATA_DFLAG_DETACH;
> -	}
> -
> -	ata_port_schedule_eh(ap);
> -}
> -
> -/**
> - * ata_acpi_handle_hotplug - ACPI event handler backend
> - * @ap: ATA port ACPI event occurred
> - * @dev: ATA device ACPI event occurred (can be NULL)
> - * @event: ACPI event which occurred
> - *
> - * All ACPI bay / device realted events end up in this function.  If
> - * the event is port-wide @dev is NULL.  If the event is specific to a
> - * device, @dev points to it.
> - *
> - * Hotplug (as opposed to unplug) notification is always handled as
> - * port-wide while unplug only kills the target device on device-wide
> - * event.
> - *
> - * LOCKING:
> - * ACPI notify handler context.  May sleep.
> - */
> -static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
> -				    u32 event)
> -{
> -	struct ata_eh_info *ehi = &ap->link.eh_info;
> -	int wait = 0;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(ap->lock, flags);
> -	/*
> -	 * When dock driver calls into the routine, it will always use
> -	 * ACPI_NOTIFY_BUS_CHECK/ACPI_NOTIFY_DEVICE_CHECK for add and
> -	 * ACPI_NOTIFY_EJECT_REQUEST for remove
> -	 */
> -	switch (event) {
> -	case ACPI_NOTIFY_BUS_CHECK:
> -	case ACPI_NOTIFY_DEVICE_CHECK:
> -		ata_ehi_push_desc(ehi, "ACPI event");
> -
> -		ata_ehi_hotplugged(ehi);
> -		ata_port_freeze(ap);
> -		break;
> -	case ACPI_NOTIFY_EJECT_REQUEST:
> -		ata_ehi_push_desc(ehi, "ACPI event");
> -
> -		ata_acpi_detach_device(ap, dev);
> -		wait = 1;
> -		break;
> -	}
> -
> -	spin_unlock_irqrestore(ap->lock, flags);
> -
> -	if (wait)
> -		ata_port_wait_eh(ap);
> -}
> -
> -static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
> -{
> -	struct ata_device *dev = data;
> -
> -	ata_acpi_handle_hotplug(dev->link->ap, dev, event);
> -}
> -
> -static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
> -{
> -	struct ata_port *ap = data;
> -
> -	ata_acpi_handle_hotplug(ap, NULL, event);
> -}
> -
> -static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
> -	u32 event)
> -{
> -	struct kobject *kobj = NULL;
> -	char event_string[20];
> -	char *envp[] = { event_string, NULL };
> -
> -	if (dev) {
> -		if (dev->sdev)
> -			kobj = &dev->sdev->sdev_gendev.kobj;
> -	} else
> -		kobj = &ap->dev->kobj;
> -
> -	if (kobj) {
> -		snprintf(event_string, 20, "BAY_EVENT=%d", event);
> -		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
> -	}
> -}
> -
> -static void ata_acpi_ap_uevent(acpi_handle handle, u32 event, void *data)
> -{
> -	ata_acpi_uevent(data, NULL, event);
> -}
> -
> -static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
> -{
> -	struct ata_device *dev = data;
> -	ata_acpi_uevent(dev->link->ap, dev, event);
> -}
> -
> -static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
> -	.handler = ata_acpi_dev_notify_dock,
> -	.uevent = ata_acpi_dev_uevent,
> -};
> -
> -static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
> -	.handler = ata_acpi_ap_notify_dock,
> -	.uevent = ata_acpi_ap_uevent,
> -};
> -
>  /**
>   * ata_acpi_dissociate - dissociate ATA host from ACPI objects
>   * @host: target ATA host
> 

