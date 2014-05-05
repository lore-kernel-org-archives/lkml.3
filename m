Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaEEIW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:22:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:54639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbaEEIWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="534733092"
Message-ID: <53674A58.3050702@linux.intel.com>
Date: Mon, 05 May 2014 16:22:48 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch Part3 V1 17/22] pci, ACPI, iommu: enhance pci_root to
 support DMAR device hotplug
References: <1398150453-28141-1-git-send-email-jiang.liu@linux.intel.com> <1398150453-28141-18-git-send-email-jiang.liu@linux.intel.com> <20140424173348.GC29593@google.com>
In-Reply-To: <20140424173348.GC29593@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/25 1:33, Bjorn Helgaas wrote:
> On Tue, Apr 22, 2014 at 03:07:28PM +0800, Jiang Liu wrote:
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
>>  
>>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>>  	if (!root)
>> @@ -557,6 +559,11 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>  	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>  	device->driver_data = root;
>>  
>> +	if (hotadd && dmar_device_hotplug(handle, true)) {
> 
> Apparently "dmar_device_hotplug(handle, true)" means "add a DMAR device,"
> and "dmar_device_hotplug(device->handle, false)" means "remove a DMAR
> device."  I'm not really a fan of interfaces where one of the arguments
> selects between two completely different actions, because it's harder for a
> casual reader to see what's going on.
> 
> I see how it simplifies your implementation a little bit, but I think it's
> more important to simplify for the reader.
Thanks Bjorn, I will rename it to dmar_device_add/remove() instead.

> 
> Bjorn
> 
