Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaFIJ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:26:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283AbaFIJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 120/146] drm/i915: Disable self-refresh for untiled fbs on i915gm
Date: Mon,  9 Jun 2014 10:50:55 +0200
Message-Id: <b5b77c8e46f976d1f1422c4247a0dda38b8f9279.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This is commit 2ab1bc9df01dbc19b55b2271100db7 upstream.

Apparently it doesn't work. X-tiled self-refresh works flawlessly
otoh. Apparently X still works correctly with linear framebuffers, so
might just be an issue with the initial modeset. It's unclear whether
this just borked wm setup from our side or a hw restriction, but just
disabling gets things going.

Note that this regression was only brought to light with

commit 3f2dc5ac05714711fc14f2bf0ee5e42d5c08c581
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Fri Jan 10 14:06:47 2014 +0200

    drm/i915: Fix 915GM self-refresh enable/disable

before that self-refresh for i915GM didn't work at all.

Kudos to Ville for spotting a little bug in the original patch I've
attached to the bug.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76103
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[Jani: rebase on top of drm-next with primary plane support.]
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_pm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 26c2ea3e985c..71a831ae73e9 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -1592,6 +1592,16 @@ static void i9xx_update_wm(struct drm_device *dev)
 
 	DRM_DEBUG_KMS("FIFO watermarks - A: %d, B: %d\n", planea_wm, planeb_wm);
 
+	if (IS_I915GM(dev) && enabled) {
+		struct intel_framebuffer *fb;
+
+		fb = to_intel_framebuffer(enabled->fb);
+
+		/* self-refresh seems busted with untiled */
+		if (fb->obj->tiling_mode == I915_TILING_NONE)
+			enabled = NULL;
+	}
+
 	/*
 	 * Overlay gets an aggressive default since video jitter is bad.
 	 */
-- 
1.9.3

