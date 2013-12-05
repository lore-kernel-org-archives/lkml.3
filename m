Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab3LERtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:49:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3LERhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Richter <thor@math.tu-berlin.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 56/90] drm/i915: flush cursors harder
Date: Thu,  5 Dec 2013 17:35:38 +0000
Message-Id: <1386264972-5399-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 05f75ff..c0668fb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5015,7 +5015,9 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR(pipe));
 	I915_WRITE(CURBASE(pipe), base);
+	POSTING_READ(CURBASE(pipe));
 }
 
 static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
@@ -5040,7 +5042,9 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR_IVB(pipe));
 	I915_WRITE(CURBASE_IVB(pipe), base);
+	POSTING_READ(CURBASE_IVB(pipe));
 }
 
 /* If no-part of the cursor is visible on the framebuffer, then the GPU may hang... */
-- 
1.8.3.2

