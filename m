Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3HFMP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:15:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43312 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3HFMPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <5200deb3.0b24b40a.3b26.ffffbadeSMTPIN_ADDED_BROKEN@mx.google.com>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<5200deb3.0b24b40a.3b26.ffffbadeSMTPIN_ADDED_BROKEN@mx.google.com>
Date: Tue, 6 Aug 2013 08:15:24 -0400
Message-ID: <CAF6AEGvXcpTKrTjhvrycLqab6F9QP5fAk0ZEWxJ-WvE==PiPsA@mail.gmail.com>
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

On Tue, Aug 6, 2013 at 7:31 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>
>> > So in some respects, there is a constraint on how buffers which will
>> > be drawn to using the GPU are allocated. I don't really like the idea
>> > of teaching the display controller DRM driver about the GPU buffer
>> > constraints, even if they are fairly trivial like this. If the same
>> > display HW IP is being used on several SoCs, it seems wrong somehow
>> > to enforce those GPU constraints if some of those SoCs don't have a
>> > GPU.
>>
>> Well, I suppose you could get min_pitch_alignment from devicetree, or
>> something like this..
>>
>> In the end, the easy solution is just to make the display allocate to
>> the worst-case pitch alignment.  In the early days of dma-buf
>> discussions, we kicked around the idea of negotiating or
>> programatically describing the constraints, but that didn't really
>> seem like a bounded problem.
>
> Yeah - I was around for some of those discussions and agree it's not
> really an easy problem to solve.
>
>
>
>> > We may also then have additional constraints when sharing buffers
>> > between the display HW and video decode or even camera ISP HW.
>> > Programmatically describing buffer allocation constraints is very
>> > difficult and I'm not sure you can actually do it - there's some
>> > pretty complex constraints out there! E.g. I believe there's a
>> > platform where Y and UV planes of the reference frame need to be in
>> > separate DRAM banks for real-time 1080p decode, or something like
>> > that?
>>
>> yes, this was discussed.  This is different from pitch/format/size
>> constraints.. it is really just a placement constraint (ie. where do
>> the physical pages go).  IIRC the conclusion was to use a dummy
>> devices with it's own CMA pool for attaching the Y vs UV buffers.
>>
>> > Anyway, I guess my point is that even if we solve how to allocate
>> > buffers which will be shared between the GPU and display HW such that
>> > both sets of constraints are satisfied, that may not be the end of
>> > the story.
>> >
>>
>> that was part of the reason to punt this problem to userspace ;-)
>>
>> In practice, the kernel drivers doesn't usually know too much about
>> the dimensions/format/etc.. that is really userspace level knowledge.
>> There are a few exceptions when the kernel needs to know how to setup
>> GTT/etc for tiled buffers, but normally this sort of information is up
>> at the next level up (userspace, and drm_framebuffer in case of
>> scanout).  Userspace media frameworks like GStreamer already have a
>> concept of format/caps negotiation.  For non-display<->gpu sharing, I
>> think this is probably where this sort of constraint negotiation
>> should be handled.
>
> I agree that user-space will know which devices will access the buffer
> and thus can figure out at least a common pixel format. Though I'm not
> so sure userspace can figure out more low-level details like alignment
> and placement in physical memory, etc.

well, let's divide things up into two categories:

1) the arrangement and format of pixels.. ie. what userspace would
need to know if it mmap's a buffer.  This includes pixel format,
stride, etc.  This should be negotiated in userspace, it would be
crazy to try to do this in the kernel.

2) the physical placement of the pages.  Ie. whether it is contiguous
or not.  Which bank the pages in the buffer are placed in, etc.  This
is not visible to userspace.  This is the purpose of the attach step,
so you know all the devices involved in sharing up front before
allocating the backing pages.  (Or in the worst case, if you have a
"late attacher" you at least know when no device is doing dma access
to a buffer and can reallocate and move the buffer.)  A long time
back, I had a patch that added a field or two to 'struct
device_dma_parameters' so that it could be known if a device required
contiguous buffers.. looks like that never got merged, so I'd need to
dig that back up and resend it.  But the idea was to have the 'struct
device' encapsulate all the information that would be needed to
do-the-right-thing when it comes to placement.

> Anyway, assuming user-space can figure out how a buffer should be
> stored in memory, how does it indicate this to a kernel driver and
> actually allocate it? Which ioctl on which device does user-space
> call, with what parameters? Are you suggesting using something like
> ION which exposes the low-level details of how buffers are laid out in
> physical memory to userspace? If not, what?

no, userspace should not need to know this.  And having a central
driver that knows this for all the other drivers in the system doesn't
really solve anything and isn't really scalable.  At best you might
want, in some cases, a flag you can pass when allocating.  For
example, some of the drivers have a 'SCANOUT' flag that can be passed
when allocating a GEM buffer, as a hint to the kernel that 'if this hw
requires contig memory for scanout, allocate this buffer contig'.  But
really, when it comes to sharing buffers between devices, we want this
sort of information in dev->dma_params of the importing device(s).

BR,
-R
