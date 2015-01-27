Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbbA0LMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:12:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:32984 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbA0LMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:12:35 -0500
Message-ID: <54C772A0.2000203@arm.com>
Date: Tue, 27 Jan 2015 11:12:32 +0000
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
Subject: Re: [PATCH v4 6/6] arm: dma-mapping: updates to limit dma_mask and
 iommu mapping size
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com> <1422052359-12384-7-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1422052359-12384-7-git-send-email-m-karicheri2@ti.com>
X-OriginalArrivalTime: 27 Jan 2015 11:12:32.0456 (UTC) FILETIME=[25672480:01D03A22]
X-MC-Unique: 115012711123403501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On 23/01/15 22:32, Murali Karicheri wrote:
> Limit the dma_mask to minimum of dma_mask and dma_base + size - 1.
>
> Also arm_iommu_create_mapping() has size parameter of size_t and
> arm_setup_iommu_dma_ops() can take a value higher than that. So
> limit the size to SIZE_MAX.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>   arch/arm/mm/dma-mapping.c |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 7864797..a1f9030 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -2004,6 +2004,13 @@ static bool arm_setup_iommu_dma_ops(struct device *dev, u64 dma_base, u64 size,
>   	if (!iommu)
>   		return false;
>
> +	/*
> +	 * currently arm_iommu_create_mapping() takes a max of size_t
> +	 * for size param. So check this limit for now.
> +	 */
> +	if (size > SIZE_MAX)
> +		return false;
> +
>   	mapping = arm_iommu_create_mapping(dev->bus, dma_base, size);
>   	if (IS_ERR(mapping)) {
>   		pr_warn("Failed to create %llu-byte IOMMU mapping for device %s\n",
> @@ -2053,6 +2060,9 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>   {
>   	struct dma_map_ops *dma_ops;
>
> +	/* limit dma_mask to the lower of the two values */
> +	*dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));
> +

Is there any reason not to do this in of_dma_configure? It seems like 
something everyone could benefit from - I'd cooked up a dodgy workaround 
for the same issue in my arm64 IOMMU code, but handling it generically 
in common code would be much nicer.

Robin.

>   	dev->archdata.dma_coherent = coherent;
>   	if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
>   		dma_ops = arm_get_iommu_dma_map_ops(coherent);
>


