Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3EIWwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:52:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3EIWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 39/73] drm/i915: Fix SDVO connector and encoder get_hw_state functions
Date: Thu,  9 May 2013 15:32:02 -0700
Message-Id: <20130509222802.209421688@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 7a7d1fb79fb581553f4830498045de774a9659f8 upstream.

The connector associated with the encoder is considered active when the
output associtated with this connector is active on the encoder. The
encoder itself is considered active when either there is an active
output on  it or the  respective SDVO channel is active.
Having active outputs when the SDVO channel is inactive seems to be
inconsistent: such states can be found when intel_modeset_setup_hw_state()
collects the hardware state set by the BIOS.
This inconsistency will be fixed in intel_sanitize_crtc()
(when intel_crtc_update_dpms() is called), this however only happens
when the encoder is associated with a crtc.

This patch also reverts:

     commit bd6946e87a98fea11907b2a47368e13044458a35
     Author: Daniel Vetter <daniel.vetter@ffwll.ch>
     Date:   Tue Apr 2 21:30:34 2013 +0200

         drm/i915: Fix sdvo connector get_hw_state function

Signed-off-by: Egbert Eich <eich@suse.de>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=63031
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1197,12 +1197,8 @@ static bool intel_sdvo_connector_get_hw_
 	struct intel_sdvo_connector *intel_sdvo_connector =
 		to_intel_sdvo_connector(&connector->base);
 	struct intel_sdvo *intel_sdvo = intel_attached_sdvo(&connector->base);
-	struct drm_i915_private *dev_priv = intel_sdvo->base.base.dev->dev_private;
 	u16 active_outputs;
 
-	if (!(I915_READ(intel_sdvo->sdvo_reg) & SDVO_ENABLE))
-		return false;
-
 	intel_sdvo_get_active_outputs(intel_sdvo, &active_outputs);
 
 	if (active_outputs & intel_sdvo_connector->output_flag)
@@ -1217,11 +1213,13 @@ static bool intel_sdvo_get_hw_state(stru
 	struct drm_device *dev = encoder->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_sdvo *intel_sdvo = to_intel_sdvo(&encoder->base);
+	u16 active_outputs;
 	u32 tmp;
 
 	tmp = I915_READ(intel_sdvo->sdvo_reg);
+	intel_sdvo_get_active_outputs(intel_sdvo, &active_outputs);
 
-	if (!(tmp & SDVO_ENABLE))
+	if (!(tmp & SDVO_ENABLE) && (active_outputs == 0))
 		return false;
 
 	if (HAS_PCH_CPT(dev))
@@ -2708,7 +2706,6 @@ bool intel_sdvo_init(struct drm_device *
 	struct intel_sdvo *intel_sdvo;
 	u32 hotplug_mask;
 	int i;
-
 	intel_sdvo = kzalloc(sizeof(struct intel_sdvo), GFP_KERNEL);
 	if (!intel_sdvo)
 		return false;


