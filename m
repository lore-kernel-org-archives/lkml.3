Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423413Ab3FUQyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:54:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60204 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161494Ab3FUQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:54:50 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 21 Jun 2013 09:54:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH v2] powerpc/pci: Improve device hotplug initialization
Message-ID: <20130621165453.GA5506@roeck-us.net>
References: <1370884688-7753-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370884688-7753-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:18:08AM -0700, Guenter Roeck wrote:
> Commit 37f02195b (powerpc/pci: fix PCI-e devices rescan issue on powerpc
> platform) fixes a problem with interrupt and DMA initialization on hot
> plugged devices. With this commit, interrupt and DMA initialization for
> hot plugged devices is handled in the pci device enable function.
> 
> This approach has a couple of drawbacks. First, it creates two code paths
> for device initialization, one for hot plugged devices and another for devices
> known during the initial PCI scan. Second, the initialization code for hot
> plugged devices is only called when the device is enabled, ie typically
> in the probe function. Also, the platform specific setup code is called each
> time pci_enable_device() is called, not only once during device discovery,
> meaning it is actually called multiple times, once for devices discovered
> during the initial scan and again each time a driver is re-loaded.
> 
> The visible result is that interrupt pins are only assigned to hot plugged
> devices when the device driver is loaded. Effectively this changes the PCI
> probe API, since pci_dev->irq and the device's dma configuration will now
> only be valid after pci_enable() was called at least once. A more subtle
> change is that platform specific PCI device setup is moved from device
> discovery into the driver's probe function, more specifically into the
> pci_enable_device() call.
> 
> To fix the inconsistencies, add new function pcibios_add_device.
> Call pcibios_setup_device from pcibios_setup_bus_devices if device setup
> is not complete, and from pcibios_add_device if bus setup is complete.
> 
> With this change, device setup code is moved back into device initialization,
> and called exactly once for both static and hot plugged devices.
> 
> Cc: Yuanquan Chen <Yuanquan.Chen@freescale.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Ensure that PCI bus fixup code has been executed before calling
>     device setup code.
> 
Hi Ben,

any comments/feedback on this approach ?

It is much less invasive than before and should address your concerns.

Thanks,
Guenter

>  arch/powerpc/kernel/pci-common.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 7f2273c..6909b13 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -992,7 +992,7 @@ void pcibios_setup_bus_self(struct pci_bus *bus)
>  		ppc_md.pci_dma_bus_setup(bus);
>  }
>  
> -void pcibios_setup_device(struct pci_dev *dev)
> +static void pcibios_setup_device(struct pci_dev *dev)
>  {
>  	/* Fixup NUMA node as it may not be setup yet by the generic
>  	 * code and is needed by the DMA init
> @@ -1013,6 +1013,17 @@ void pcibios_setup_device(struct pci_dev *dev)
>  		ppc_md.pci_irq_fixup(dev);
>  }
>  
> +int pcibios_add_device(struct pci_dev *dev)
> +{
> +	/*
> +	 * We can only call pcibios_setup_device() after bus setup is complete,
> +	 * since some of the platform specific DMA setup code depends on it.
> +	 */
> +	if (dev->bus->is_added)
> +		pcibios_setup_device(dev);
> +	return 0;
> +}
> +
>  void pcibios_setup_bus_devices(struct pci_bus *bus)
>  {
>  	struct pci_dev *dev;
> @@ -1467,10 +1478,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
>  		if (ppc_md.pcibios_enable_device_hook(dev))
>  			return -EINVAL;
>  
> -	/* avoid pcie irq fix up impact on cardbus */
> -	if (dev->hdr_type != PCI_HEADER_TYPE_CARDBUS)
> -		pcibios_setup_device(dev);
> -
>  	return pci_enable_resources(dev, mask);
>  }
>  
> -- 
> 1.7.9.7
> 
> 
