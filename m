Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3ILOub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:50:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51397 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3ILOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:50:29 -0400
X-IronPort-AV: E=Sophos;i="4.90,891,1371081600"; 
   d="scan'208";a="50891210"
Date: Thu, 12 Sep 2013 15:44:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
In-Reply-To: <20130912135347.GA23425@darko.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1309121541290.32236@kaball.uk.xensource.com>
References: <20130906141444.GE1946@arm.com> <alpine.DEB.2.02.1309061554260.6397@kaball.uk.xensource.com> <20130906155928.GH1946@arm.com> <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com> <20130906162018.GJ1946@arm.com>
 <alpine.DEB.2.02.1309061740050.6397@kaball.uk.xensource.com> <8492887B-2509-42B5-A5F9-A711C519D912@arm.com> <alpine.DEB.2.02.1309091732230.6397@kaball.uk.xensource.com> <20130911093646.GA26777@darko.cambridge.arm.com> <alpine.DEB.2.02.1309111825210.32236@kaball.uk.xensource.com>
 <20130912135347.GA23425@darko.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Catalin Marinas wrote:
> On Wed, Sep 11, 2013 at 06:34:17PM +0100, Stefano Stabellini wrote:
> > On Wed, 11 Sep 2013, Catalin Marinas wrote:
> > >  static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> > >  {
> > >  	BUG_ON(!dev);
> > > @@ -32,7 +39,7 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> > >  
> > >  static inline int dma_set_mask(struct device *dev, u64 mask)
> > >  {
> > > -	return get_dma_ops(dev)->set_dma_mask(dev, mask);
> > > +	return __get_dma_ops(dev)->set_dma_mask(dev, mask);
> > >  }
> > >  
> > >  #ifdef __arch_page_to_dma
> > 
> > I don't understand the reason for this change though: shouldn't
> > set_dma_mask go via the "default" (whatever that is), like the others?
> 
> Under Xen, this would mean xen_dma_ops->set_dma_mask(). I thought you
> want to set the default dma address.
> 
> I can see why you may want set_dma_mask() for xen_dma_ops but in also
> needs to be passed to __get_dma_ops(dev)->set_dma_ops() otherwise the
> actual dma_alloc_attrs() will miss the mask (and on arm64 it does
> bouncing via swiotlb).
 
xen_dma_ops->set_dma_mask() is implemented by
drivers/xen/swiotlb-xen.c:xen_swiotlb_set_dma_mask (provided by this
patch series). The function takes care of setting:

*dev->dma_mask = dma_mask;

I think that should be enough to make dma_alloc_attrs happy.
