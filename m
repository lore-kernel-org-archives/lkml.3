Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab3AOWhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:37:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:44110 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab3AOWgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 220/221] i915: ensure that VGA plane is disabled
Date: Tue, 15 Jan 2013 10:52:27 -0800
Message-Id: <20130115185013.929783424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Mazur <krzysiek@podlesie.net>

commit 0fde901f1ddd2ce0e380a6444f1fb7ca555859e9 upstream.

Some broken systems (like HP nc6120) in some cases, usually after LID
close/open, enable VGA plane, making display unusable (black screen on LVDS,
some strange mode on VGA output). We used to disable VGA plane only once at
startup. Now we also check, if VGA plane is still disabled while changing
mode, and fix that if something changed it.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=57434
Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8248,6 +8248,23 @@ static void intel_sanitize_encoder(struc
 	 * the crtc fixup. */
 }
 
+static void i915_redisable_vga(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 vga_reg;
+
+	if (HAS_PCH_SPLIT(dev))
+		vga_reg = CPU_VGACNTRL;
+	else
+		vga_reg = VGACNTRL;
+
+	if (I915_READ(vga_reg) != VGA_DISP_DISABLE) {
+		DRM_DEBUG_KMS("Something enabled VGA plane, disabling it\n");
+		I915_WRITE(vga_reg, VGA_DISP_DISABLE);
+		POSTING_READ(vga_reg);
+	}
+}
+
 /* Scan out the current hw modeset state, sanitizes it and maps it into the drm
  * and i915 state tracking structures. */
 void intel_modeset_setup_hw_state(struct drm_device *dev,
@@ -8328,6 +8345,8 @@ void intel_modeset_setup_hw_state(struct
 			intel_set_mode(&crtc->base, &crtc->base.mode,
 				       crtc->base.x, crtc->base.y, crtc->base.fb);
 		}
+
+		i915_redisable_vga(dev);
 	} else {
 		intel_modeset_update_staged_output_state(dev);
 	}


