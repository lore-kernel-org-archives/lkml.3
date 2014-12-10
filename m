Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaLJNqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:46:49 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48300 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaLJNqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:46:47 -0500
Date: Wed, 10 Dec 2014 14:47:19 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC 1/4] dma-buf: Add constraints sharing information
Message-ID: <20141210134719.GX27182@phenom.ffwll.local>
Mail-Followup-To: Sumit Semwal <sumit.semwal@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
 <1412971678-4457-2-git-send-email-sumit.semwal@linaro.org>
 <20141011185502.GH26941@phenom.ffwll.local>
 <CAO_48GH2JmyT-qLyJk=H=rVkds79Gr2MsD3u+1pV48ta78q7OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GH2JmyT-qLyJk=H=rVkds79Gr2MsD3u+1pV48ta78q7OQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 07:01:16PM +0530, Sumit Semwal wrote:
> Hi Daniel,
> 
> Thanks a bunch for your review comments! A few comments, post our
> discussion at LPC;
> 
> On 12 October 2014 at 00:25, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Sat, Oct 11, 2014 at 01:37:55AM +0530, Sumit Semwal wrote:
> >> At present, struct device lacks a mechanism of exposing memory
> >> access constraints for the device.
> >>
> >> Consequently, there is also no mechanism to share these constraints
> >> while sharing buffers using dma-buf.
> >>
> >> If we add support for sharing such constraints, we could use that
> >> to try to collect requirements of different buffer-sharing devices
> >> to allocate buffers from a pool that satisfies requirements of all
> >> such devices.
> >>
> >> This is an attempt to add this support; at the moment, only a bitmask
> >> is added, but if post discussion, we realise we need more information,
> >> we could always extend the definition of constraint.
> >>
> >> A new dma-buf op is also added, to allow exporters to interpret or decide
> >> on constraint-masks on their own. A default implementation is provided to
> >> just AND (&) all the constraint-masks.
> >>
> >> What constitutes a constraint-mask could be left for interpretation on a
> >> per-platform basis, while defining some common masks.
> >>
> >> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: dri-devel@lists.freedesktop.org
> >> Cc: linaro-mm-sig@lists.linaro.org
> >
> > Just a few high-level comments, I'm between conference travel but
> > hopefully I can discuss this a bit at plumbers next week.
> >
> > - I agree that for the insane specific cases we need something opaque like
> >   the access constraints mask you propose here. But for the normal case I
> >   think the existing dma constraints in dma_params would go a long way,
> >   and I think we should look at Rob's RFC from aeons ago to solve those:
> >
> >   https://lkml.org/lkml/2012/7/19/285
> >
> >   With this we should be able to cover the allocation constraints of 90%
> >   of all cases hopefully.
> >
> > - I'm not sure whether an opaque bitmask is good enough really, I suspect
> >   that we also need various priorities between different allocators. With
> >   the option that some allocators are flat-out incompatible.
> 
> Your/Rob's idea to figure out the constraints wrt max number of
> segments in the sg_list can provide, like you said, maybe 80-90% of
> the allocation constraints hopefully. The opaque mask should help for
> the remaining 'crazy' cases, so I'll be glad to merge Rob's and my
> approach on defining the constraints.
> 
> I should think a little bit more about the priority idea that you
> propose here (and in another patch), but atm I am unable to see how
> that could help solve the finding-out-constraints problem.
> >
> > - The big bummer imo with ION is that it fully side-steps, but this
> >   proposal here also seems to add entirely new allocators. My rough idea
> 
> This proposal does borrow this bit from ION, but once we have the
> required changes done in the dma api itself, the allocators can just
> become shims to the dma api allocators (eg dma_alloc_coherent etc) for
> cases where they can be used directly, while leaving provision for any
> crazy platform-specific allocators, without the userspace having to
> worry about it.
> 
> >   was that at allocate/attach time we iterate over all attached devices
> >   like in Rob's patch and compute the most constrained allocation
> >   requirements. Then we pick the underlying dma api allocator for these
> >   constraints. That probably means that we need to open up the dma api a
> >   bit. But I guess for a start we could simply try to allocate from the
> >   most constrained device. Together with the opaque bits you propose here
> >   we could even map additional crazy requirements like that an allocation
> >   must come from a specific memory bank (provided by a special-purpose CMA
> >   region). That might also mean that requirements are exclusive and no
> >   allocation is possible.
> >
> My idea was a little variation on what you said here - rather than do
> compute the most constraint allocation 'after' devices have attached
> (and right now, we don't really have a way to know that - but that's
> another point), I'd proposed to do the compute on each attach request,
> so the requesting drivers can know immediately if the attachment will
> not work for the other currently attached devices.

Well I said allocate/attach ;-) But yeah if we check at attach and reject
anything that doesn't work then there's no need to check again when
allocating, it /should/ work. But perhaps good to be paranoid and check
again.

> > - I'm not sure we should allow drivers to override the access constraint
> >   checks really - the dma_buf interfaces already provide this possibility
> >   through the ->attach callback. In there exporters are allowed to reject
> >   the attachment for any reason whatsover.
> >
> This override the access constraint check is again meant only as a
> helper, but I could sure drop it.
> 
> > - I think we should at least provide a helper implementation to allocate
> >   dma-buffers for multiple devices using the dma constraints logic we
> >   implement here. I think we should even go as far as providing a default
> >   implementation for dma-bufs which uses dma_alloc_coherent and this new
> >   dma contstraints computation code internally. This should be good enough
> 
> Ok, my idea was to keep the allocation helpers separate from dma-buf
> framework - hence the cenalloc idea; if it seems like an extremely
> terrible approach to separate out helpers, I could try and do an RFC
> based on your idea.

Oh, I like helpers, it'd just put them into the dma-buf code and integrate
it directly instead of creating something separate.

> >   for almost all devices, except those that do crazy stuff like swap
> >   support of buffer objects (gem/ttm), virtual hardware buffers (vmwgfx)
> >   or have other special needs (e.g. non-coherent buffers as speed
> >   optimization).
> >
> Cenalloc type of idea could allow for these special needs I think!

Well imo we should aim for 90% first, fix out fallout and then reasses
what's needed. Tends to leat to better design overall.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
