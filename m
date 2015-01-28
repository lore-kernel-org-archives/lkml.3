Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbbA1UmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46503 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020AbbA1Uly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:54 -0500
Message-ID: <54C9000C.3040907@ti.com>
Date: Wed, 28 Jan 2015 10:28:12 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Robin Murphy <robin.murphy@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v5 3/8] of: fix size when dma-range is not used
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com> <1422392405-32196-4-git-send-email-m-karicheri2@ti.com> <54C8C652.8050507@arm.com>
In-Reply-To: <54C8C652.8050507@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 06:21 AM, Robin Murphy wrote:
> Hi Murali,
>
> [sorry, missed replying to yesterday's version]
>
> On 27/01/15 21:00, Murali Karicheri wrote:
>> Fix the dma-range size when the DT attribute is missing. i.e set size to
>> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. Also add
>> code to check invalid values of size configured in DT and log error.
>>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>> drivers/of/device.c | 9 ++++++++-
>> 1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/device.c b/drivers/of/device.c
>> index 2de320d..17504f4 100644
>> --- a/drivers/of/device.c
>> +++ b/drivers/of/device.c
>> @@ -105,12 +105,19 @@ void of_dma_configure(struct device *dev, struct
>> device_node *np)
>> ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
>> if (ret < 0) {
>> dma_addr = offset = 0;
>> - size = dev->coherent_dma_mask;
>> + size = dev->coherent_dma_mask + 1;
>> } else {
>> offset = PFN_DOWN(paddr - dma_addr);
>> dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
>> }
>>
>> + if (is_power_of_2(size + 1))
>> + size = size + 1;
>> + else if (!is_power_of_2(size)) {
>> + dev_err(dev, "invalid size\n");
>> + return;
>> + }
>> +
>
> Couldn't these checks go into the "else" path above? We don't need to
> check the non-DT case, because we know we've just set it to something
> sensible.
Robin,

Sure it can. I was doing flip/flop on the choice and thought it doesn' 
matter either way. Please also repond to Catalin's comment if you have 
any issues so that I can avoid additional spin on this patch.

Thanks

Murali
>
> Robin.
>
>> dev->dma_pfn_offset = offset;
>>
>> coherent = of_dma_is_coherent(np);
>>
>
>


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
