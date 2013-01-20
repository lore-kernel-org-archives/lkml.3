Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3ATWto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:49:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47792 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3ATWtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:49:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v9 07/11] PCI, acpiphp: Move and enhance hotplug support of pci host bridge
Date: Sun, 20 Jan 2013 23:55:39 +0100
Message-ID: <9639993.DWkmFxRIH0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358495602-22867-8-git-send-email-yinghai@kernel.org>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org> <1358495602-22867-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 11:53:18 PM Yinghai Lu wrote:
> We have partial hot-add support in acpiphp driver, and it is confusing.
> 
> Move host bridge hot-add support to pci_root.c, and keep acpiphp simple,
> also add hot-remove support in pci_root.c.
> 
> How to test it: if sci_emu patch is applied,
> 
> Find out root bus number to acpi root name mapping from dmesg or /sys
> 
>   echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify
> to remove root bus
> 
>   echo "\_SB.PCIB 1" > /sys/kernel/debug/acpi/sci_notify
> to add back root bus
> 
> -v2: put back pci_root_hp change in one patch
> -v3: add pcibios_resource_survey_bus() calling
> -v4: remove not needed code with remove_bridge
> -v5: put back support for acpiphp support for slots just on root bus.
> -v6: change some functions to *_p2p_* to make it more clean.
> -v7: split hot_added change out.
> -v8: Move to pci_root.c instead of adding another file requested by Bjorn.
> -v9: Fold three following patches into this one for easy review:
> 	a: Add missing hot_remove support for root device.
> 	b: Tang Chen noticed that hotplug through container will not update
> 	   acpi_root_bridge list. After closely checking, we don't need
> 	   that for struct for tracking and could use acpi_pci_root directly.
> 	c: Tang Chen found handle_root_bridge_removal is very similiar to
> 	   acpi_bus_hot_remove_device().  Change to handle_root_bridge_removal
> 	   to use acpi_bus_hot_remove_device.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/pci_root.c            |  139 ++++++++++++++++++++++++++++++++++++
>  drivers/pci/hotplug/acpiphp_glue.c |   59 ++++-----------
>  2 files changed, 154 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index bf5108a..3ce5d80 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -655,3 +655,142 @@ int __init acpi_pci_root_init(void)
>  
>  	return 0;
>  }
> +
> +/* Support root bridge hotplug */
> +
> +static void handle_root_bridge_insertion(acpi_handle handle)
> +{
> +	struct acpi_device *device, *pdevice;
> +	acpi_handle phandle;
> +	int ret_val;
> +
> +	acpi_get_parent(handle, &phandle);
> +	if (acpi_bus_get_device(phandle, &pdevice)) {
> +		printk(KERN_DEBUG "no parent device, assuming NULL\n");
> +		pdevice = NULL;
> +	}
> +	if (!acpi_bus_get_device(handle, &device)) {
> +		/* check if  pci root_bus is removed */
> +		struct acpi_pci_root *root = acpi_driver_data(device);
> +		if (pci_find_bus(root->segment, root->secondary.start))
> +			return;
> +
> +		printk(KERN_DEBUG "bus exists... trim\n");
> +		/* this shouldn't be in here, so remove
> +		 * the bus then re-add it...
> +		 */
> +		ret_val = acpi_bus_trim(device);

You said that this followed acpiphp, but the purpose of the trimming in there
seems to be to handle surprise removal and re-insertion, which I'm not sure is
OK with something like a host bridge.

The drawback is that if we have a spurious ACPI_NOTIFY_BUS_CHECK or
ACPI_NOTIFY_DEVICE_CHECK, we'll be trying to remove the whole bus here in
response.  That doesn't sound quite right.

> +		printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
> +	}
> +	if (acpi_bus_add(handle))
> +		printk(KERN_ERR "cannot add bridge to acpi list\n");
> +}
> +
> +static void handle_root_bridge_removal(struct acpi_device *device)
> +{
> +	struct acpi_eject_event *ej_event;
> +
> +	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> +	if (!ej_event)

Shouldn't we do acpi_evaluate_hotplug_ost() here?

> +		return;
> +
> +	ej_event->device = device;
> +	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> +
> +	acpi_bus_hot_remove_device(ej_event);
> +}
> +
> +static void _handle_hotplug_event_root(struct work_struct *work)
> +{
> +	struct acpi_pci_root *root;
> +	char objname[64];
> +	struct acpi_buffer buffer = { .length = sizeof(objname),
> +				      .pointer = objname };
> +	struct acpi_hp_work *hp_work;
> +	acpi_handle handle;
> +	u32 type;
> +
> +	hp_work = container_of(work, struct acpi_hp_work, work);
> +	handle = hp_work->handle;
> +	type = hp_work->type;
> +
> +	root = acpi_pci_find_root(handle);
> +
> +	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);

Is the path guaranteed not to be longer than 64 characters?

> +
> +	switch (type) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +		/* bus enumerate */
> +		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
> +				 objname);

pr_debug() would be nicer (and analogously below).

> +		if (!root)
> +			handle_root_bridge_insertion(handle);
> +
> +		break;
> +
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		/* device check */
> +		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
> +				 objname);
> +		if (!root)
> +			handle_root_bridge_insertion(handle);
> +		break;
> +
> +	case ACPI_NOTIFY_EJECT_REQUEST:
> +		/* request device eject */
> +		printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
> +				 objname);
> +		if (root)
> +			handle_root_bridge_removal(root->device);
> +		break;
> +	default:
> +		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
> +				 type, objname);
> +		break;
> +	}
> +
> +	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
> +}
> +
> +static void handle_hotplug_event_root(acpi_handle handle, u32 type,
> +					void *context)
> +{
> +	alloc_acpi_hp_work(handle, type, context,
> +				_handle_hotplug_event_root);
> +}
> +
> +static acpi_status __init
> +find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> +{
> +	char objname[64];
> +	struct acpi_buffer buffer = { .length = sizeof(objname),
> +				      .pointer = objname };
> +	int *count = (int *)context;
> +
> +	if (!acpi_is_root_bridge(handle))
> +		return AE_OK;
> +
> +	(*count)++;
> +
> +	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> +
> +	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +				handle_hotplug_event_root, NULL);
> +	printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
> +
> +	return AE_OK;
> +}
> +
> +static int __init acpi_pci_root_hp_init(void)
> +{
> +	int num = 0;
> +
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +		ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
> +
> +	printk(KERN_DEBUG "Found %d acpi root devices\n", num);
> +
> +	return 0;
> +}
> +
> +subsys_initcall(acpi_pci_root_hp_init);

Why do we need a separate initcall here?  Is it not enough to call
acpi_pci_root_hp_init() from acpi_init() or acpi_scan_init(), or
acpi_pci_root_init() even?

> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 55e03b6..45917a5 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -543,10 +543,13 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>  	acpi_status status;
>  	acpi_handle handle = bridge->handle;
>  
> -	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +	if (bridge->type != BRIDGE_TYPE_HOST) {
> +		status = acpi_remove_notify_handler(handle,
> +					    ACPI_SYSTEM_NOTIFY,
>  					    handle_hotplug_event_bridge);
> -	if (ACPI_FAILURE(status))
> -		err("failed to remove notify handler\n");
> +		if (ACPI_FAILURE(status))
> +			err("failed to remove notify handler\n");
> +	}
>  
>  	if ((bridge->type != BRIDGE_TYPE_HOST) &&
>  	    ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
> @@ -630,9 +633,6 @@ static void remove_bridge(struct acpi_pci_root *root)
>  	bridge = acpiphp_handle_to_bridge(handle);
>  	if (bridge)
>  		cleanup_bridge(bridge);
> -	else
> -		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -					   handle_hotplug_event_bridge);
>  }
>  
>  static int power_on_slot(struct acpiphp_slot *slot)
> @@ -1123,18 +1123,12 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
>  }
>  
>  /* Program resources in newly inserted bridge */
> -static int acpiphp_configure_bridge (acpi_handle handle)
> +static int acpiphp_configure_p2p_bridge(acpi_handle handle)
>  {
> -	struct pci_bus *bus;
> +	struct pci_dev *pdev = acpi_get_pci_dev(handle);
> +	struct pci_bus *bus = pdev->subordinate;
>  
> -	if (acpi_is_root_bridge(handle)) {
> -		struct acpi_pci_root *root = acpi_pci_find_root(handle);
> -		bus = root->bus;
> -	} else {
> -		struct pci_dev *pdev = acpi_get_pci_dev(handle);
> -		bus = pdev->subordinate;
> -		pci_dev_put(pdev);
> -	}
> +	pci_dev_put(pdev);
>  
>  	pci_bus_size_bridges(bus);
>  	pci_bus_assign_resources(bus);
> @@ -1144,7 +1138,7 @@ static int acpiphp_configure_bridge (acpi_handle handle)
>  	return 0;
>  }
>  
> -static void handle_bridge_insertion(acpi_handle handle, u32 type)
> +static void handle_p2p_bridge_insertion(acpi_handle handle, u32 type)
>  {
>  	struct acpi_device *device;
>  
> @@ -1162,8 +1156,8 @@ static void handle_bridge_insertion(acpi_handle handle, u32 type)
>  		err("ACPI device object missing\n");
>  		return;
>  	}
> -	if (!acpiphp_configure_bridge(handle))
> -		add_bridge(handle);
> +	if (!acpiphp_configure_p2p_bridge(handle))
> +		add_p2p_bridge(handle);
>  	else
>  		err("cannot configure and start bridge\n");
>  
> @@ -1221,7 +1215,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>  
>  	if (acpi_bus_get_device(handle, &device)) {
>  		/* This bridge must have just been physically inserted */
> -		handle_bridge_insertion(handle, type);
> +		handle_p2p_bridge_insertion(handle, type);
>  		goto out;
>  	}
>  
> @@ -1396,21 +1390,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>  	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
>  }
>  
> -static acpi_status
> -find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	int *count = (int *)context;
> -
> -	if (!acpi_is_root_bridge(handle))
> -		return AE_OK;
> -
> -	(*count)++;
> -	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -				    handle_hotplug_event_bridge, NULL);
> -
> -	return AE_OK ;
> -}
> -
>  static struct acpi_pci_driver acpi_pci_hp_driver = {
>  	.add =		add_bridge,
>  	.remove =	remove_bridge,
> @@ -1421,15 +1400,7 @@ static struct acpi_pci_driver acpi_pci_hp_driver = {
>   */
>  int __init acpiphp_glue_init(void)
>  {
> -	int num = 0;
> -
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -			ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
> -
> -	if (num <= 0)
> -		return -1;
> -	else
> -		acpi_pci_register_driver(&acpi_pci_hp_driver);
> +	acpi_pci_register_driver(&acpi_pci_hp_driver);
>  
>  	return 0;
>  }

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
