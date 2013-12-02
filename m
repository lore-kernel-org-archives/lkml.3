Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3LBTsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:48:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3LBTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?G=C3=B6k=C3=A7en=20Eraslan?= <gokcen.eraslan@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 131/212] drm/i915: Replicate BIOS eDP bpp clamping hack for hsw
Date: Mon,  2 Dec 2013 11:15:22 -0800
Message-Id: <20131202191301.601487320@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ddi.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1285,6 +1285,26 @@ void intel_ddi_get_config(struct intel_e
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


