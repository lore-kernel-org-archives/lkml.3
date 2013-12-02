Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab3LBU4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:56:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3LBTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Richter <thor@math.tu-berlin.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 097/173] drm/i915: flush cursors harder
Date: Mon,  2 Dec 2013 11:11:20 -0800
Message-Id: <20131202191155.148666905@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6262,7 +6262,9 @@ static void i9xx_update_cursor(struct dr
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR(pipe));
 	I915_WRITE(CURBASE(pipe), base);
+	POSTING_READ(CURBASE(pipe));
 }
 
 static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
@@ -6289,7 +6291,9 @@ static void ivb_update_cursor(struct drm
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR_IVB(pipe));
 	I915_WRITE(CURBASE_IVB(pipe), base);
+	POSTING_READ(CURBASE_IVB(pipe));
 }
 
 /* If no-part of the cursor is visible on the framebuffer, then the GPU may hang... */


