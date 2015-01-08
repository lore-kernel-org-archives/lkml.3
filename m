Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbbAHPvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:51:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53976 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754888AbbAHPvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:51:07 -0500
Date: Thu, 8 Jan 2015 10:51:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC][PATCH] PCI / PM: Avoid resuming PCI devices during system
 suspend
In-Reply-To: <1460212.bInrzeZle0@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1501081041230.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Commit f25c0ae2b4c4 (ACPI / PM: Avoid resuming devices in ACPI PM
> domain during system suspend) modified the ACPI PM domain's system
> suspend callbacks to allow devices attached to it to be left in the
> runtime-suspended state during system suspend so as to optimize
> the suspend process.
> 
> This was based on the general mechanism introduced by commit
> aae4518b3124 (PM / sleep: Mechanism to avoid resuming runtime-suspended
> devices unnecessarily).
> 
> Extend that approach to PCI devices by modifying the PCI bus type's
> ->prepare callback to return 1 for devices that are runtime-suspended
> when it is being executed and that are in a suitable power state and
> need not be resumed going forward.

Does this correctly handle PCI devices that aren't included in the ACPI
tables?  For example, add-on PCI cards?

> +/**
> + * pci_dev_keep_suspended - Check if the device can stay in the suspended state.
> + * @dev: Device to check.
> + *
> + * Return 'true' if the device is runtime-suspended, it doesn't have to be
> + * reconfigured for system wakeup and the current power state of it is
> + * suitable for the upcoming (system) transition.
> + */
> +bool pci_dev_keep_suspended(struct pci_dev *dev)
> +{
> +	if (!pm_runtime_suspended(&dev->dev) || platform_pci_need_resume(dev))
> +		return false;
> +
> +	return pci_target_state(dev) == dev->current_state;
> +}

So if platform_pci_need_resume() returns "false", you will try to keep 
the device suspended.  And platform_pci_need_resume() simply invokes 
the .need_resume method of the pci_platform_pm structure.

> +static bool acpi_pci_need_resume(struct pci_dev *dev)
> +{
> +	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
> +
> +	if (!adev || !acpi_device_power_manageable(adev))
> +		return false;

And this says if the device doesn't appear in ACPI then it doesn't need 
to be resumed.

But what if it uses PME and it currently has the wrong wakeup setting?  
Shouldn't this routine start out with

	if (!adev)
		return true;

?  Or should there maybe be an explicit test for devices using PME?

Alan Stern

