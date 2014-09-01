Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaIAIK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:10:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:23537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaIAIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="566468234"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
Subject: [PATCH] drm/i915: Fix lock dropping in intel_tv_detect()
Date: Mon,  1 Sep 2014 11:09:46 +0300
Message-Id: <1409558986-5099-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <877g1ndfh5.fsf@intel.com>
References: <877g1ndfh5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

When intel_tv_detect() fails to do load detection it would forget to
drop the locks and clean up the acquire context. Fix it up.

This is a regression from:
 commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
 Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
 Date:   Mon Aug 11 13:15:35 2014 +0300

    drm/i915: Fix locking for intel_enable_pipe_a()

Cc: Tibor Billes <tbilles@gmx.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_tv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 32186a6..abbf0ea 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1311,7 +1311,8 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 {
 	struct drm_display_mode mode;
 	struct intel_tv *intel_tv = intel_attached_tv(connector);
-	int type;
+	enum drm_connector_status status = connector->status;
+	int type = -1;
 
 	DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
 		      connector->base.id, connector->name,
@@ -1328,21 +1329,23 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 		if (intel_get_load_detect_pipe(connector, &mode, &tmp, &ctx)) {
 			type = intel_tv_detect_type(intel_tv, connector);
 			intel_release_load_detect_pipe(connector, &tmp);
+			status = type < 0 ?
+				connector_status_disconnected :
+				connector_status_connected;
 		} else
-			return connector_status_unknown;
+			status = connector_status_unknown;
 
 		drm_modeset_drop_locks(&ctx);
 		drm_modeset_acquire_fini(&ctx);
-	} else
-		return connector->status;
+	}
 
 	if (type < 0)
-		return connector_status_disconnected;
+		return status;
 
 	intel_tv->type = type;
 	intel_tv_find_better_format(connector);
 
-	return connector_status_connected;
+	return status;
 }
 
 static const struct input_res {
-- 
1.8.5.5

