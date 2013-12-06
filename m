Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161138Ab3LFNAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161114Ab3LFM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/272] drm/i915: Replicate BIOS eDP bpp clamping hack for hsw
Date: Fri,  6 Dec 2013 12:55:12 +0000
Message-Id: <1386334761-25517-24-git-send-email-luis.henriques@canonical.com>
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

commit 1021442098ee9328fdd4d113d63a3a7f2f40c37b upstream.

Haswell's DDI encoders have their own ->get_config callback and in

commit c6cd2ee2d59111a07cd9199564c9bdcb2d11e5cf
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Mon Oct 21 10:52:07 2013 +0300

    drm/i915/dp: workaround BIOS eDP bpp clamping issue

we've forgotten to replicate this hack. So let's do it that.

Note for backporters: The above commit and all it's depencies need to
be backported first.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71049
Tested-by: Gökçen Eraslan <gokcen.eraslan@gmail.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index 5a6368d..e9af22a 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1297,6 +1297,26 @@ void intel_ddi_get_config(struct intel_encoder *encoder,
 	default:
 		break;
 	}
+
+	if (encoder->type == INTEL_OUTPUT_EDP && dev_priv->vbt.edp_bpp &&
+	    pipe_config->pipe_bpp > dev_priv->vbt.edp_bpp) {
+		/*
+		 * This is a big fat ugly hack.
+		 *
+		 * Some machines in UEFI boot mode provide us a VBT that has 18
+		 * bpp and 1.62 GHz link bandwidth for eDP, which for reasons
+		 * unknown we fail to light up. Yet the same BIOS boots up with
+		 * 24 bpp and 2.7 GHz link. Use the same bpp as the BIOS uses as
+		 * max, not what it tells us to use.
+		 *
+		 * Note: This will still be broken if the eDP panel is not lit
+		 * up by the BIOS, and thus we can't get the mode at module
+		 * load.
+		 */
+		DRM_DEBUG_KMS("pipe has %d bpp for eDP panel, overriding BIOS-provided max %d bpp\n",
+			      pipe_config->pipe_bpp, dev_priv->vbt.edp_bpp);
+		dev_priv->vbt.edp_bpp = pipe_config->pipe_bpp;
+	}
 }
 
 static void intel_ddi_destroy(struct drm_encoder *encoder)
-- 
1.8.3.2

