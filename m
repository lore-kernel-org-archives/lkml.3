Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaFIIyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:54:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58480 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476AbaFIIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Egbert Eich <eich@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/146] drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()
Date: Mon,  9 Jun 2014 10:49:37 +0200
Message-Id: <6d7ed02039761fc0e7acbb839de65a4bfdd40486.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Egbert Eich <eich@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7f1950fbb989e8fc5463b307e062b4529d51c862 upstream.

Depending on the SDVO output_flags SDVO may have multiple connectors
linking to the same encoder (in intel_connector->encoder->base).
Only one of those connectors should be active (ie link to the encoder
thru drm_connector->encoder).
If intel_connector_break_all_links() is called from intel_sanitize_crtc()
we may break the crtc connection of an encoder thru an inactive connector
in which case intel_connector_break_all_links() will not be called again
for the active connector if this happens to come later in the list due to:
    if (connector->encoder->base.crtc != &crtc->base)
                                 continue;
in intel_sanitize_crtc().
This will however leave the drm_connector->encoder linkage for this
active connector in place. Subsequently this will cause multiple
warnings in intel_connector_check_state() to trigger and the driver
will eventually die in drm_encoder_crtc_ok() (because of crtc == NULL).

To avoid this remove intel_connector_break_all_links() and move its
code to its two calling functions: intel_sanitize_crtc() and
intel_sanitize_encoder().
This allows to implement the link breaking more flexibly matching
the surrounding code: ie. in intel_sanitize_crtc() we can break the
crtc link separatly after the links to the encoders have been
broken which avoids above problem.

This regression has been introduced in:

commit 24929352481f085c5f85d4d4cbc919ddf106d381
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Jul 2 20:28:59 2012 +0200

    drm/i915: read out the modeset hw state at load and resume time

so goes back to the very beginning of the modeset rework.

v2: This patch takes care of the concernes voiced by Chris Wilson
and Daniel Vetter that only breaking links if the drm_connector
is linked to an encoder may miss some links.
v3: move all encoder handling to encoder loop as suggested by
Daniel Vetter.

Signed-off-by: Egbert Eich <eich@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_display.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 48a4faf5e63a..c74bf330d290 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10239,15 +10239,6 @@ void intel_modeset_init(struct drm_device *dev)
 	intel_disable_fbc(dev);
 }
 
-static void
-intel_connector_break_all_links(struct intel_connector *connector)
-{
-	connector->base.dpms = DRM_MODE_DPMS_OFF;
-	connector->base.encoder = NULL;
-	connector->encoder->connectors_active = false;
-	connector->encoder->base.crtc = NULL;
-}
-
 static void intel_enable_pipe_a(struct drm_device *dev)
 {
 	struct intel_connector *connector;
@@ -10329,8 +10320,17 @@ static void intel_sanitize_crtc(struct intel_crtc *crtc)
 			if (connector->encoder->base.crtc != &crtc->base)
 				continue;
 
-			intel_connector_break_all_links(connector);
+			connector->base.dpms = DRM_MODE_DPMS_OFF;
+			connector->base.encoder = NULL;
 		}
+		/* multiple connectors may have the same encoder:
+		 *  handle them and break crtc link separately */
+		list_for_each_entry(connector, &dev->mode_config.connector_list,
+				    base.head)
+			if (connector->encoder->base.crtc == &crtc->base) {
+				connector->encoder->base.crtc = NULL;
+				connector->encoder->connectors_active = false;
+			}
 
 		WARN_ON(crtc->active);
 		crtc->base.enabled = false;
@@ -10401,6 +10401,8 @@ static void intel_sanitize_encoder(struct intel_encoder *encoder)
 				      drm_get_encoder_name(&encoder->base));
 			encoder->disable(encoder);
 		}
+		encoder->base.crtc = NULL;
+		encoder->connectors_active = false;
 
 		/* Inconsistent output/port/pipe state happens presumably due to
 		 * a bug in one of the get_hw_state functions. Or someplace else
@@ -10411,8 +10413,8 @@ static void intel_sanitize_encoder(struct intel_encoder *encoder)
 				    base.head) {
 			if (connector->encoder != encoder)
 				continue;
-
-			intel_connector_break_all_links(connector);
+			connector->base.dpms = DRM_MODE_DPMS_OFF;
+			connector->base.encoder = NULL;
 		}
 	}
 	/* Enabled encoders without active connectors will be fixed in
-- 
1.9.3

