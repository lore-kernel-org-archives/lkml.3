Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3IFQVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:21:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51813 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515Ab3IFQVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:21:04 -0400
Date: Fri, 6 Sep 2013 17:20:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130906162018.GJ1946@arm.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-11-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130905160905.GI11887@arm.com>
 <alpine.DEB.2.02.1309051742390.6397@kaball.uk.xensource.com>
 <20130906141444.GE1946@arm.com>
 <alpine.DEB.2.02.1309061554260.6397@kaball.uk.xensource.com>
 <20130906155928.GH1946@arm.com>
 <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:09:52PM +0100, Stefano Stabellini wrote:
> On Fri, 6 Sep 2013, Catalin Marinas wrote:
> > On Fri, Sep 06, 2013 at 03:59:02PM +0100, Stefano Stabellini wrote:
> > > On Fri, 6 Sep 2013, Catalin Marinas wrote:
> > > > On Thu, Sep 05, 2013 at 05:43:33PM +0100, Stefano Stabellini wrote:
> > > > > On Thu, 5 Sep 2013, Catalin Marinas wrote:
> > > > > > On Thu, Aug 29, 2013 at 07:32:32PM +0100, Stefano Stabellini wrote:
> > > > > > > xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> > > > > > > and devices. On native x86 and ARMv8 is sufficient to call
> > > > > > > __get_free_pages in order to get a coherent buffer, while on ARM we need
> > > > > > > to call arm_dma_ops.alloc.
> > > > > > 
> > > > > > Don't bet on this for ARMv8. It's not mandated for the architecture, so
> > > > > > at some point some SoC will require non-cacheable buffers for coherency.
> > > > > 
> > > > > I see.
> > > > > Would it be better if I implemented xen_alloc_coherent_pages on armv8 by
> > > > > calling arm64_swiotlb_dma_ops.alloc?
> > > > 
> > > > What does this buffer do exactly? Is it allocated by guests?
> > > 
> > > It is allocated by Dom0 to do DMA to/from a device.
> > > It is the buffer that is going to be returned by dma_map_ops.alloc to
> > > the caller:
> > > 
> > > On x86:
> > > dma_map_ops.alloc -> xen_swiotlb_alloc_coherent -> xen_alloc_coherent_pages -> __get_free_pages
> > > 
> > > On ARM:
> > > dma_map_ops.alloc -> xen_swiotlb_alloc_coherent -> xen_alloc_coherent_pages -> arm_dma_ops.alloc
> > > 
> > > On ARM64
> > > dma_map_ops.alloc -> xen_swiotlb_alloc_coherent -> xen_alloc_coherent_pages -> ????
> > 
> > OK, I'm getting more confused. Do all the above calls happen in the
> > guest, Dom0, or a mix?
> 
> I guess the confusion comes from a difference in terminology: dom0 is a
> guest like the others, just a bit more privileged. We usually call domU
> a normal unprivileged guest.

Thanks for the explanation.

> The above calls would happen in Dom0 (when an SMMU is not available).

So for Dom0, are there cases when it needs xen_swiotlb_alloc_coherent()
and other cases when it needs the arm_dma_ops.alloc? In Dom0 could we
not always use the default dma_alloc_coherent()?

> They could also happen in a DomU if we assign a physical device to it
> (and an SMMU is not available).

The problem is that you don't necessarily know one kind of coherency you
know for a physical device. As I said, we plan to do this DT-driven.

-- 
Catalin
