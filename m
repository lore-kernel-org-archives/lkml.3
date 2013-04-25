Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3DYRmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:42:21 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:57427
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759071Ab3DYRmT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:42:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0chbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: RE: [PATCH 13/21] iommu: tegra: print dma_addr_t using %lld
Thread-Topic: [PATCH 13/21] iommu: tegra: print dma_addr_t using %lld
Thread-Index: AQHOQdpsG1YW08ubHUaGPKtNUH7/NJjnMoOg
Date: Thu, 25 Apr 2013 17:42:12 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D4BD243@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1366910944-3033663-14-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
I already submitted a patch to fix this.
http://permalink.gmane.org/gmane.linux.kernel.iommu/2036

Regards
Varun

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, April 25, 2013 10:59 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org; Arnd Bergmann; Sethi Varun-B16395;
> Joerg Roedel
> Subject: [PATCH 13/21] iommu: tegra: print dma_addr_t using %lld
> 
> The code was recently changed to work for builds with a 64 bit
> dma_addr_t, but the printk unconditionally uses a format string for an
> "long" variable, which is always wrong as the dma_add_t is now either
> 'unsigned int' or 'unsigned long long'
> depending on configuration.
> 
> The easiest solution is to cast the variable to u64 and print it as a 64
> bit value.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Varun Sethi <Varun.Sethi@freescale.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>  drivers/iommu/tegra-gart.c | 3 ++-
>  drivers/iommu/tegra-smmu.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
> index 4aec8be..ebbdd82 100644
> --- a/drivers/iommu/tegra-gart.c
> +++ b/drivers/iommu/tegra-gart.c
> @@ -295,7 +295,8 @@ static phys_addr_t gart_iommu_iova_to_phys(struct
> iommu_domain *domain,
> 
>  	pa = (pte & GART_PAGE_MASK);
>  	if (!pfn_valid(__phys_to_pfn(pa))) {
> -		dev_err(gart->dev, "No entry for %08lx:%08x\n", iova, pa);
> +		dev_err(gart->dev, "No entry for %08llx:%pa\n",
> +				(u64)iova, &pa);
>  		gart_dump_table(gart);
>  		return -EINVAL;
>  	}
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index bc9b599..ef2a120 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -772,7 +772,7 @@ static phys_addr_t smmu_iommu_iova_to_phys(struct
> iommu_domain *domain,
>  	pfn = *pte & SMMU_PFN_MASK;
>  	WARN_ON(!pfn_valid(pfn));
>  	dev_dbg(as->smmu->dev,
> -		"iova:%08lx pfn:%08lx asid:%d\n", iova, pfn, as->asid);
> +		"iova:%08llx pfn:%08lx asid:%d\n", (u64)iova, pfn, as->asid);
> 
>  	spin_unlock_irqrestore(&as->lock, flags);
>  	return PFN_PHYS(pfn);
> --
> 1.8.1.2
> 


