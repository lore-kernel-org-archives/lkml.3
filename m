Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaGVN0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:26:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44845 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbaGVN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:26:45 -0400
Date: Tue, 22 Jul 2014 15:26:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
Message-ID: <20140722132652.GO15237@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
 <20140722114607.GL15237@phenom.ffwll.local>
 <20140722115737.GN15237@phenom.ffwll.local>
 <53CE56ED.4040109@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53CE56ED.4040109@vodafone.de>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:19:57PM +0200, Christian König wrote:
> Am 22.07.2014 13:57, schrieb Daniel Vetter:
> >On Tue, Jul 22, 2014 at 01:46:07PM +0200, Daniel Vetter wrote:
> >>On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
> >>>Am 22.07.2014 06:05, schrieb Dave Airlie:
> >>>>On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
> >>>>>Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> >>>>>---
> >>>>>  drivers/gpu/drm/radeon/radeon.h        |   15 +-
> >>>>>  drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
> >>>>>  drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
> >>>>>  3 files changed, 248 insertions(+), 50 deletions(-)
> >>>>>
> >>>> From what I can see this is still suffering from the problem that we
> >>>>need to find a proper solution to,
> >>>>
> >>>>My summary of the issues after talking to Jerome and Ben and
> >>>>re-reading things is:
> >>>>
> >>>>We really need to work out a better interface into the drivers to be
> >>>>able to avoid random atomic entrypoints,
> >>>Which is exactly what I criticized from the very first beginning. Good to
> >>>know that I'm not the only one thinking that this isn't such a good idea.
> >>I guess I've lost context a bit, but which atomic entry point are we
> >>talking about? Afaics the only one that's mandatory is the is
> >>fence->signaled callback to check whether a fence really has been
> >>signalled. It's used internally by the fence code to avoid spurious
> >>wakeups. Afaik that should be doable already on any hardware. If that's
> >>not the case then we can always track the signalled state in software and
> >>double-check in a worker thread before updating the sw state. And wrap
> >>this all up into a special fence class if there's more than one driver
> >>needing this.
> >One thing I've forgotten: The i915 scheduler that's floating around runs
> >its bottom half from irq context. So I really want to be able to check
> >fence state from irq context and I also want to make it possible
> >(possible! not mandatory) to register callbacks which are run from any
> >context asap after the fence is signalled.
> 
> NAK, that's just the bad design I've talked about. Checking fence state
> inside the same driver from interrupt context is OK, because it's the
> drivers interrupt that we are talking about here.
> 
> Checking fence status from another drivers interrupt context is what really
> concerns me here, cause your driver doesn't have the slightest idea if the
> called driver is really capable of checking the fence right now.

I guess my mail hasn't been clear then. If you don't like it we could add
a bit of glue to insulate the madness and bad design i915 might do from
radeon. That imo doesn't invalidate the overall fence interfaces.

So what about the following:
- fence->enabling_signaling is restricted to be called from process
  context. We don't use any different yet, so would boild down to adding a
  WARN_ON(in_interrupt) or so to fence_enable_sw_signalling.

- Make fence->signaled optional (already the case) and don't implement it
  in readon (i.e. reduce this patch here). Only downside is that radeon
  needs to correctly (i.e. without races or so) call fence_signal. And the
  cross-driver synchronization might be a bit less efficient. Note that
  you can call fence_signal from wherever you want to, so hopefully that
  doesn't restrict your implementation. 

End result: No one calls into radeon from interrupt context, and this is
guaranteed.

Would that be something you can agree to?

Like I've said I think restricting the insanity other people are willing
to live with just because you don't like it isn't right. But it is
certainly right for you to insist on not being forced into any such
design. I think the above would achieve this.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
