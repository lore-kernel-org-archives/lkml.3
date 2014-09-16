Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIPHx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:53:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:33598 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaIPHx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:53:57 -0400
Message-ID: <5417EC7B.4060400@huawei.com>
Date: Tue, 16 Sep 2014 15:53:31 +0800
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
Subject: Re: [Patch Part3 V5 5/8] iommu/vt-d: Enhance intel_irq_remapping
 driver to support DMAR unit hotplug
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-6-git-send-email-jiang.liu@linux.intel.com> <54164D01.4060003@huawei.com> <5417E00D.5000108@linux.intel.com>
In-Reply-To: <5417E00D.5000108@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/16 15:00, Jiang Liu wrote:
> On 2014/9/15 10:20, Yijing Wang wrote:
>>> +static void ir_remove_ioapic_hpet_scope(struct intel_iommu *iommu)
>>> +{
>>> +	int i;
>>>  
>>> -			ir_parse_one_hpet_scope(scope, iommu);
>>> -		}
>>> -		start += scope->length;
>>> -	}
>>> +	for (i = 0; i < MAX_HPET_TBS; i++)
>>> +		if (ir_hpet[i].iommu == iommu)
>>> +			ir_hpet[i].iommu = NULL;
>>
>> Hi Gerry, why not reset whole ir_hpe and ir_ioapic data struct?
> Hi Yijing,
> 	Thanks for review. Zero is legal for id, bus and devfn in
> struct ioapic_scope and struct hpet_scope. So we use domain field
> as a flag to mark entry valid or invalid and only reset iommu field.

Hi Gerry, use iommu field as a flag to mark entry valid may be not safe enough,
I found map_hpet_to_ir() and map_ioapic_to_ir() still only check the id field to return the valid iommu.

What about this case:
E.g. ir_hpet[2].id = N, ir_hpet[2].iommu = NULL, ir_hpet[4].id = N, ir_hpet[4].iommu = iommu;

ir_hpet[2] maybe released yet, and the hpet now has been saved in ir_hpet[4], but map_hpet_to_irq()
will return the wrong iommu(NULL).


static struct intel_iommu *map_hpet_to_ir(u8 hpet_id)
{
	int i;

	for (i = 0; i < MAX_HPET_TBS; i++)
		if (ir_hpet[i].id == hpet_id)
			return ir_hpet[i].iommu;
	return NULL;
}

> 
> Regards!
> Gerry
>>
>>
>>
>>>  
>>> -	return 0;
>>> +	for (i = 0; i < MAX_IO_APICS; i++)
>>> +		if (ir_ioapic[i].iommu == iommu)
>>> +			ir_ioapic[i].iommu = NULL;
>>>  }
>>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> .
> 


-- 
Thanks!
Yijing

