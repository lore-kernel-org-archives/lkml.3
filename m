Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3APQI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36730 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3APQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 177/222] drm/i915: add some barriers when changing DIPs
Date: Wed, 16 Jan 2013 13:56:17 -0200
Message-Id: <1358351822-7675-178-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 9d9740f099f2eaf309c4c9cbc0d732507140db28 upstream.

On IVB and older, we basically have two registers: the control and the
data register. We write a few consecutitve times to the control
register, and we need these writes to arrive exactly in the specified
order.

Also, when we're changing the data register, we need to guarantee that
anything written to the control register already arrived (since
changing the control register can change where the data register
points to). Also, we need to make sure all the writes to the data
register happen exactly in the specified order, and we also *can't*
read the data register during this process, since reading and/or
writing it will change the place it points to.

So invoke the "better safe than sorry" rule and just be careful and
put barriers everywhere :)

On HSW we still have a control register that we write many times, but
we have many data registers.

Demanded-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: drop changes to *_set_infoframes functions, not present in
  3.5. While commits which add *_set_infoframes and all that could be
  picked, may be it's too much for this stable (although they fix other
  issues), just this makes next patch easier to apply ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_hdmi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index bc1f0f2..a0194e5 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -141,16 +141,19 @@ static void g4x_write_infoframe(struct drm_encoder *encoder,
 
 	I915_WRITE(VIDEO_DIP_CTL, val);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(VIDEO_DIP_DATA, *data);
 		data++;
 	}
+	mmiowb();
 
 	val |= g4x_infoframe_enable(frame);
 	val &= ~VIDEO_DIP_FREQ_MASK;
 	val |= VIDEO_DIP_FREQ_VSYNC;
 
 	I915_WRITE(VIDEO_DIP_CTL, val);
+	POSTING_READ(VIDEO_DIP_CTL);
 }
 
 static void ibx_write_infoframe(struct drm_encoder *encoder,
@@ -190,16 +193,19 @@ static void ibx_write_infoframe(struct drm_encoder *encoder,
 
 	I915_WRITE(reg, val);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(TVIDEO_DIP_DATA(intel_crtc->pipe), *data);
 		data++;
 	}
+	mmiowb();
 
 	val |= g4x_infoframe_enable(frame);
 	val &= ~VIDEO_DIP_FREQ_MASK;
 	val |= VIDEO_DIP_FREQ_VSYNC;
 
 	I915_WRITE(reg, val);
+	POSTING_READ(reg);
 }
 
 static void cpt_write_infoframe(struct drm_encoder *encoder,
@@ -229,16 +235,19 @@ static void cpt_write_infoframe(struct drm_encoder *encoder,
 
 	I915_WRITE(reg, val);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(TVIDEO_DIP_DATA(intel_crtc->pipe), *data);
 		data++;
 	}
+	mmiowb();
 
 	val |= g4x_infoframe_enable(frame);
 	val &= ~VIDEO_DIP_FREQ_MASK;
 	val |= VIDEO_DIP_FREQ_VSYNC;
 
 	I915_WRITE(reg, val);
+	POSTING_READ(reg);
 }
 
 static void vlv_write_infoframe(struct drm_encoder *encoder,
@@ -262,16 +271,19 @@ static void vlv_write_infoframe(struct drm_encoder *encoder,
 
 	I915_WRITE(reg, val);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(VLV_TVIDEO_DIP_DATA(intel_crtc->pipe), *data);
 		data++;
 	}
+	mmiowb();
 
 	val |= g4x_infoframe_enable(frame);
 	val &= ~VIDEO_DIP_FREQ_MASK;
 	val |= VIDEO_DIP_FREQ_VSYNC;
 
 	I915_WRITE(reg, val);
+	POSTING_READ(reg);
 }
 
 static void hsw_write_infoframe(struct drm_encoder *encoder,
@@ -294,13 +306,16 @@ static void hsw_write_infoframe(struct drm_encoder *encoder,
 	val &= ~hsw_infoframe_enable(frame);
 	I915_WRITE(ctl_reg, val);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(data_reg + i, *data);
 		data++;
 	}
+	mmiowb();
 
 	val |= hsw_infoframe_enable(frame);
 	I915_WRITE(ctl_reg, val);
+	POSTING_READ(ctl_reg);
 }
 
 static void intel_set_infoframe(struct drm_encoder *encoder,
-- 
1.7.9.5

