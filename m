Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaGVLqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:46:03 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60496 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaGVLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:45:59 -0400
Date: Tue, 22 Jul 2014 13:46:07 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for
 fences
Message-ID: <20140722114607.GL15237@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Dave Airlie <airlied@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	nouveau <nouveau@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Ben Skeggs <bskeggs@redhat.com>,
	"Deucher, Alexander" <alexander.deucher@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
 <20140709122953.11354.46381.stgit@patser>
 <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
 <53CE2421.5040906@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53CE2421.5040906@amd.com>
X-Operating-System: Linux phenom 3.15.0-rc3+
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
> Am 22.07.2014 06:05, schrieb Dave Airlie:
> >On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
> >>Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> >>---
> >>  drivers/gpu/drm/radeon/radeon.h        |   15 +-
> >>  drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
> >>  drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
> >>  3 files changed, 248 insertions(+), 50 deletions(-)
> >>
> > From what I can see this is still suffering from the problem that we
> >need to find a proper solution to,
> >
> >My summary of the issues after talking to Jerome and Ben and
> >re-reading things is:
> >
> >We really need to work out a better interface into the drivers to be
> >able to avoid random atomic entrypoints,
> 
> Which is exactly what I criticized from the very first beginning. Good to
> know that I'm not the only one thinking that this isn't such a good idea.

I guess I've lost context a bit, but which atomic entry point are we
talking about? Afaics the only one that's mandatory is the is
fence->signaled callback to check whether a fence really has been
signalled. It's used internally by the fence code to avoid spurious
wakeups. Afaik that should be doable already on any hardware. If that's
not the case then we can always track the signalled state in software and
double-check in a worker thread before updating the sw state. And wrap
this all up into a special fence class if there's more than one driver
needing this.

There is nothing else that forces callbacks from atomic contexts upon you.
You can use them if you see it fit, but really if it doesn't suit your
driver you can just ignore that part and do process based waits
everywhere.

> >I'm sure you have some ideas and I think you really need to
> >investigate them to move this thing forward,
> >even it if means some issues with android sync pts.
> 
> Actually I think that TTMs fence interface already gave quite a good hint
> how it might look like. I can only guess that this won't fit with the
> Android stuff, otherwise I can't see a good reason why we didn't stick with
> that.

Well the current plan for i915<->radeon sync from Maarten is to use these
atomic callbacks on the i915 side. So android didn't figure into this at
all. Actually with android the entire implementation is kinda the
platforms problem, the generic parts just give you a userspace interface
and some means to stack up fences.

> >but none of the two major drivers seem to want the interface as-is so
> >something needs to give
> >
> >My major question is why we need an atomic callback here at all, what
> >scenario does it cover?
> 
> Agree totally. As far as I can see all current uses of the interface are of
> the kind of waiting for a fence to signal.
> 
> No need for any callback from one driver into another, especially not in
> atomic context. If a driver needs such a functionality it should just start
> up a kernel thread and do it's waiting there.
> 
> This obviously shouldn't be an obstacle for pure hardware implementations
> where one driver signals a semaphore another driver is waiting for, or a
> high signal on an interrupt line directly wired between two chips. And I
> think this is a completely different topic and not necessarily part of the
> common fence interface we should currently focus on.

It's for mixed hw/sw stuff where we want to poke the hw from the irq
context (if possible) since someone forgot the wire. At least on the i915
side it boils down to one mmio write, and it's fairly pointless to launch
a thread for that.

So I haven't dug into ttm details but from the i915 side the current stuff
and atomic semantics makes sense. Maybe we just need to wrap a bit more
insulation around ttm-based drivers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
