Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbbABRVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:21:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45605 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbABRVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:21:33 -0500
Message-ID: <54A6D375.6050604@ti.com>
Date: Fri, 2 Jan 2015 12:20:53 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of/pci: add of_pci_dma_configure() update dma
 configuration
References: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com> <1419459099-6667-2-git-send-email-m-karicheri2@ti.com> <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com>
In-Reply-To: <CAL_JsqJtVnP_5zAiUvMwL00JQV0mjw-R_hEkxiv13ZuNrQ8nAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

See my response below. Arnd and Will, please review this as well.

On 12/26/2014 02:33 PM, Rob Herring wrote:
> On Wed, Dec 24, 2014 at 4:11 PM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>> Add of_pci_dma_configure() to allow updating the dma configuration
>> of the pci device using the configuration from DT of the parent of
>> the root bridge device.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>> ---
>>   drivers/of/of_pci.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/of_pci.h |   12 ++++++++
>>   2 files changed, 85 insertions(+)
>>
----------------------CUT--------------------------------------------
>> +       unsigned long offset;
>> +       bool coherent;
>> +       int ret;
>> +
>> +       parent_np = of_get_pci_root_bridge_parent(pci_dev);
>> +
>> +       if (parent_np) {
>
> Save a level of indentation and do:
>
> if (!parent_np)
>    return;

Agree. This will not be needed if I go with changes proposed by your 
next comment below.
>
>> +               /*
-------CUT------------------------------------------------------
>> +
>> +               coherent = of_dma_is_coherent(parent_np);
>> +               dev_dbg(dev, "device is%sdma coherent\n",
>> +                       coherent ? " " : " not ");
>> +
>> +               arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);
>
> This is the same code as of_dma_configure. The only difference I see
> is which node ptr is passed to of_dma_get_range. You need to make that
> a function param of of_dma_configure.
>
> of_dma_configure also has iommu handling now. You will probably need
> something similar for PCI in that you setup an iommu based on the root
> bus DT properties.
>
Initially I had the same idea to re-use the existing function 
of_dma_configure() for this. I wanted to defer this until we have an 
agreement on the changes required for the subject functionality. My 
quick review of the code suggestio this would require additional API 
changes as below. I did a quick test of the changes and it works for 
Keystone, but need to be reviewed by everyone as I touch the IOMMU 
functionality here and I don't have a platform with IOMMU. Need test by 
someone to make sure I don't break anything.

Here are the changes required to implement this suggestion.

1. Move the of_dma_configure() to drivers/of/device.c (include the API 
in of_device.h) and make it global (using proper EXPORT macro). 
Otherwise, we will have to include of_platform.h in drivers/of/of_pci.c 
assuming the prototype is defined in of_platform.h which doesn't look 
appropriate to me. Would require following additional include files in 
drivers/of/device.c as well.

+#include <linux/of_address.h>
+#include <linux/of_iommu.h>
+#include <linux/dma-mapping.h>

2. drivers/iommu/of_iommu.c. This is needed so that of_iommu_configure() 
can take confuguration from the root bus DT as you have suggested.

-struct iommu_ops *of_iommu_configure(struct device *dev)
+struct iommu_ops *of_iommu_configure(struct device *dev, struct 
device_node *node)
  {
         struct of_phandle_args iommu_spec;
         struct device_node *np;
@@ -145,7 +145,7 @@ struct iommu_ops *of_iommu_configure(struct device *dev)
          * See the `Notes:' section of
          * Documentation/devicetree/bindings/iommu/iommu.txt
          */
-       while (!of_parse_phandle_with_args(dev->of_node, "iommus",
+       while (!of_parse_phandle_with_args(node, "iommus",
                                            "#iommu-cells", idx,
                                            &iommu_spec)) {

3. drivers/of/of_pci.c. The existing function (added in this patch) will 
make call to of_dma_configure() as

parent_np = of_get_pci_root_bridge_parent(pci_dev);
of_dma_configure(dev, parent_np);

4. drivers/of/platform.c. Add a wrapper function 
of_platform_dma_configure() that calls of_dma_configure() as
of_dma_configure(dev, dev->of_node). All existing calls converted to 
this wrapper.

If the above looks good, I can post v3 of the patch with these changes.

> Rob


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
