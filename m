Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3FXSef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:34:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FXSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:34:32 -0400
Date: Mon, 24 Jun 2013 14:34:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>, Dave Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: make compact dma scatter lists creation work
 with SWIOTLB backend.
Message-ID: <20130624183409.GA25015@phenom.dumpdata.com>
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
 <1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
 <20130624170912.GH5823@phenom.ffwll.local>
 <20130624173227.GA24626@phenom.dumpdata.com>
 <CAKMK7uGPeAXmm21KCK4ZfqrynykyKCjn5dZVTsBheQ4JnaoW=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGPeAXmm21KCK4ZfqrynykyKCjn5dZVTsBheQ4JnaoW=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 08:26:18PM +0200, Daniel Vetter wrote:
> On Mon, Jun 24, 2013 at 7:32 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Mon, Jun 24, 2013 at 07:09:12PM +0200, Daniel Vetter wrote:
> >> On Mon, Jun 24, 2013 at 11:47:48AM -0400, Konrad Rzeszutek Wilk wrote:
> >> > Git commit 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
> >> > ("drm/i915: create compact dma scatter lists for gem objects") makes
> >> > certain assumptions about the under laying DMA API that are not always
> >> > correct.
> >> >
> >> > On a ThinkPad X230 with an Intel HD 4000 with Xen during the bootup
> >> > I see:
> >> >
> >> > [drm:intel_pipe_set_base] *ERROR* pin & fence failed
> >> > [drm:intel_crtc_set_config] *ERROR* failed to set mode on [CRTC:3], err = -28
> >> >
> >> > Bit of debugging traced it down to dma_map_sg failing (in
> >> > i915_gem_gtt_prepare_object) as some of the SG entries were huge (3MB).
> >> >
> >> > That unfortunately are sizes that the SWIOTLB is incapable of handling -
> >> > the maximum it can handle is a an entry of 512KB of virtual contiguous
> >> > memory for its bounce buffer. (See IO_TLB_SEGSIZE).
> >> >
> >> > Previous to the above mention git commit the SG entries were of 4KB, and
> >> > the code introduced by above git commit squashed the CPU contiguous PFNs
> >> > in one big virtual address provided to DMA API.
> >> >
> >> > This patch is a simple semi-revert - were we emulate the old behavior
> >> > if we detect that SWIOTLB is online. If it is not online then we continue
> >> > on with the new compact scatter gather mechanism.
> >> >
> >> > An alternative solution would be for the the '.get_pages' and the
> >> > i915_gem_gtt_prepare_object to retry with smaller max gap of the
> >> > amount of PFNs that can be combined together - but with this issue
> >> > discovered during rc7 that might be too risky.
> >> >
> >> > Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> > CC: Chris Wilson <chris@chris-wilson.co.uk>
> >> > CC: Imre Deak <imre.deak@intel.com>
> >> > CC: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> > CC: David Airlie <airlied@linux.ie>
> >> > CC: <dri-devel@lists.freedesktop.org>
> >> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>
> >> Two things:
> >
> > Hey Daniel,
> >
> >>
> >> - SWIOTLB usage should seriously blow up all over the place in drm/i915.
> >>   We really rely on the everywhere else true fact that the pages and their
> >>   dma mapping point at the same backing storage.
> >
> > It works. As in, it seems to work for just a normal desktop user. I don't
> > see much of dma_sync_* sprinkled around the drm/i915 so I would think that
> > there are some issues would be hit as well - but at the first glance
> > when using it on a laptop it looks OK.
> 
> Yeah, we have a pretty serious case of "roll our own coherency stuff".
> The biggest reason is that for a long time i915.ko didn't care one bit
> about iommus, and the thing we care about (flushing cpu caches for
> dma) isn't supported on x86 since x86 every dma is coherent (well, not
> quite, but we don't have support for it). I think longer-term it would
> make sense to move the clfushing we're doing into the dma layer.
> 
> >> - How is this solved elsewhere when constructing sg tables? Or are we
> >>   really the only guys who try to construct such big sg entries? I
> >>   expected somewhat that the dma mapping backed would fill in the segment
> >>   limits accordingly, but I haven't found anything really on a quick
> >>   search.
> >
> > The TTM layer (so radeon, nouveau) uses pci_alloc_coherent which will
> > construct the dma mapped pages. That allows it to construct "SWIOTLB-approved"
> > pages that won't need to go through dma_map/dma_unmap as they are
> > already mapped and ready to go.
> >
> > Coming back to your question - I think that i915 is the one that I've
> > encountered.
> 
> That's a bit surprising. With dma_buf graphics people will use sg
> tables much more (there's even a nice sg_alloc_table_from_pages helper
> to construct them), and those sg tables tend to have large segments. I
> guess we need some more generic solution here ...

Yes. I don't grok the full picture yet so I am not sure how to help with
this right now. Is there a roadmap or Wiki on how this was envisioned?
> 
> For now I guess we can live with your CONFIG_SWIOTLB hack.
> -Daniel

OK, I read that as an Ack-ed-by. Should I send the patch to Dave Airlie
in a GIT PULL or some other way to make it on the v3.10-rc7 train?

> 
> 
> 
> >>
> >>
> >> Cheers, Daniel
> >>
> >> > ---
> >> >  drivers/gpu/drm/i915/i915_gem.c | 15 ++++++++++++---
> >> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> >> > index 970ad17..7045f45 100644
> >> > --- a/drivers/gpu/drm/i915/i915_gem.c
> >> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> >> > @@ -1801,7 +1801,14 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
> >> >                     gfp |= __GFP_NORETRY | __GFP_NOWARN | __GFP_NO_KSWAPD;
> >> >                     gfp &= ~(__GFP_IO | __GFP_WAIT);
> >> >             }
> >> > -
> >> > +#ifdef CONFIG_SWIOTLB
> >> > +           if (swiotlb_nr_tbl()) {
> >> > +                   st->nents++;
> >> > +                   sg_set_page(sg, page, PAGE_SIZE, 0);
> >> > +                   sg = sg_next(sg);
> >> > +                   continue;
> >> > +           }
> >> > +#endif
> >> >             if (!i || page_to_pfn(page) != last_pfn + 1) {
> >> >                     if (i)
> >> >                             sg = sg_next(sg);
> >> > @@ -1812,8 +1819,10 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
> >> >             }
> >> >             last_pfn = page_to_pfn(page);
> >> >     }
> >> > -
> >> > -   sg_mark_end(sg);
> >> > +#ifdef CONFIG_SWIOTLB
> >> > +   if (!swiotlb_nr_tbl())
> >> > +#endif
> >> > +           sg_mark_end(sg);
> >> >     obj->pages = st;
> >> >
> >> >     if (i915_gem_object_needs_bit17_swizzle(obj))
> >> > --
> >> > 1.8.1.4
> >> >
> >>
> >> --
> >> Daniel Vetter
> >> Software Engineer, Intel Corporation
> >> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> 
> 
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
