Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3GIJSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:18:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:29678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab3GIJS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1027,1363158000"; 
   d="scan'208";a="265806091"
Date: Tue, 9 Jul 2013 12:23:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 4/8] ACPI / hotplug / PCI: Hotplug context objects
 for bridges and functions
Message-ID: <20130709092353.GI4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
 <1541978.EJm27nSHDT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541978.EJm27nSHDT@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 02:18:12AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> When either a new hotplug brigde or a new hotplug function is added
                            ^^^^^^
                            typo

> by the ACPI-based PCI hotplug (acpiphp) code, attach a context object
> to its ACPI handle to store hotplug-related information in it.  To
> start with, put the handle's bridge and function pointers into that
> object.  Count references to the context objects and drop them when
> they are not needed any more.
> 
> First of all, this makes it possible to find out if the given bridge
> has been registered as a function already in a much more
> straightforward way and acpiphp_bridge_handle_to_function() can be
> dropped (Yay!).
>
> This also will allow some more simplifications to be made going
> forward.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/pci/hotplug/acpiphp.h      |   10 ++
>  drivers/pci/hotplug/acpiphp_glue.c |  154 ++++++++++++++++++++++++++-----------
>  2 files changed, 121 insertions(+), 43 deletions(-)
> 
> Index: linux-pm/drivers/pci/hotplug/acpiphp.h
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
> +++ linux-pm/drivers/pci/hotplug/acpiphp.h
> @@ -49,6 +49,7 @@
>  #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
>  #define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
>  
> +struct acpiphp_context;
>  struct acpiphp_bridge;
>  struct acpiphp_slot;
>  
> @@ -77,6 +78,7 @@ struct acpiphp_bridge {
>  	struct kref ref;
>  	acpi_handle handle;
>  
> +	struct acpiphp_context *context;
>  	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
>  	struct acpiphp_func *func;
>  
> @@ -119,6 +121,7 @@ struct acpiphp_slot {
>   * typically 8 objects per slot (i.e. for each PCI function)
>   */
>  struct acpiphp_func {
> +	struct acpiphp_context *context;
>  	struct acpiphp_slot *slot;	/* parent */
>  
>  	struct list_head sibling;
> @@ -129,6 +132,13 @@ struct acpiphp_func {
>  	u32		flags;		/* see below */
>  };
>  
> +struct acpiphp_context {
> +	struct kref kref;
> +	acpi_handle handle;
> +	struct acpiphp_func *func;
> +	struct acpiphp_bridge *bridge;
> +};
> +
>  /*
>   * struct acpiphp_attention_info - device specific attention registration
>   *
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -79,6 +79,61 @@ is_pci_dock_device(acpi_handle handle, u
>  	}
>  }
>  
> +static void acpiphp_context_handler(acpi_handle handle, void *context)
> +{
> +	/* Intentionally empty. */
> +}
> +
> +static struct acpiphp_context *acpiphp_init_context(acpi_handle handle)
> +{
> +	struct acpiphp_context *context;
> +	acpi_status status;
> +
> +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context)
> +		return NULL;
> +
> +	context->handle = handle;
> +	kref_init(&context->kref);
> +	status = acpi_attach_data(handle, acpiphp_context_handler, context);
> +	if (ACPI_FAILURE(status)) {
> +		kfree(context);
> +		return NULL;
> +	}
> +	return context;
> +}
> +
> +static struct acpiphp_context *acpiphp_get_context(acpi_handle handle)
> +{
> +	struct acpiphp_context *context = NULL;
> +	acpi_status status;
> +	void *data;
> +
> +	status = acpi_get_data(handle, acpiphp_context_handler, &data);
> +	if (ACPI_SUCCESS(status)) {
> +		context = data;
> +		kref_get(&context->kref);
> +	} else if (status == AE_NOT_FOUND) {
> +		context = acpiphp_init_context(handle);
> +	}
> +	return context;
> +}
> +
> +static void acpiphp_release_context(struct kref *kref)
> +{
> +	struct acpiphp_context *context;
> +
> +	context = container_of(kref, struct acpiphp_context, kref);
> +	WARN_ON(context->func || context->bridge);
> +	acpi_detach_data(context->handle, acpiphp_context_handler);
> +	kfree(context);
> +}
> +
> +static void acpiphp_put_context(struct acpiphp_context *context)
> +{
> +	kref_put(&context->kref, acpiphp_release_context);
> +}
> +
>  static inline void get_bridge(struct acpiphp_bridge *bridge)
>  {
>  	kref_get(&bridge->ref);
> @@ -91,6 +146,7 @@ static inline void put_bridge(struct acp
>  
>  static void free_bridge(struct kref *kref)
>  {
> +	struct acpiphp_context *context;
>  	struct acpiphp_bridge *bridge;
>  	struct acpiphp_slot *slot, *next;
>  	struct acpiphp_func *func, *tmp;
> @@ -99,17 +155,24 @@ static void free_bridge(struct kref *kre
>  
>  	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
>  		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
> +			context = func->context;
> +			context->func = NULL;
>  			kfree(func);
> +			acpiphp_put_context(context);
>  		}
>  		kfree(slot);
>  	}
>  
> -	/* Release reference acquired by acpiphp_bridge_handle_to_function() */
> +	/* Release reference acquired by acpiphp_enumerate_slots(). */
>  	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)
>  		put_bridge(bridge->func->slot->bridge);
> +
>  	put_device(&bridge->pci_bus->dev);
>  	pci_dev_put(bridge->pci_dev);
> +	context = bridge->context;
> +	context->bridge = NULL;
>  	kfree(bridge);
> +	acpiphp_put_context(context);
>  }
>  
>  /*
> @@ -195,10 +258,11 @@ static void acpiphp_dock_release(void *d
>  }
>  
>  /* callback routine to register each ACPI PCI slot object */
> -static acpi_status
> -register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> +static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
> +				 void **rv)
>  {
> -	struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)context;
> +	struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)data;
> +	struct acpiphp_context *context;
>  	struct acpiphp_slot *slot;
>  	struct acpiphp_func *newfunc;
>  	acpi_handle tmp;
> @@ -229,8 +293,20 @@ register_slot(acpi_handle handle, u32 lv
>  	if (!newfunc)
>  		return AE_NO_MEMORY;
>  
> +	context = acpiphp_get_context(handle);
> +	if (!context) {
> +		context = acpiphp_init_context(handle);

Since acpiphp_get_context() already does acpiphp_init_context() is the
above really necessary?

> +		if (!context) {
> +			acpi_handle_err(handle, "No hotplug context\n");
> +			kfree(newfunc);
> +			return AE_NOT_EXIST;
> +		}
> +	}
> +
>  	newfunc->handle = handle;
>  	newfunc->function = function;
> +	newfunc->context = context;
> +	context->func = newfunc;
>  
>  	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
>  		newfunc->flags = FUNC_HAS_EJ0;
> @@ -268,8 +344,8 @@ register_slot(acpi_handle handle, u32 lv
>  	if (!found) {
>  		slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
>  		if (!slot) {
> -			kfree(newfunc);
> -			return AE_NO_MEMORY;
> +			status = AE_NO_MEMORY;
> +			goto err_out;
>  		}
>  
>  		slot->bridge = bridge;
> @@ -293,7 +369,9 @@ register_slot(acpi_handle handle, u32 lv
>  			else
>  				warn("acpiphp_register_hotplug_slot failed "
>  					"(err code = 0x%x)\n", retval);
> -			goto err_exit;
> +
> +			status = AE_OK;
> +			goto err;
>  		}
>  	}
>  
> @@ -339,15 +417,17 @@ register_slot(acpi_handle handle, u32 lv
>  
>  	return AE_OK;
>  
> - err_exit:
> + err:
>  	bridge->nr_slots--;
>  	mutex_lock(&bridge_mutex);
>  	list_del(&slot->node);
>  	mutex_unlock(&bridge_mutex);
>  	kfree(slot);
> + err_out:
> +	context->func = NULL;
>  	kfree(newfunc);
> -
> -	return AE_OK;
> +	acpiphp_put_context(context);
> +	return status;
>  }
>  
>  
> @@ -362,32 +442,6 @@ static int detect_ejectable_slots(acpi_h
>  	return found;
>  }
>  
> -
> -/* find acpiphp_func from acpiphp_bridge */
> -static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
> -{
> -	struct acpiphp_bridge *bridge;
> -	struct acpiphp_slot *slot;
> -	struct acpiphp_func *func = NULL;
> -
> -	mutex_lock(&bridge_mutex);
> -	list_for_each_entry(bridge, &bridge_list, list) {
> -		list_for_each_entry(slot, &bridge->slots, node) {
> -			list_for_each_entry(func, &slot->funcs, sibling) {
> -				if (func->handle == handle) {
> -					get_bridge(func->slot->bridge);
> -					mutex_unlock(&bridge_mutex);
> -					return func;
> -				}
> -			}
> -		}
> -	}
> -	mutex_unlock(&bridge_mutex);
> -
> -	return NULL;
> -}
> -
> -
>  static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
>  {
>  	struct acpiphp_bridge *bridge;
> @@ -1130,6 +1184,7 @@ static void handle_hotplug_event_func(ac
>   */
>  void acpiphp_enumerate_slots(struct pci_bus *bus)
>  {
> +	struct acpiphp_context *context;
>  	struct acpiphp_bridge *bridge;
>  	acpi_handle handle;
>  	acpi_status status;
> @@ -1141,9 +1196,19 @@ void acpiphp_enumerate_slots(struct pci_
>  	if (!handle || detect_ejectable_slots(handle) <= 0)
>  		return;
>  
> +	context = acpiphp_get_context(handle);
> +	if (!context) {
> +		context = acpiphp_init_context(handle);

Ditto.

> +		if (!context) {
> +			acpi_handle_err(handle, "No hotplug context\n");
> +			return;
> +		}
> +	}
> +
>  	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
>  	if (bridge == NULL) {
> -		err("out of memory\n");
> +		acpi_handle_err(handle, "No memory for bridge object\n");
> +		acpiphp_put_context(context);
>  		return;
>  	}
