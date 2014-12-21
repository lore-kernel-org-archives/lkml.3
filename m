Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaLUKmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:42:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52630 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaLUKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:42:07 -0500
Date: Sun, 21 Dec 2014 10:42:00 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [RFC PATCH 1/2] common: dma-mapping: introduce
 dma_get_parent_cfg() helper
Message-ID: <20141221104200.GG23242@arm.com>
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com>
 <1949667.gMcOLHe7Sk@wuerfel>
 <549210BB.9080603@ti.com>
 <2935351.ba8Au9y4fE@wuerfel>
 <20141218172011.GB20963@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218172011.GB20963@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 05:20:12PM +0000, Catalin Marinas wrote:
> On Thu, Dec 18, 2014 at 12:09:17AM +0000, Arnd Bergmann wrote:
> > Will, I think we may have a problem on ARM64 now, since we only replaced
> > set_arch_dma_coherent_ops on ARM32 but not ARM64. Can you send a fix for
> > this? Without that, we don't have any coherent operations on ARM64 any
> > more, unless I'm missing something.
> 
> Good point, I think Will forgot about arm64 (weird ;)).

Oops, I think arm64 didn't implement set_arch_dma_coherent_ops when I
started that series and I forgot to refresh it.

> I'll push this out since Will is on holiday, probably shortly after
> -rc1.
> 
> -----8<--------------------------------------------
> 
> From 40ec7fd94b4efbd5d74185a062433f71c6576e20 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Thu, 18 Dec 2014 17:13:49 +0000
> Subject: [PATCH] arm64: Replace set_arch_dma_coherent_ops with
>  arch_setup_dma_ops
> 
> Commit a3a60f81ee6f (dma-mapping: replace set_arch_dma_coherent_ops with
> arch_setup_dma_ops) changes the of_dma_configure() arch dma_ops callback
> to arch_setup_dma_ops but only the arch/arm code is updated. Subsequent
> commit 97890ba9289c (dma-mapping: detect and configure IOMMU in
> of_dma_configure) changes the arch_setup_dma_ops() prototype further to
> handle iommu. The patch makes the corresponding arm64 changes.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/dma-mapping.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index d34189bceff7..9ce3e680ae1c 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -52,13 +52,14 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
>  	dev->archdata.dma_ops = ops;
>  }
>  
> -static inline int set_arch_dma_coherent_ops(struct device *dev)
> +static inline void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
> +				      struct iommu_ops *iommu, bool coherent)
>  {
> -	dev->archdata.dma_coherent = true;
> -	set_dma_ops(dev, &coherent_swiotlb_dma_ops);
> -	return 0;
> +	dev->archdata.dma_coherent = coherent;
> +	if (coherent)
> +		set_dma_ops(dev, &coherent_swiotlb_dma_ops);
>  }
> -#define set_arch_dma_coherent_ops	set_arch_dma_coherent_ops
> +#define arch_setup_dma_ops	arch_setup_dma_ops

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks for fixing this.

Will
