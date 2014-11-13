Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbaKMXTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:19:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:34660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbaKMXT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:19:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,380,1413270000"; 
   d="scan'208";a="636667843"
Message-ID: <54653C7A.6060003@linux.intel.com>
Date: Fri, 14 Nov 2014 07:19:22 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: generic: Add set_msi_parent callback
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com> <1415647480-3320-3-git-send-email-suravee.suthikulpanit@amd.com> <20141111112424.GB16265@arm.com> <20141111115227.GF12037@e106497-lin.cambridge.arm.com> <20141113152243.GB9726@red-moon>
In-Reply-To: <20141113152243.GB9726@red-moon>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 23:22, Lorenzo Pieralisi wrote:
> On Tue, Nov 11, 2014 at 11:52:27AM +0000, Liviu Dudau wrote:
>> On Tue, Nov 11, 2014 at 11:24:24AM +0000, Will Deacon wrote:
>>> Hi Suravee,
>>>
>>> On Mon, Nov 10, 2014 at 07:24:40PM +0000, suravee.suthikulpanit@amd.com wrote:
>>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>
>>> I don't think this makes much sense a host controller callback. Why can't
>>> bus->msi be set in generic code?
>>
>> Because of the current way in which a bus gets created and them immediately used for
>> scanning devices if you use pci_scan_root_bus(). Alternative is to use pci_create_root_bus()
>> and increase your code size with the body of pci_scan_root_bus().
>>
>> Solution is to have pci_host_bridge holding the msi_chip pointer and that gets created
>> before root bus, with pci_scan_root_bus() now having all the info needed to do successful
>> setup of scanned devices.
> 
> Why can't we add a hook like pci_bus_assign_domain_nr(), say:
> 
> pci_bus_msi_init()
> 
> in pci_create_root_bus() that does what Suravee wants in a generic way ?
+1
BTW, x86 may have multiple MSI controllers/domains under a host bridge,
so prefer calling it for every bus instead of for root bus only.
Regards!
Gerry
> 
> What am I missing ?
> 
> Lorenzo
> 
>>
>> Best regards,
>> Liviu
>>
>>>
>>>>  static struct pci_ops gen_pci_ops = {
>>>>  	.read	= gen_pci_config_read,
>>>>  	.write	= gen_pci_config_write,
>>>> +	.set_msi_parent = gen_pci_set_msi_parent,
>>>>  };
>>>>  
>>>>  static const struct of_device_id gen_pci_of_match[] = {
>>>> @@ -313,6 +324,9 @@ static int gen_pci_probe(struct platform_device *pdev)
>>>>  		return err;
>>>>  	}
>>>>  
>>>> +	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
>>>> +						  "msi-parent", 0));
>>>
>>> This bit should be in the generic of_pci.c code and not duplicated for
>>> each host controller.
>>>
>>> Will
>>>
>>
>> -- 
>> ====================
>> | I would like to |
>> | fix the world,  |
>> | but they're not |
>> | giving me the   |
>>  \ source code!  /
>>   ---------------
>>     ¯\_(ツ)_/¯
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
