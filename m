Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3B0BA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:00:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab3BZX5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Damien Lespiau <damien.lespiau@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 081/150] drm/i915: Preserve the FDI line reversal override bit on CPT
Date: Tue, 26 Feb 2013 15:55:38 -0800
Message-Id: <20130226235532.519698861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Lespiau <damien.lespiau@intel.com>

commit 3e68320ef84528604d971afc3cadfbe208bef001 upstream.

The FDI link has supported link reversal to make the PCB layout
engineer's life easier for quite a while and we have always presered
this bit as we programmed FDI_RX_CTL with a read/modify/write sequence.

We're trying to take a bit more control over what the BIOS leaves in
various register and with the introduction of DDI, started to program
FDI_RX_CTL fully.

There's a fused bit to indicate DMI link reversal and FDI defaults to
mirroring that configuration. We have a bit to override that behaviour
that we need to preserve from the BIOS.

Signed-off-by: Damien Lespiau <damien.lespiau@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h  |    2 +-
 drivers/gpu/drm/i915/i915_reg.h  |    2 +-
 drivers/gpu/drm/i915/intel_crt.c |   14 +++++++++-----
 drivers/gpu/drm/i915/intel_ddi.c |    6 ++----
 4 files changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -919,7 +919,7 @@ typedef struct drm_i915_private {
 	bool hw_contexts_disabled;
 	uint32_t hw_context_size;
 
-	bool fdi_rx_polarity_reversed;
+	u32 fdi_rx_config;
 
 	struct i915_suspend_saved_registers regfile;
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3927,7 +3927,7 @@
 #define  FDI_10BPC                      (1<<16)
 #define  FDI_6BPC                       (2<<16)
 #define  FDI_12BPC                      (3<<16)
-#define  FDI_LINK_REVERSE_OVERWRITE     (1<<15)
+#define  FDI_RX_LINK_REVERSAL_OVERRIDE  (1<<15)
 #define  FDI_DMI_LINK_REVERSE_MASK      (1<<14)
 #define  FDI_RX_PLL_ENABLE              (1<<13)
 #define  FDI_FS_ERR_CORRECT_ENABLE      (1<<11)
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -800,10 +800,14 @@ void intel_crt_init(struct drm_device *d
 	dev_priv->hotplug_supported_mask |= CRT_HOTPLUG_INT_STATUS;
 
 	/*
-	 * TODO: find a proper way to discover whether we need to set the
-	 * polarity reversal bit or not, instead of relying on the BIOS.
+	 * TODO: find a proper way to discover whether we need to set the the
+	 * polarity and link reversal bits or not, instead of relying on the
+	 * BIOS.
 	 */
-	if (HAS_PCH_LPT(dev))
-		dev_priv->fdi_rx_polarity_reversed =
-		     !!(I915_READ(_FDI_RXA_CTL) & FDI_RX_POLARITY_REVERSED_LPT);
+	if (HAS_PCH_LPT(dev)) {
+		u32 fdi_config = FDI_RX_POLARITY_REVERSED_LPT |
+				 FDI_RX_LINK_REVERSAL_OVERRIDE;
+
+		dev_priv->fdi_rx_config = I915_READ(_FDI_RXA_CTL) & fdi_config;
+	}
 }
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -178,10 +178,8 @@ void hsw_fdi_link_train(struct drm_crtc
 				  FDI_RX_TP1_TO_TP2_48 | FDI_RX_FDI_DELAY_90);
 
 	/* Enable the PCH Receiver FDI PLL */
-	rx_ctl_val = FDI_RX_PLL_ENABLE | FDI_RX_ENHANCE_FRAME_ENABLE |
-		     ((intel_crtc->fdi_lanes - 1) << 19);
-	if (dev_priv->fdi_rx_polarity_reversed)
-		rx_ctl_val |= FDI_RX_POLARITY_REVERSED_LPT;
+	rx_ctl_val = dev_priv->fdi_rx_config | FDI_RX_ENHANCE_FRAME_ENABLE |
+		     FDI_RX_PLL_ENABLE | ((intel_crtc->fdi_lanes - 1) << 19);
 	I915_WRITE(_FDI_RXA_CTL, rx_ctl_val);
 	POSTING_READ(_FDI_RXA_CTL);
 	udelay(220);


