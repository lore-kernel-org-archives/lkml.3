Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3KIG77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:59:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3KIGwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Shobhit Kumar <shobhit.kumar@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.11 79/94] drm/i915: split aux_clock_divider logic in a separated function for reuse.
Date: Fri,  8 Nov 2013 22:52:25 -0800
Message-Id: <20131109065209.835314296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@gmail.com>

commit b84a1cf8950ed075c4ab2630514d4caaae504176 upstream.

Prep patch for reuse aux_clock_divider with EDP_PSR_AUX_CTL setup.

Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Reviewed-by: Shobhit Kumar <shobhit.kumar@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   58 ++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -276,29 +276,12 @@ intel_dp_aux_wait_done(struct intel_dp *
 	return status;
 }
 
-static int
-intel_dp_aux_ch(struct intel_dp *intel_dp,
-		uint8_t *send, int send_bytes,
-		uint8_t *recv, int recv_size)
+static uint32_t get_aux_clock_divider(struct intel_dp *intel_dp)
 {
 	struct intel_digital_port *intel_dig_port = dp_to_dig_port(intel_dp);
 	struct drm_device *dev = intel_dig_port->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	uint32_t ch_ctl = intel_dp->aux_ch_ctl_reg;
-	uint32_t ch_data = ch_ctl + 4;
-	int i, ret, recv_bytes;
-	uint32_t status;
-	uint32_t aux_clock_divider;
-	int try, precharge;
-	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5 && !IS_VALLEYVIEW(dev);
 
-	/* dp aux is extremely sensitive to irq latency, hence request the
-	 * lowest possible wakeup latency and so prevent the cpu from going into
-	 * deep sleep states.
-	 */
-	pm_qos_update_request(&dev_priv->pm_qos, 0);
-
-	intel_dp_check_edp(intel_dp);
 	/* The clock divider is based off the hrawclk,
 	 * and would like to run at 2MHz. So, take the
 	 * hrawclk value and divide by 2 and use that
@@ -307,23 +290,48 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 	 * clock divider.
 	 */
 	if (IS_VALLEYVIEW(dev)) {
-		aux_clock_divider = 100;
+		return 100;
 	} else if (intel_dig_port->port == PORT_A) {
 		if (HAS_DDI(dev))
-			aux_clock_divider = DIV_ROUND_CLOSEST(
+			return DIV_ROUND_CLOSEST(
 				intel_ddi_get_cdclk_freq(dev_priv), 2000);
 		else if (IS_GEN6(dev) || IS_GEN7(dev))
-			aux_clock_divider = 200; /* SNB & IVB eDP input clock at 400Mhz */
+			return 200; /* SNB & IVB eDP input clock at 400Mhz */
 		else
-			aux_clock_divider = 225; /* eDP input clock at 450Mhz */
+			return 225; /* eDP input clock at 450Mhz */
 	} else if (dev_priv->pch_id == INTEL_PCH_LPT_DEVICE_ID_TYPE) {
 		/* Workaround for non-ULT HSW */
-		aux_clock_divider = 74;
+		return 74;
 	} else if (HAS_PCH_SPLIT(dev)) {
-		aux_clock_divider = DIV_ROUND_UP(intel_pch_rawclk(dev), 2);
+		return DIV_ROUND_UP(intel_pch_rawclk(dev), 2);
 	} else {
-		aux_clock_divider = intel_hrawclk(dev) / 2;
+		return intel_hrawclk(dev) / 2;
 	}
+}
+
+static int
+intel_dp_aux_ch(struct intel_dp *intel_dp,
+		uint8_t *send, int send_bytes,
+		uint8_t *recv, int recv_size)
+{
+	struct intel_digital_port *intel_dig_port = dp_to_dig_port(intel_dp);
+	struct drm_device *dev = intel_dig_port->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	uint32_t ch_ctl = intel_dp->aux_ch_ctl_reg;
+	uint32_t ch_data = ch_ctl + 4;
+	int i, ret, recv_bytes;
+	uint32_t status;
+	uint32_t aux_clock_divider = get_aux_clock_divider(intel_dp);
+	int try, precharge;
+	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5 && !IS_VALLEYVIEW(dev);
+
+	/* dp aux is extremely sensitive to irq latency, hence request the
+	 * lowest possible wakeup latency and so prevent the cpu from going into
+	 * deep sleep states.
+	 */
+	pm_qos_update_request(&dev_priv->pm_qos, 0);
+
+	intel_dp_check_edp(intel_dp);
 
 	if (IS_GEN6(dev))
 		precharge = 3;


