Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3FKUFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:05:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab3FKUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Egbert Eich <eich@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 70/79] drm/i915: force full modeset if the connector is in DPMS OFF mode
Date: Tue, 11 Jun 2013 13:03:36 -0700
Message-Id: <20130611195325.239932641@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit e3de42b68478a8c95dd27520e9adead2af9477a5 upstream.

Currently the driver's assumed behavior for a modeset with an attached
FB is that the corresponding connector will be switched to DPMS ON mode
if it happened to be in DPMS OFF (or another power save mode). This
wasn't enforced though if only the FB changed, everything else (format,
connector etc.) remaining the same. In this case we only set the new FB
base and left the connector in the old power save mode.

Fix this by forcing a full modeset whenever there is an attached FB and
any affected connector is in a power save mode.

V_2: Run the test for encoders in power save mode outside the the
test for fb change: user space may have just disabled the encoders
but left everything else in place. Make sure the connector list is
not empty before running this test.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Egbert Eich <eich@suse.de>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=61642
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59834
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59339
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=64178
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65559
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
[danvet: Apply Jani's s/connector_off/is_crtc_connector_off bikeshed.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7960,6 +7960,21 @@ static void intel_set_config_restore_sta
 	}
 }
 
+static bool
+is_crtc_connector_off(struct drm_crtc *crtc, struct drm_connector *connectors,
+		      int num_connectors)
+{
+	int i;
+
+	for (i = 0; i < num_connectors; i++)
+		if (connectors[i].encoder &&
+		    connectors[i].encoder->crtc == crtc &&
+		    connectors[i].dpms != DRM_MODE_DPMS_ON)
+			return true;
+
+	return false;
+}
+
 static void
 intel_set_config_compute_mode_changes(struct drm_mode_set *set,
 				      struct intel_set_config *config)
@@ -7967,7 +7982,11 @@ intel_set_config_compute_mode_changes(st
 
 	/* We should be able to check here if the fb has the same properties
 	 * and then just flip_or_move it */
-	if (set->crtc->fb != set->fb) {
+	if (set->connectors != NULL &&
+	    is_crtc_connector_off(set->crtc, *set->connectors,
+				  set->num_connectors)) {
+			config->mode_changed = true;
+	} else if (set->crtc->fb != set->fb) {
 		/* If we have no fb then treat it as a full mode set */
 		if (set->crtc->fb == NULL) {
 			DRM_DEBUG_KMS("crtc has no fb, full mode set\n");
@@ -7979,8 +7998,9 @@ intel_set_config_compute_mode_changes(st
 		} else if (set->fb->bits_per_pixel !=
 			   set->crtc->fb->bits_per_pixel) {
 			config->mode_changed = true;
-		} else
+		} else {
 			config->fb_changed = true;
+		}
 	}
 
 	if (set->fb && (set->x != set->crtc->x || set->y != set->crtc->y))


