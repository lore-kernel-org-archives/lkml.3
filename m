Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaDXUPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:15:42 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:57488 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbaDXUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:15:36 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 24 Apr 2014 21:15:21 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: [bisect result] Re: 3.15-rc2: i915 regression: only top 20% of
 screen works in X
Message-ID: <20140424201521.GN31221@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jikos@jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
 <20140424194037.GB30333@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424194037.GB30333@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 09:40:38PM +0200, Pavel Machek wrote:
> Hi!
> 
> > And if you can indeed reliably reproduce this a bisect could be really useful.
> 
> And we have a winner here :-)
> 
> Ok, it was not as painfull as I feared.
> 
> It does not revert cleanly, but doing it by hand was not that bad.

Oh my. That is bizarre, can you check whether you have

commit 9991ae787a0c87fe7c783b4b6f4754c3cdbb6213
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Apr 2 16:36:07 2014 +0100

    drm/i915: Move all ring resets before setting the HWS page

in your latest kernel? That just makes

> commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
> Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
> Date:   Wed Mar 12 16:39:40 2014 +0530
> 
>     drm/i915: disable rings before HW status page setup

more consistent wrt g4x.

To confirm, on drm-intel-nightly you used a patch like:

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 36a62af..ce6186a 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -494,6 +494,11 @@ static int init_ring_common(struct intel_ring_buffer *ring)
               I915_READ_TAIL(ring),
               I915_READ_START(ring));
 
+       if (I915_NEED_GFX_HWS(dev))
+               intel_ring_setup_status_page(ring);
+       else
+               ring_setup_phys_status_page(ring);
+
        if (!stop_ring(ring)) {
                /* G45 ring initialization often fails to reset head to zero */
                DRM_DEBUG_KMS("%s head not reset to zero "
@@ -517,11 +522,6 @@ static int init_ring_common(struct intel_ring_buffer *ring)
                }
        }
 
-       if (I915_NEED_GFX_HWS(dev))
-               intel_ring_setup_status_page(ring);
-       else
-               ring_setup_phys_status_page(ring);
-
 reset:
        /* Initialize the ring. This must happen _after_ we've cleared the ring
         * registers with the above sequence (the readback of the HEAD registers


-- 
Chris Wilson, Intel Open Source Technology Centre
