Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3HIRMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:12:32 -0400
Received: from mail-ie0-f193.google.com ([209.85.223.193]:52578 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3HIRM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <520515b9.87370f0a.16e6.2380SMTPIN_ADDED_BROKEN@mx.google.com>
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
	<CAF6AEGtq-azZAxD+2OKz=Tg48bYAphBqGn033iWVZ-DjHA216A@mail.gmail.com>
	<520515b9.87370f0a.16e6.2380SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Fri, 9 Aug 2013 13:12:28 -0400
Message-ID: <CAF6AEGsmvtwBKMhp3b3Z3M0B2Xi9HXApQ+0c2_prDST1QrL8Xw@mail.gmail.com>
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

On Fri, Aug 9, 2013 at 12:15 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>
>> > Turning to DRM/KMS, it seems the supported formats of a plane can be
>> > queried using drm_mode_get_plane. However, there doesn't seem to be a
>> > way to query the supported formats of a crtc? If display HW only
>> > supports scanning out from a single buffer (like pl111 does), I think
>> > it won't have any planes and a fb can only be set on the crtc. In
>> > which case, how should user-space query which pixel formats that crtc
>> > supports?
>>
>> it is exposed for drm plane's.  What is missing is to expose the
>> primary-plane associated with the crtc.
>
> Cool - so a patch which adds a way to query the what formats a crtc
> supports would be welcome?

well, I kinda think we want something that exposes the "primary plane"
of the crtc.. I'm thinking something roughly like:

---------
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 53db7ce..c7ffca8 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -157,6 +157,12 @@ struct drm_mode_get_plane {
 struct drm_mode_get_plane_res {
 	__u64 plane_id_ptr;
 	__u32 count_planes;
+	/* The primary planes are in matching order to crtc_id_ptr in
+	 * drm_mode_card_res (and same length).  For crtc_id[n], it's
+	 * primary plane is given by primary_plane_id[n].
+	 */
+	__u32 count_primary_planes;
+	__u64 primary_plane_id_ptr;
 };

 #define DRM_MODE_ENCODER_NONE	0
---------

then use the existing GETPLANE ioctl to query the capabilities

> What about a way to query the stride alignment constraints?
>
> Presumably using the drm_mode_get_property mechanism would be the
> right way to implement that?
>

I suppose you could try that.. typically that is in userspace,
however.  It seems like get_property would get messy quickly (ie. is
it a pitch alignment constraint, or stride alignment?  What if this is
different for different formats (in particular tiled)? etc)

>
>> > As with v4l2, DRM doesn't appear to have a way to query the stride
>> > constraints? Assuming there is a way to query the stride constraints,
>> > there also isn't a way to specify them when creating a buffer with
>> > DRM, though perhaps the existing pitch parameter of
>> > drm_mode_create_dumb could be used to allow user-space to pass in a
>> > minimum stride as well as receive the allocated stride?
>> >
>>
>> well, you really shouldn't be using create_dumb..  you should have a
>> userspace piece that is specific to the drm driver, and knows how to
>> use that driver's gem allocate ioctl.
>
> Sorry, why does this need a driver-specific allocation function? It's
> just a display controller driver and I just want to allocate a scan-
> out buffer - all I'm asking is for the display controller driver to
> use a minimum stride alignment so I can export the buffer and use
> another device to fill it with data.

Sure.. but userspace has more information readily available to make a
better choice.  For example, for omapdrm I'd do things differently
depending on whether I wanted to scan out that buffer (or a portion of
it) rotated.  This is something I know in the DDX driver, but not in
the kernel.  And it is quite likely something that is driver specific.
 Sure, we could add that to a generic "allocate me a buffer" ioctl.
But that doesn't really seem better, and it becomes a problem as soon
as we come across some hw that needs to know something different.  In
userspace, you have a lot more flexibility, since you don't really
need to commit to an API for life.

And to bring back the GStreamer argument (since that seems a fitting
example when you start talking about sharing buffers between many
devices, for example camera+codec+display), it would already be
negotiating format between v4l2src + fooencoder + displaysink.. the
pitch/stride is part of that format information.  If the display isn't
the one with the strictest requirements, we don't want the display
driver deciding what pitch to use.

> The whole point is to be able to allocate the buffer in such a way
> that another device can access it. So the driver _can't_ use a
> special, device specific format, nor can it allocate it from a
> private memory pool because doing so would preclude it from being
> shared with another device.
>
> That other device doesn't need to be a GPU wither, it could just as
> easily be a camera/ISP or video decoder.
>
>
>
>> >> > So presumably you're talking about a GPU driver being the exporter
>> >> > here? If so, how could the GPU driver do these kind of tricks on
>> >> > memory shared with another device?
>> >>
>> >> Yes, that is gpu-as-exporter.  If someone else is allocating
>> >> buffers, it is up to them to do these tricks or not.  Probably
>> >> there is a pretty good chance that if you aren't a GPU you don't
>> >> need those sort of tricks for fast allocation of transient upload
>> >> buffers, staging textures, temporary pixmaps, etc.  Ie. I don't
>> >> really think a v4l camera or video decoder would benefit from that
>> >> sort of optimization.
>> >
>> > Right - but none of those are really buffers you'd want to export
>>
>> > with dma_buf to share with another device are they? In which case,
>> > why not just have dma_buf figure out the constraints and allocate
>> > the memory?
>>
>> maybe not.. but (a) you don't necessarily know at creation time if it
>> is going to be exported (maybe you know if it is definitely not going
>> to be exported, but the converse is not true),
>
> I can't actually think of an example where you would not know if a
> buffer was going to be exported or not at allocation time? Do you have
> a case in mind?

yeah, dri2.. when the front buffer is allocated it is just a regular
pixmap.  If you swap/flip it becomes the back buffer and now shared
;-)
And pixmaps are allocated w/ enough frequency that it is the sort of
thing you might want to optimize.

And even when you know it will be shared, you don't know with who.

> Regardless, you'd certainly have to know if a buffer will be exported
> pretty quickly, before it's used so that you can import it into
> whatever devices are going to access it. Otherwise if it gets
> allocated before you export it, the allocation won't satisfy the
> constraints of the other devices which will need to access it and
> importing will fail. Assuming of course deferred allocation of the
> backing pages as discussed earlier in the thread.
>
>
>
>> and (b) there isn't
>> really any reason to special case the allocation in the driver because
>> it is going to be exported.
>
> Not sure I follow you here? Surely you absolutely have to special-case
> the allocation if the buffer is to be exported because you have to
> take the other devices' constraints into account when you allocate? Or
> do you mean you don't need to special-case the GEM buffer object
> creation, only the allocation of the backing pages? Though I'm not
> sure how that distinction is useful - at the end of the day, you need
> to special-case allocation of the backing pages.
>

well, you need to consider separately what is (a) in the pages, and
(b) where the pages come from.

By moving the allocation into dmabuf you restrict (b).  For sharing
buffers, (a) may be restricted, but there is at least some examples of
hardware where (b) would not otherwise be restricted by sharing.

>
>> helpers that can be used by simple drivers, yes.  Forcing the way the
>> buffer is allocated, for sure not.  Currently, for example, there is
>> no issue to export a buffer allocated from stolen-mem.
>
> Where stolen-mem is the PC-world's version of a carveout? I.e. A chunk
> of memory reserved at boot for the GPU which the OS can't touch? I
> guess I view such memory as accessible to all media devices on the
> system and as such, needs to be managed by a central allocator which
> dma_buf can use to allocate from.

think carve-out created by bios.  In all the cases I am aware of, the
drm driver handles allocation of buffer(s) from the carveout.

> I guess if that stolen-mem is managed by a single device then in
> essence that device becomes the central allocator you have to use to
> be able to allocate from that stolen mem?
>
>
>> > If a driver needs to allocate memory in a special way for a
>> > particular device, I can't really imagine how it would be able
>> > to share that buffer with another device using dma_buf? I guess
>> > a driver is likely to need some magic voodoo to configure access
>> > to the buffer for its device, but surely that would be done by
>> > the dma_mapping framework when dma_buf_map happens?
>> >
>>
>> if, what it has to configure actually manages to fit in the
>> dma-mapping framework
>
> But if it doesn't, surely that's an issue which needs to be addressed
> in the dma_mapping framework or else you won't be able to import
> buffers for use by that device anyway?
>

I'm not sure if we have to fit everything in dma-mapping framework, at
least in cases where you have something that is specific to one
platform.

Currently dma-buf provides enough flexibility for other drivers to be
able to import these buffers.

>
>> anyways, where the pages come from has nothing to do with whether a
>> buffer can be shared or not
>
> Sure, but where they are located in physical memory really does
> matter.
>

s/does/can/

it doesn't always matter.  And in cases where it does matter, as long
as we can express the restrictions in dma_parms (which we can already
for the case of range-of-memory restrictions) we are covered

>
>> >> At any rate, for both xorg and wayland/gbm, you know when a buffer
>> >> is going to be a scanout buffer.  What I'd recommend is define a
>> >> small userspace API that your customers (the SoC vendors) implement
>> >> to allocate a scanout buffer and hand you back a dmabuf fd.  That
>> >> could be used both for x11 and for gbm.  Inputs should be requested
>> >> width/height and format.  And outputs pitch plus dmabuf fd.
>> >>
>> >> (Actually you might even just want to use gbm as your starting
>> >> point. You could probably just use gbm from xf86-video-armsoc for
>> >> allocation, to have one thing that works for both wayland and x11.
>> >> Scanout and cursor buffers should go to vendor/SoC specific fxn,
>> >> rest can be allocated from mali kernel driver.)
>> >
>> > What does that buy us over just using drm_mode_create_dumb on the
>> > display's DRM driver?
>>
>> well, for example, if there was actually some hw w/ omap's dss + mali,
>> you could actually have mali render transparently to tiled buffers
>> which could be scanned out rotated.  Which would not be possible w/
>> dumb buffers.
>
> Why not? As you said earlier, the format is defined when you setup the
> fb with drm_mode_fb_cmd2. If you wanted to share the buffer between
> devices, you have to be explicit about what format that buffer is in,
> so you'd have to add an entry to drm_fourcc.h for the tiled format.

no, that doesn't really work

in this case, the format to any device (or userspace) accessing the
buffer is not tiled.  (Ie. it would look like normal NV12 or
whatever).  But there are some different requirements on stride.  And
there are cases where you would prefer not to use tiled buffers, but
the kernel doesn't know enough in the dumb-buffer alloc ioctl to make
the correct decision.

> So userspace queries what formats the GPU DRM supports and what
> formats the OMAP DSS DRM supports, selects the tiled format and then
> uses drm_mode_create_dumb to allocate a buffer of the correct size and
> sets the appropriate drm_fourcc.h enum value when creating an fb for
> that buffer. Or have I missed something?
>
>
>
>> >> >> For example, on omapdrm, the SCANOUT flag does nothing on omap4+
>> >> >> (where phys contig is not required for scanout), but causes CMA
>> >> >> (dma_alloc_*()) to be used on omap3.  Userspace doesn't care.
>> >> >> It just knows that it wants to be able to scanout that particular
>> >> >> buffer.
>> >> >
>> >> > I think that's the idea? The omap3's allocator driver would use
>> >> > contiguous memory when it detects the SCANOUT flag whereas the
>> >> > omap4 allocator driver wouldn't have to. No complex negotiation
>> >> > of constraints - it just "knows".
>> >> >
>> >>
>> >> well, it is same allocating driver in both cases (although maybe
>> >> that is unimportant).  The "it" that just knows it wants to scanout
>> >> is userspace.  The "it" that just knows that scanout translates to
>> >> contiguous (or not) is the kernel.  Perhaps we are saying the same
>> >> thing ;-)
>> >
>> > Yeah - I think we are... so what's the issue with having a per-SoC
>> > allocation driver again?
>> >
>>
>> In a way the display driver is a per-SoC allocator.  But not
>> necessarily the *central* allocator for everything.  Ie. no need for
>> display driver to allocate vertex buffers for a separate gpu driver,
>> and that sort of thing.
>
> Again, I'm only talking about allocating buffers which will be shared
> between different devices. At no point have I mentioned the allocation
> of buffers which aren't to be shared between devices. Sorry if that's
> not been clear.

ok, I guess we were talking about slightly different things ;-)

> So for buffers which are to be shared between devices, your suggesting
> that the display driver is the per-SoC allocator? But as I say, and
> how this thread got started, the same display driver can be used on
> different SoCs, so having _it_ be the central allocator isn't ideal.
> Though this is our current solution and why we're "abusing" the dumb
> buffer allocation functions. :-)
>

which is why you want to let userspace figure out the pitch and then
tell the display driver what size it wants, rather than using dumb
buffer ioctl ;-)

Ok, you could have a generic TELL_ME_WHAT_STRIDE_TO_USE ioctl or
property or what have you.. but I think that would be hard to get
right for all cases, and most people don't really care about that
because they already need a gpu/display specific xorg driver and/or
gl/egl talking to their kernel driver.  You are in a slightly special
case, since you are providing GL driver independently of the display
driver.  But I think that is easier to handle by just telling your
customers "here, fill out this function(s) to allocate buffer for
scanout" (and, well, I guess you'd need one to query for
pitch/stride), rather than trying to cram everything into the kernel.

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
