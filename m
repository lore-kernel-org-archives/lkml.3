Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaBGNVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:21:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaBGLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 022/233] drm/i915: fix DDI PLLs HW state readout code
Date: Fri,  7 Feb 2014 11:44:01 +0000
Message-Id: <1391773652-25214-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 0882dae983707455e97479e5e904e37673517ebc upstream.

Properly zero the refcounts and crtc->ddi_pll_set so the previous HW
state doesn't affect the result of reading the current HW state.

This fixes WARNs about WRPLL refcount if we have an HDMI monitor on
HSW and then suspend/resume.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=64379
Tested-by: Qingshuai Tian <qingshuai.tian@intel.com>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index e9af22a..029a165 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -978,12 +978,18 @@ void intel_ddi_setup_hw_pll_state(struct drm_device *dev)
 	enum pipe pipe;
 	struct intel_crtc *intel_crtc;
 
+	dev_priv->ddi_plls.spll_refcount = 0;
+	dev_priv->ddi_plls.wrpll1_refcount = 0;
+	dev_priv->ddi_plls.wrpll2_refcount = 0;
+
 	for_each_pipe(pipe) {
 		intel_crtc =
 			to_intel_crtc(dev_priv->pipe_to_crtc_mapping[pipe]);
 
-		if (!intel_crtc->active)
+		if (!intel_crtc->active) {
+			intel_crtc->ddi_pll_sel = PORT_CLK_SEL_NONE;
 			continue;
+		}
 
 		intel_crtc->ddi_pll_sel = intel_ddi_get_crtc_pll(dev_priv,
 								 pipe);
-- 
1.8.3.2

