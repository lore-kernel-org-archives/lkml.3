Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLQXZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:25:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33862 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaLQXZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:25:09 -0500
Message-ID: <549210BB.9080603@ti.com>
Date: Wed, 17 Dec 2014 18:24:43 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>,
        <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] common: dma-mapping: introduce dma_get_parent_cfg()
 helper
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com> <1418839344-14393-2-git-send-email-m-karicheri2@ti.com> <1949667.gMcOLHe7Sk@wuerfel>
In-Reply-To: <1949667.gMcOLHe7Sk@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 04:56 PM, Arnd Bergmann wrote:
> On Wednesday 17 December 2014 13:02:23 Murali Karicheri wrote:
>> Now, in Kernel, parent device's DMA parameters has to be applied to
>> the child as is - to enable DMA support for the device. Usually this
>> is happened in places where parent device manually instantiates child
>> device such as in drivers/pci/probe.c (pci_device_add() for example).
>>
>> Now DMA configuration is represented in device data structure not only
>> by DMA mask and DMA params, it also includes dma_pfn_offset at least.
>> Hence introduce common dma_get_parent_cfg() helper to apply dma
>> configuration from parent to child, and use __weak to allow arch to
>> override it if needed.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>> ---
>>   drivers/base/dma-mapping.c  |   18 ++++++++++++++++++
>>   include/linux/dma-mapping.h |    3 +++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
>> index 9e8bbdd..5322426 100644
>> --- a/drivers/base/dma-mapping.c
>> +++ b/drivers/base/dma-mapping.c
>> @@ -339,3 +339,21 @@ void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
>>   	vunmap(cpu_addr);
>>   }
>>   #endif
>> +
>> +int __weak dma_get_parent_cfg(struct device *dev, struct device *parent)
>> +{
>> +	struct device *temp = parent;
>> +
>> +	if (!temp)
>> +		temp = dev->parent;
>> +
>> +	if (temp&&  is_device_dma_capable(temp)) {
>> +		dev->dma_mask	= temp->dma_mask;
>> +		dev->coherent_dma_mask = temp->coherent_dma_mask;
>
> As discussed, setting the pointers like this is always wrong,
> so don't do it.
>
> What's wrong with using arch_setup_dma_ops() from PCI as suggested
> previously?
>
> 	Arnd

Arnd,

Thanks for the review.

I had originally written a code based on that line as below. But 
dma-ranges property is also used by ppc and other architectures in the 
pci device DT node. So I wasn't sure how this code impact PCI driver 
functionality on those platforms. Hence used a simpler change as all 
that is needed for keystone is to get the dma_pfn_offset rightly set in 
the pci slave device.

Initially I had a function implemented as below for this in of_pci.c.

+ * of_pci_dma_configure - Setup DMA configuration for a pci device
+ * @dev:       pci device to apply DMA configuration
+ *
+ * Try to get devices's DMA configuration from DT and update it
+ * accordingly. This is a similar to of_dma_configure() for platform
+ * devices.
+ *
+ */
+void of_pci_dma_configure(struct pci_dev *dev)
+{
+       struct device *host_bridge, *parent;
+       struct pci_bus *bus = dev->bus;
+       u64 dma_addr, paddr, size;
+       int ret;
+
+       while (!pci_is_root_bus(bus))
+               bus = bus->parent;
+       host_bridge = bus->bridge;
+
+       parent = host_bridge->parent;
+       if (parent->of_node) {
+               /*
+                * if dma-coherent property exist, call arch hook to setup
+                * dma coherent operations.
+                */
+               if (of_dma_is_coherent(parent->of_node)) {
+                       set_arch_dma_coherent_ops(&dev->dev);
+                       dev_info(&dev->dev, "device is dma coherent\n");
+               }
+
+               /*
+                * if dma-ranges property doesn't exist - just return else
+                * setup the dma offset
+                */
+               ret = of_dma_get_range(parent->of_node, &dma_addr, 
&paddr, &size);
+               if (ret < 0) {
+                       dev_info(&dev->dev, "no dma range information to 
setup\n");
+                       printk("no dma range information to setup\n");
+                       return;
+               }
+
+               /* DMA ranges found. Calculate and set dma_pfn_offset */
+               dev->dev.dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
+               dev_info(&dev->dev, "dma_pfn_offset(%#08lx)\n", 
dev->dev.dma_pfn_offset);
+       }
+}
+EXPORT_SYMBOL_GPL(of_pci_dma_configure);


and then called from pci/probe.c as

@@ -1527,6 +1528,9 @@ void pci_device_add(struct pci_dev *dev, struct 
pci_bus *bus)
         dev->dev.dma_parms = &dev->dma_parms;
         dev->dev.coherent_dma_mask = 0xffffffffull;

+       /* Get the DMA configuration from root bridge's parent if present */
+       of_pci_dma_configure(dev);

If you think this is a better way to implement this, I can work on a 
patch set using this approach. Let me know.

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
