Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaCUVFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:05:10 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:43743 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaCUVFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:05:05 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use em28xx_reg_len()
Date: Fri, 21 Mar 2014 15:04:50 -0600
Message-Id: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change em28xx_scaler_set() to use em28xx_reg_len() to get register
lengths for EM28XX_R30_HSCALELOW and EM28XX_R32_VSCALELOW registers,
instead of hard-coding the length. Moved em28xx_reg_len() definition
for it to be visible to em28xx_scaler_set().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 19af6b3..f8a91de 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -272,6 +272,18 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
 	}
 }
 
+static int em28xx_reg_len(int reg)
+{
+	switch (reg) {
+	case EM28XX_R40_AC97LSB:
+	case EM28XX_R30_HSCALELOW:
+	case EM28XX_R32_VSCALELOW:
+		return 2;
+	default:
+		return 1;
+	}
+}
+
 static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 {
 	u8 mode;
@@ -284,11 +296,13 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 
 		buf[0] = h;
 		buf[1] = h >> 8;
-		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
+		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf,
+				  em28xx_reg_len(EM28XX_R30_HSCALELOW));
 
 		buf[0] = v;
 		buf[1] = v >> 8;
-		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
+		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf,
+				  em28xx_reg_len(EM28XX_R32_VSCALELOW));
 		/* it seems that both H and V scalers must be active
 		   to work correctly */
 		mode = (h || v) ? 0x30 : 0x00;
@@ -1583,17 +1597,6 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
 	return 0;
 }
 
-static int em28xx_reg_len(int reg)
-{
-	switch (reg) {
-	case EM28XX_R40_AC97LSB:
-	case EM28XX_R30_HSCALELOW:
-	case EM28XX_R32_VSCALELOW:
-		return 2;
-	default:
-		return 1;
-	}
-}
 
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
-- 
1.7.10.4

