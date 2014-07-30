Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaG3Mcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:32:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36740 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 63/94] drm/radeon: set default bl level to something reasonable
Date: Wed, 30 Jul 2014 14:14:52 +0200
Message-Id: <ef34ede9581679fdbd02e6f13494b04de656fb38.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 201bb62402e0227375c655446ea04fcd0acf7287 upstream.

If the value in the scratch register is 0, set it to the
max level.  This fixes an issue where the console fb blanking
code calls back into the backlight driver on unblank and then
sets the backlight level to 0 after the driver has already
set the mode and enabled the backlight.

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=81382
https://bugs.freedesktop.org/show_bug.cgi?id=70207

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: David Heidelberger <david.heidelberger@ixit.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 583345636d4b..6a965172d8dd 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -183,7 +183,6 @@ void radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
 	struct backlight_properties props;
 	struct radeon_backlight_privdata *pdata;
 	struct radeon_encoder_atom_dig *dig;
-	u8 backlight_level;
 	char bl_name[16];
 
 	/* Mac laptops with multiple GPUs use the gmux driver for backlight
@@ -222,12 +221,17 @@ void radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
 
 	pdata->encoder = radeon_encoder;
 
-	backlight_level = radeon_atom_get_backlight_level_from_reg(rdev);
-
 	dig = radeon_encoder->enc_priv;
 	dig->bl_dev = bd;
 
 	bd->props.brightness = radeon_atom_backlight_get_brightness(bd);
+	/* Set a reasonable default here if the level is 0 otherwise
+	 * fbdev will attempt to turn the backlight on after console
+	 * unblanking and it will try and restore 0 which turns the backlight
+	 * off again.
+	 */
+	if (bd->props.brightness == 0)
+		bd->props.brightness = RADEON_MAX_BL_LEVEL;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
 
-- 
2.0.1

