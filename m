Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3KIGxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:53:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3KIGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.11 80/94] drm/i915: Retry DP aux_ch communications with a different clock after failure
Date: Fri,  8 Nov 2013 22:52:26 -0800
Message-Id: <20131109065209.902625327@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit bc86625a4ff7574d4d4dba79723457711eb784e0 upstream.

The w/a db makes the recommendation to both use a non-default value for
the initial clock and then to retry with an alternative clock for
Haswell with the Lakeport PCH.

"On LPT:H, use a divider value of 63 decimal (03Fh). If there is a
failure, retry at least three times with 63, then retry at least three
times with 72 decimal (048h)."

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   90 ++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 40 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -276,7 +276,8 @@ intel_dp_aux_wait_done(struct intel_dp *
 	return status;
 }
 
-static uint32_t get_aux_clock_divider(struct intel_dp *intel_dp)
+static uint32_t get_aux_clock_divider(struct intel_dp *intel_dp,
+				      int index)
 {
 	struct intel_digital_port *intel_dig_port = dp_to_dig_port(intel_dp);
 	struct drm_device *dev = intel_dig_port->base.base.dev;
@@ -290,22 +291,27 @@ static uint32_t get_aux_clock_divider(st
 	 * clock divider.
 	 */
 	if (IS_VALLEYVIEW(dev)) {
-		return 100;
+		return index ? 0 : 100;
 	} else if (intel_dig_port->port == PORT_A) {
+		if (index)
+			return 0;
 		if (HAS_DDI(dev))
-			return DIV_ROUND_CLOSEST(
-				intel_ddi_get_cdclk_freq(dev_priv), 2000);
+			return DIV_ROUND_CLOSEST(intel_ddi_get_cdclk_freq(dev_priv), 2000);
 		else if (IS_GEN6(dev) || IS_GEN7(dev))
 			return 200; /* SNB & IVB eDP input clock at 400Mhz */
 		else
 			return 225; /* eDP input clock at 450Mhz */
 	} else if (dev_priv->pch_id == INTEL_PCH_LPT_DEVICE_ID_TYPE) {
 		/* Workaround for non-ULT HSW */
-		return 74;
+		switch (index) {
+		case 0: return 63;
+		case 1: return 72;
+		default: return 0;
+		}
 	} else if (HAS_PCH_SPLIT(dev)) {
-		return DIV_ROUND_UP(intel_pch_rawclk(dev), 2);
+		return index ? 0 : DIV_ROUND_UP(intel_pch_rawclk(dev), 2);
 	} else {
-		return intel_hrawclk(dev) / 2;
+		return index ? 0 :intel_hrawclk(dev) / 2;
 	}
 }
 
@@ -319,10 +325,10 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	uint32_t ch_ctl = intel_dp->aux_ch_ctl_reg;
 	uint32_t ch_data = ch_ctl + 4;
+	uint32_t aux_clock_divider;
 	int i, ret, recv_bytes;
 	uint32_t status;
-	uint32_t aux_clock_divider = get_aux_clock_divider(intel_dp);
-	int try, precharge;
+	int try, precharge, clock = 0;
 	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5 && !IS_VALLEYVIEW(dev);
 
 	/* dp aux is extremely sensitive to irq latency, hence request the
@@ -353,37 +359,41 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 		goto out;
 	}
 
-	/* Must try at least 3 times according to DP spec */
-	for (try = 0; try < 5; try++) {
-		/* Load the send data into the aux channel data registers */
-		for (i = 0; i < send_bytes; i += 4)
-			I915_WRITE(ch_data + i,
-				   pack_aux(send + i, send_bytes - i));
-
-		/* Send the command and wait for it to complete */
-		I915_WRITE(ch_ctl,
-			   DP_AUX_CH_CTL_SEND_BUSY |
-			   (has_aux_irq ? DP_AUX_CH_CTL_INTERRUPT : 0) |
-			   DP_AUX_CH_CTL_TIME_OUT_400us |
-			   (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-			   (precharge << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
-			   (aux_clock_divider << DP_AUX_CH_CTL_BIT_CLOCK_2X_SHIFT) |
-			   DP_AUX_CH_CTL_DONE |
-			   DP_AUX_CH_CTL_TIME_OUT_ERROR |
-			   DP_AUX_CH_CTL_RECEIVE_ERROR);
-
-		status = intel_dp_aux_wait_done(intel_dp, has_aux_irq);
-
-		/* Clear done status and any errors */
-		I915_WRITE(ch_ctl,
-			   status |
-			   DP_AUX_CH_CTL_DONE |
-			   DP_AUX_CH_CTL_TIME_OUT_ERROR |
-			   DP_AUX_CH_CTL_RECEIVE_ERROR);
-
-		if (status & (DP_AUX_CH_CTL_TIME_OUT_ERROR |
-			      DP_AUX_CH_CTL_RECEIVE_ERROR))
-			continue;
+	while ((aux_clock_divider = get_aux_clock_divider(intel_dp, clock++))) {
+		/* Must try at least 3 times according to DP spec */
+		for (try = 0; try < 5; try++) {
+			/* Load the send data into the aux channel data registers */
+			for (i = 0; i < send_bytes; i += 4)
+				I915_WRITE(ch_data + i,
+					   pack_aux(send + i, send_bytes - i));
+
+			/* Send the command and wait for it to complete */
+			I915_WRITE(ch_ctl,
+				   DP_AUX_CH_CTL_SEND_BUSY |
+				   (has_aux_irq ? DP_AUX_CH_CTL_INTERRUPT : 0) |
+				   DP_AUX_CH_CTL_TIME_OUT_400us |
+				   (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
+				   (precharge << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
+				   (aux_clock_divider << DP_AUX_CH_CTL_BIT_CLOCK_2X_SHIFT) |
+				   DP_AUX_CH_CTL_DONE |
+				   DP_AUX_CH_CTL_TIME_OUT_ERROR |
+				   DP_AUX_CH_CTL_RECEIVE_ERROR);
+
+			status = intel_dp_aux_wait_done(intel_dp, has_aux_irq);
+
+			/* Clear done status and any errors */
+			I915_WRITE(ch_ctl,
+				   status |
+				   DP_AUX_CH_CTL_DONE |
+				   DP_AUX_CH_CTL_TIME_OUT_ERROR |
+				   DP_AUX_CH_CTL_RECEIVE_ERROR);
+
+			if (status & (DP_AUX_CH_CTL_TIME_OUT_ERROR |
+				      DP_AUX_CH_CTL_RECEIVE_ERROR))
+				continue;
+			if (status & DP_AUX_CH_CTL_DONE)
+				break;
+		}
 		if (status & DP_AUX_CH_CTL_DONE)
 			break;
 	}


