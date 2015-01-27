Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbbA0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:20:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42350 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbA0PU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:20:26 -0500
Message-ID: <54C7AC9B.1040308@ti.com>
Date: Tue, 27 Jan 2015 10:19:55 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Robin Murphy <robin.murphy@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v4 6/6] arm: dma-mapping: updates to limit dma_mask and
 iommu mapping size
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <1422052359-12384-7-git-send-email-m-karicheri2@ti.com> <54C772A0.2000203@arm.com> <20150127113416.GB3226@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150127113416.GB3226@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 06:34 AM, Catalin Marinas wrote:
> On Tue, Jan 27, 2015 at 11:12:32AM +0000, Robin Murphy wrote:
>> On 23/01/15 22:32, Murali Karicheri wrote:
>>> Limit the dma_mask to minimum of dma_mask and dma_base + size - 1.
>>>
>>> Also arm_iommu_create_mapping() has size parameter of size_t and
>>> arm_setup_iommu_dma_ops() can take a value higher than that. So
>>> limit the size to SIZE_MAX.
>>>
>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>> ---
>>>    arch/arm/mm/dma-mapping.c |   10 ++++++++++
>>>    1 file changed, 10 insertions(+)
>>>
>>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>>> index 7864797..a1f9030 100644
>>> --- a/arch/arm/mm/dma-mapping.c
>>> +++ b/arch/arm/mm/dma-mapping.c
>>> @@ -2004,6 +2004,13 @@ static bool arm_setup_iommu_dma_ops(struct device *dev, u64 dma_base, u64 size,
>>>    	if (!iommu)
>>>    		return false;
>>>
>>> +	/*
>>> +	 * currently arm_iommu_create_mapping() takes a max of size_t
>>> +	 * for size param. So check this limit for now.
>>> +	 */
>>> +	if (size>  SIZE_MAX)
>>> +		return false;
>>> +
>>>    	mapping = arm_iommu_create_mapping(dev->bus, dma_base, size);
>>>    	if (IS_ERR(mapping)) {
>>>    		pr_warn("Failed to create %llu-byte IOMMU mapping for device %s\n",
>>> @@ -2053,6 +2060,9 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>>>    {
>>>    	struct dma_map_ops *dma_ops;
>>>
>>> +	/* limit dma_mask to the lower of the two values */
>>> +	*dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));
>>> +
>>
>> Is there any reason not to do this in of_dma_configure? It seems like
>> something everyone could benefit from - I'd cooked up a dodgy workaround
>> for the same issue in my arm64 IOMMU code, but handling it generically
>> in common code would be much nicer.

Ok Will move this to of_dma_configure().

Murali

>
> I agree. I started something here:
>
> http://article.gmane.org/gmane.linux.kernel/1835096
>
> but I don't remember to have got to a clear conclusion.
>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
