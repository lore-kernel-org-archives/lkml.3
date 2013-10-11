Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3JKNB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:01:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56832 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179Ab3JKNBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:01:55 -0400
Date: Fri, 11 Oct 2013 09:01:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Message-ID: <20131011090153.7760db6b@gandalf.local.home>
In-Reply-To: <2096980.ZtIelfoX39@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home>
	<18685640.N2BnVjDmHD@vostro.rjw.lan>
	<CA+55aFwqf7kkh0dy6AhCvB87XYkQ03YUpsYEDJmnkiRe8GQfMQ@mail.gmail.com>
	<2096980.ZtIelfoX39@vostro.rjw.lan>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 13:13:47 +0200
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / hotplug / PCI: Accept coexistence with native PCIe hotplug
> 
> Allow ACPIPHP (ACPI-based PCI hotplug) to handle event signaling for
> devices that have already been claimed by the native PCIe hotplug
> (pciehp).
> 
> The ACPI hotplug events are essentially re-scan, remove and eject
> requests.  Re-scan and remove should work regardless, because they
> may be triggered by user space via sysfs and the ACPI eject (_EJ0)
> should work if the BIOS wants us to use it.  There may be an issue
> if the BIOS signals ACPI eject and wants us to use the native eject,
> but that doesn't work without this change anyway.
> 
> This change prevents the WARN_ON() in acpiphp_enumerate_slots() from
> triggering unnecessarily for bridges whose parents are managed by
> pciehp.
> 

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -259,6 +259,31 @@ static void acpiphp_dock_release(void *d
>  	put_bridge(context->func.parent);
>  }
>  
> +/**
> + * slot_should_be_exposed - Check whether or not to expose a slot to userland.
> + * @bridge: ACPIPHP bridge the slot belongs to.
> + * @handle: ACPI handle of a device in the slot.
> + */
> +static inline bool slot_should_be_exposed(struct acpiphp_bridge *bridge,
> +					  acpi_handle handle)
> +{
> +	struct pci_bus *pbus = bridge->pci_bus;
> +	struct pci_dev *pdev = bridge->pci_dev;
> +
> +	/*
> +	 * Do not expose slots whose bridges are managed by pciehp, because they
> +	 * will be exposed to user space by the pciehp driver.
> +	 */
> +	if (pdev && device_is_managed_by_native_pciehp(pdev))
> +		return false;
> +
> +	/*
> +	 * Expose slots for devices with either _EJ0 or _RMV and for devices
> +	 * on docking stations.
> +	 */
> +	return acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle);
> +}
> +
>  /* callback routine to register each ACPI PCI slot object */
>  static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
>  				 void **rv)
> @@ -271,12 +296,8 @@ static acpi_status register_slot(acpi_ha
>  	unsigned long long adr;
>  	int device, function;
>  	struct pci_bus *pbus = bridge->pci_bus;
> -	struct pci_dev *pdev = bridge->pci_dev;
>  	u32 val;
>  
> -	if (pdev && device_is_managed_by_native_pciehp(pdev))
> -		return AE_OK;
> -
>  	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
>  	if (ACPI_FAILURE(status)) {
>  		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
> @@ -325,8 +346,7 @@ static acpi_status register_slot(acpi_ha
>  
>  	list_add_tail(&slot->node, &bridge->slots);
>  
> -	/* Register slots for ejectable funtions only. */
> -	if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
> +	if (slot_should_be_exposed(bridge, handle)) {
>  		unsigned long long sun;
>  		int retval;
>  

