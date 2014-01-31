Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbaAaRf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:35:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaAaRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 03/14] drm/i915: fix DDI PLLs HW state readout code
Date: Fri, 31 Jan 2014 09:32:06 -0800
Message-Id: <1391189537-20777-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ddi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_ddi.c b/drivers/gpu/drm/i915/intel_ddi.c
index b8e53d9..6f09de3 100644
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1178,12 +1178,18 @@ void intel_ddi_setup_hw_pll_state(struct drm_device *dev)
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

