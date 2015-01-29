Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbbA2PBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:01:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40979 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbbA2PAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:00:35 -0500
Message-ID: <54CA4AD5.2060307@ti.com>
Date: Thu, 29 Jan 2015 09:59:33 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Rob Herring <robh+dt@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/6] of: iommu: add ptr to OF node arg to of_iommu_configure()
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <13812499.ICbNgSDOae@avalon> <20150128133219.GM1569@arm.com> <5349994.6VHXzPdIxs@avalon>
In-Reply-To: <5349994.6VHXzPdIxs@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 06:32 PM, Laurent Pinchart wrote:
> Hi Will,
>
> On Wednesday 28 January 2015 13:32:19 Will Deacon wrote:
>> On Wed, Jan 28, 2015 at 01:15:10PM +0000, Laurent Pinchart wrote:
>>> On Wednesday 28 January 2015 12:29:42 Will Deacon wrote:
>>>> On Wed, Jan 28, 2015 at 12:23:03PM +0000, Laurent Pinchart wrote:
>>>>> On Wednesday 28 January 2015 11:33:00 Will Deacon wrote:
>>>>>> On Mon, Jan 26, 2015 at 06:49:01PM +0000, Murali Karicheri wrote:
>>>>>>> On 01/25/2015 08:32 AM, Laurent Pinchart wrote:
>>>>>>>> On Friday 23 January 2015 17:32:34 Murali Karicheri wrote:
>>>>>>>>> Function of_iommu_configure() is called from of_dma_configure() to
>>>>>>>>> setup iommu ops using DT property. This API is currently used for
>>>>>>>>> platform devices for which DMA configuration (including iommu ops)
>>>>>>>>> may come from device's parent. To extend this functionality for
>>>>>>>>> PCI devices, this API need to take a parent node ptr as an argument
>>>>>>>>> instead of assuming device's parent. This is needed since for PCI,
>>>>>>>>> the dma configuration may be defined in the DT node of the root
>>>>>>>>> bus bridge's parent device. Currently only dma-range is used for PCI
>>>>>>>>> and iommu is not supported. So return error if the device is PCI.
>>>>>>>>>
>>>>>>>>> Cc: Joerg Roedel<joro@8bytes.org>
>>>>>>>>> Cc: Grant Likely<grant.likely@linaro.org>
>>>>>>>>> Cc: Rob Herring<robh+dt@kernel.org>
>>>>>>>>> Cc: Bjorn Helgaas<bhelgaas@google.com>
>>>>>>>>> Cc: Will Deacon<will.deacon@arm.com>
>>>>>>>>> Cc: Russell King<linux@arm.linux.org.uk>
>>>>>>>>> Cc: Arnd Bergmann<arnd@arndb.de>
>>>>>>>>> Cc: Suravee Suthikulpanit<Suravee.Suthikulpanit@amd.com>
>>>>>>>>>
>>>>>>>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>>    drivers/iommu/of_iommu.c |   10 ++++++++--
>>>>>>>>>    drivers/of/platform.c    |    2 +-
>>>>>>>>>    include/linux/of_iommu.h |    6 ++++--
>>>>>>>>>    3 files changed, 13 insertions(+), 5 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
>>>>>>>>> index af1dc6a..439235b 100644
>>>>>>>>> --- a/drivers/iommu/of_iommu.c
>>>>>>>>> +++ b/drivers/iommu/of_iommu.c
>>>>>>>>> @@ -133,19 +133,25 @@ struct iommu_ops *of_iommu_get_ops(struct
>>>>>>>>> device_node *np)
>>>>>>>>>    	return ops;
>>>>>>>>>   }
>>>>>>>>>
>>>>>>>>> -struct iommu_ops *of_iommu_configure(struct device *dev)
>>>>>>>>> +struct iommu_ops *of_iommu_configure(struct device *dev,
>>>>>>>>> +				     struct device_node *iommu_np)
>>>>>>>>>   {
>>>>>>>>>    	struct of_phandle_args iommu_spec;
>>>>>>>>>    	struct device_node *np;
>>>>>>>>>    	struct iommu_ops *ops = NULL;
>>>>>>>>>    	int idx = 0;
>>>>>>>>>
>>>>>>>>> +	if (dev_is_pci(dev)) {
>>>>>>>>> +		dev_err(dev, "iommu is currently not supported for PCI\n");
>>>>>>>>> +		return NULL;
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>>    	/*
>>>>>>>>>    	 * We don't currently walk up the tree looking for a parent
>>>>>>>>>    	 IOMMU.
>>>>>>>>>    	 * See the `Notes:' section of
>>>>>>>>>    	 * Documentation/devicetree/bindings/iommu/iommu.txt
>>>>>>>>>    	 */
>>>>>>>>
>>>>>>>> Wouldn't it be better to fix this rather than passing the device
>>>>>>>> node pointer to the function ? The solution would be more generic.
>>>>>>>
>>>>>>> Will Deacon (Copied here) is working on this as we alteady discussed
>>>>>>> in this thread. So it will be addressed by him in another series.
>>>>>>
>>>>>> Well, "working on this" equates to "has it somewhere near the bottom
>>>>>> of a very long list" :)
>>>>>
>>>>> What's your opinion on this patch then, do you think adding the
>>>>> iommu_np argument makes sense as a temporary hack, or should we instead
>>>>> walk up the tree looking for an iommus attribute in parent nodes ? I
>>>>> don't expect that to be insanely difficult to code.
>>>>
>>>> If walking up the tree is useful, then I think we should do that and
>>>> update the Documentation to reflect the new behaviour.
>>>
>>> If I understand Murali's patch set right (please correct me if that's not
>>> the case) the PCI code walks up the DT nodes hierarchy to the parent node
>>> that contains the iommus attribute and passes a pointer to that node to
>>> this function. It's thus a PCI-specific solution. As a temporary hack
>>> that's OK I suppose, but if implementing it right straight away isn't
>>> difficult that would be better.
>>
>> It looks to me like the code walks the PCI topology to get the DT node for
>> the host controller, and passes *that* to of_dma_configure. That sounds
>> like the right thing to do to me, especially since the PCI topology is
>> likely not encoded in the device-tree. So actually, it is passing the
>> first parent node afaict.
>
> Indeed, that's right. I forgot for a moment that we have non-DT devices ;-)
>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>
> Murali, nitpicking a bit, shouldn't the iommu_np parameter be renamed ? It
> points to the node containing the iommus parameter, not to the iommu node, so
> the current name is slightly confusing. A brief kerneldoc above the function
> would also help. This can be the subject of a separate patch.
Probably the doc part can be added by Will. The iommu_np was a 
suggestion from Rob, if I recollect. Isn't the iommu_np points to the 
iommu device, and if so, iommu_np make sense.

Murali
>
>> The part I'm more interested in is the mapping of RequesterID (PCI dma
>> alias) to IOMMU ID when we transition from the PCI topology to the DT
>> topology. Currently, it seems to be 1:1 on the platforms I have, but I
>> doubt this will always be the case.
>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
