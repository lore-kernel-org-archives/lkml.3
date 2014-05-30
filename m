Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaE3FbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:31:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59934 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaE3FbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:31:08 -0400
Message-ID: <53881759.2070905@ti.com>
Date: Fri, 30 May 2014 11:00:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-4-git-send-email-kishon@ti.com> <53876116.90504@ti.com>
In-Reply-To: <53876116.90504@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 29 May 2014 10:02 PM, Murali Karicheri wrote:
> On 5/29/2014 2:38 AM, ABRAHAM, KISHON VIJAY wrote:
>> The configuration address space has so far been specified in *ranges*,
>> however it should be specified in *reg* making it a platform MEM resource.
>> Hence used 'platform_get_resource_*' API to get configuration address
>> space in the designware driver.
>>
>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Mohit Kumar <mohit.kumar@st.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Marek Vasut <marex@denx.de>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>>   drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>>   2 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> index d6fae13..8314360 100644
>> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>> @@ -6,6 +6,7 @@ Required properties:
>>       as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>>   - reg: base addresses and lengths of the pcie controller,
>>       the phy controller, additional register for the phy controller.
>> +    The configuration address space should also be specified here.
> Kishon,
> 
> I am working on the Keystone PCI driver for which v1 is already posted. Want to
> clarify
> following.
> 1. Original text for reg states "base addresses and lengths of the pcie
> controller,
>         the phy controller, additional register for the phy controller" and you
> added
>         "The configuration address space should also be specified here"
> 
>    and the code below added resource name "config"
> 
> Does PCI designware follow some convention? Does it mean after applying this patch
> config name is mandatory or optional? Below code you are not returning error.
> Can you
> or author of PCI designware clarify what is expected to be present as mandatory
> and
> what is optional.

>From whatever I could make out from the comments for my previous version,
'config' is mandatory for all new platforms adding support for PCIe DW. However
since there already exists platforms that use 'ranges', I'm not returning
error. Once all the platforms that use DW is modified to use 'reg', will return
error.
> 
> Does config refers to RC's config space or EP's config space or both? The code
> below divide

In the case of DRA7, it's the space from where you read the configuration space
contents of the EP (we have separate address space for the configuration space
of RC denoted by *rc_dbics* in this patch series). But there are other
platforms where RC does not have a separate configuration address space.
> the size by 2. So it appears to be RC's + EP's config space. Please clarify.

No. divide by 2 is for cfg1 and cfg1 is used by PCIe bridges.
> 
>>   - interrupts: interrupt values for level interrupt,
>>       pulse interrupt, special interrupt.
>>   - clocks: from common clock binding: handle to pci clock.
>> diff --git a/drivers/pci/host/pcie-designware.c
>> b/drivers/pci/host/pcie-designware.c
>> index c4e3732..603b386 100644
>> --- a/drivers/pci/host/pcie-designware.c
>> +++ b/drivers/pci/host/pcie-designware.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/of_pci.h>
>>   #include <linux/pci.h>
>>   #include <linux/pci_regs.h>
>> +#include <linux/platform_device.h>
>>   #include <linux/types.h>
>>     #include "pcie-designware.h"
>> @@ -392,11 +393,23 @@ static const struct irq_domain_ops msi_domain_ops = {
>>   int __init dw_pcie_host_init(struct pcie_port *pp)
>>   {
>>       struct device_node *np = pp->dev->of_node;
>> +    struct platform_device *pdev = to_platform_device(pp->dev);
>>       struct of_pci_range range;
>>       struct of_pci_range_parser parser;
>> +    struct resource *cfg_res;
>>       u32 val;
>>       int i;
>>   +    cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
>> +    if (cfg_res) {
>> +        pp->config.cfg0_size = resource_size(cfg_res)/2;
>> +        pp->config.cfg1_size = resource_size(cfg_res)/2;
>> +        pp->cfg0_base = cfg_res->start;
>> +        pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
>> +    } else {
>> +        dev_err(pp->dev, "missing *config* reg space\n");
> This should return error -EINVAL.

ah.. it'll break for other platforms. It should be part of a different patch
once we convert all users to 8reg*.
> 
>> +    }
>> +
>>       if (of_pci_range_parser_init(&parser, np)) {
>>           dev_err(pp->dev, "missing ranges property\n");
>>           return -EINVAL;
>> @@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>>               of_pci_range_to_resource(&range, np, &pp->cfg);
>>               pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>>               pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>> +            pp->cfg0_base = pp->cfg.start;
>> +            pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>>           }
>>       }
>>   @@ -441,8 +456,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>>           }
>>       }
>>   -    pp->cfg0_base = pp->cfg.start;
>> -    pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>>       pp->mem_base = pp->mem.start;
>>         pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> BTW, Please also review my Keystone series so that we could discuss this topic
> in that context
> as well.

sure..

Cheers
Kishon
