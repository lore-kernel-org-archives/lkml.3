Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3FPWJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:09:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625Ab3FPWJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Patrik Jakobsson" <patrik.r.jakobsson@gmail.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.905769996@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [64/83] drm/gma500/psb: Unpin framebuffer on crtc disable
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/gma500/psb_intel_display.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1255,6 +1255,19 @@ void psb_intel_crtc_destroy(struct drm_c
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
@@ -1262,6 +1275,7 @@ const struct drm_crtc_helper_funcs psb_i
 	.mode_set_base = psb_intel_pipe_set_base,
 	.prepare = psb_intel_crtc_prepare,
 	.commit = psb_intel_crtc_commit,
+	.disable = psb_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {

