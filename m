Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab3GCTAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab3GCTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:20 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3DBaszRiHMcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-AnfmqIOyKwA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184106.163021523@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [117/141] drm/gma500/cdv: Unpin framebuffer on crtc disable
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0117-drm-gma500-cdv-Unpin-framebuffer-on-crtc-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

[ Upstream commit 22e7c385a80d771aaf3a15ae7ccea3b0686bbe10 ]

The framebuffer needs to be unpinned in the crtc->disable callback
because of previous pinning in psb_intel_pipe_set_base(). This will fix
a memory leak where the framebuffer was released but not unpinned
properly. This patch only affects Cedarview.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=889511
Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=812113
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/gma500/cdv_intel_display.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_display.c
index a68509b..294fcf5 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -1600,6 +1600,19 @@ static void cdv_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void cdv_intel_crtc_disable(struct drm_crtc *crtc)
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
 const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.dpms = cdv_intel_crtc_dpms,
 	.mode_fixup = cdv_intel_crtc_mode_fixup,
@@ -1607,6 +1620,7 @@ const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.mode_set_base = cdv_intel_pipe_set_base,
 	.prepare = cdv_intel_crtc_prepare,
 	.commit = cdv_intel_crtc_commit,
+	.disable = cdv_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs cdv_intel_crtc_funcs = {
-- 
1.7.10.4


