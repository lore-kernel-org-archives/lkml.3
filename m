Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3LWVhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:37:15 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:52682 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab3LWVhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:37:12 -0500
Message-ID: <52B8A87F.7080100@epfl.ch>
Date: Mon, 23 Dec 2013 22:17:51 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Anna, Suman" <s-anna@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/7] iommu/omap: Convert to devicetree
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch> <52B89394.5060902@ti.com>
In-Reply-To: <52B89394.5060902@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 12/23/2013 08:48 PM, Anna, Suman wrote:
> Hi Florian,
> 
> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>> As OMAP2+ is moving to a full DT boot for 3.14, commit 7ce93f3
>> "ARM: OMAP2+: Fix more missing data for omap3.dtsi file" adds
>> basic DT bits. But the driver is not yet converted, so this will
>> not work and driver will not be probed. Convert it!
>>
>> Apart from standard bindings, this patch uses 'dma-window' (already
>> used by Tegra SMMU) and adds a custom 'ti,#tlb-entries' binding.
>>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>   .../devicetree/bindings/iommu/ti,omap-iommu.txt    | 19 ++++++++++++
>>   arch/arm/mach-omap2/omap-iommu.c                   |  5 +++
>>   drivers/iommu/omap-iommu.c                         | 36
>> +++++++++++++++++++---
>>   3 files changed, 55 insertions(+), 5 deletions(-)
>>   create mode 100644
>> Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>> b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>> new file mode 100644
>> index 0000000..4e5027c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>> @@ -0,0 +1,19 @@
>> +OMAP3 IOMMU used by camera subsystem
> 
> As I mentioned in comments on your cover-letter, the current binding is
> only limited to OMAP3 ISP, but the driver is common for all OMAP2+ SoCs.
> This binding an update to handle all SoCs.
> 
> To summarize the differences, OMAP2/3 has the same MMU register set for
> all remote processor MMUs (IVA/DSP/ISP) with the only difference being
> the number of TLBs supported (8 for ISP on OMAP2/3 and 32 for all other
> instances on all OMAP2+ SoCs). Depending on whether the compatibility
> property is defined for an SoC or for the processor, "ti,#tlb-entries"
> can be retrieved directly from the match data or made as an optional
> property, with the default value being 32.
> 

It makes sense.

> OMAP4 and OMAP5 have some additional registers (MMU_FAULT_PC,
> MMU_FAULT_STATUS, MMU_GP_REG/DSPSS_MMU_GPR) on top of the OMAP2/OMAP3
> ones, and DRA7 a further superset of OMAP4/OMAP5. The only difference is
> the definition of the MMU_GPR register, which is different between the
> IPU and DSP processors, but present at the same offset, and dictates the
> validity of the MMU_FAULT_PC and MMU_FAULT_STATUS registers. The MMU_GPR
> register is also not defined on OMAP4430 ES1.0, but is present on all
> other newer SoCs.
> 

Thank you for this detailed comparison ! I do not know much about
OMAP4 and OMAP5. In the current implementation, I was unable to find
references to these specificities. Is this currently supported?

>> +
>> +Required properties:
>> +- compatible : "ti,omap3-mmu-isp"
> My suggestion would be to use
>     "ti,omap2-iommu" for OMAP2/OMAP3 MMUs with the optional
> "ti,#tlb-entries" to distinguish ISP MMU.
>     "ti,omap4-iommu" for OMAP4/OMAP5 MMUs with an additional boolean
> property to distinguish the presence/functionality of the MMU_GPR register
>     "ti,dra7-iommu" for DRA7 MMUs
> 
> Mark, Tony,
> Do you have any other recommendations given the above summary?
> 
>> +- ti,hwmods : "mmu_isp"
> Replace with general description
> 

You mean something like "Name of the hwmod associated to the IOMMU"?

>> +- reg : address space for the configuration registers
>> +- interrupts : interrupt line
>> +- dma-window : IOVA start address and length.
>> +- ti,#tlb-entries : number of entries in the translation look-aside
>> buffer
>> +
>> +Example:
>> +    mmu_isp: mmu_isp@480bd400 {
>> +        compatible = "ti,omap3-mmu-isp";
>> +        ti,hwmods = "mmu_isp";
>> +        reg = <0x480bd400 0x80>;
>> +        interrupts = <8>;
>> +        dma-window = <0 0xfffff000>;
>> +        ti,#tlb-entries = <8>;
>> +    };
>> diff --git a/arch/arm/mach-omap2/omap-iommu.c
>> b/arch/arm/mach-omap2/omap-iommu.c
>> index f6daae8..f1fab56 100644
>> --- a/arch/arm/mach-omap2/omap-iommu.c
>> +++ b/arch/arm/mach-omap2/omap-iommu.c
>> @@ -10,6 +10,7 @@
>>    * published by the Free Software Foundation.
>>    */
>>
>> +#include <linux/of.h>
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/err.h>
>> @@ -58,6 +59,10 @@ static int __init omap_iommu_dev_init(struct
>> omap_hwmod *oh, void *unused)
>>
>>   static int __init omap_iommu_init(void)
>>   {
>> +    /* If dtb is there, the devices will be created dynamically */
>> +    if (of_have_populated_dt())
>> +        return -ENODEV;
>> +
>>       return omap_hwmod_for_each_by_class("mmu", omap_iommu_dev_init,
>> NULL);
>>   }
>>   /* must be ready before omap3isp is probed */
>> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
>> index 385bf5e..51efcc4 100644
>> --- a/drivers/iommu/omap-iommu.c
>> +++ b/drivers/iommu/omap-iommu.c
>> @@ -23,6 +23,9 @@
>>   #include <linux/spinlock.h>
>>   #include <linux/io.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/of.h>
>> +#include <linux/of_iommu.h>
>> +#include <linux/of_irq.h>
>>
>>   #include <asm/cacheflush.h>
>>
>> @@ -1171,20 +1174,30 @@ static int omap_iommu_probe(struct
>> platform_device *pdev)
>>   {
>>       int err = -ENODEV;
>>       int irq;
>> +    size_t len;
>>       struct omap_iommu *obj;
>>       struct resource *res;
>>       struct iommu_platform_data *pdata = pdev->dev.platform_data;
>> +    struct device_node *of = pdev->dev.of_node;
>>
>>       obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
>>       if (!obj)
>>           return -ENOMEM;
>>
>> -    obj->nr_tlb_entries = pdata->nr_tlb_entries;
>> -    obj->name = pdata->name;
>> +    if (of) {
>> +        obj->name = of->name;
>> +        of_property_read_u32(of, "ti,#tlb-entries",
>> +                     &obj->nr_tlb_entries);
>> +        of_get_dma_window(of, NULL, 0, NULL, &obj->da_start, &len);
> 
> There is no error checking performed on both the of functions.
> 

Indeed.

>> +        obj->da_end = obj->da_start + len;
>> +    } else {
>> +        obj->nr_tlb_entries = pdata->nr_tlb_entries;
>> +        obj->name = pdata->name;
>> +        obj->da_start = pdata->da_start;
>> +        obj->da_end = pdata->da_end;
>> +    }
>>       obj->dev = &pdev->dev;
>>       obj->ctx = (void *)obj + sizeof(*obj);
>> -    obj->da_start = pdata->da_start;
>> -    obj->da_end = pdata->da_end;
>>
>>       spin_lock_init(&obj->iommu_lock);
>>       mutex_init(&obj->mmap_lock);
>> @@ -1210,7 +1223,11 @@ static int omap_iommu_probe(struct
>> platform_device *pdev)
>>           goto err_ioremap;
>>       }
>>
>> -    irq = platform_get_irq(pdev, 0);
>> +    if (of)
>> +        irq = irq_of_parse_and_map(of, 0);
>> +    else
>> +        irq = platform_get_irq(pdev, 0);
> 
> The platform_get_irq should still work just fine, so this change can
> probably be left out. We can switch once the driver supports DT-only
> devices completely.
> 

Ok I will test when back at my office.

Thank you!

Regards,
Florian
