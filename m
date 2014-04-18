Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaDRJn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45913 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/72] drm/radeon: change audio enable logic
Date: Fri, 18 Apr 2014 11:21:49 +0200
Message-Id: <d6bb21f4cff50264a5e798607bbddbf1baf123e0.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 832eafaf34ff7d0348fe701e417900c6cf1f5656 upstream.

Disable audio around audio hw setup.  This may avoid
hangs on certain asics.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/dce6_afmt.c      | 13 ++++++++-----
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 26 +++++++++++++++-----------
 drivers/gpu/drm/radeon/r600_audio.c     | 14 ++++++++------
 drivers/gpu/drm/radeon/r600_hdmi.c      | 12 +++++++-----
 drivers/gpu/drm/radeon/radeon.h         |  6 ++++++
 5 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index 2a2879e53bd5..bbcd2dd653a3 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -226,13 +226,15 @@ static int dce6_audio_chipset_supported(struct radeon_device *rdev)
 	return !ASIC_IS_NODCE(rdev);
 }
 
-static void dce6_audio_enable(struct radeon_device *rdev,
-			      struct r600_audio_pin *pin,
-			      bool enable)
+void dce6_audio_enable(struct radeon_device *rdev,
+		       struct r600_audio_pin *pin,
+		       bool enable)
 {
+	if (!pin)
+		return;
+
 	WREG32_ENDPOINT(pin->offset, AZ_F0_CODEC_PIN_CONTROL_HOTPLUG_CONTROL,
 			enable ? AUDIO_ENABLED : 0);
-	DRM_INFO("%s audio %d support\n", enable ? "Enabling" : "Disabling", pin->id);
 }
 
 static const u32 pin_offsets[7] =
@@ -269,7 +271,8 @@ int dce6_audio_init(struct radeon_device *rdev)
 		rdev->audio.pin[i].connected = false;
 		rdev->audio.pin[i].offset = pin_offsets[i];
 		rdev->audio.pin[i].id = i;
-		dce6_audio_enable(rdev, &rdev->audio.pin[i], true);
+		/* disable audio.  it will be set up later */
+		dce6_audio_enable(rdev, &rdev->audio.pin[i], false);
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index b347fffa4519..da4e504b78a4 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -257,6 +257,15 @@ void evergreen_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode
 		return;
 	offset = dig->afmt->offset;
 
+	/* disable audio prior to setting up hw */
+	if (ASIC_IS_DCE6(rdev)) {
+		dig->afmt->pin = dce6_audio_get_pin(rdev);
+		dce6_audio_enable(rdev, dig->afmt->pin, false);
+	} else {
+		dig->afmt->pin = r600_audio_get_pin(rdev);
+		r600_audio_enable(rdev, dig->afmt->pin, false);
+	}
+
 	evergreen_audio_set_dto(encoder, mode->clock);
 
 	WREG32(HDMI_VBI_PACKET_CONTROL + offset,
@@ -358,12 +367,16 @@ void evergreen_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode
 	WREG32(AFMT_RAMP_CONTROL1 + offset, 0x007FFFFF);
 	WREG32(AFMT_RAMP_CONTROL2 + offset, 0x00000001);
 	WREG32(AFMT_RAMP_CONTROL3 + offset, 0x00000001);
+
+	/* enable audio after to setting up hw */
+	if (ASIC_IS_DCE6(rdev))
+		dce6_audio_enable(rdev, dig->afmt->pin, true);
+	else
+		r600_audio_enable(rdev, dig->afmt->pin, true);
 }
 
 void evergreen_hdmi_enable(struct drm_encoder *encoder, bool enable)
 {
-	struct drm_device *dev = encoder->dev;
-	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 
@@ -376,15 +389,6 @@ void evergreen_hdmi_enable(struct drm_encoder *encoder, bool enable)
 	if (!enable && !dig->afmt->enabled)
 		return;
 
-	if (enable) {
-		if (ASIC_IS_DCE6(rdev))
-			dig->afmt->pin = dce6_audio_get_pin(rdev);
-		else
-			dig->afmt->pin = r600_audio_get_pin(rdev);
-	} else {
-		dig->afmt->pin = NULL;
-	}
-
 	dig->afmt->enabled = enable;
 
 	DRM_DEBUG("%sabling HDMI interface @ 0x%04X for encoder 0x%x\n",
diff --git a/drivers/gpu/drm/radeon/r600_audio.c b/drivers/gpu/drm/radeon/r600_audio.c
index 47fc2b886979..bffac10c4296 100644
--- a/drivers/gpu/drm/radeon/r600_audio.c
+++ b/drivers/gpu/drm/radeon/r600_audio.c
@@ -142,12 +142,15 @@ void r600_audio_update_hdmi(struct work_struct *work)
 }
 
 /* enable the audio stream */
-static void r600_audio_enable(struct radeon_device *rdev,
-			      struct r600_audio_pin *pin,
-			      bool enable)
+void r600_audio_enable(struct radeon_device *rdev,
+		       struct r600_audio_pin *pin,
+		       bool enable)
 {
 	u32 value = 0;
 
+	if (!pin)
+		return;
+
 	if (ASIC_IS_DCE4(rdev)) {
 		if (enable) {
 			value |= 0x81000000; /* Required to enable audio */
@@ -158,7 +161,6 @@ static void r600_audio_enable(struct radeon_device *rdev,
 		WREG32_P(R600_AUDIO_ENABLE,
 			 enable ? 0x81000000 : 0x0, ~0x81000000);
 	}
-	DRM_INFO("%s audio %d support\n", enable ? "Enabling" : "Disabling", pin->id);
 }
 
 /*
@@ -178,8 +180,8 @@ int r600_audio_init(struct radeon_device *rdev)
 	rdev->audio.pin[0].status_bits = 0;
 	rdev->audio.pin[0].category_code = 0;
 	rdev->audio.pin[0].id = 0;
-
-	r600_audio_enable(rdev, &rdev->audio.pin[0], true);
+	/* disable audio.  it will be set up later */
+	r600_audio_enable(rdev, &rdev->audio.pin[0], false);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 7f3b0d9aaada..9ba0675d0682 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -446,6 +446,10 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 		return;
 	offset = dig->afmt->offset;
 
+	/* disable audio prior to setting up hw */
+	dig->afmt->pin = r600_audio_get_pin(rdev);
+	r600_audio_enable(rdev, dig->afmt->pin, false);
+
 	r600_audio_set_dto(encoder, mode->clock);
 
 	WREG32(HDMI0_VBI_PACKET_CONTROL + offset,
@@ -517,6 +521,9 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 	WREG32(HDMI0_RAMP_CONTROL3 + offset, 0x00000001);
 
 	r600_hdmi_audio_workaround(encoder);
+
+	/* enable audio after to setting up hw */
+	r600_audio_enable(rdev, dig->afmt->pin, true);
 }
 
 /*
@@ -637,11 +644,6 @@ void r600_hdmi_enable(struct drm_encoder *encoder, bool enable)
 	if (!enable && !dig->afmt->enabled)
 		return;
 
-	if (enable)
-		dig->afmt->pin = r600_audio_get_pin(rdev);
-	else
-		dig->afmt->pin = NULL;
-
 	/* Older chipsets require setting HDMI and routing manually */
 	if (!ASIC_IS_DCE3(rdev)) {
 		if (enable)
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index f44ca5853ff2..b11433f75578 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2717,6 +2717,12 @@ int radeon_vm_bo_rmv(struct radeon_device *rdev,
 void r600_audio_update_hdmi(struct work_struct *work);
 struct r600_audio_pin *r600_audio_get_pin(struct radeon_device *rdev);
 struct r600_audio_pin *dce6_audio_get_pin(struct radeon_device *rdev);
+void r600_audio_enable(struct radeon_device *rdev,
+		       struct r600_audio_pin *pin,
+		       bool enable);
+void dce6_audio_enable(struct radeon_device *rdev,
+		       struct r600_audio_pin *pin,
+		       bool enable);
 
 /*
  * R600 vram scratch functions
-- 
1.9.2

