Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaLIKCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:02:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46779 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaLIKCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:02:49 -0500
Message-ID: <5486C8BA.8030608@arm.com>
Date: Tue, 09 Dec 2014 10:02:34 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 2/6] PCI/MSI: add hooks to populate the msi_domain field
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com> <1418069543-21969-3-git-send-email-marc.zyngier@arm.com> <5486585B.40000@huawei.com>
In-Reply-To: <5486585B.40000@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing,

On 09/12/14 02:03, Yijing Wang wrote:
> On 2014/12/9 4:12, Marc Zyngier wrote:
>> In order to be able to populate the device msi_domain field,
>> add the necesary hooks to propagate the PHB msi_domain across
>> secondary busses to devices.
>>
>> So far, nobody populates the initial msi_domain.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/pci/probe.c | 24 ++++++++++++++++++++++++
>>  include/linux/pci.h |  1 +
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index c8ca98c..d1009a2 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -670,6 +670,20 @@ static void pci_set_bus_speed(struct pci_bus *bus)
>>  	}
>>  }
>>  
>> +void __weak pcibios_set_phb_msi_domain(struct pci_bus *bus)
>> +{
>> +}
>> +
>> +static void pci_set_bus_msi_domain(struct pci_bus *bus)
>> +{
>> +	struct pci_dev *bridge = bus->self;
>> +
>> +	if (!bridge)
>> +		pcibios_set_phb_msi_domain(bus);
>> +	else
>> +		dev_set_msi_domain(&bus->dev, dev_get_msi_domain(&bridge->dev));
>> +}
> 
> 
> Hi Marc, we can not assume pci devices under same phb share the same msi irq domain,
> now in x86, pci devices under the same phb may associate different msi irq domain.

Well, this is not supposed to be a perfect solution yet, but instead a
basis for discussion. What I'd like to find out is:

- What is the minimum granularity for associating a device with its MSI
domain in existing platforms?
- What topology data structures do you use to find out what MSI
controller a device should be matched with?
- What in-tree platform already has this requirements?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
