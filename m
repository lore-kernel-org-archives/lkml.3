Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbbA0L1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:27:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49893 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbA0L1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:27:23 -0500
Message-ID: <54C77616.80301@arm.com>
Date: Tue, 27 Jan 2015 11:27:18 +0000
From: Robin Murphy <robin.murphy@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v4 3/6] of: fix size when dma-range is not used
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <1422052359-12384-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1422052359-12384-4-git-send-email-m-karicheri2@ti.com>
X-OriginalArrivalTime: 27 Jan 2015 11:27:19.0292 (UTC) FILETIME=[35FF93C0:01D03A24]
X-MC-Unique: 115012711272101201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On 23/01/15 22:32, Murali Karicheri wrote:
> Fix the dma-range size when the DT attribute is missing. i.e  set size to
> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. To detect
> overflow when mask is set to max of u64, add a check, log error and return.
> Some platform use mask format for size in DTS. So add a work around to
> catch this and fix.
>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>   drivers/of/device.c |   14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 2de320d..0a5ff54 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -105,12 +105,24 @@ void of_dma_configure(struct device *dev, struct device_node *np)
>   	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
>   	if (ret < 0) {
>   		dma_addr = offset = 0;
> -		size = dev->coherent_dma_mask;
> +		size = dev->coherent_dma_mask + 1;
>   	} else {
>   		offset = PFN_DOWN(paddr - dma_addr);
> +		/*
> +		 * Add a work around to treat the size as mask + 1 in case
> +		 * it is defined in DT as a mask.
> +		 */
> +		if (size & 1)
> +			size = size + 1;
>   		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
>   	}
>
> +	/* if size is 0, we have an overflow of u64 */
> +	if (!size) {
> +		dev_err(dev, "invalid size\n");
> +		return;
> +	}
> +

This seems potentially fragile to dodgy DTs given that we might also be 
using size to make a mask later. Would it make sense to double-up a 
sanity check as mask-format detection? Something like:

if is_power_of_2(size)
	// use size
else if is_power_of_2(size + 1)
	// use size + 1
else
	// cry


Robin.

>   	dev->dma_pfn_offset = offset;
>
>   	coherent = of_dma_is_coherent(np);
>


