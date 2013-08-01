Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3HAAeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:34:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43416 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3HAAd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:33:58 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1375292732-7627-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RFC 1/8] arm: make SWIOTLB available
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Jul 2013 20:32:54 -0400
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefano.Stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Message-ID: <334c4fe7-e40c-489c-84db-9bb58c705d44@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
>Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>CC: will.deacon@arm.com
>CC: linux@arm.linux.org.uk
>---
> arch/arm/Kconfig                   |    7 +++++++
> arch/arm/include/asm/dma-mapping.h |   24 ++++++++++++++++++++++++
> 2 files changed, 31 insertions(+), 0 deletions(-)
>
>diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>index ba412e0..05125ab 100644
>--- a/arch/arm/Kconfig
>+++ b/arch/arm/Kconfig
>@@ -1832,6 +1832,13 @@ config CC_STACKPROTECTOR
> 	  neutralized via a kernel panic.
> 	  This feature requires gcc version 4.2 or above.
> 
>+config SWIOTLB
>+	def_bool y
>+	select NEED_SG_DMA_LENGTH
>+
>+config IOMMU_HELPER
>+	def_bool SWIOTLB
>+

Could you explain the purpose of these two a bit more please? 

> config XEN_DOM0
> 	def_bool y
> 	depends on XEN
>diff --git a/arch/arm/include/asm/dma-mapping.h
>b/arch/arm/include/asm/dma-mapping.h
>index 5b579b9..ad89e0f 100644
>--- a/arch/arm/include/asm/dma-mapping.h
>+++ b/arch/arm/include/asm/dma-mapping.h
>@@ -86,6 +86,30 @@ static inline dma_addr_t virt_to_dma(struct device
>*dev, void *addr)
> }
> #endif
> 
>+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t
>paddr)
>+{
>+	unsigned int offset = paddr & ~PAGE_MASK;
>+	return pfn_to_dma(dev, paddr >> PAGE_SHIFT) + offset;
>+}
>+
>+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t
>dev_addr)
>+{
>+	unsigned int offset = dev_addr & ~PAGE_MASK;
>+	return (dma_to_pfn(dev, dev_addr) << PAGE_SHIFT) + offset;
>+}
>+
>+static inline bool dma_capable(struct device *dev, dma_addr_t addr,
>size_t size)
>+{
>+	if (!dev->dma_mask)
>+		return 0;
>+
>+	return addr + size - 1 <= *dev->dma_mask;
>+}
>+
>+static inline void dma_mark_clean(void *addr, size_t size)
>+{
>+}
>+
> /*
>  * DMA errors are defined by all-bits-set in the DMA address.
>  */


