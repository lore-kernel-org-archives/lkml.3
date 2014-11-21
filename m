Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaKUJf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:35:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36258 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbaKUJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:35:20 -0500
Date: Fri, 21 Nov 2014 09:35:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ding Tianhong <dingtianhong@huawei.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <1535751.CcvIi3DN4F@wuerfel>
 <546D58B1.60108@huawei.com>
 <2522857.bNQToYpBNt@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2522857.bNQToYpBNt@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:40:00AM +0000, Arnd Bergmann wrote:
> On Thursday 20 November 2014 10:57:53 Ding Tianhong wrote:
> > On 2014/11/19 16:45, Arnd Bergmann wrote:
> > > On Wednesday 19 November 2014 11:17:15 Ding Tianhong wrote:
> > >> On 2014/11/18 2:09, Catalin Marinas wrote:
> > >>> On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
> > >> Thanks everyone, I think I found the way to fix it, need to enable DMA_CMA, to reserve a big memory
> > >> for CMA and set coherent mask for dev, then dma_alloc and dma_mapping will not use the swiotlb until
> > >> the memory out of mask or swiotlb_force is enabled.
> > >>
> > >> If I still understand uncorrectly, please inform me.
> > > 
> > > Please do not use CMA to work around the problem, but fix the underlying bug
> > > instead.
> > > 
> > > The driver should call 'dma_set_mask_and_coherent()' with the appropriate
> > > dma mask, and check whether that succeeded. However, the code implementing
> > > dma_set_mask_and_coherent on arm64 also needs to be changed to look up
> > > the dma-ranges property (see of_dma_configure()), and check if the mask
> > > is possible.
> > > 
> > The dma_pfn_offset looks only support arm32, but my platform is
> > aarch64 and I check the latest kernel version, I think the dma-rangs
> > still could not work for aarch64, so maybe we should add
> > dma_pfn_offset for aarch64 first.
> 
> I didn't mean the dma_pfn_offset. The problem is that the of_dma_configure
> code currently doesn't look at the mask. As I explained in my reply to
> Catalin, it should set the mask to the size of the dma-ranges if that is
> 32-bit or smaller, and dma_set_mask should look at the same dma-ranges
> property to decide what to set the mask to when a driver asks for a
> mask larger than 64-bit.

But this wouldn't help Ding's case, here the driver needs to set the
wider DMA mask.

Anyway, back to your point, to make sure I understand what you meant (I
can send a proper patch with log afterwards):

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1e0e4671dd25..d6a4b4619174 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -120,6 +120,9 @@ config HAVE_GENERIC_RCU_GUP
 config ARCH_DMA_ADDR_T_64BIT
 	def_bool y
 
+config ARCH_HAS_DMA_SET_COHERENT_MASK
+	def_bool y
+
 config NEED_DMA_MAP_STATE
 	def_bool y
 
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index adeae3f6f0fc..92dcd251e549 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -18,6 +18,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/of_address.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
@@ -88,11 +89,24 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
+	/* if asking for bigger dma mask, limit it to the bus dma ranges */
+	if (mask > *dev->dma_mask)
+		mask &= of_dma_get_range_mask(dev);
 	*dev->dma_mask = mask;
 
 	return 0;
 }
 
+static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (!dma_supported(dev, mask))
+		return -EIO;
+	if (mask > dev->coherent_dma_mask)
+		mask &= of_dma_get_range_mask(dev);
+	dev->coherent_dma_mask = mask;
+	return 0;
+}
+
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff --git a/drivers/of/address.c b/drivers/of/address.c
index afdb78299f61..89c04abdf9bb 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -1,5 +1,6 @@
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
@@ -979,6 +980,19 @@ out:
 }
 EXPORT_SYMBOL_GPL(of_dma_get_range);
 
+u64 of_dma_get_range_mask(struct device *dev)
+{
+	u64 dma_addr, paddr, size;
+
+	/* no dma mask limiting if no of_node or no dma-ranges property */
+	if (!dev->of_node ||
+	    of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size) < 0)
+		return DMA_BIT_MASK(64);
+
+	return DMA_BIT_MASK(ilog2(size));
+}
+EXPORT_SYMBOL_GPL(of_dma_get_range_mask);
+
 /**
  * of_dma_is_coherent - Check if device is coherent
  * @np:	device node
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0bf5bba..50d1ac4739e6 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
 	/* DMA ranges found. Calculate and set dma_pfn_offset */
 	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
 	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
+
+	/* limit the coherent_dma_mask to the dma-ranges size property */
+	if (size < (1ULL << 32))
+		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
 }
 
 /**
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 8cb14eb393d6..fffb1a49a1a7 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -55,6 +55,8 @@ extern struct of_pci_range *of_pci_range_parser_one(
 					struct of_pci_range *range);
 extern int of_dma_get_range(struct device_node *np, u64 *dma_addr,
 				u64 *paddr, u64 *size);
+extern u64 of_dma_get_range_mask(struct device *dev);
+
 extern bool of_dma_is_coherent(struct device_node *np);
 #else /* CONFIG_OF_ADDRESS */
 static inline struct device_node *of_find_matching_node_by_address(
