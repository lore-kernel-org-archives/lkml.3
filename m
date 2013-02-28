Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab3B1PBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:01:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab3B1OuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 104/139] drm/i915: disable shared panel fitter for pipe
Date: Thu, 28 Feb 2013 14:44:14 +0000
Message-Id: <1362062689-2567-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

commit 24a1f16de97c4cf0029d9acd04be06db32208726 upstream.

If encoder is switched off by BIOS, but the panel fitter is left on,
we never try to turn off the panel fitter and leave it still attached
to the pipe - which can cause blurry output elsewhere.

Based on work by Chris Wilson <chris@chris-wilson.co.uk>

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58867
Signed-off-by: Mika Kuoppala <mika.kuoppala@intel.com>
Tested-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
[danvet: Remove the redundant HAS_PCH_SPLIT check and add a tiny
comment.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b61bc50..bff2719 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3226,6 +3226,7 @@ static void i9xx_crtc_disable(struct drm_crtc *crtc)
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	int pipe = intel_crtc->pipe;
 	int plane = intel_crtc->plane;
+	u32 pctl;
 
 	if (!intel_crtc->active)
 		return;
@@ -3241,6 +3242,13 @@ static void i9xx_crtc_disable(struct drm_crtc *crtc)
 
 	intel_disable_plane(dev_priv, plane, pipe);
 	intel_disable_pipe(dev_priv, pipe);
+
+	/* Disable pannel fitter if it is on this pipe. */
+	pctl = I915_READ(PFIT_CONTROL);
+	if ((pctl & PFIT_ENABLE) &&
+	    ((pctl & PFIT_PIPE_MASK) >> PFIT_PIPE_SHIFT) == pipe)
+		I915_WRITE(PFIT_CONTROL, 0);
+
 	intel_disable_pll(dev_priv, pipe);
 
 	intel_crtc->active = false;
-- 
1.8.1.2

