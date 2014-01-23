Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaAWSm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:42:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaAWSjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qingshuai Tian <qingshuai.tian@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 15/23] drm/i915: fix DDI PLLs HW state readout code
Date: Thu, 23 Jan 2014 10:39:48 -0800
Message-Id: <20140123183901.989207539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ddi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1193,12 +1193,18 @@ void intel_ddi_setup_hw_pll_state(struct
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


