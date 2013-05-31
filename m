Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3EaLiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:38:07 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:37526 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756022Ab3EaLhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:37:33 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com, hans.verkuil@cisco.com,
        prabhakar.csengg@gmail.com, g.liakhovetski@gmx.de,
        ezequiel.garcia@free-electrons.com, timo.teras@iki.fi
Subject: [RFC v2 2/2] saa7115: Remove gm7113c video_std register change
Date: Fri, 31 May 2013 13:40:26 +0200
Message-Id: <1370000426-3324-3-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1370000426-3324-1-git-send-email-jonarne@jonarne.no>
References: <1370000426-3324-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On video std change, the driver would disable the automatic field
detection on the gm7113c chip, and force either 50Hz or 60Hz.
Don't do this any more.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/i2c/saa7115.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 4a52b4d..ba18e57 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -479,24 +479,6 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
 
 /* ============== SAA7715 VIDEO templates (end) =======  */
 
-/* ============== GM7113C VIDEO templates =============  */
-static const unsigned char gm7113c_cfg_60hz_video[] = {
-	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
-	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
-
-	0x00, 0x00
-};
-
-static const unsigned char gm7113c_cfg_50hz_video[] = {
-	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
-	R_0E_CHROMA_CNTL_1, 0x07,
-
-	0x00, 0x00
-};
-
-/* ============== GM7113C VIDEO templates (end) =======  */
-
-
 static const unsigned char saa7115_cfg_vbi_on[] = {
 	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
 	R_88_POWER_SAVE_ADC_PORT_CNTL, 0xd0,		/* reset scaler */
@@ -981,16 +963,12 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
 	if (std & V4L2_STD_525_60) {
 		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
-		if (state->ident == V4L2_IDENT_GM7113C)
-			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
-		else
+		if (state->ident != V4L2_IDENT_GM7113C)
 			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
 		saa711x_set_size(sd, 720, 480);
 	} else {
 		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
-		if (state->ident == V4L2_IDENT_GM7113C)
-			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
-		else
+		if (state->ident != V4L2_IDENT_GM7113C)
 			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
 		saa711x_set_size(sd, 720, 576);
 	}
-- 
1.8.2.3

