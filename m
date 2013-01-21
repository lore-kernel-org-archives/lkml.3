Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3ATX7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:59:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47880 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3ATX7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:59:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 5/8] PCI, ACPI: hook PCI bus notifications to create/destroy PCI slots
Date: Mon, 21 Jan 2013 01:05:47 +0100
Message-ID: <2478524.Ynr5Pmh940@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358525267-14268-6-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-6-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 12:07:43 AM Jiang Liu wrote:
> Currently the pci_slot driver doesn't update PCI slot information
> when PCI device hotplug event happens, which may cause memory leak
> and returning stale information to user.
> 
> By hooking PCI bus notifications, this patch unifies the way to
> create/destroy PCI slots when:
> 1) create PCI hierarchy at boot time
> 2) create PCI hierarchy for PCI root bridge hot-adding
> 3) create PCI hierarchy for PCI device hotplug hot-adding
> 4) destroy PCI hierarchy for PCI root bridge hot-removal
> 4) destroy PCI hierarchy for PCI device hot-removal

This patch also removes some code which apparently is not necessary any more.
It would be good to write in the changelog _why_ that code isn't necessary.

Apart from this, looks good.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/acpi/pci_slot.c |  197 +++++++++++++----------------------------------
>  1 file changed, 54 insertions(+), 143 deletions(-)
> 
> diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
> index a7d7e77..2b38f4d 100644
> --- a/drivers/acpi/pci_slot.c
> +++ b/drivers/acpi/pci_slot.c
> @@ -9,6 +9,9 @@
>   *  Copyright (C) 2007-2008 Hewlett-Packard Development Company, L.P.
>   *  	Alex Chiang <achiang@hp.com>
>   *
> + *  Copyright (C) 2013 Huawei Tech. Co., Ltd.
> + *	Jiang Liu <jiang.liu@huawei.com>
> + *
>   *  This program is free software; you can redistribute it and/or modify it
>   *  under the terms and conditions of the GNU General Public License,
>   *  version 2, as published by the Free Software Foundation.
> @@ -28,10 +31,9 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
> +#include <linux/list.h>
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
> -#include <acpi/acpi_bus.h>
> -#include <acpi/acpi_drivers.h>
>  #include <linux/dmi.h>
>  
>  static bool debug;
> @@ -62,20 +64,12 @@ ACPI_MODULE_NAME("pci_slot");
>  #define SLOT_NAME_SIZE 21		/* Inspired by #define in acpiphp.h */
>  
>  struct acpi_pci_slot {
> -	acpi_handle root_handle;	/* handle of the root bridge */
>  	struct pci_slot *pci_slot;	/* corresponding pci_slot */
>  	struct list_head list;		/* node in the list of slots */
>  };
>  
> -static int acpi_pci_slot_add(struct acpi_pci_root *root);
> -static void acpi_pci_slot_remove(struct acpi_pci_root *root);
> -
>  static LIST_HEAD(slot_list);
>  static DEFINE_MUTEX(slot_list_lock);
> -static struct acpi_pci_driver acpi_pci_slot_driver = {
> -	.add = acpi_pci_slot_add,
> -	.remove = acpi_pci_slot_remove,
> -};
>  
>  static int
>  check_slot(acpi_handle handle, unsigned long long *sun)
> @@ -114,21 +108,8 @@ out:
>  	return device;
>  }
>  
> -struct callback_args {
> -	acpi_walk_callback	user_function;	/* only for walk_p2p_bridge */
> -	struct pci_bus		*pci_bus;
> -	acpi_handle		root_handle;
> -};
> -
>  /*
> - * register_slot
> - *
> - * Called once for each SxFy object in the namespace. Don't worry about
> - * calling pci_create_slot multiple times for the same pci_bus:device,
> - * since each subsequent call simply bumps the refcount on the pci_slot.
> - *
> - * The number of calls to pci_destroy_slot from unregister_slot is
> - * symmetrical.
> + * Check whether handle has an associated slot and create PCI slot if it has.
>   */
>  static acpi_status
>  register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> @@ -138,13 +119,23 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	char name[SLOT_NAME_SIZE];
>  	struct acpi_pci_slot *slot;
>  	struct pci_slot *pci_slot;
> -	struct callback_args *parent_context = context;
> -	struct pci_bus *pci_bus = parent_context->pci_bus;
> +	struct pci_bus *pci_bus = context;
>  
>  	device = check_slot(handle, &sun);
>  	if (device < 0)
>  		return AE_OK;
>  
> +	/*
> +	 * There may be multiple PCI functions associated with the same slot.
> +	 * Check whether PCI slot has already been created for this PCI device.
> +	 */
> +	list_for_each_entry(slot, &slot_list, list) {
> +		pci_slot = slot->pci_slot;
> +		if (pci_slot->bus == pci_bus && pci_slot->number == device) {
> +			return AE_OK;
> +		}
> +	}
> +
>  	slot = kmalloc(sizeof(*slot), GFP_KERNEL);
>  	if (!slot) {
>  		err("%s: cannot allocate memory\n", __func__);
> @@ -159,12 +150,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>  		return AE_OK;
>  	}
>  
> -	slot->root_handle = parent_context->root_handle;
>  	slot->pci_slot = pci_slot;
>  	INIT_LIST_HEAD(&slot->list);
> -	mutex_lock(&slot_list_lock);
>  	list_add(&slot->list, &slot_list);
> -	mutex_unlock(&slot_list_lock);
>  
>  	get_device(&pci_bus->dev);
>  
> @@ -174,137 +162,60 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK;
>  }
>  
> -/*
> - * walk_p2p_bridge - discover and walk p2p bridges
> - * @handle: points to an acpi_pci_root
> - * @context: p2p_bridge_context pointer
> - *
> - * Note that when we call ourselves recursively, we pass a different
> - * value of pci_bus in the child_context.
> - */
> -static acpi_status
> -walk_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	int device, function;
> -	unsigned long long adr;
> -	acpi_status status;
> -	acpi_handle dummy_handle;
> -	acpi_walk_callback user_function;
> -
> -	struct pci_dev *dev;
> -	struct pci_bus *pci_bus;
> -	struct callback_args child_context;
> -	struct callback_args *parent_context = context;
> -
> -	pci_bus = parent_context->pci_bus;
> -	user_function = parent_context->user_function;
> -
> -	status = acpi_get_handle(handle, "_ADR", &dummy_handle);
> -	if (ACPI_FAILURE(status))
> -		return AE_OK;
> -
> -	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
> -	if (ACPI_FAILURE(status))
> -		return AE_OK;
> -
> -	device = (adr >> 16) & 0xffff;
> -	function = adr & 0xffff;
> -
> -	dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
> -	if (!dev || !dev->subordinate)
> -		goto out;
> -
> -	child_context.pci_bus = dev->subordinate;
> -	child_context.user_function = user_function;
> -	child_context.root_handle = parent_context->root_handle;
> -
> -	dbg("p2p bridge walk, pci_bus = %x\n", dev->subordinate->number);
> -	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     user_function, NULL, &child_context, NULL);
> -	if (ACPI_FAILURE(status))
> -		goto out;
> -
> -	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     walk_p2p_bridge, NULL, &child_context, NULL);
> -out:
> -	pci_dev_put(dev);
> -	return AE_OK;
> -}
> -
> -/*
> - * walk_root_bridge - generic root bridge walker
> - * @root: poiner of an acpi_pci_root
> - * @user_function: user callback for slot objects
> - *
> - * Call user_function for all objects underneath this root bridge.
> - * Walk p2p bridges underneath us and call user_function on those too.
> - */
> -static int
> -walk_root_bridge(struct acpi_pci_root *root, acpi_walk_callback user_function)
> +static void acpi_pci_slot_notify_add(struct pci_bus *bus)
>  {
> -	acpi_status status;
> -	acpi_handle handle = root->device->handle;
> -	struct pci_bus *pci_bus = root->bus;
> -	struct callback_args context;
> -
> -	context.pci_bus = pci_bus;
> -	context.user_function = user_function;
> -	context.root_handle = handle;
> -
> -	dbg("root bridge walk, pci_bus = %x\n", pci_bus->number);
> -	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     user_function, NULL, &context, NULL);
> -	if (ACPI_FAILURE(status))
> -		return status;
> -
> -	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
> -				     walk_p2p_bridge, NULL, &context, NULL);
> -	if (ACPI_FAILURE(status))
> -		err("%s: walk_p2p_bridge failure - %d\n", __func__, status);
> -
> -	return status;
> -}
> +	acpi_handle handle = NULL;
>  
> -/*
> - * acpi_pci_slot_add
> - * @handle: points to an acpi_pci_root
> - */
> -static int
> -acpi_pci_slot_add(struct acpi_pci_root *root)
> -{
> -	acpi_status status;
> -
> -	status = walk_root_bridge(root, register_slot);
> -	if (ACPI_FAILURE(status))
> -		err("%s: register_slot failure - %d\n", __func__, status);
> +	if (bus->bridge)
> +		handle = DEVICE_ACPI_HANDLE(bus->bridge);
> +	if (!handle)
> +		return;
>  
> -	return status;
> +	mutex_lock(&slot_list_lock);
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +			    register_slot, NULL, bus, NULL);
> +	mutex_unlock(&slot_list_lock);
>  }
>  
> -/*
> - * acpi_pci_slot_remove
> - * @handle: points to an acpi_pci_root
> - */
> -static void
> -acpi_pci_slot_remove(struct acpi_pci_root *root)
> +static void acpi_pci_slot_notify_del(struct pci_bus *bus)
>  {
>  	struct acpi_pci_slot *slot, *tmp;
> -	struct pci_bus *pbus;
> -	acpi_handle handle = root->device->handle;
>  
>  	mutex_lock(&slot_list_lock);
>  	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
> -		if (slot->root_handle == handle) {
> +		if (slot->pci_slot->bus == bus) {
>  			list_del(&slot->list);
> -			pbus = slot->pci_slot->bus;
>  			pci_destroy_slot(slot->pci_slot);
> -			put_device(&pbus->dev);
> +			put_device(&bus->dev);
>  			kfree(slot);
>  		}
>  	}
>  	mutex_unlock(&slot_list_lock);
>  }
>  
> +static int acpi_pci_slot_notify_fn(struct notifier_block *nb,
> +				   unsigned long event, void *data)
> +{
> +	struct pci_bus *bus = data;
> +
> +	switch (event) {
> +	case PCI_NOTIFY_POST_BUS_ADD:
> +		acpi_pci_slot_notify_add(bus);
> +		break;
> +	case PCI_NOTIFY_PRE_BUS_DEL:
> +		acpi_pci_slot_notify_del(bus);
> +		break;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block acpi_pci_slot_notifier = {
> +	.notifier_call = &acpi_pci_slot_notify_fn,
> +};
> +
>  static int do_sta_before_sun(const struct dmi_system_id *d)
>  {
>  	info("%s detected: will evaluate _STA before calling _SUN\n", d->ident);
> @@ -333,5 +244,5 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata = {
>  void __init acpi_pci_slot_init(void)
>  {
>  	dmi_check_system(acpi_pci_slot_dmi_table);
> -	acpi_pci_register_driver(&acpi_pci_slot_driver);
> +	pci_bus_register_notifier(&acpi_pci_slot_notifier);
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
