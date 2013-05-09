Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab3EIW4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:56:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3EIWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@pdx.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 37/73] drm/i915: Fix sdvo connector get_hw_state function
Date: Thu,  9 May 2013 15:32:00 -0700
Message-Id: <20130509222801.993788425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit bd6946e87a98fea11907b2a47368e13044458a35 upstream.

The active output is only the currently selected one, which does not
imply that it's actually enabled. Since we don't use the sdvo encoder
side dpms support, we need to check whether the chip-side sdvo port is
enabled instead.

v2: Fix up Bugzilla links.

v3: Simplify logic a bit (Chris).

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=60138
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=63031
Cc: Egbert Eich <eich@pdx.freedesktop.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Egbert Eich <eich@pdx.freedesktop.org> (v2)
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1197,8 +1197,12 @@ static bool intel_sdvo_connector_get_hw_
 	struct intel_sdvo_connector *intel_sdvo_connector =
 		to_intel_sdvo_connector(&connector->base);
 	struct intel_sdvo *intel_sdvo = intel_attached_sdvo(&connector->base);
+	struct drm_i915_private *dev_priv = intel_sdvo->base.base.dev->dev_private;
 	u16 active_outputs;
 
+	if (!(I915_READ(intel_sdvo->sdvo_reg) & SDVO_ENABLE))
+		return false;
+
 	intel_sdvo_get_active_outputs(intel_sdvo, &active_outputs);
 
 	if (active_outputs & intel_sdvo_connector->output_flag)


