Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3HFOOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:14:39 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47552 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3HFOOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <1375791502.4276.38.camel@weser.hi.pengutronix.de>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<1375791502.4276.38.camel@weser.hi.pengutronix.de>
Date: Tue, 6 Aug 2013 10:14:35 -0400
Message-ID: <CAF6AEGvgqsS4Ht6xuACbywTorRiCwHcUaYPji9dRP6AM3Ag-ww@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 0/1] drm/pl111: Initial drm/kms driver for pl111
From: Rob Clark <robdclark@gmail.com>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Tom Cooksey <tom.cooksey@arm.com>, linux-fbdev@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 8:18 AM, Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Dienstag, den 06.08.2013, 12:31 +0100 schrieb Tom Cooksey:
>> Hi Rob,
>>
>> +lkml
>>
>> > >> On Fri, Jul 26, 2013 at 11:58 AM, Tom Cooksey <tom.cooksey@arm.com>
>> > >> wrote:
>> > >> >> >  * It abuses flags parameter of DRM_IOCTL_MODE_CREATE_DUMB to
>> > >> >> >    also allocate buffers for the GPU. Still not sure how to
>> > >> >> >    resolve this as we don't use DRM for our GPU driver.
>> > >> >>
>> > >> >> any thoughts/plans about a DRM GPU driver?  Ideally long term
>> > >> >> (esp. once the dma-fence stuff is in place), we'd have
>> > >> >> gpu-specific drm (gpu-only, no kms) driver, and SoC/display
>> > >> >> specific drm/kms driver, using prime/dmabuf to share between
>> > >> >> the two.
>> > >> >
>> > >> > The "extra" buffers we were allocating from armsoc DDX were really
>> > >> > being allocated through DRM/GEM so we could get an flink name
>> > >> > for them and pass a reference to them back to our GPU driver on
>> > >> > the client side. If it weren't for our need to access those
>> > >> > extra off-screen buffers with the GPU we wouldn't need to
>> > >> > allocate them with DRM at all. So, given they are really "GPU"
>> > >> > buffers, it does absolutely make sense to allocate them in a
>> > >> > different driver to the display driver.
>> > >> >
>> > >> > However, to avoid unnecessary memcpys & related cache
>> > >> > maintenance ops, we'd also like the GPU to render into buffers
>> > >> > which are scanned out by the display controller. So let's say
>> > >> > we continue using DRM_IOCTL_MODE_CREATE_DUMB to allocate scan
>> > >> > out buffers with the display's DRM driver but a custom ioctl
>> > >> > on the GPU's DRM driver to allocate non scanout, off-screen
>> > >> > buffers. Sounds great, but I don't think that really works
>> > >> > with DRI2. If we used two drivers to allocate buffers, which
>> > >> > of those drivers do we return in DRI2ConnectReply? Even if we
>> > >> > solve that somehow, GEM flink names are name-spaced to a
>> > >> > single device node (AFAIK). So when we do a DRI2GetBuffers,
>> > >> > how does the EGL in the client know which DRM device owns GEM
>> > >> > flink name "1234"? We'd need some pretty dirty hacks.
>> > >>
>> > >> You would return the name of the display driver allocating the
>> > >> buffers.  On the client side you can use generic ioctls to go from
>> > >> flink -> handle -> dmabuf.  So the client side would end up opening
>> > >> both the display drm device and the gpu, but without needing to know
>> > >> too much about the display.
>> > >
>> > > I think the bit I was missing was that a GEM bo for a buffer imported
>> > > using dma_buf/PRIME can still be flink'd. So the display controller's
>> > > DRM driver allocates scan-out buffers via the DUMB buffer allocate
>> > > ioctl. Those scan-out buffers than then be exported from the
>> > > dispaly's DRM driver and imported into the GPU's DRM driver using
>> > > PRIME. Once imported into the GPU's driver, we can use flink to get a
>> > > name for that buffer within the GPU DRM driver's name-space to return
>> > > to the DRI2 client. That same namespace is also what DRI2 back-
>> > > buffers are allocated from, so I think that could work... Except...
>> >
>> > (and.. the general direction is that things will move more to just use
>> > dmabuf directly, ie. wayland or dri3)
>>
>> I agree, DRI2 is the only reason why we need a system-wide ID. I also
>> prefer buffers to be passed around by dma_buf fd, but we still need to
>> support DRI2 and will do for some time I expect.
>>
>>
>>
>> > >> > Anyway, that latter case also gets quite difficult. The "GPU"
>> > >> > DRM driver would need to know the constraints of the display
>> > >> > controller when allocating buffers intended to be scanned out.
>> > >> > For example, pl111 typically isn't behind an IOMMU and so
>> > >> > requires physically contiguous memory. We'd have to teach the
>> > >> > GPU's DRM driver about the constraints of the display HW. Not
>> > >> > exactly a clean driver model. :-(
>> > >> >
>> > >> > I'm still a little stuck on how to proceed, so any ideas
>> > >> > would greatly appreciated! My current train of thought is
>> > >> > having a kind of SoC-specific DRM driver which allocates
>> > >> > buffers for both display and GPU within a single GEM
>> > >> > namespace. That SoC-specific DRM driver could then know the
>> > >> > constraints of both the GPU and the display HW. We could then
>> > >> > use PRIME to export buffers allocated with the SoC DRM driver
>> > >> > and import them into the GPU and/or display DRM driver.
>> > >>
>> > >> Usually if the display drm driver is allocating the buffers that
>> > >> might be scanned out, it just needs to have minimal knowledge of
>> > >> the GPU (pitch alignment constraints).  I don't think we need a
>> > >> 3rd device just to allocate buffers.
>> > >
>> > > While Mali can render to pretty much any buffer, there is a mild
>> > > performance improvement to be had if the buffer stride is aligned to
>> > > the AXI bus's max burst length when drawing to the buffer.
>> >
>> > I suspect the display controllers might frequently benefit if the
>> > pitch is aligned to AXI burst length too..
>>
>> If the display controller is going to be reading from linear memory
>> I don't think it will make much difference - you'll just get an extra
>> 1-2 bus transactions per scanline. With a tile-based GPU like Mali,
>> you get those extra transactions per _tile_ scan-line and as such,
>> the overhead is more pronounced.
>>
>>
>>
>> > > So in some respects, there is a constraint on how buffers which will
>> > > be drawn to using the GPU are allocated. I don't really like the idea
>> > > of teaching the display controller DRM driver about the GPU buffer
>> > > constraints, even if they are fairly trivial like this. If the same
>> > > display HW IP is being used on several SoCs, it seems wrong somehow
>> > > to enforce those GPU constraints if some of those SoCs don't have a
>> > > GPU.
>> >
>> > Well, I suppose you could get min_pitch_alignment from devicetree, or
>> > something like this..
>> >
>> > In the end, the easy solution is just to make the display allocate to
>> > the worst-case pitch alignment.  In the early days of dma-buf
>> > discussions, we kicked around the idea of negotiating or
>> > programatically describing the constraints, but that didn't really
>> > seem like a bounded problem.
>>
>> Yeah - I was around for some of those discussions and agree it's not
>> really an easy problem to solve.
>>
>>
>>
>> > > We may also then have additional constraints when sharing buffers
>> > > between the display HW and video decode or even camera ISP HW.
>> > > Programmatically describing buffer allocation constraints is very
>> > > difficult and I'm not sure you can actually do it - there's some
>> > > pretty complex constraints out there! E.g. I believe there's a
>> > > platform where Y and UV planes of the reference frame need to be in
>> > > separate DRAM banks for real-time 1080p decode, or something like
>> > > that?
>> >
>> > yes, this was discussed.  This is different from pitch/format/size
>> > constraints.. it is really just a placement constraint (ie. where do
>> > the physical pages go).  IIRC the conclusion was to use a dummy
>> > devices with it's own CMA pool for attaching the Y vs UV buffers.
>> >
>> > > Anyway, I guess my point is that even if we solve how to allocate
>> > > buffers which will be shared between the GPU and display HW such that
>> > > both sets of constraints are satisfied, that may not be the end of
>> > > the story.
>> > >
>> >
>> > that was part of the reason to punt this problem to userspace ;-)
>> >
>> > In practice, the kernel drivers doesn't usually know too much about
>> > the dimensions/format/etc.. that is really userspace level knowledge.
>> > There are a few exceptions when the kernel needs to know how to setup
>> > GTT/etc for tiled buffers, but normally this sort of information is up
>> > at the next level up (userspace, and drm_framebuffer in case of
>> > scanout).  Userspace media frameworks like GStreamer already have a
>> > concept of format/caps negotiation.  For non-display<->gpu sharing, I
>> > think this is probably where this sort of constraint negotiation
>> > should be handled.
>>
>> I agree that user-space will know which devices will access the buffer
>> and thus can figure out at least a common pixel format. Though I'm not
>> so sure userspace can figure out more low-level details like alignment
>> and placement in physical memory, etc.
>>
>> Anyway, assuming user-space can figure out how a buffer should be
>> stored in memory, how does it indicate this to a kernel driver and
>> actually allocate it? Which ioctl on which device does user-space
>> call, with what parameters? Are you suggesting using something like
>> ION which exposes the low-level details of how buffers are laid out in
>> physical memory to userspace? If not, what?
>>
>
> I strongly disagree with exposing low-level hardware details like tiling
> to userspace. If we have to do the negotiation of those things in
> userspace we will end up with having to pipe those information through
> things like the wayland protocol. I don't see how this could ever be
> considered a good idea.

well, unless userspace mmap's via a de-tiling gart type thing, I don't
think tiling can be invisible to userspace.

But if two GPU's have some overlap in supportable tiled formats, and
you have one gpu doing app and one doing compositor, and you want to
use tiling for the shared buffers, you need something in the wayland
protocol to figure out what the common supported formats are between
the two sides.  I suppose it shouldn't be too hard to add a
standardized (cross-driver) format-negotiation protocol, and in the
absence of that fallback to non tiled format for shared buffers.

> I would rather see kernel drivers negotiating those things at dmabuf
> attach time in way invisible to userspace. I agree that this negotiation
> thing isn't easy to get right for the plethora of different hardware
> constraints we see today, but I would rather see this in-kernel, where
> we have the chance to fix things up if needed, than in a fixed userspace
> interface.

Well, if you can think of a sane way to add that to dev->dma_params,
and if it isn't visible if userspace mmap's a buffer, then we could
handle that in the kernel.  But I don't think that will be the case.

BR,
-R

>
> Regards,
> Lucas
> --
> Pengutronix e.K.                           | Lucas Stach                 |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
