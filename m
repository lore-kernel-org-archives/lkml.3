Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3CDECc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:02:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468Ab3CDDnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:46 -0500
Message-Id: <20130304033715.447220421@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 080/153] drm/i915: disable shared panel fitter for pipe
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3242,6 +3242,7 @@ static void i9xx_crtc_disable(struct drm
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	int pipe = intel_crtc->pipe;
 	int plane = intel_crtc->plane;
+	u32 pctl;
 
 	if (!intel_crtc->active)
 		return;
@@ -3257,6 +3258,13 @@ static void i9xx_crtc_disable(struct drm
 
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


