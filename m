Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3FZODs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:03:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:03:46 -0400
Date: Wed, 26 Jun 2013 10:03:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: make compact dma scatter lists creation work
 with SWIOTLB backend.
Message-ID: <20130626140324.GE4222@phenom.dumpdata.com>
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
 <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
 <20130624170912.GH5823@phenom.ffwll.local>
 <20130624173227.GA24626@phenom.dumpdata.com>
 <CAKMK7uGPeAXmm21KCK4ZfqrynykyKCjn5dZVTsBheQ4JnaoW=A@mail.gmail.com>
 <20130624183409.GA25015@phenom.dumpdata.com>
 <CAPM=9tx2pquifzbSEE7DNZB1uLpWGRPqEmE3Dt-AOOcL_9FOng@mail.gmail.com>
 <4f8c7d81-f0c4-41b7-a931-f84c190f806c@email.android.com>
 <CAPM=9tyP+Rmo-4=tgiRAMiO+4DnhqX-ogjVv8zoagu+6EMZMvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyP+Rmo-4=tgiRAMiO+4DnhqX-ogjVv8zoagu+6EMZMvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>Dave.
> >
> > Hey Dave
> > Of course I will investigate.
> >
> > The SWIOTLB is unfortunately used because it is a fallback (and I am the maintainer of it) and if a real IOMMU is activated it can be mitigated differently. When you say 'passed through'  you mean in terms of an IOMMU in a guest? There are no IOMMU inside a guest when passing in a PCI device.
> 
> I just don't understand why anyone would see swiotlb in this case, the
> host would be using hw iommu, why would the guest then need to use a
> bounce buffer?

Hey Dave,

Sorry for the late response.

The guest has no concept of the HW IOMMU as it is not 'emulated' or there
are no plumbing for it to interface with the host's IOMMU. It means that if
it has more than 4GB it will automatically turn on SWIOTLB (b/c hey it
might have 32-bit capable devices and it needs to bounce buffer the data
to an area above 4GB).

Normally the SWIOTLB bounce buffers won't be used unless:
 a) the pages are not contingous. This is not a case for HVM guests (as
   it _thinks_ its PFN are always contingous - albeit in reality in might
   not be, but that is the job of the host EPT/IOMMU to construct this fake
   view), but for Xen PV - which has a mapping of the PFN -> machine addresses -
   it _knows_ that the real machine address of a PFN. And as guests are
   created from random swaths of memory - some of the PFNs might be
   contingous but some might not. In other words for RAM regions:

      pfn_to_mfn(pfn + 1) != (pfn_to_mfn(pfn) + 1)

   mfn is the real physical address bitshifted (PAGE_SHIFT). For HVM guest:
   (pfn_to_mfn returns the pfn value, so the above formula is):

       pfn+1 == pfn+1

   If this does not make any sense to you - that is OK :-) I can try to
   explain more but it might just put you to sleep - in which case just
   think: "Xen PV CPU physical addresses are not the same as the bus(DMA)
   addresses." - which means it is similar to Sparc platforms or other
   platforms where the IOMMU has no address CPU->PCI machinery.

 b) the pages are not page aligned. Less of an issue, but still can
   come up.

 c) the DMA mask of the PCI device is 32-bit (common with USB devices, not
   so often with graphic cards). But hey - there are quirks that sometimes
    make graphics card DMA up only to certain bitness.

 d). user provided 'swiotlb=force' and now everything is going through
   the bounce buffer.

The nice solution is to have a virtualization aware version of IOMMU in the
guest that will disable SWIOTLB (or use it only in fallback). The AMD folks
were thinking about that for KVM, but nothing came out of that. The Citrix
folks are looking at that for Xen, but nothing yet (thought I did see some
RFC patches).

> 
> >
> > Let me start on a new thread on this when I have gotten my head wrapped around dma  buf.

Hadn't gotten to that yet.
> >
> > Thanks and sorry for getting to this so late in the cycle.  New laptop and playing with it and that triggered me finding this.
> 
> My main worry is this will regress things for people with swiotlb
> enabled even if the gpu isn't using it, granted it won't be any slower
> than before so probably not something I care about now if I know
> you'll narrow down why all this is necessary later.

I am not sure how it would? The patch makes the i915 construct the
scatter gather list as it was in v3.9. So it _should_ not impact it
negatively. I was trying to follow the spirit of doing a partial revert
as close as possible so that the risk of regression would be nil.

To summarize, I think (and please correct me if I am mistaken):
 - You or Daniel are thinking to take this patch for v3.10 or v3.11
   (and if in v3.11 then tack on stable@vger.kernel.org).

 - You will tell defer all SWIOTLB related issues to me. In other words
   if you see something that is i915 and swiotlb, you will happily shout
   "Konrad! Tag!" and wash your hands. Hopefully you can also send me
   some of the past bugs that you suspect are SWIOTLB related.

 - You expect me to look at dma-buf and figure out how it can coexist with
   SWIOTLB.

Sounds about right?
> 
> Dave.
