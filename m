Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3FYAGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:06:12 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:47798 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3FYAGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <4f8c7d81-f0c4-41b7-a931-f84c190f806c@email.android.com>
References: <1372088868-23477-1-git-send-email-konrad.wilk@oracle.com>
	<1372088868-23477-2-git-send-email-konrad.wilk@oracle.com>
	<20130624170912.GH5823@phenom.ffwll.local>
	<20130624173227.GA24626@phenom.dumpdata.com>
	<CAKMK7uGPeAXmm21KCK4ZfqrynykyKCjn5dZVTsBheQ4JnaoW=A@mail.gmail.com>
	<20130624183409.GA25015@phenom.dumpdata.com>
	<CAPM=9tx2pquifzbSEE7DNZB1uLpWGRPqEmE3Dt-AOOcL_9FOng@mail.gmail.com>
	<4f8c7d81-f0c4-41b7-a931-f84c190f806c@email.android.com>
Date: Tue, 25 Jun 2013 10:06:08 +1000
Message-ID: <CAPM=9tyP+Rmo-4=tgiRAMiO+4DnhqX-ogjVv8zoagu+6EMZMvw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: make compact dma scatter lists creation work
 with SWIOTLB backend.
From: Dave Airlie <airlied@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:18 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Dave Airlie <airlied@gmail.com> wrote:
>
>>On Tue, Jun 25, 2013 at 4:34 AM, Konrad Rzeszutek Wilk
>><konrad.wilk@oracle.com> wrote:
>>> On Mon, Jun 24, 2013 at 08:26:18PM +0200, Daniel Vetter wrote:
>>>> On Mon, Jun 24, 2013 at 7:32 PM, Konrad Rzeszutek Wilk
>>>> <konrad.wilk@oracle.com> wrote:
>>>> > On Mon, Jun 24, 2013 at 07:09:12PM +0200, Daniel Vetter wrote:
>>>> >> On Mon, Jun 24, 2013 at 11:47:48AM -0400, Konrad Rzeszutek Wilk
>>wrote:
>>>> >> > Git commit 90797e6d1ec0dfde6ba62a48b9ee3803887d6ed4
>>>> >> > ("drm/i915: create compact dma scatter lists for gem objects")
>>makes
>>>> >> > certain assumptions about the under laying DMA API that are not
>>always
>>>> >> > correct.
>>>> >> >
>>>> >> > On a ThinkPad X230 with an Intel HD 4000 with Xen during the
>>bootup
>>>> >> > I see:
>>>> >> >
>>>> >> > [drm:intel_pipe_set_base] *ERROR* pin & fence failed
>>>> >> > [drm:intel_crtc_set_config] *ERROR* failed to set mode on
>>[CRTC:3], err = -28
>>>> >> >
>>>> >> > Bit of debugging traced it down to dma_map_sg failing (in
>>>> >> > i915_gem_gtt_prepare_object) as some of the SG entries were
>>huge (3MB).
>>>> >> >
>>>> >> > That unfortunately are sizes that the SWIOTLB is incapable of
>>handling -
>>>> >> > the maximum it can handle is a an entry of 512KB of virtual
>>contiguous
>>>> >> > memory for its bounce buffer. (See IO_TLB_SEGSIZE).
>>>> >> >
>>>> >> > Previous to the above mention git commit the SG entries were of
>>4KB, and
>>>> >> > the code introduced by above git commit squashed the CPU
>>contiguous PFNs
>>>> >> > in one big virtual address provided to DMA API.
>>>> >> >
>>>> >> > This patch is a simple semi-revert - were we emulate the old
>>behavior
>>>> >> > if we detect that SWIOTLB is online. If it is not online then
>>we continue
>>>> >> > on with the new compact scatter gather mechanism.
>>>> >> >
>>>> >> > An alternative solution would be for the the '.get_pages' and
>>the
>>>> >> > i915_gem_gtt_prepare_object to retry with smaller max gap of
>>the
>>>> >> > amount of PFNs that can be combined together - but with this
>>issue
>>>> >> > discovered during rc7 that might be too risky.
>>>> >> >
>>>> >> > Reported-and-Tested-by: Konrad Rzeszutek Wilk
>><konrad.wilk@oracle.com>
>>>> >> > CC: Chris Wilson <chris@chris-wilson.co.uk>
>>>> >> > CC: Imre Deak <imre.deak@intel.com>
>>>> >> > CC: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>> >> > CC: David Airlie <airlied@linux.ie>
>>>> >> > CC: <dri-devel@lists.freedesktop.org>
>>>> >> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>> >>
>>>> >> Two things:
>>>> >
>>>> > Hey Daniel,
>>>> >
>>>> >>
>>>> >> - SWIOTLB usage should seriously blow up all over the place in
>>drm/i915.
>>>> >>   We really rely on the everywhere else true fact that the pages
>>and their
>>>> >>   dma mapping point at the same backing storage.
>>>> >
>>>> > It works. As in, it seems to work for just a normal desktop user.
>>I don't
>>>> > see much of dma_sync_* sprinkled around the drm/i915 so I would
>>think that
>>>> > there are some issues would be hit as well - but at the first
>>glance
>>>> > when using it on a laptop it looks OK.
>>>>
>>>> Yeah, we have a pretty serious case of "roll our own coherency
>>stuff".
>>>> The biggest reason is that for a long time i915.ko didn't care one
>>bit
>>>> about iommus, and the thing we care about (flushing cpu caches for
>>>> dma) isn't supported on x86 since x86 every dma is coherent (well,
>>not
>>>> quite, but we don't have support for it). I think longer-term it
>>would
>>>> make sense to move the clfushing we're doing into the dma layer.
>>>>
>>>> >> - How is this solved elsewhere when constructing sg tables? Or
>>are we
>>>> >>   really the only guys who try to construct such big sg entries?
>>I
>>>> >>   expected somewhat that the dma mapping backed would fill in the
>>segment
>>>> >>   limits accordingly, but I haven't found anything really on a
>>quick
>>>> >>   search.
>>>> >
>>>> > The TTM layer (so radeon, nouveau) uses pci_alloc_coherent which
>>will
>>>> > construct the dma mapped pages. That allows it to construct
>>"SWIOTLB-approved"
>>>> > pages that won't need to go through dma_map/dma_unmap as they are
>>>> > already mapped and ready to go.
>>>> >
>>>> > Coming back to your question - I think that i915 is the one that
>>I've
>>>> > encountered.
>>>>
>>>> That's a bit surprising. With dma_buf graphics people will use sg
>>>> tables much more (there's even a nice sg_alloc_table_from_pages
>>helper
>>>> to construct them), and those sg tables tend to have large segments.
>>I
>>>> guess we need some more generic solution here ...
>>>
>>> Yes. I don't grok the full picture yet so I am not sure how to help
>>with
>>> this right now. Is there a roadmap or Wiki on how this was
>>envisioned?
>>>>
>>>> For now I guess we can live with your CONFIG_SWIOTLB hack.
>>>> -Daniel
>>>
>>> OK, I read that as an Ack-ed-by. Should I send the patch to Dave
>>Airlie
>>> in a GIT PULL or some other way to make it on the v3.10-rc7 train?
>>
>>I don't like this at all, I'll accept the patch on the condition you
>>investigate further :-)
>>
>>If you are using swiotlb on i915 things should break, I know I've
>>investigated problems before where swiotlb was being incorrectly used
>>due to page masks or other issues. Shouldn't you be passing through
>>using the real iommu?
>>
>>Dave.
>
> Hey Dave
> Of course I will investigate.
>
> The SWIOTLB is unfortunately used because it is a fallback (and I am the maintainer of it) and if a real IOMMU is activated it can be mitigated differently. When you say 'passed through'  you mean in terms of an IOMMU in a guest? There are no IOMMU inside a guest when passing in a PCI device.

I just don't understand why anyone would see swiotlb in this case, the
host would be using hw iommu, why would the guest then need to use a
bounce buffer?

>
> Let me start on a new thread on this when I have gotten my head wrapped around dma  buf.
>
> Thanks and sorry for getting to this so late in the cycle.  New laptop and playing with it and that triggered me finding this.

My main worry is this will regress things for people with swiotlb
enabled even if the gpu isn't using it, granted it won't be any slower
than before so probably not something I care about now if I know
you'll narrow down why all this is necessary later.

Dave.
