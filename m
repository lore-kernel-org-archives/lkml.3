Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIOD3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 23:29:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32682 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaIOD3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 23:29:19 -0400
Message-ID: <54165CEB.6090903@huawei.com>
Date: Mon, 15 Sep 2014 11:28:43 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part3 V5 8/8] pci, ACPI, iommu: Enhance pci_root to support
 DMAR device hotplug
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-9-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-9-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54165D08.0069,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 1a2c8973a94d121d6ef75c49ec0efb57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> Finally enhance pci_root driver to support DMAR device hotplug when
> hot-plugging PCI host bridges.

Reviewed-by: Yijing Wang <wangyijing@huawei.com>

> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
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
> 


-- 
Thanks!
Yijing

