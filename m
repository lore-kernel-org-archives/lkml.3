Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaJXPoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:44:13 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48320 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJXPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:44:09 -0400
Date: Fri, 24 Oct 2014 16:43:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
Message-ID: <20141024154353.GE20534@e104818-lin.cambridge.arm.com>
References: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <20141010120702.GI7755@arm.com>
 <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com>
 <20141013125725.GA19156@arm.com>
 <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1410231516450.876@kaball.uk.xensource.com>
 <20141024104746.GC1955@localhost>
 <alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 12:39:59PM +0100, Stefano Stabellini wrote:
> On Fri, 24 Oct 2014, Catalin Marinas wrote:
> > I think a better way would be some Xen hook around
> > set_arch_dma_coherent_ops(). Does Xen have its own device tracking
> > structures? If not, you may be able to add another bitfield to the
> > kernel one.
> 
> We don't have an additional device tracking struct on Xen.
> I agree that a new bit somewhere would be the best solution, but I am
> not sure where. Maybe in dev_archdata under arm and arm64? After all it
> is already used to keep pointers to dma and coherency related
> structures.

I was thinking about something like below (maybe with some additional
ARCH_HAS_NONCOHERENT_DMA config for architectures that are always
coherent):

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0bf5bba..ae399ccbd569 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -183,6 +183,7 @@ static void of_dma_configure(struct device *dev)
 	 * dma coherent operations.
 	 */
 	if (of_dma_is_coherent(dev->of_node)) {
+		dev->dma_coherent = 1;
 		set_arch_dma_coherent_ops(dev);
 		dev_dbg(dev, "device is dma coherent\n");
 	}
diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f21608b16..e00ca876db01 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -796,6 +796,7 @@ struct device {
 
 	bool			offline_disabled:1;
 	bool			offline:1;
+	bool			dma_coherent:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index d5d388160f42..9c9ba5a5428e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -78,6 +78,11 @@ static inline int is_device_dma_capable(struct device *dev)
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
+static inline int is_device_dma_coherent(struct device *dev)
+{
+	return dev->dma_coherent;
+}
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else

> However given the timing constraints I hope you would be OK with the
> suboptimal solution for now and create a common is_dma_coherent function
> in 3.19?

If you want to push something for 3.18, you could have a temporary
solution but I would prefer a bool or something in the dev_archdata
structure. Another untested patch:

diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
index cf98b362094b..243ef256b8c9 100644
--- a/arch/arm64/include/asm/device.h
+++ b/arch/arm64/include/asm/device.h
@@ -21,6 +21,7 @@ struct dev_archdata {
 #ifdef CONFIG_IOMMU_API
 	void *iommu;			/* private IOMMU data */
 #endif
+	bool dma_coherent;
 };
 
 struct pdev_archdata {
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index adeae3f6f0fc..b6bc4c268878 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -54,11 +54,17 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 
 static inline int set_arch_dma_coherent_ops(struct device *dev)
 {
+	dev->dev_archdata.dma_coherent = true;
 	set_dma_ops(dev, &coherent_swiotlb_dma_ops);
 	return 0;
 }
 #define set_arch_dma_coherent_ops	set_arch_dma_coherent_ops
 
+static inline int is_device_dma_coherent(struct device *dev)
+{
+	return dev->dev_archdata.dma_coherent;
+}
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)


This way you don't have to test for swiotlb vs iommu ops (we don't have
the latter yet on arm64 but they are coming).

-- 
Catalin
