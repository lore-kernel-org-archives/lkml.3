Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3E1VVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:21:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3E1VVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Damien Lespiau <damien.lespiau@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 01/78] drm/i915: Revert hdmi HDP pin checks
Date: Tue, 28 May 2013 14:19:10 -0700
Message-Id: <1369776027-17859-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 202adf4b9f5957b26a1cb97267d78e0edb319c5e upstream.

This reverts

commit 8ec22b214d76773c9d89f4040505ce10f677ed9a
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri May 11 18:01:34 2012 +0100

    drm/i915/hdmi: Query the live connector status bit for G4x

and

commit b0ea7d37a8f63eeec5ae80b4a6403cfba01da02f
Author: Damien Lespiau <damien.lespiau@intel.com>
Date:   Thu Dec 13 16:09:00 2012 +0000

    drm/i915/hdmi: Read the HPD status before trying to read the EDID

They reliably cause HDMI to not be detected on some systems (like my
ivb or the bug reporters gm45). To fix up the very slow unplug issues
we might want to fire up a 2nd detect cycle a few hundred ms after
each hotplug. But for now at least make displays work again.

I somewhat suspect that this is confined to HDMI connectors, since all
the machines I have with DP+ outputs work correctly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=52361
Cc: Damien Lespiau <damien.lespiau@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: revert 8ec22b21 for 3.8 backport ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_hdmi.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 2ee9821..8246706 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -769,27 +769,6 @@ bool intel_hdmi_mode_fixup(struct drm_encoder *encoder,
 	return true;
 }
 
-static bool g4x_hdmi_connected(struct intel_hdmi *intel_hdmi)
-{
-	struct drm_device *dev = intel_hdmi_to_dev(intel_hdmi);
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	uint32_t bit;
-
-	switch (intel_hdmi->sdvox_reg) {
-	case SDVOB:
-		bit = HDMIB_HOTPLUG_LIVE_STATUS;
-		break;
-	case SDVOC:
-		bit = HDMIC_HOTPLUG_LIVE_STATUS;
-		break;
-	default:
-		bit = 0;
-		break;
-	}
-
-	return I915_READ(PORT_HOTPLUG_STAT) & bit;
-}
-
 static enum drm_connector_status
 intel_hdmi_detect(struct drm_connector *connector, bool force)
 {
@@ -801,9 +780,6 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
 	struct edid *edid;
 	enum drm_connector_status status = connector_status_disconnected;
 
-	if (IS_G4X(connector->dev) && !g4x_hdmi_connected(intel_hdmi))
-		return status;
-
 	intel_hdmi->has_hdmi_sink = false;
 	intel_hdmi->has_audio = false;
 	edid = drm_get_edid(connector,
-- 
1.8.1.2

