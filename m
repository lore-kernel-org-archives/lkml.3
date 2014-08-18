Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaHRKEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:04:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42532 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaHRJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/137] drm/radeon: set default bl level to something reasonable
Date: Mon, 18 Aug 2014 10:31:28 +0100
Message-Id: <1408354398-10226-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 76e5e29ac46c..af359bae3e6f 100644
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
1.9.1

