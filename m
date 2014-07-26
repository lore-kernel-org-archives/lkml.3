Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaGZTDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaGZTDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        David Heidelberger <david.heidelberger@ixit.cz>
Subject: [PATCH 3.10 47/56] drm/radeon: set default bl level to something reasonable
Date: Sat, 26 Jul 2014 12:02:40 -0700
Message-Id: <20140726190201.605634461@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -183,7 +183,6 @@ void radeon_atom_backlight_init(struct r
 	struct backlight_properties props;
 	struct radeon_backlight_privdata *pdata;
 	struct radeon_encoder_atom_dig *dig;
-	u8 backlight_level;
 	char bl_name[16];
 
 	/* Mac laptops with multiple GPUs use the gmux driver for backlight
@@ -222,12 +221,17 @@ void radeon_atom_backlight_init(struct r
 
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
 


