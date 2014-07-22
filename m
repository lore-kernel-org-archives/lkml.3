Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaGVLwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:52:32 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44443 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaGVLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:52:30 -0400
Date: Tue, 22 Jul 2014 13:52:39 +0200
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
Message-ID: <20140722115239.GM15237@phenom.ffwll.local>
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
 <20140722114607.GL15237@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140722114607.GL15237@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:46:07PM +0200, Daniel Vetter wrote:
> On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
> > Am 22.07.2014 06:05, schrieb Dave Airlie:
> > >On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
> > >>Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > >>---
> > >>  drivers/gpu/drm/radeon/radeon.h        |   15 +-
> > >>  drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
> > >>  drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
> > >>  3 files changed, 248 insertions(+), 50 deletions(-)
> > >>
> > > From what I can see this is still suffering from the problem that we
> > >need to find a proper solution to,
> > >
> > >My summary of the issues after talking to Jerome and Ben and
> > >re-reading things is:
> > >
> > >We really need to work out a better interface into the drivers to be
> > >able to avoid random atomic entrypoints,
> > 
> > Which is exactly what I criticized from the very first beginning. Good to
> > know that I'm not the only one thinking that this isn't such a good idea.
> 
> I guess I've lost context a bit, but which atomic entry point are we
> talking about? Afaics the only one that's mandatory is the is
> fence->signaled callback to check whether a fence really has been
> signalled. It's used internally by the fence code to avoid spurious
> wakeups. Afaik that should be doable already on any hardware. If that's
> not the case then we can always track the signalled state in software and
> double-check in a worker thread before updating the sw state. And wrap
> this all up into a special fence class if there's more than one driver
> needing this.
> 
> There is nothing else that forces callbacks from atomic contexts upon you.
> You can use them if you see it fit, but really if it doesn't suit your
> driver you can just ignore that part and do process based waits
> everywhere.

Aside: The fence-process-callback has already been implemented by nouveau
with the struct fence_work in nouveau_fence.c. Would make loads of sense
to move that code into the driver core and adapat it to Maarten's struct
fence once this has all landed.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
