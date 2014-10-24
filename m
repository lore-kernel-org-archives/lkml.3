Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaJXLma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:42:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57051 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaJXLm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:42:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,779,1406592000"; 
   d="scan'208";a="185857387"
Date: Fri, 24 Oct 2014 12:39:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
In-Reply-To: <20141024104746.GC1955@localhost>
Message-ID: <alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com> <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141010120702.GI7755@arm.com> <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com> <20141013125725.GA19156@arm.com> <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com> <alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com> <alpine.DEB.2.02.1410231516450.876@kaball.uk.xensource.com>
 <20141024104746.GC1955@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Catalin Marinas wrote:
> On Thu, Oct 23, 2014 at 03:22:27PM +0100, Stefano Stabellini wrote:
> > On Wed, 22 Oct 2014, Stefano Stabellini wrote:
> > > On Mon, 13 Oct 2014, Stefano Stabellini wrote:
> > > > On Mon, 13 Oct 2014, Will Deacon wrote:
> > > > > On Mon, Oct 13, 2014 at 12:16:14PM +0100, Stefano Stabellini wrote:
> > > > > > On Fri, 10 Oct 2014, Stefano Stabellini wrote:
> > > > > > > On Fri, 10 Oct 2014, Will Deacon wrote:
> > > > > > > > On Fri, Oct 10, 2014 at 12:51:44PM +0100, Stefano Stabellini wrote:
> > > > > > > > > Introduce a function to check whether a device is dma coherent.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > > > > > CC: linux@arm.linux.org.uk
> > > > > > > > > CC: catalin.marinas@arm.com
> > > > > > > > > CC: will.deacon@arm.com
> > > > > > > > > CC: linux-arm-kernel@lists.infradead.org
> > > > > > > > > ---
> > > > > > > > >  arch/arm/include/asm/dma-mapping.h   |    6 ++++++
> > > > > > > > >  arch/arm64/include/asm/dma-mapping.h |    5 +++++
> > > > > > > > >  2 files changed, 11 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > > > > > > > > index c45b61a..bededbb 100644
> > > > > > > > > --- a/arch/arm/include/asm/dma-mapping.h
> > > > > > > > > +++ b/arch/arm/include/asm/dma-mapping.h
> > > > > > > > > @@ -126,6 +126,12 @@ static inline int set_arch_dma_coherent_ops(struct device *dev)
> > > > > > > > >  	set_dma_ops(dev, &arm_coherent_dma_ops);
> > > > > > > > >  	return 0;
> > > > > > > > >  }
> > > > > > > > > +
> > > > > > > > > +static inline bool is_dma_coherent(struct device *dev)
> > > > > > > > > +{
> > > > > > > > > +    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
> > > > > > > > > +}
> > > > > > > > 
> > > > > > > > Hmm, what about the IOMMU ops?
> > > > > > > 
> > > > > > > Maybe I should check __generic_dma_ops(dev) != &arm_dma_ops?
> > > > > > > Do you have any better suggestions?
> > > > > > 
> > > > > > ping?
> > > > > 
> > > > > Without any clear idea about why this is needed or how it's used, I don't
> > > > > have any better ideas.
> > > > 
> > > > Thanks for the quick reply.
> > > > 
> > > > It is used in dom0 to figure out whether the device is not coherent: in
> > > > that case Dom0 is going to issue an hypercall and Xen is going to
> > > > execute the required cache maintenance operations on Dom0's behalf.
> > > > 
> > > > In practice for this use case iommu_dma_ops is not a problem, as the
> > > > device is never going to appear as being behind an SMMU in dom0.
> > > 
> > > re-ping?
> > 
> > I don't mean to be pushy but this series is required to fix a regression
> > that causes dom0 to crash when running as dom0 on Xen on ARM if
> > non-coherent devices are present on the platform.
> 
> Sorry for ignoring it but I don't fully understand how Xen works,
> especially this DMA stuff. I recall some blogs you wrote but I don't
> have time to re-read them (and I'm on holiday next week).

No worries.


> I think a better way would be some Xen hook around
> set_arch_dma_coherent_ops(). Does Xen have its own device tracking
> structures? If not, you may be able to add another bitfield to the
> kernel one.

We don't have an additional device tracking struct on Xen.
I agree that a new bit somewhere would be the best solution, but I am
not sure where. Maybe in dev_archdata under arm and arm64? After all it
is already used to keep pointers to dma and coherency related
structures.

However given the timing constraints I hope you would be OK with the
suboptimal solution for now and create a common is_dma_coherent function
in 3.19?
