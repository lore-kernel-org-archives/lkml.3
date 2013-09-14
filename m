Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3INVeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 17:34:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41847 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3INVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 17:33:58 -0400
Message-ID: <1379194431.2978.22.camel@nightslugs>
Subject: Re: [Linaro-mm-sig] [RFC 0/1] drm/pl111: Initial drm/kms driver for
 pl111
From: Daniel Stone <daniels@collabora.com>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: "'Rob Clark'" <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Sat, 14 Sep 2013 17:33:51 -0400
In-Reply-To: <000101ce9298$8ce44ee0$a6aceca0$@cooksey@arm.com>
References: <1374772648-19151-1-git-send-email-tom.cooksey@arm.com>
		<CAF6AEGtspnhSGNM4_QQubVfOkZ1Gh1-Z3iyHOLBPVWuqRy81ew@mail.gmail.com>
		<51f29ccd.f014b40a.34cc.ffffca2aSMTPIN_ADDED_BROKEN@mx.google.com>
		<CAF6AEGvFPGueM_LHVij9KFzM6NJySHCzmaLstuzZkK5GwP+6gQ@mail.gmail.com>
		<51ffdc7e.06b8b40a.2cc8.0fe0SMTPIN_ADDED_BROKEN@mx.google.com>
	 <CAF6AEGsyKk_G-R-OX_YcgYFDgTEmCy9Vf2LV1pAOV0452QKSww@mail.gmail.com>
	 <000101ce9298$8ce44ee0$a6aceca0$@cooksey@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-08-06 at 12:31 +0100, Tom Cooksey wrote:
> > >> On Fri, Jul 26, 2013 at 11:58 AM, Tom Cooksey <tom.cooksey@arm.com>
> > >> wrote:
> > that was part of the reason to punt this problem to userspace ;-)
> >
> > In practice, the kernel drivers doesn't usually know too much about
> > the dimensions/format/etc.. that is really userspace level knowledge.
> > There are a few exceptions when the kernel needs to know how to setup
> > GTT/etc for tiled buffers, but normally this sort of information is up
> > at the next level up (userspace, and drm_framebuffer in case of
> > scanout).  Userspace media frameworks like GStreamer already have a
> > concept of format/caps negotiation.  For non-display<->gpu sharing, I
> > think this is probably where this sort of constraint negotiation
> > should be handled.

Egads.  GStreamer's caps negotiation is already close to unbounded time;
seems like most of the optimisation work that goes into it these days is
all about _reducing_ the complexity of caps negotiation!

> I agree that user-space will know which devices will access the buffer
> and thus can figure out at least a common pixel format.

Hm, are you sure about that? The answer is yes for 'userspace' as a
broad handwave, but not necessarily for individual processes.  Take, for
instance, media decode through GStreamer, being displayed by Wayland
using a KMS plane/overlay/sprite/cursor/etc.  The media player knows
that the buffers are coming from the decode engine, and Wayland knows
that the buffers are going to a KMS plane, but neither of them knows the
full combination of the two.

Though this kinda feeds into an idea I've been kicking around for a
while, which is an 'optimal hint' mechanism in the Wayland protocol.  So
for our hypothetical dmabuf-using protocol, we'd start off with buffers
which satisfied all the constraints of our media decode engine, but
perhaps just the GPU rather than display controller.  At this point,
we'd note that we could place the video in a plane if only the buffers
were better-allocated, and send an event to the client letting it know
how to tweak its buffer allocation for more optimal display.

But ...

> Though I'm not
> so sure userspace can figure out more low-level details like alignment
> and placement in physical memory, etc.
> 
> Anyway, assuming user-space can figure out how a buffer should be 
> stored in memory, how does it indicate this to a kernel driver and 
> actually allocate it? Which ioctl on which device does user-space
> call, with what parameters? Are you suggesting using something like
> ION which exposes the low-level details of how buffers are laid out in
> physical memory to userspace? If not, what?

... this is still rather unresolved. ;)

Cheers,
Daniel


> 
> Cheers,
> 
> Tom
> 
> 
> 
> 
> 
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig


