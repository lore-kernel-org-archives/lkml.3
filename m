Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab3GCXYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:24:45 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:54224 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933051Ab3GCXYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:24:42 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonarne@jonarne.no, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com, andriy.shevchenko@linux.intel.com
Subject: [RFC v3 1/3] saa7115: Fix saa711x_set_v4lstd for gm7113c
Date: Thu,  4 Jul 2013 01:27:18 +0200
Message-Id: <1372894040-23922-2-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
References: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saa711x_set_v4lstd would toggle several bits that should not be touched
when changing std.
This could potentially override configurations set in platform_data.
This patch should fix that problem.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/i2c/saa7115.c      | 37 +++++++++++++------------------------
 drivers/media/i2c/saa711x_regs.h |  4 ++++
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 7fd766e..41408dd 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -462,24 +462,6 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
 
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
@@ -964,17 +946,24 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
 	if (std & V4L2_STD_525_60) {
 		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
-		if (state->ident == GM7113C)
-			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
-		else
+		if (state->ident == GM7113C) {
+			u8 reg = saa711x_read(sd, R_08_SYNC_CNTL);
+			reg &= ~(SAA7113_R_08_FSEL | SAA7113_R_08_AUFD);
+			reg |= SAA7113_R_08_FSEL;
+			saa711x_write(sd, R_08_SYNC_CNTL, reg);
+		} else {
 			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
+		}
 		saa711x_set_size(sd, 720, 480);
 	} else {
 		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
-		if (state->ident == GM7113C)
-			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
-		else
+		if (state->ident == GM7113C) {
+			u8 reg = saa711x_read(sd, R_08_SYNC_CNTL);
+			reg &= ~(SAA7113_R_08_FSEL | SAA7113_R_08_AUFD);
+			saa711x_write(sd, R_08_SYNC_CNTL, reg);
+		} else {
 			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
+		}
 		saa711x_set_size(sd, 720, 576);
 	}
 
diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
index 4e5f2eb..70c56d1 100644
--- a/drivers/media/i2c/saa711x_regs.h
+++ b/drivers/media/i2c/saa711x_regs.h
@@ -201,6 +201,10 @@
 #define R_FB_PULSE_C_POS_MSB                          0xfb
 #define R_FF_S_PLL_MAX_PHASE_ERR_THRESH_NUM_LINES     0xff
 
+/* SAA7113 bit-masks */
+#define SAA7113_R_08_FSEL 0x40
+#define SAA7113_R_08_AUFD 0x80
+
 #if 0
 /* Those structs will be used in the future for debug purposes */
 struct saa711x_reg_descr {
-- 
1.8.3.1

