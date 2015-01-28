Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbbA1UWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:22:50 -0500
Received: from service88.mimecast.com ([195.130.217.12]:37088 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbbA1UWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:45 -0500
Message-ID: <54C8C652.8050507@arm.com>
Date: Wed, 28 Jan 2015 11:21:54 +0000
From: Robin Murphy <robin.murphy@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v5 3/8] of: fix size when dma-range is not used
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com> <1422392405-32196-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1422392405-32196-4-git-send-email-m-karicheri2@ti.com>
X-OriginalArrivalTime: 28 Jan 2015 11:21:54.0851 (UTC) FILETIME=[9F078F30:01D03AEC]
X-MC-Unique: 115012811215711801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

[sorry, missed replying to yesterday's version]

On 27/01/15 21:00, Murali Karicheri wrote:
> Fix the dma-range size when the DT attribute is missing. i.e  set size to
> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. Also add
> code to check invalid values of size configured in DT and log error.
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
>   drivers/of/device.c |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 2de320d..17504f4 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -105,12 +105,19 @@ void of_dma_configure(struct device *dev, struct device_node *np)
>   	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
>   	if (ret < 0) {
>   		dma_addr = offset = 0;
> -		size = dev->coherent_dma_mask;
> +		size = dev->coherent_dma_mask + 1;
>   	} else {
>   		offset = PFN_DOWN(paddr - dma_addr);
>   		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
>   	}
>
> +	if (is_power_of_2(size + 1))
> +		size = size + 1;
> +	else if (!is_power_of_2(size)) {
> +		dev_err(dev, "invalid size\n");
> +		return;
> +	}
> +

Couldn't these checks go into the "else" path above? We don't need to 
check the non-DT case, because we know we've just set it to something 
sensible.

Robin.

>   	dev->dma_pfn_offset = offset;
>
>   	coherent = of_dma_is_coherent(np);
>


