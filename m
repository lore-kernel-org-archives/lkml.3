Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaIAKHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:07:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:52410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaIAKHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="566513979"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        Tibor Billes <tbilles@gmx.com>
Subject: [PATCH v2] drm/i915: Fix lock dropping in intel_tv_detect()
Date: Mon,  1 Sep 2014 13:07:40 +0300
Message-Id: <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140901085022.GB11648@nuc-i3427.alporthouse.com>
References: <20140901085022.GB11648@nuc-i3427.alporthouse.com>
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

v2: Make the code more readable (Chris)

Cc: Tibor Billes <tbilles@gmx.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_tv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 32186a6..c6b00f20 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1311,6 +1311,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
 {
 	struct drm_display_mode mode;
 	struct intel_tv *intel_tv = intel_attached_tv(connector);
+	enum drm_connector_status status;
 	int type;
 
 	DRM_DEBUG_KMS("[CONNECTOR:%d:%s] force=%d\n",
@@ -1328,15 +1329,21 @@ intel_tv_detect(struct drm_connector *connector, bool force)
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
 	} else
 		return connector->status;
 
-	if (type < 0)
+	if (status != connector_status_connected)
+		return status;
+
+	if (WARN_ON(type < 0))
 		return connector_status_disconnected;
 
 	intel_tv->type = type;
-- 
1.8.5.5

