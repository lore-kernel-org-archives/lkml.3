Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaGJIaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:30:52 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38090 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaGJIas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:30:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: rickard_strandqvist@spectrumdigital.se, Lee Jones <lee.jones@linaro.org>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH] backlight: jornada720: Minimise code duplication and handle errors better
Date: Thu, 10 Jul 2014 09:07:06 +0100
Message-Id: <1404979626-10951-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvi's ran a code analysis application which found that
jornada_lcd_get_contrast(() and jornada_lcd_set_contrast() contained
some code duplication (calling the same functions during various
code execution paths) and failed to return errors in a consistent
manner.  This patch aims to simplify the code, coercing it into
behaving at a level expected of a driver in the Linux kernel.

Cc: Bryan Wu <cooloney@gmail.com>
Suggested-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/jornada720_lcd.c | 37 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index da3876c..228bc31 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -43,37 +43,38 @@ static int jornada_lcd_get_contrast(struct lcd_device *ld)
 
 	jornada_ssp_start();
 
-	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		dev_err(&ld->dev, "get contrast failed\n");
-		jornada_ssp_end();
-		return -ETIMEDOUT;
-	} else {
+	if (jornada_ssp_byte(GETCONTRAST) == TXDUMMY) {
 		ret = jornada_ssp_byte(TXDUMMY);
-		jornada_ssp_end();
-		return ret;
+		goto success;
 	}
+
+	dev_err(&ld->dev, "failed to set contrast\n");
+	ret = -ETIMEDOUT;
+
+success:
+	jornada_ssp_end();
+	return ret;
 }
 
 static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
 {
-	int ret;
+	int ret = 0;
 
 	jornada_ssp_start();
 
 	/* start by sending our set contrast cmd to mcu */
-	ret = jornada_ssp_byte(SETCONTRAST);
-
-	/* push the new value */
-	if (jornada_ssp_byte(value) != TXDUMMY) {
-		dev_err(&ld->dev, "set contrast failed\n");
-		jornada_ssp_end();
-		return -ETIMEDOUT;
+	if (jornada_ssp_byte(SETCONTRAST) == TXDUMMY) {
+		/* if successful push the new value */
+		if (jornada_ssp_byte(value) == TXDUMMY)
+			goto success;
 	}
 
-	/* if we get here we can assume everything went well */
-	jornada_ssp_end();
+	dev_err(&ld->dev, "failed to set contrast\n");
+	ret = -ETIMEDOUT;
 
-	return 0;
+success:
+	jornada_ssp_end();
+	return ret;
 }
 
 static int jornada_lcd_set_power(struct lcd_device *ld, int power)
-- 
1.8.3.2

