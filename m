Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaFWIqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:46:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55589 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/111] drm/i915: Allow user modes to exceed DVI 165MHz limit
Date: Mon, 23 Jun 2014 10:31:51 +0200
Message-Id: <a2793aa17bdf13e3959f016b6ee224a9468555e7.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 40478455fefdc0bde24ae872c3f88d58a1b0e435 upstream.

In commit
 commit 6375b768a9850b6154478993e5fb566fa4614a9c
 Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
 Date:   Mon Mar 3 11:33:36 2014 +0200

    drm/i915: Reject >165MHz modes w/ DVI monitors

the driver started to filter out display modes which exceed the
single-link DVI 165Mz dotclock limits when the monitor doesn't report
itself as being HDMI compliant. The intent was to filter out all
EDID derived modes that require dual-link DVI to operate since we
don't support dual-link.

However the patch went a bit too far and also causes the driver to reject
such modes even when specified by the user. Normally we don't check the
sink limitations when setting a mode from the user. This allows the user
to specify any mode whether the sink reports to support it or not. This
can be useful since often the sinks support more modes than they report
in the EDID.

So relax the checks a bit, and apply the single-link DVI dotclock limit
only when filtering the mode list, and ignore the limit when setting
a user specified mode.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=72961
Tested-by: Nicholas Vinson <nvinson@comcast.net>
Cc: stable@vger.kernel.org [3.14]
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_hdmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 4d302f3dec89..f5c4366a7213 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -830,11 +830,11 @@ static void intel_disable_hdmi(struct intel_encoder *encoder)
 	}
 }
 
-static int hdmi_portclock_limit(struct intel_hdmi *hdmi)
+static int hdmi_portclock_limit(struct intel_hdmi *hdmi, bool respect_dvi_limit)
 {
 	struct drm_device *dev = intel_hdmi_to_dev(hdmi);
 
-	if (!hdmi->has_hdmi_sink || IS_G4X(dev))
+	if ((respect_dvi_limit && !hdmi->has_hdmi_sink) || IS_G4X(dev))
 		return 165000;
 	else if (IS_HASWELL(dev))
 		return 300000;
@@ -845,7 +845,8 @@ static int hdmi_portclock_limit(struct intel_hdmi *hdmi)
 static int intel_hdmi_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
-	if (mode->clock > hdmi_portclock_limit(intel_attached_hdmi(connector)))
+	if (mode->clock > hdmi_portclock_limit(intel_attached_hdmi(connector),
+					       true))
 		return MODE_CLOCK_HIGH;
 	if (mode->clock < 20000)
 		return MODE_CLOCK_LOW;
@@ -863,7 +864,7 @@ bool intel_hdmi_compute_config(struct intel_encoder *encoder,
 	struct drm_device *dev = encoder->base.dev;
 	struct drm_display_mode *adjusted_mode = &pipe_config->adjusted_mode;
 	int clock_12bpc = pipe_config->requested_mode.clock * 3 / 2;
-	int portclock_limit = hdmi_portclock_limit(intel_hdmi);
+	int portclock_limit = hdmi_portclock_limit(intel_hdmi, false);
 	int desired_bpp;
 
 	if (intel_hdmi->color_range_auto) {
-- 
2.0.0

