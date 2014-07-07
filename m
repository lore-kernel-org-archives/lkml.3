Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaGGT76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:59:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52049 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaGGT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:59:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: backlight: jornada720_lcd.c:  Cleaning up variable that is never used
Date: Mon,  7 Jul 2014 22:01:10 +0200
Message-Id: <1404763270-24932-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose,
and made same change to clarify the similarities in function.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/backlight/jornada720_lcd.c |   31 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index da3876c..d16abcf 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -36,44 +36,41 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
 
 static int jornada_lcd_get_contrast(struct lcd_device *ld)
 {
-	int ret;
+	int ret = -ETIMEDOUT;
 
 	if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
 		return 0;
 
 	jornada_ssp_start();
 
-	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
+	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY)
 		dev_err(&ld->dev, "get contrast failed\n");
-		jornada_ssp_end();
-		return -ETIMEDOUT;
-	} else {
+	else
 		ret = jornada_ssp_byte(TXDUMMY);
-		jornada_ssp_end();
-		return ret;
-	}
+
+	jornada_ssp_end();
+
+	return ret;
 }
 
 static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
 {
-	int ret;
+	int ret = -ETIMEDOUT;
 
 	jornada_ssp_start();
 
 	/* start by sending our set contrast cmd to mcu */
-	ret = jornada_ssp_byte(SETCONTRAST);
-
+	if (jornada_ssp_byte(SETCONTRAST) != TXDUMMY)
+		dev_err(&ld->dev, "set contrast failed\n");
 	/* push the new value */
-	if (jornada_ssp_byte(value) != TXDUMMY) {
+	else if (jornada_ssp_byte(value) != TXDUMMY)
 		dev_err(&ld->dev, "set contrast failed\n");
-		jornada_ssp_end();
-		return -ETIMEDOUT;
-	}
+	else /* if we get here we can assume everything went well */
+		ret = 0;
 
-	/* if we get here we can assume everything went well */
 	jornada_ssp_end();
 
-	return 0;
+	return ret;
 }
 
 static int jornada_lcd_set_power(struct lcd_device *ld, int power)
-- 
1.7.10.4

