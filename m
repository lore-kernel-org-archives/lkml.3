Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3FQRfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:35:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3FQRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 63/84] drm/gma500/psb: Unpin framebuffer on crtc disable
Date: Mon, 17 Jun 2013 10:31:07 -0700
Message-Id: <1371490288-23167-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit 820de86a90089ee607d7864538c98a23b503c846 upstream.

The framebuffer needs to be unpinned in the crtc->disable callback
because of previous pinning in psb_intel_pipe_set_base(). This will fix
a memory leak where the framebuffer was released but not unpinned
properly. This patch only affects Poulsbo.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=889511
Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=812113
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/gma500/psb_intel_display.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index 8033526..8714d6a 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -1246,6 +1246,19 @@ void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void psb_intel_crtc_disable(struct drm_crtc *crtc)
+{
+	struct gtt_range *gt;
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	if (crtc->fb) {
+		gt = to_psb_fb(crtc->fb)->gtt;
+		psb_gtt_unpin(gt);
+	}
+}
+
 const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.dpms = psb_intel_crtc_dpms,
 	.mode_fixup = psb_intel_crtc_mode_fixup,
@@ -1253,6 +1266,7 @@ const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.mode_set_base = psb_intel_pipe_set_base,
 	.prepare = psb_intel_crtc_prepare,
 	.commit = psb_intel_crtc_commit,
+	.disable = psb_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
-- 
1.8.1.2

