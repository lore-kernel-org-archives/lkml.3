Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab3B0ASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:18:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760397Ab3B0AJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 53/86] drm/i915: disable shared panel fitter for pipe
Date: Tue, 26 Feb 2013 16:08:01 -0800
Message-Id: <20130226235918.428901738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3303,6 +3303,7 @@ static void i9xx_crtc_disable(struct drm
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	int pipe = intel_crtc->pipe;
 	int plane = intel_crtc->plane;
+	u32 pctl;
 
 	if (!intel_crtc->active)
 		return;
@@ -3318,6 +3319,13 @@ static void i9xx_crtc_disable(struct drm
 
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


