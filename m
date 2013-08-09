Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382Ab3HICHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:07:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967572Ab3HIB7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Zhouping Liu <zliu@redhat.com>
Subject: [ 074/102] drm/i915: Preserve the DDI_A_4_LANES bit from the bios
Date: Thu,  8 Aug 2013 18:57:50 -0700
Message-Id: <20130809015027.666587088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stéphane Marchesin <marcheu@chromium.org>

commit bcf53de4e60d9000b82f541d654529e2902a4c2c upstream.

Otherwise the DDI_A_4_LANES bit gets lost and we can't use > 2 lanes
on eDP. This fixes eDP on hsw with > 2 lanes.

Also s/port_reversal/saved_port_bits/ since the current name is
confusing.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ddi.c |   10 ++++++----
 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -684,7 +684,7 @@ static void intel_ddi_mode_set(struct dr
 		struct intel_digital_port *intel_dig_port =
 			enc_to_dig_port(encoder);
 
-		intel_dp->DP = intel_dig_port->port_reversal |
+		intel_dp->DP = intel_dig_port->saved_port_bits |
 			       DDI_BUF_CTL_ENABLE | DDI_BUF_EMP_400MV_0DB_HSW;
 		switch (intel_dp->lane_count) {
 		case 1:
@@ -1324,7 +1324,8 @@ static void intel_enable_ddi(struct inte
 		 * enabling the port.
 		 */
 		I915_WRITE(DDI_BUF_CTL(port),
-			   intel_dig_port->port_reversal | DDI_BUF_CTL_ENABLE);
+			   intel_dig_port->saved_port_bits |
+			   DDI_BUF_CTL_ENABLE);
 	} else if (type == INTEL_OUTPUT_EDP) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
@@ -1543,8 +1544,9 @@ void intel_ddi_init(struct drm_device *d
 	intel_encoder->get_hw_state = intel_ddi_get_hw_state;
 
 	intel_dig_port->port = port;
-	intel_dig_port->port_reversal = I915_READ(DDI_BUF_CTL(port)) &
-					DDI_BUF_PORT_REVERSAL;
+	intel_dig_port->saved_port_bits = I915_READ(DDI_BUF_CTL(port)) &
+					  (DDI_BUF_PORT_REVERSAL |
+					   DDI_A_4_LANES);
 	if (hdmi_connector)
 		intel_dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
 	intel_dig_port->dp.output_reg = DDI_BUF_CTL(port);
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -426,7 +426,7 @@ struct intel_dp {
 struct intel_digital_port {
 	struct intel_encoder base;
 	enum port port;
-	u32 port_reversal;
+	u32 saved_port_bits;
 	struct intel_dp dp;
 	struct intel_hdmi hdmi;
 };


