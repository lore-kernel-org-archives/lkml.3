Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaIXShV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:37:21 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45708 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaIXShS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:37:18 -0400
Date: Wed, 24 Sep 2014 12:37:14 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V6 8/8] pci, ACPI, iommu: Enhance pci_root to
 support DMAR device hotplug
Message-ID: <20140924183714.GE20416@google.com>
References: <1411103935-31301-1-git-send-email-jiang.liu@linux.intel.com>
 <1411103935-31301-9-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411103935-31301-9-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 01:18:55PM +0800, Jiang Liu wrote:
> Finally enhance pci_root driver to support DMAR device hotplug when
> hot-plugging PCI host bridges.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Reviewed-by: Yijing Wang <wangyijing@huawei.com>

I assume this will be merged via a non-PCI tree, so:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Looks OK to me, but I expect you'll want Rafael's ack as well.

> ---
>  drivers/acpi/pci_root.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index e6ae603ed1a1..4e177daa18e3 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -33,6 +33,7 @@
>  #include <linux/pci.h>
>  #include <linux/pci-acpi.h>
>  #include <linux/pci-aspm.h>
> +#include <linux/dmar.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
>  #include <acpi/apei.h>	/* for acpi_hest_init() */
> @@ -511,6 +512,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	struct acpi_pci_root *root;
>  	acpi_handle handle = device->handle;
>  	int no_aspm = 0, clear_aspm = 0;
> +	bool hotadd = system_state != SYSTEM_BOOTING;
>  
>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>  	if (!root)
> @@ -557,6 +559,11 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>  	device->driver_data = root;
>  
> +	if (hotadd && dmar_device_add(handle)) {
> +		result = -ENXIO;
> +		goto end;
> +	}
> +
>  	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>  	       acpi_device_name(device), acpi_device_bid(device),
>  	       root->segment, &root->secondary);
> @@ -583,7 +590,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  			root->segment, (unsigned int)root->secondary.start);
>  		device->driver_data = NULL;
>  		result = -ENODEV;
> -		goto end;
> +		goto remove_dmar;
>  	}
>  
>  	if (clear_aspm) {
> @@ -597,7 +604,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	if (device->wakeup.flags.run_wake)
>  		device_set_run_wake(root->bus->bridge, true);
>  
> -	if (system_state != SYSTEM_BOOTING) {
> +	if (hotadd) {
>  		pcibios_resource_survey_bus(root->bus);
>  		pci_assign_unassigned_root_bus_resources(root->bus);
>  	}
> @@ -607,6 +614,9 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	pci_unlock_rescan_remove();
>  	return 1;
>  
> +remove_dmar:
> +	if (hotadd)
> +		dmar_device_remove(handle);
>  end:
>  	kfree(root);
>  	return result;
> @@ -625,6 +635,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
>  
>  	pci_remove_root_bus(root->bus);
>  
> +	dmar_device_remove(device->handle);
> +
>  	pci_unlock_rescan_remove();
>  
>  	kfree(root);
> -- 
> 1.7.10.4
> 
