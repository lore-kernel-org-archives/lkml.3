Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079Ab3LFM7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:59:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3LFM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Richter <thor@math.tu-berlin.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/272] drm/i915: flush cursors harder
Date: Fri,  6 Dec 2013 12:55:02 +0000
Message-Id: <1386334761-25517-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
index ad2a258..449ec09 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6415,7 +6415,9 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR(pipe));
 	I915_WRITE(CURBASE(pipe), base);
+	POSTING_READ(CURBASE(pipe));
 }
 
 static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
@@ -6442,7 +6444,9 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
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

