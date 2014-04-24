Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaDXUNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:13:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35442 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDXUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:13:50 -0400
Date: Thu, 24 Apr 2014 22:13:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: [PATCH] fix i915 regression: only top 20% of screen works in X
Message-ID: <20140424201349.GA31233@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix regression where only 20% of screen works in X. This is manual
revert of a51435a3137ad8ae75c288c39bd2d8b2696bae8f.

Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 6bc68bd..cf63c67 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -447,6 +447,11 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 
 	gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
 
+	if (I915_NEED_GFX_HWS(dev))
+		intel_ring_setup_status_page(ring);
+	else
+		ring_setup_phys_status_page(ring);
+
 	/* Stop the ring if it's running. */
 	I915_WRITE_CTL(ring, 0);
 	I915_WRITE_HEAD(ring, 0);
@@ -454,11 +459,6 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 	if (wait_for_atomic((I915_READ_MODE(ring) & MODE_IDLE) != 0, 1000))
 		DRM_ERROR("%s :timed out trying to stop ring\n", ring->name);
 
-	if (I915_NEED_GFX_HWS(dev))
-		intel_ring_setup_status_page(ring);
-	else
-		ring_setup_phys_status_page(ring);
-
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
 
 	/* G45 ring initialization fails to reset head to zero */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
