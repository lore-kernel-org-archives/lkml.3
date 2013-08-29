Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3H2SNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:13:01 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50364 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3H2SM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:12:57 -0400
Date: Thu, 29 Aug 2013 14:12:31 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3] ACPI: Fix osc flag setup ordering to allow pcie
 hotplug use when available
Message-ID: <20130829181231.GA2285@hmsreliant.think-freely.org>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
 <1377531553-17716-1-git-send-email-nhorman@tuxdriver.com>
 <20130829174713.GA6489@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829174713.GA6489@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:47:13AM -0600, Bjorn Helgaas wrote:
> On Mon, Aug 26, 2013 at 11:39:13AM -0400, Neil Horman wrote:
> > Somewhere between 3.9 and 3.10 it seems the order in which pcie and acpi probed
> > slots for hotplug capabilites got reversed.  While this isn't a big deal, it did
> > uncover a bug in the ACPI bus setup path.  Specifically, acpi_pci_root_add calls
> > pci_acpi_scan_root before setting the osc flags for the device handle.
> > pci_acpi_scan_root, among other things uses device_is_managed_by_native_pciehp()
> > to determine if a given slot has pcie hotplug capabilties, whcih checks the
> > devices OSC_PCI_EXPRESS_NATIVE_HP_CONTROL flag.  Since that flag is not set
> > until after pci_acpi_scan_root_completes, the acpi code never sees that pcie
> > slots are hotplug capable and configures them all to use acpi instead.
> > 
> > Fix is pretty simple, just defer the scan until after the osc flags have been
> > set on the device.  Tested by myself and it seems to work well.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Len Brown <lenb@kernel.org>
> > CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: linux-acpi@vger.kernel.org
> > CC: linux-pci@vger.kernel.org
> > 
> > ---
> > Change notes:
> > v2) eferred the disabling of aspm until after the acpi scan of the pci bus is
> > complete.  This was done to allow proper handling of pcie 1.1 devices, as per:
> > 
> > commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
> > Author: Bjorn Helgaas <bhelgaas@google.com>
> > Date:   Mon Apr 1 15:47:39 2013 -0600
> > 
> >     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
> > 
> > As discussed previously in the thread the disable logic for aspm needs to be
> > untangled and refactored, which is not something I'm sufficently versed in teh
> > hotplug code to do right now, but this fixes the problem above, and prevents the
> > problem that necessitated the revert without adding any visible complexity to
> > the user, so I think its ok.
> > 
> > v3) Fixup stupid authorship error
> > ---
> >  drivers/acpi/pci_root.c | 54 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 32 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > index 5917839..1e80a90 100644
> > --- a/drivers/acpi/pci_root.c
> > +++ b/drivers/acpi/pci_root.c
> > @@ -378,6 +378,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
> >  	struct acpi_pci_root *root;
> >  	u32 flags, base_flags;
> >  	acpi_handle handle = device->handle;
> > +	bool no_aspm = false;
> >  
> >  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
> >  	if (!root)
> > @@ -437,27 +438,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
> >  	flags = base_flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
> >  	acpi_pci_osc_support(root, flags);
> >  
> > -	/*
> > -	 * TBD: Need PCI interface for enumeration/configuration of roots.
> > -	 */
> > -
> > -	/*
> > -	 * Scan the Root Bridge
> > -	 * --------------------
> > -	 * Must do this prior to any attempt to bind the root device, as the
> > -	 * PCI namespace does not get created until this call is made (and
> > -	 * thus the root bridge's pci_dev does not exist).
> > -	 */
> > -	root->bus = pci_acpi_scan_root(root);
> > -	if (!root->bus) {
> > -		dev_err(&device->dev,
> > -			"Bus %04x:%02x not present in PCI namespace\n",
> > -			root->segment, (unsigned int)root->secondary.start);
> > -		result = -ENODEV;
> > -		goto end;
> > -	}
> > -
> > -	/* Indicate support for various _OSC capabilities. */
> >  	if (pci_ext_cfg_avail())
> >  		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
> >  	if (pcie_aspm_support_enabled()) {
> > @@ -512,7 +492,14 @@ static int acpi_pci_root_add(struct acpi_device *device,
> >  				acpi_format_exception(status), flags);
> >  			dev_info(&device->dev,
> >  				 "ACPI _OSC control for PCIe not granted, disabling ASPM\n");
> > -			pcie_no_aspm();
> > +			/*
> > +			 * We want to disable aspm here, but aspm_disabled
> > +			 * needs to remain in its state from boot so that we
> > +			 * properly handle pcie 1.1 devices.  So we set this
> > +			 * flag here, to defer the action until after the acpi
> > +			 * root scan
> > +			 */
> > +			no_aspm = true;
> >  		}
> >  	} else {
> >  		dev_info(&device->dev,
> > @@ -520,6 +507,29 @@ static int acpi_pci_root_add(struct acpi_device *device,
> >  			 "(_OSC support mask: 0x%02x)\n", flags);
> >  	}
> >  
> > +	/*
> > +	 * TBD: Need PCI interface for enumeration/configuration of roots.
> > +	 */
> > +
> > +	/*
> > +	 * Scan the Root Bridge
> > +	 * --------------------
> > +	 * Must do this prior to any attempt to bind the root device, as the
> > +	 * PCI namespace does not get created until this call is made (and
> > +	 * thus the root bridge's pci_dev does not exist).
> > +	 */
> > +	root->bus = pci_acpi_scan_root(root);
> > +	if (!root->bus) {
> > +		dev_err(&device->dev,
> > +			"Bus %04x:%02x not present in PCI namespace\n",
> > +			root->segment, (unsigned int)root->secondary.start);
> > +		result = -ENODEV;
> > +		goto end;
> > +	}
> > +
> > +	if (no_aspm)
> > +		pcie_no_aspm();
> > +
> >  	pci_acpi_add_bus_pm_notifier(device, root->bus);
> >  	if (device->wakeup.flags.run_wake)
> >  		device_set_run_wake(root->bus->bridge, true);
> 
> I think there are two problems with this patch:
> 
>   1) There's another call of pcie_no_aspm() at line 454 (in the
>   error path when acpi_pci_osc_support() fails), which happens
>   before scanning the bus.  I think this needs to be converted to
>   "no_aspm = true" as you did for the one in the error path when
>   acpi_pci_osc_control_set() fails.
> 
I was wondering about that.  I left it alone because this patch didn't introduce
that condition (callingpcie_no_aspm at line 454).  I thought perhaps there was
something there I didn't completely understand, but yes, I agree, it seems like
it should use the no_aspm just like the call I converted.

>   2) You effectively moved the call of "pcie_clear_aspm(root->bus)"
>   so it now happens before scanning the bus, which will cause a
>   NULL pointer dereference if we take that path.
> 
Yes, you're correct, and I missed that, we need to defer that call just like we
do with pcie_no_aspm.


> I think we need something like the patch below on top of your
> v3 patch.  Can you take a look and see if this makes sense, and
> if so, update your patch to include these or similar fixes?
> 
I agree, I'll send a v4 tomorrow, with these changes incorporated, and an
updated changelog reflecting the exact problem we're solving here.

Thanks!
Neil

> Here are my notes about where the ASPM and root->osc_control_set 
> setting and testing happen.
> 
> Before your patch:
> 
>     acpi_pci_root_add
>       root = kzalloc			# root->osc_control_set = 0
>       acpi_pci_osc_support		# indicate OS support for segments
>       root->bus = pci_acpi_scan_root	# SCAN BUS
> 	pci_create_root_bus
> 	  pcibios_add_bus
> 	    acpi_pci_add_bus
> 	      acpiphp_enumerate_slots
> 		acpi_walk_namespace(..., register_slot, ...)
> 		  register_slot
> 		    device_is_managed_by_native_pciehp
> 		      <test root->osc_control_set>	# root->osc_control_set == 0
> 		    return if OS has PCIe hotplug control (we never do)
> 		    acpiphp_register_hotplug_slot (so we always do this)
>       acpi_pci_osc_support		# indicate OS support for MSI, ASPM, etc
>       if (_osc_support() failed)
> 	pci_no_aspm
>       acpi_pci_osc_control_set		# request OS control of hotplug, PME, AER, etc
> 	root->osc_control_set = XX
>       if (_osc_control_set() succeeded) {
> 	if (FADT NO_ASPM bit)
> 	  pcie_clear_aspm
> 	    list_for_each_entry(..., &bus->devices, ...)
>       } else
> 	pcie_no_aspm			# _osc_control_set() failed
> 
> After your patch:
> 
>     acpi_pci_root_add
>       root = kzalloc			# root->osc_control_set = 0
>       acpi_pci_osc_support		# indicate OS support for segments
>       if (_osc_support() failed)
> 	pci_no_aspm			# ** (1) before bus scan
>       acpi_pci_osc_support		# indicate OS support for MSI, ASPM, etc
>       acpi_pci_osc_control_set		# request OS control of hotplug, PME, AER, etc
> 	root->osc_control_set = XX
>       if (_osc_control_set() succeeded) {
> 	if (FADT NO_ASPM bit)
> 	  pcie_clear_aspm(root->bus)	# ** (2) root->bus == NULL
> 	    list_for_each_entry(..., &bus->devices, ...)
>       } else
> 	no_aspm = true			# _osc_control_set() failed
>       root->bus = pci_acpi_scan_root	# SCAN BUS
> 	pci_create_root_bus
> 	  pcibios_add_bus
> 	    acpi_pci_add_bus
> 	      acpiphp_enumerate_slots
> 		acpi_walk_namespace(..., register_slot, ...)
> 		  register_slot
> 		    device_is_managed_by_native_pciehp
> 		      <test root->osc_control_set>
> 		    return if OS has PCIe hotplug control
> 		    acpiphp_register_hotplug_slot
>       if (no_aspm)
> 	pcie_no_aspm
> 
> 
> Bjorn
> 
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index a37a372..a67853e 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -378,7 +378,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	struct acpi_pci_root *root;
>  	u32 flags, base_flags;
>  	acpi_handle handle = device->handle;
> -	bool no_aspm = false;
> +	bool no_aspm = false, clear_aspm = false;
>  
>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>  	if (!root)
> @@ -451,7 +451,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  		if (ACPI_FAILURE(status)) {
>  			dev_info(&device->dev, "ACPI _OSC support "
>  				"notification failed, disabling PCIe ASPM\n");
> -			pcie_no_aspm();
> +			no_aspm = true;
>  			flags = base_flags;
>  		}
>  	}
> @@ -483,7 +483,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  				 * We have ASPM control, but the FADT indicates
>  				 * that it's unsupported. Clear it.
>  				 */
> -				pcie_clear_aspm(root->bus);
> +				clear_aspm = true;
>  			}
>  		} else {
>  			dev_info(&device->dev,
> @@ -527,6 +527,10 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  		goto end;
>  	}
>  
> +	if (clear_aspm) {
> +		dev_info(&device->dev, "Disabling ASPM (FADT indicates it is unsupported)\n");
> +		pcie_clear_aspm(root->bus);
> +	}
>  	if (no_aspm)
>  		pcie_no_aspm();
>  
> 
