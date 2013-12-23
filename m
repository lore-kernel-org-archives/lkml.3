Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3LWXmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 18:42:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37511 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab3LWXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 18:42:53 -0500
Message-ID: <52B8CA4D.8000501@ti.com>
Date: Mon, 23 Dec 2013 17:42:05 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <florian.vaussard@epfl.ch>, Joerg Roedel <joro@8bytes.org>,
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
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch> <52B89394.5060902@ti.com> <52B8A87F.7080100@epfl.ch>
In-Reply-To: <52B8A87F.7080100@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

 >>
>> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>>> As OMAP2+ is moving to a full DT boot for 3.14, commit 7ce93f3
>>> "ARM: OMAP2+: Fix more missing data for omap3.dtsi file" adds
>>> basic DT bits. But the driver is not yet converted, so this will
>>> not work and driver will not be probed. Convert it!
>>>
>>> Apart from standard bindings, this patch uses 'dma-window' (already
>>> used by Tegra SMMU) and adds a custom 'ti,#tlb-entries' binding.
>>>
>>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>>> ---
>>>    .../devicetree/bindings/iommu/ti,omap-iommu.txt    | 19 ++++++++++++
>>>    arch/arm/mach-omap2/omap-iommu.c                   |  5 +++
>>>    drivers/iommu/omap-iommu.c                         | 36
>>> +++++++++++++++++++---
>>>    3 files changed, 55 insertions(+), 5 deletions(-)
>>>    create mode 100644
>>> Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>>> b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>>> new file mode 100644
>>> index 0000000..4e5027c
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
>>> @@ -0,0 +1,19 @@
>>> +OMAP3 IOMMU used by camera subsystem
>>
>> As I mentioned in comments on your cover-letter, the current binding is
>> only limited to OMAP3 ISP, but the driver is common for all OMAP2+ SoCs.
>> This binding an update to handle all SoCs.
>>
>> To summarize the differences, OMAP2/3 has the same MMU register set for
>> all remote processor MMUs (IVA/DSP/ISP) with the only difference being
>> the number of TLBs supported (8 for ISP on OMAP2/3 and 32 for all other
>> instances on all OMAP2+ SoCs). Depending on whether the compatibility
>> property is defined for an SoC or for the processor, "ti,#tlb-entries"
>> can be retrieved directly from the match data or made as an optional
>> property, with the default value being 32.
>>
>
> It makes sense.
>
>> OMAP4 and OMAP5 have some additional registers (MMU_FAULT_PC,
>> MMU_FAULT_STATUS, MMU_GP_REG/DSPSS_MMU_GPR) on top of the OMAP2/OMAP3
>> ones, and DRA7 a further superset of OMAP4/OMAP5. The only difference is
>> the definition of the MMU_GPR register, which is different between the
>> IPU and DSP processors, but present at the same offset, and dictates the
>> validity of the MMU_FAULT_PC and MMU_FAULT_STATUS registers. The MMU_GPR
>> register is also not defined on OMAP4430 ES1.0, but is present on all
>> other newer SoCs.
>>
>
> Thank you for this detailed comparison ! I do not know much about
> OMAP4 and OMAP5. In the current implementation, I was unable to find
> references to these specificities. Is this currently supported?

OMAP4 iommu devices are instantiated today in legacy form, using the 
hwmod data. These are used by the remoteproc driver. OMAP5 data has not 
yet been added, as there is no point in adding it in legacy form at the 
moment.

>
>>> +
>>> +Required properties:
>>> +- compatible : "ti,omap3-mmu-isp"
>> My suggestion would be to use
>>      "ti,omap2-iommu" for OMAP2/OMAP3 MMUs with the optional
>> "ti,#tlb-entries" to distinguish ISP MMU.
>>      "ti,omap4-iommu" for OMAP4/OMAP5 MMUs with an additional boolean
>> property to distinguish the presence/functionality of the MMU_GPR register
>>      "ti,dra7-iommu" for DRA7 MMUs
>>
>> Mark, Tony,
>> Do you have any other recommendations given the above summary?
>>
>>> +- ti,hwmods : "mmu_isp"
>> Replace with general description
>>
>
> You mean something like "Name of the hwmod associated to the IOMMU"?

Yes.

regards
Suman

[snip]
