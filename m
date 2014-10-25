Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaJYS6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:58:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37318 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaJYS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:58:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,786,1406592000"; 
   d="scan'208";a="186159032"
Date: Sat, 25 Oct 2014 14:29:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
In-Reply-To: <alpine.DEB.2.02.1410241828110.22875@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1410251424350.22875@kaball.uk.xensource.com>
References: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141010120702.GI7755@arm.com> <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com> <alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com> <20141013125725.GA19156@arm.com>
 <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com> <alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com> <alpine.DEB.2.02.1410231516450.876@kaball.uk.xensource.com> <20141024104746.GC1955@localhost> <alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>
 <20141024154353.GE20534@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1410241751160.22875@kaball.uk.xensource.com> <alpine.DEB.2.02.1410241828110.22875@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Stefano Stabellini wrote:
> On Fri, 24 Oct 2014, Stefano Stabellini wrote:
> > On Fri, 24 Oct 2014, Catalin Marinas wrote:
> > > > However given the timing constraints I hope you would be OK with the
> > > > suboptimal solution for now and create a common is_dma_coherent function
> > > > in 3.19?
> > > 
> > > If you want to push something for 3.18, you could have a temporary
> > > solution but I would prefer a bool or something in the dev_archdata
> > > structure. Another untested patch:
> > > 
> > > diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
> > > index cf98b362094b..243ef256b8c9 100644
> > > --- a/arch/arm64/include/asm/device.h
> > > +++ b/arch/arm64/include/asm/device.h
> > > @@ -21,6 +21,7 @@ struct dev_archdata {
> > >  #ifdef CONFIG_IOMMU_API
> > >  	void *iommu;			/* private IOMMU data */
> > >  #endif
> > > +	bool dma_coherent;
> > >  };
> > >  
> > >  struct pdev_archdata {
> > > diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> > > index adeae3f6f0fc..b6bc4c268878 100644
> > > --- a/arch/arm64/include/asm/dma-mapping.h
> > > +++ b/arch/arm64/include/asm/dma-mapping.h
> > > @@ -54,11 +54,17 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> > >  
> > >  static inline int set_arch_dma_coherent_ops(struct device *dev)
> > >  {
> > > +	dev->dev_archdata.dma_coherent = true;
> > >  	set_dma_ops(dev, &coherent_swiotlb_dma_ops);
> > >  	return 0;
> > >  }
> > >  #define set_arch_dma_coherent_ops	set_arch_dma_coherent_ops
> > >  
> > > +static inline int is_device_dma_coherent(struct device *dev)
> > > +{
> > > +	return dev->dev_archdata.dma_coherent;
> > > +}
> > > +
> > >  #include <asm-generic/dma-mapping-common.h>
> > >  
> > >  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> > > 
> > > 
> > > This way you don't have to test for swiotlb vs iommu ops (we don't have
> > > the latter yet on arm64 but they are coming).
 
Your suggestions and looking more at the code gave me another idea, that
I think is clean and at the same time suitable for 3.18.
What do you think of the following? It is simple, self-contained and
doesn't need a new flag in struct device.


diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 6153d61..2b259f1 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -2,10 +2,16 @@
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/of_address.h>
 
 #include <xen/features.h>
 
 
+static inline bool is_dma_coherent(struct device *dev)
+{
+	return of_dma_is_coherent(dev->of_node);
+}
+
 /* functions called by SWIOTLB */
 
 static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
