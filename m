Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbbAZStz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:49:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55652 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbbAZStx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:49:53 -0500
Message-ID: <54C68C1D.5030605@ti.com>
Date: Mon, 26 Jan 2015 13:49:01 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/6] of: iommu: add ptr to OF node arg to of_iommu_configure()
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <1422052359-12384-2-git-send-email-m-karicheri2@ti.com> <4711364.TTK5TCBdiy@avalon>
In-Reply-To: <4711364.TTK5TCBdiy@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2015 08:32 AM, Laurent Pinchart wrote:
> Hi Murali,
>
> Thank you for the patch.
>
> On Friday 23 January 2015 17:32:34 Murali Karicheri wrote:
>> Function of_iommu_configure() is called from of_dma_configure() to
>> setup iommu ops using DT property. This API is currently used for
>> platform devices for which DMA configuration (including iommu ops)
>> may come from device's parent. To extend this functionality for PCI
>> devices, this API need to take a parent node ptr as an argument
>> instead of assuming device's parent. This is needed since for PCI, the
>> dma configuration may be defined in the DT node of the root bus bridge's
>> parent device. Currently only dma-range is used for PCI and iommu is not
>> supported. So return error if the device is PCI.
>>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Grant Likely<grant.likely@linaro.org>
>> Cc: Rob Herring<robh+dt@kernel.org>
>> Cc: Bjorn Helgaas<bhelgaas@google.com>
>> Cc: Will Deacon<will.deacon@arm.com>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann<arnd@arndb.de>
>> Cc: Suravee Suthikulpanit<Suravee.Suthikulpanit@amd.com>
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>> ---
>>   drivers/iommu/of_iommu.c |   10 ++++++++--
>>   drivers/of/platform.c    |    2 +-
>>   include/linux/of_iommu.h |    6 ++++--
>>   3 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
>> index af1dc6a..439235b 100644
>> --- a/drivers/iommu/of_iommu.c
>> +++ b/drivers/iommu/of_iommu.c
>> @@ -133,19 +133,25 @@ struct iommu_ops *of_iommu_get_ops(struct device_node
>> *np) return ops;
>>   }
>>
>> -struct iommu_ops *of_iommu_configure(struct device *dev)
>> +struct iommu_ops *of_iommu_configure(struct device *dev,
>> +				     struct device_node *iommu_np)
>>   {
>>   	struct of_phandle_args iommu_spec;
>>   	struct device_node *np;
>>   	struct iommu_ops *ops = NULL;
>>   	int idx = 0;
>>
>> +	if (dev_is_pci(dev)) {
>> +		dev_err(dev, "iommu is currently not supported for PCI\n");
>> +		return NULL;
>> +	}
>> +
>>   	/*
>>   	 * We don't currently walk up the tree looking for a parent IOMMU.
>>   	 * See the `Notes:' section of
>>   	 * Documentation/devicetree/bindings/iommu/iommu.txt
>>   	 */
> Wouldn't it be better to fix this rather than passing the device node pointer
> to the function ? The solution would be more generic.
Laurent,

Will Deacon (Copied here) is working on this as we alteady discussed in 
this thread. So it will be
addressed by him in another series.

Murali
>
>> -	while (!of_parse_phandle_with_args(dev->of_node, "iommus",
>> +	while (!of_parse_phandle_with_args(iommu_np, "iommus",
>>   					   "#iommu-cells", idx,
>>   					&iommu_spec)) {
>>   		np = iommu_spec.np;
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index a54ec10..7675b79 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -196,7 +196,7 @@ static void of_dma_configure(struct device *dev)
>>   	dev_dbg(dev, "device is%sdma coherent\n",
>>   		coherent ? " " : " not ");
>>
>> -	iommu = of_iommu_configure(dev);
>> +	iommu = of_iommu_configure(dev, dev->of_node);
>>   	dev_dbg(dev, "device is%sbehind an iommu\n",
>>   		iommu ? " " : " not ");
>>
>> diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
>> index 16c7554..a97e5bd 100644
>> --- a/include/linux/of_iommu.h
>> +++ b/include/linux/of_iommu.h
>> @@ -12,7 +12,8 @@ extern int of_get_dma_window(struct device_node *dn, const
>> char *prefix, size_t *size);
>>
>>   extern void of_iommu_init(void);
>> -extern struct iommu_ops *of_iommu_configure(struct device *dev);
>> +extern struct iommu_ops *of_iommu_configure(struct device *dev,
>> +					struct device_node *iommu_np);
>>
>>   #else
>>
>> @@ -24,7 +25,8 @@ static inline int of_get_dma_window(struct device_node
>> *dn, const char *prefix, }
>>
>>   static inline void of_iommu_init(void) { }
>> -static inline struct iommu_ops *of_iommu_configure(struct device *dev)
>> +static inline struct iommu_ops *of_iommu_configure(struct device *dev,
>> +					 struct device_node *iommu_np)
>>   {
>>   	return NULL;
>>   }


-- 
Murali Karicheri
Linux Kernel, Texas Instruments

