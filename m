Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3HGSMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:12:48 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40291 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab3HGSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <520284d6.07300f0a.72a4.1623SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
	<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
	<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
	<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	<5200deb3.0b24b40a.3b26.ffffbadeSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGvXcpTKrTjhvrycLqab6F9QP5fAk0ZEWxJ-WvE==PiPsA@mail.gmail.com>
	<52010257.245fc20a.6ff8.1cfdSMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGsDA8qdShWdYQRqQ0Czn4mLAe-FoADjZdRFcbeWGGe8Hg@mail.gmail.com>
	<52013482.e107c20a.27f9.ffffa718SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGtaYJfJ4WBddbtyE9P8odXOYvJXLsreMwXMLCBOsfXy7w@mail.gmail.com>
	<520284d6.07300f0a.72a4.1623SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Wed, 7 Aug 2013 14:12:44 -0400
Message-ID: <CAF6AEGtq-azZAxD+2OKz=Tg48bYAphBqGn033iWVZ-DjHA216A@mail.gmail.com>
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

On Wed, Aug 7, 2013 at 1:33 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>
>> >> > Didn't you say that programmatically describing device placement
>> >> > constraints was an unbounded problem? I guess we would have to
>> >> > accept that it's not possible to describe all possible constraints
>> >> > and instead find a way to describe the common ones?
>> >>
>> >> well, the point I'm trying to make, is by dividing your constraints
>> >> into two groups, one that impacts and is handled by userspace, and
>> >> one that is in the kernel (ie. where the pages go), you cut down
>> >> the number of permutations that the kernel has to care about
>> >>  considerably. And kernel already cares about, for example, what
>> >> range of addresses that a device can dma to/from.  I think really
>> >> the only thing missing is the max # of sglist entries (contiguous
>> >> or not)
>> >
>> > I think it's more than physically contiguous or not.
>> >
>> > For example, it can be more efficient to use large page sizes on
>> > devices with IOMMUs to reduce TLB traffic. I think the size and even
>> > the availability of large pages varies between different IOMMUs.
>>
>> sure.. but I suppose if we can spiff out dma_params to express "I need
>> contiguous", perhaps we can add some way to express "I prefer
>> as-contiguous-as-possible".. either way, this is about where the pages
>> are placed, and not about the layout of pixels within the page, so
>> should be in kernel.  It's something that is missing, but I believe
>> that it belongs in dma_params and hidden behind dma_alloc_*() for
>> simple drivers.
>
> Thinking about it, isn't this more a property of the IOMMU? I mean,
> are there any cases where an IOMMU had a large page mode but you
> wouldn't want to use it? So when allocating the memory, you'd have to
> take into account not just the constraints of the devices themselves,
> but also of any IOMMUs any of the device sit behind?
>

perhaps yes.  But the device is associated w/ the iommu it is attached
to, so this shouldn't be a problem

>
>> > There's also the issue of buffer stride alignment. As I say, if the
>> > buffer is to be written by a tile-based GPU like Mali, it's more
>> > efficient if the buffer's stride is aligned to the max AXI bus burst
>> > length. Though I guess a buffer stride only makes sense as a concept
>> > when interpreting the data as a linear-layout 2D image, so perhaps
>> > belongs in user-space along with format negotiation?
>> >
>>
>> Yeah.. this isn't about where the pages go, but about the arrangement
>> within a page.
>>
>> And, well, except for hw that supports the same tiling (or
>> compressed-fb) in display+gpu, you probably aren't sharing tiled
>> buffers.
>
> You'd only want to share a buffer between devices if those devices can
> understand the same pixel format. That pixel format can't be device-
> specific or opaque, it has to be explicit. I think drm_fourcc.h is
> what defines all the possible pixel formats. This is the enum I used
> in EGL_EXT_image_dma_buf_import at least. So if we get to the point
> where multiple devices can understand a tiled or compressed format, I
> assume we could just add that format to drm_fourcc.h and possibly
> v4l2's v4l2_mbus_pixelcode enum in v4l2-mediabus.h.
>
> For user-space to negotiate a common pixel format and now stride
> alignment, I guess it will obviously need a way to query what pixel
> formats a device supports and what its stride alignment requirements
> are.
>
> I don't know v4l2 very well, but it certainly seems the pixel format
> can be queried using V4L2_SUBDEV_FORMAT_TRY when attempting to set
> a particular format. I couldn't however find a way to retrieve a list
> of supported formats - it seems the mechanism is to try out each
> format in turn to determine if it is supported. Is that right?

it is exposed for drm plane's.  What is missing is to expose the
primary-plane associated with the crtc.

> There doesn't however seem a way to query what stride constraints a
> V4l2 device might have. Does HW abstracted by v4l2 typically have
> such constraints? If so, how can we query them such that a buffer
> allocated by a DRM driver can be imported into v4l2 and used with
> that HW?
>
> Turning to DRM/KMS, it seems the supported formats of a plane can be
> queried using drm_mode_get_plane. However, there doesn't seem to be a
> way to query the supported formats of a crtc? If display HW only
> supports scanning out from a single buffer (like pl111 does), I think
> it won't have any planes and a fb can only be set on the crtc. In
> which case, how should user-space query which pixel formats that crtc
> supports?
>
> Assuming user-space can query the supported formats and find a common
> one, it will need to allocate a buffer. Looks like
> drm_mode_create_dumb can do that, but it only takes a bpp parameter,
> there's no format parameter. I assume then that user-space defines
> the format and tells the DRM driver which format the buffer is in
> when creating the fb with drm_mode_fb_cmd2, which does take a format
> parameter? Is that right?

Right, the gem object has no inherent format, it is just some bytes.
The format/width/height/pitch are all attributes of the fb.

> As with v4l2, DRM doesn't appear to have a way to query the stride
> constraints? Assuming there is a way to query the stride constraints,
> there also isn't a way to specify them when creating a buffer with
> DRM, though perhaps the existing pitch parameter of
> drm_mode_create_dumb could be used to allow user-space to pass in a
> minimum stride as well as receive the allocated stride?
>

well, you really shouldn't be using create_dumb..  you should have a
userspace piece that is specific to the drm driver, and knows how to
use that driver's gem allocate ioctl.

>
>> >> > One problem with this is it duplicates a lot of logic in each
>> >> > driver which can export a dma_buf buffer. Each exporter will
>> >> > need to do pretty much the same thing: iterate over all the
>> >> > attachments, determine of all the constraints (assuming that
>> >> > can be done) and allocate pages such that the lowest-common-
>> >> > denominator is satisfied. Perhaps rather than duplicating that
>> >> > logic in every driver, we could instead move allocation of the
>> >> > backing pages into dma_buf itself?
>> >>
>> >> I tend to think it is better to add helpers as we see common
>>
>> >> patterns emerge, which drivers can opt-in to using.  I don't
>> >> think that we should move allocation into dma_buf itself, but
>> >> it would perhaps be useful to have dma_alloc_*() variants that
>> >> could allocate for multiple devices.
>> >
>> > A helper could work I guess, though I quite like the idea of
>> > having dma_alloc_*() variants which take a list of devices to
>> > allocate memory for.
>> >
>> >
>> >> That would help for simple stuff, although I'd suspect
>> >> eventually a GPU driver will move away from that.  (Since you
>> >> probably want to play tricks w/ pools of pages that are
>> >> pre-zero'd and in the correct cache state, use spare cycles on
>> >> the gpu or dma engine to pre-zero uncached pages, and games
>> >> like that.)
>> >
>> > So presumably you're talking about a GPU driver being the exporter
>> > here? If so, how could the GPU driver do these kind of tricks on
>> > memory shared with another device?
>>
>> Yes, that is gpu-as-exporter.  If someone else is allocating buffers,
>> it is up to them to do these tricks or not.  Probably there is a
>> pretty good chance that if you aren't a GPU you don't need those sort
>> of tricks for fast allocation of transient upload buffers, staging
>> textures, temporary pixmaps, etc.  Ie. I don't really think a v4l
>> camera or video decoder would benefit from that sort of optimization.
>
> Right - but none of those are really buffers you'd want to export with
> dma_buf to share with another device are they? In which case, why not
> just have dma_buf figure out the constraints and allocate the memory?

maybe not.. but (a) you don't necessarily know at creation time if it
is going to be exported (maybe you know if it is definitely not going
to be exported, but the converse is not true), and (b) there isn't
really any reason to special case the allocation in the driver because
it is going to be exported.

helpers that can be used by simple drivers, yes.  Forcing the way the
buffer is allocated, for sure not.  Currently, for example, there is
no issue to export a buffer allocated from stolen-mem.  If we put the
page allocation in dma-buf, this would not be possible.  That is just
one quick example off the top of my head, I'm sure there are plenty
more.  But we definitely do not want the allocate in dma_buf itself.

> If a driver needs to allocate memory in a special way for a particular
> device, I can't really imagine how it would be able to share that
> buffer with another device using dma_buf? I guess a driver is likely
> to need some magic voodoo to configure access to the buffer for its
> device, but surely that would be done by the dma_mapping framework
> when dma_buf_map happens?
>

if, what it has to configure actually manages to fit in the
dma-mapping framework

anyways, where the pages come from has nothing to do with whether a
buffer can be shared or not

>
>
>> >> You probably want to get out of the SoC mindset, otherwise you are
>> >> going to make bad assumptions that come back to bite you later on.
>> >
>> > Sure - there are always going to be PC-like devices where the
>> > hardware configuration isn't fixed like it is on a traditional SoC.
>> > But I'd rather have a simple solution which works on traditional SoCs
>> > than no solution at all. Today our solution is to over-load the dumb
>> > buffer alloc functions of the display's DRM driver - For now I'm just
>> > looking for the next step up from that! ;-)
>>
>> True.. the original intention, which is perhaps a bit desktop-centric,
>> really was for there to be a userspace component talking to the drm
>> driver for allocation, ie. xf86-video-foo and/or
>> src/gallium/drivers/foo (for example) ;-)
>>
>> Which means for x11 having a SoC vendor specific xf86-video-foo for
>> x11..  or vendor specific gbm implementation for wayland.  (Although
>> at least in the latter case it is a pretty small piece of code.)  But
>> that is probably what you are trying to avoid.
>
> I've been trying to get my head around how PRIME relates to DDX
> drivers. As I understand it (which is likely wrong), you have a laptop
> with both an Intel & an nVidia GPU. You have both the i915 & nouveau
> kernel drivers loaded. What I'm not sure about is which GPU's display
> controller is actually hooked up to the physical connector? Perhaps
> there is a MUX like there is on Versatile Express?

afaiu it can be a, b, or c (ie. either gpu can have the display or
there can be a mux)..

> What I also don't understand is what DDX driver is loaded? Is it
> xf86-video-intel, xf86-video-nouveau or both? I get the impression
> that there's a "master" DDX which implements 2D operations but can
> import buffers using PRIME from the other driver and draw to them.
> Or is it more that it's able to export rendered buffers to the
> "slave" DRM for scanout? Either way, it's pretty similar to an ARM
> SoC setup which has the GPU and the display as two totally
> independent devices.
>
>
>
>> At any rate, for both xorg and wayland/gbm, you know when a buffer is
>> going to be a scanout buffer.  What I'd recommend is define a small
>> userspace API that your customers (the SoC vendors) implement to
>> allocate a scanout buffer and hand you back a dmabuf fd.  That could
>> be used both for x11 and for gbm.  Inputs should be requested
>> width/height and format.  And outputs pitch plus dmabuf fd.
>>
>> (Actually you might even just want to use gbm as your starting point.
>> You could probably just use gbm from xf86-video-armsoc for allocation,
>> to have one thing that works for both wayland and x11.  Scanout and
>> cursor buffers should go to vendor/SoC specific fxn, rest can be
>> allocated from mali kernel driver.)
>
> What does that buy us over just using drm_mode_create_dumb on the
> display's DRM driver?
>

well, for example, if there was actually some hw w/ omap's dss + mali,
you could actually have mali render transparently to tiled buffers
which could be scanned out rotated.  Which would not be possible w/
dumb buffers.

>
>
>> >> > wouldn't need a way to programmatically describe the constraints
>> >> > either: As you say, if userspace sets the "SCANOUT" flag, it would
>> >> > just "know" that on this SoC, that buffer needs to be physically
>> >> > contiguous for example.
>> >>
>> >> not really.. it just knows it wants to scanout the buffer, and tells
>> >> this as a hint to the kernel.
>> >>
>> >> For example, on omapdrm, the SCANOUT flag does nothing on omap4+
>> >> (where phys contig is not required for scanout), but causes CMA
>> >> (dma_alloc_*()) to be used on omap3.  Userspace doesn't care.
>> >> It just knows that it wants to be able to scanout that particular
>> >> buffer.
>> >
>> > I think that's the idea? The omap3's allocator driver would use
>> > contiguous memory when it detects the SCANOUT flag whereas the omap4
>> > allocator driver wouldn't have to. No complex negotiation of
>> > constraints - it just "knows".
>> >
>>
>> well, it is same allocating driver in both cases (although maybe that
>> is unimportant).  The "it" that just knows it wants to scanout is
>> userspace.  The "it" that just knows that scanout translates to
>> contiguous (or not) is the kernel.  Perhaps we are saying the same
>> thing ;-)
>
> Yeah - I think we are... so what's the issue with having a per-SoC
> allocation driver again?
>

In a way the display driver is a per-SoC allocator.  But not
necessarily the *central* allocator for everything.  Ie. no need for
display driver to allocate vertex buffers for a separate gpu driver,
and that sort of thing.

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
