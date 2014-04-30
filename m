Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbaD3OUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:20:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55713 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820AbaD3OT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:19:58 -0400
Message-ID: <53610663.7070305@ti.com>
Date: Wed, 30 Apr 2014 10:19:15 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>	<1398353407-2345-5-git-send-email-santosh.shilimkar@ti.com> <20140429144147.004EEC40992@trevor.secretlab.ca>
In-Reply-To: <20140429144147.004EEC40992@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tuesday 29 April 2014 10:41 AM, Grant Likely wrote:
> On Thu, 24 Apr 2014 11:30:04 -0400, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> Retrieve DMA configuration from DT and setup platform device's DMA
>> parameters. The DMA configuration in DT has to be specified using
>> "dma-ranges" and "dma-coherent" properties if supported.
>>
>> We setup dma_pfn_offset using "dma-ranges" and dma_coherent_ops
>> using "dma-coherent" device tree properties.
>>
>> The set_arch_dma_coherent_ops macro has to be defined by arch if
>> it supports coherent dma_ops. Otherwise, set_arch_dma_coherent_ops() is
>> declared as nop.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  drivers/of/platform.c       |   48 ++++++++++++++++++++++++++++++++++++++++---
>>  include/linux/dma-mapping.h |    7 +++++++
>>  2 files changed, 52 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index 48de98f..270c0b9 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -187,6 +187,50 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>  EXPORT_SYMBOL(of_device_alloc);
>>  
>>  /**
>> + * of_dma_configure - Setup DMA configuration
>> + * @dev:	Device to apply DMA configuration
>> + *
>> + * Try to get devices's DMA configuration from DT and update it
>> + * accordingly.
>> + *
>> + * In case if platform code need to use own special DMA configuration,it
>> + * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
>> + * to fix up DMA configuration.
>> + */
>> +static void of_dma_configure(struct device *dev)
>> +{
>> +	u64 dma_addr, paddr, size;
>> +	int ret;
>> +
>> +	dev->coherent_dma_mask = DMA_BIT_MASK(32);
>> +	if (!dev->dma_mask)
>> +		dev->dma_mask = &dev->coherent_dma_mask;
>> +
>> +	/*
>> +	 * if dma-coherent property exist, call arch hook to setup
>> +	 * dma coherent operations.
>> +	 */
>> +	if (of_dma_is_coherent(dev->of_node)) {
>> +		set_arch_dma_coherent_ops(dev);
>> +		dev_dbg(dev, "device is dma coherent\n");
>> +	}
>> +
>> +	/*
>> +	 * if dma-ranges property doesn't exist - just return else
>> +	 * setup the dma offset
>> +	 */
>> +	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
>> +	if ((ret == -ENODEV) || (ret < 0)) {
>> +		dev_dbg(dev, "no dma range information to setup\n");
>> +		return;
>> +	}
>> +
>> +	/* DMA ranges found. Calculate and set dma_pfn_offset */
>> +	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
>> +	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> 
> I've got two concerns here. of_dma_get_range() retrieves only the first
> tuple from the dma-ranges property, but it is perfectly valid for
> dma-ranges to contain multiple tuples. How should we handle it if a
> device has multiple ranges it can DMA from?
> 

We've not found any cases in current Linux where more than one dma-ranges
would be used. Moreover, The MM (definitely for ARM) isn't supported such
cases at all (if i understand everything right).
- there are only one arm_dma_pfn_limit
- there is only one MM zone is used for ARM
- some arches like x86,mips can support 2 zones (per arch - not per device or bus)
  DMA & DMA32, but they configured once and forever per arch.

Example:
static void *loongson_dma_alloc_coherent(struct device *dev, size_t size,
		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
{
...

	/* ignore region specifiers */
	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);

#ifdef CONFIG_ISA
	if (dev == NULL)
		gfp |= __GFP_DMA;
	else
#endif
#ifdef CONFIG_ZONE_DMA
	if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
		gfp |= __GFP_DMA;
	else
#endif
#ifdef CONFIG_ZONE_DMA32
	if (dev->coherent_dma_mask < DMA_BIT_MASK(40))
		gfp |= __GFP_DMA32;
	else
#endif
...
}

Any ways, it can be added later if we have an usecase for
that.

> Second, while the pfn offset is being determined, I don't see anything
> making use of either the base address or size. How is the device
> constrained to only getting DMA buffers from within that range? Is the
> driver expected to manage that directly?
> 
Drivers don't have to do anything special apart from setting
the correct mask. The pfn_offset case, we use DMA_ZONE which takes
care of masks already. Size is suppose to be used for dma_mask
setup which we discussed in previous threads.

Regards,
Santosh
