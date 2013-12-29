Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3L2CNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:13:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55821 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab3L2CNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:13:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Ville =?UTF-8?Q?Syrj=C3=A4l=C3=A4?=" <ville.syrjala@linux.intel.com>,
        "Thomas Richter" <thor@math.tu-berlin.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.267139622@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 067/185] drm/i915: flush cursors harder
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b2ea8ef559b4d94190009f3651b5b3ab7c05afd3 upstream.

Apparently they need the same treatment as primary planes. This fixes
modesetting failures because of stuck cursors (!) on Thomas' i830M
machine.

I've figured while at it I'll also roll it out for the ivb 3 pipe
version of this function. I didn't do this for i845/i865 since Bspec
says the update mechanism works differently, and there's some
additional rules about what can be updated in which order.

Tested-by: Thomas Richter <thor@math.tu-berlin.de>
Cc:  Thomas Richter <thor@math.tu-berlin.de>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6063,7 +6063,9 @@ static void i9xx_update_cursor(struct dr
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR(pipe));
 	I915_WRITE(CURBASE(pipe), base);
+	POSTING_READ(CURBASE(pipe));
 }
 
 static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
@@ -6088,7 +6090,9 @@ static void ivb_update_cursor(struct drm
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR_IVB(pipe));
 	I915_WRITE(CURBASE_IVB(pipe), base);
+	POSTING_READ(CURBASE_IVB(pipe));
 }
 
 /* If no-part of the cursor is visible on the framebuffer, then the GPU may hang... */

