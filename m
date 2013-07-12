Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3GLLs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:48:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:59687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3GLLsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,652,1367996400"; 
   d="scan'208";a="369191555"
Date: Fri, 12 Jul 2013 14:54:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 11/30] ACPI / hotplug / PCI: Register all devices
 under the given bridge
Message-ID: <20130712115420.GH4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
 <3718119.FLASu5DBx8@vostro.rjw.lan>
 <1910839.UjS2m1ckUq@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1910839.UjS2m1ckUq@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 01:50:29AM +0200, Rafael J. Wysocki wrote:
> @@ -1210,6 +1125,35 @@ void acpiphp_enumerate_slots(struct pci_
>  	 */
>  	get_device(&bus->dev);
>  
> +	if (!pci_is_root_bus(bridge->pci_bus)) {
> +		struct acpiphp_context *context;
> +
> +		/*
> +		 * This bridge should have been registered as a hotplug function
> +		 * under its parent, so the context has to be there.  If not, we
> +		 * are in deep goo.
> +		 */
> +		mutex_lock(&acpiphp_context_lock);
> +		context = acpiphp_get_context(handle);
> +		if (WARN_ON(!context || !context->func)) {
> +			mutex_unlock(&acpiphp_context_lock);
> +			put_device(&bus->dev);
> +			kfree(bridge);
> +			return;
> +		}
> +		bridge->context = context;
> +		context->bridge = bridge;
> +		/* Get a reference to the parent bridge. */
> +		get_bridge(context->func->slot->bridge);
> +		mutex_unlock(&acpiphp_context_lock);
> +	}
> +
> +	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
> +	if (ACPI_SUCCESS(status)) {
> +		dbg("found ejectable p2p bridge\n");
> +		bridge->flags |= BRIDGE_HAS_EJ0;
> +	}
> +
>  	/* must be added to the list prior to calling register_slot */
>  	mutex_lock(&bridge_mutex);
>  	list_add(&bridge->list, &bridge_list);
> @@ -1220,34 +1164,9 @@ void acpiphp_enumerate_slots(struct pci_
>  				     register_slot, NULL, bridge, NULL);
>  	if (ACPI_FAILURE(status)) {
>  		acpi_handle_err(bridge->handle, "failed to register slots\n");
> -		goto err;
> -	}
> -
> -	if (pci_is_root_bus(bridge->pci_bus))
> -		return;
> -
> -	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
> -	if (ACPI_SUCCESS(status)) {
> -		dbg("found ejectable p2p bridge\n");
> -		bridge->flags |= BRIDGE_HAS_EJ0;
> -	}
> -	if (context->handler_for_func) {
> -		/* Notify handler already installed. */
> -		get_bridge(context->func->slot->bridge);
> -		return;
> +		cleanup_bridge(bridge);
> +		put_bridge(bridge);
>  	}
> -
> -	/* install notify handler for P2P bridges */
> -	status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
> -					     handle_hotplug_event, NULL);

With this removed we now install notify handlers for the slot objects under
this bridge but not for the bridge itself.

In case of Thunderbolt the BIOS will send the event for the root port ACPI
device \_SB_.PCI0.RP05 and with the above change we don't handle it
anymore.

> -	if (ACPI_SUCCESS(status))
> -		return;
> -
> -	acpi_handle_err(bridge->handle, "failed to register notify handler\n");
> -
> - err:
> -	cleanup_bridge(bridge);
> -	put_bridge(bridge);
>  }
