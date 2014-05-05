Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaEEIby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:31:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:8060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbaEEIbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="534736071"
Message-ID: <53674C6E.1070909@linux.intel.com>
Date: Mon, 05 May 2014 16:31:42 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch Part3 V1 17/22] pci, ACPI, iommu: enhance pci_root to
 support DMAR device hotplug
References: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com> <1398150453-28141-18-git-send-email-jiang.liu@linux.intel.com> <2370777.I1hYvaFUEg@vostro.rjw.lan>
In-Reply-To: <2370777.I1hYvaFUEg@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/22 17:49, Rafael J. Wysocki wrote:
> On Tuesday, April 22, 2014 03:07:28 PM Jiang Liu wrote:
>> Finally enhance pci_root driver to support DMAR device hotplug when
>> hot-plugging PCI host bridges.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/pci_root.c |   16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index d388f13d48b4..aa8f549869f3 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/pci.h>
>>  #include <linux/pci-acpi.h>
>>  #include <linux/pci-aspm.h>
>> +#include <linux/dmar.h>
>>  #include <linux/acpi.h>
>>  #include <linux/slab.h>
>>  #include <acpi/apei.h>	/* for acpi_hest_init() */
>> @@ -511,6 +512,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  	struct acpi_pci_root *root;
>>  	acpi_handle handle = device->handle;
>>  	int no_aspm = 0, clear_aspm = 0;
>> +	bool hotadd = (system_state != SYSTEM_BOOTING);
> 
> The parens are not necessary in the above instruction.
Hi Rafael,
	Thanks! Will fix it in next version.

> 
>>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>>  	if (!root)
>> @@ -557,6 +559,11 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>  	device->driver_data = root;
>>  
>> +	if (hotadd && dmar_device_hotplug(handle, true)) {
>> +		result = -ENXIO;
>> +		goto end;
>> +	}
>> +
>>  	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>>  	       acpi_device_name(device), acpi_device_bid(device),
>>  	       root->segment, &root->secondary);
>> @@ -583,7 +590,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  			root->segment, (unsigned int)root->secondary.start);
>>  		device->driver_data = NULL;
>>  		result = -ENODEV;
>> -		goto end;
>> +		goto remove_dmar;
>>  	}
>>  
>>  	if (clear_aspm) {
>> @@ -597,7 +604,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  	if (device->wakeup.flags.run_wake)
>>  		device_set_run_wake(root->bus->bridge, true);
>>  
>> -	if (system_state != SYSTEM_BOOTING) {
>> +	if (hotadd) {
>>  		pcibios_resource_survey_bus(root->bus);
>>  		pci_assign_unassigned_root_bus_resources(root->bus);
>>  	}
>> @@ -607,6 +614,9 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  	pci_unlock_rescan_remove();
>>  	return 1;
>>  
>> +remove_dmar:
>> +	if (hotadd)
>> +		dmar_device_hotplug(handle, false);
> 
> I suppose that works if dmar_device_hotplug() returned false before?
Yes, it's for error recover only.

> 
>>  end:
>>  	kfree(root);
>>  	return result;
>> @@ -625,6 +635,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
>>  
>>  	pci_remove_root_bus(root->bus);
>>  
>> +	dmar_device_hotplug(device->handle, false);
>> +
>>  	pci_unlock_rescan_remove();
>>  
>>  	kfree(root);
>>
> 
