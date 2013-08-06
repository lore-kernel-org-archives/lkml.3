Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3HFOkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:40:05 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41396 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3HFOkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <52010257.245fc20a.6ff8.1cfdSMTPIN_ADDED_BROKEN@mx.google.com>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<5200deb3.0b24b40a.3b26.ffffbadeSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvXcpTKrTjhvrycLqab6F9QP5fAk0ZEWxJ-WvE==PiPsA@mail.gmail.com>
	<52010257.245fc20a.6ff8.1cfdSMTPIN_ADDED_BROKEN@mx.google.com>
Date: Tue, 6 Aug 2013 10:40:00 -0400
Message-ID: <CAF6AEGsDA8qdShWdYQRqQ0Czn4mLAe-FoADjZdRFcbeWGGe8Hg@mail.gmail.com>
Subject: Re: [RFC 0/1] drm/pl111: Initial drm/kms driver for pl111
From: Rob Clark <robdclark@gmail.com>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 10:03 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
> Hi Rob,
>
>> >> > We may also then have additional constraints when sharing buffers
>> >> > between the display HW and video decode or even camera ISP HW.
>> >> > Programmatically describing buffer allocation constraints is very
>> >> > difficult and I'm not sure you can actually do it - there's some
>> >> > pretty complex constraints out there! E.g. I believe there's a
>> >> > platform where Y and UV planes of the reference frame need to be
>> >> > in separate DRAM banks for real-time 1080p decode, or something
>> >> > like that?
>> >>
>> >> yes, this was discussed.  This is different from pitch/format/size
>> >> constraints.. it is really just a placement constraint (ie. where
>> >> do the physical pages go).  IIRC the conclusion was to use a dummy
>> >> devices with it's own CMA pool for attaching the Y vs UV buffers.
>> >>
>> >> > Anyway, I guess my point is that even if we solve how to allocate
>> >> > buffers which will be shared between the GPU and display HW such
>> >> > that both sets of constraints are satisfied, that may not be the
>> >> > end of the story.
>> >> >
>> >>
>> >> that was part of the reason to punt this problem to userspace ;-)
>> >>
>> >> In practice, the kernel drivers doesn't usually know too much about
>> >> the dimensions/format/etc.. that is really userspace level
>> >> knowledge. There are a few exceptions when the kernel needs to know
>> >> how to setup GTT/etc for tiled buffers, but normally this sort of
>> >> information is up at the next level up (userspace, and
>> >> drm_framebuffer in case of scanout).  Userspace media frameworks
>> >> like GStreamer already have a concept of format/caps negotiation.
>> >> For non-display<->gpu sharing, I think this is probably where this
>> >> sort of constraint negotiation should be handled.
>> >
>> > I agree that user-space will know which devices will access the
>> > buffer and thus can figure out at least a common pixel format.
>> > Though I'm not so sure userspace can figure out more low-level
>> > details like alignment and placement in physical memory, etc.
>> >
>>
>> well, let's divide things up into two categories:
>>
>> 1) the arrangement and format of pixels.. ie. what userspace would
>> need to know if it mmap's a buffer.  This includes pixel format,
>> stride, etc.  This should be negotiated in userspace, it would be
>> crazy to try to do this in the kernel.
>
> Absolutely. Pixel format has to be negotiated by user-space as in
> most cases, user-space can map the buffer and thus will need to
> know how to interpret the data.
>
>
>
>> 2) the physical placement of the pages.  Ie. whether it is contiguous
>> or not.  Which bank the pages in the buffer are placed in, etc.  This
>> is not visible to userspace.
>
> Seems sensible to me.
>
>
>> ... This is the purpose of the attach step,
>> so you know all the devices involved in sharing up front before
>> allocating the backing pages. (Or in the worst case, if you have a
>> "late attacher" you at least know when no device is doing dma access
>> to a buffer and can reallocate and move the buffer.)  A long time
>> back, I had a patch that added a field or two to 'struct
>> device_dma_parameters' so that it could be known if a device required
>> contiguous buffers.. looks like that never got merged, so I'd need to
>> dig that back up and resend it.  But the idea was to have the 'struct
>> device' encapsulate all the information that would be needed to
>> do-the-right-thing when it comes to placement.
>
> As I understand it, it's up to the exporting device to allocate the
> memory backing the dma_buf buffer. I guess the latest possible point
> you can allocate the backing pages is when map_dma_buf is first
> called? At that point the exporter can iterate over the current set
> of attachments, programmatically determine the all the constraints of
> all the attached drivers and attempt to allocate the backing pages
> in such a way as to satisfy all those constraints?

yes, this is the idea..  possibly some room for some helpers to help
out with this, but that is all under the hood from userspace
perspective

> Didn't you say that programmatically describing device placement
> constraints was an unbounded problem? I guess we would have to
> accept that it's not possible to describe all possible constraints
> and instead find a way to describe the common ones?

well, the point I'm trying to make, is by dividing your constraints
into two groups, one that impacts and is handled by userspace, and one
that is in the kernel (ie. where the pages go), you cut down the
number of permutations that the kernel has to care about considerably.
 And kernel already cares about, for example, what range of addresses
that a device can dma to/from.  I think really the only thing missing
is the max # of sglist entries (contiguous or not)

> One problem with this is it duplicates a lot of logic in each
> driver which can export a dma_buf buffer. Each exporter will need to
> do pretty much the same thing: iterate over all the attachments,
> determine of all the constraints (assuming that can be done) and
> allocate pages such that the lowest-common-denominator is satisfied.
>
> Perhaps rather than duplicating that logic in every driver, we could
> Instead move allocation of the backing pages into dma_buf itself?
>

I tend to think it is better to add helpers as we see common patterns
emerge, which drivers can opt-in to using.  I don't think that we
should move allocation into dma_buf itself, but it would perhaps be
useful to have dma_alloc_*() variants that could allocate for multiple
devices.  That would help for simple stuff, although I'd suspect
eventually a GPU driver will move away from that.  (Since you probably
want to play tricks w/ pools of pages that are pre-zero'd and in the
correct cache state, use spare cycles on the gpu or dma engine to
pre-zero uncached pages, and games like that.)

>
>> > Anyway, assuming user-space can figure out how a buffer should be
>> > stored in memory, how does it indicate this to a kernel driver and
>> > actually allocate it? Which ioctl on which device does user-space
>> > call, with what parameters? Are you suggesting using something like
>> > ION which exposes the low-level details of how buffers are laid out
>> in
>> > physical memory to userspace? If not, what?
>>
>> no, userspace should not need to know this.  And having a central
>> driver that knows this for all the other drivers in the system doesn't
>> really solve anything and isn't really scalable.  At best you might
>> want, in some cases, a flag you can pass when allocating.  For
>> example, some of the drivers have a 'SCANOUT' flag that can be passed
>> when allocating a GEM buffer, as a hint to the kernel that 'if this hw
>> requires contig memory for scanout, allocate this buffer contig'.  But
>> really, when it comes to sharing buffers between devices, we want this
>> sort of information in dev->dma_params of the importing device(s).
>
> If you had a single driver which knew the constraints of all devices
> on that particular SoC and the interface allowed user-space to specify
> which devices a buffer is intended to be used with, I guess it could
> pretty trivially allocate pages which satisfy those constraints? It

keep in mind, even a number of SoC's come with pcie these days.  You
already have things like

  https://developer.nvidia.com/content/kayla-platform

You probably want to get out of the SoC mindset, otherwise you are
going to make bad assumptions that come back to bite you later on.

> wouldn't need a way to programmatically describe the constraints
> either: As you say, if userspace sets the "SCANOUT" flag, it would
> just "know" that on this SoC, that buffer needs to be physically
> contiguous for example.

not really.. it just knows it wants to scanout the buffer, and tells
this as a hint to the kernel.

For example, on omapdrm, the SCANOUT flag does nothing on omap4+
(where phys contig is not required for scanout), but causes CMA
(dma_alloc_*()) to be used on omap3.  Userspace doesn't care.  It just
knows that it wants to be able to scanout that particular buffer.

> Though It would effectively mean you'd need an "allocation" driver per
> SoC, which as you say may not be scalable?

Right.. and not actually even possible in the general sense (see SoC +
external pcie gfx card)

BR,
-R

>
>
> Cheers,
>
> Tom
>
>
>
>
>
