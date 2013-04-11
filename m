Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3DKSgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:36:37 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:54678 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3DKSgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:36:35 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-fbdev@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] backlight: platform_lcd: introduce probe callback
Date: Thu, 11 Apr 2013 11:36:31 -0700
Message-Id: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform LCD devices may need to do some device-specific
initialization before they can be used (regulator or GPIO setup,
for example), but currently the driver does not support any way of
doing this.  This patch adds a probe() callback to plat_lcd_data
which platform LCD devices can set to indicate that device-specific
initialization is needed.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/video/backlight/platform_lcd.c | 8 ++++++++
 include/video/platform_lcd.h           | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 54d94de..2fb24a1 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -86,6 +86,14 @@ static int platform_lcd_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (pdata->probe) {
+		err = pdata->probe(pdata);
+		if (err) {
+			dev_err(dev, "platform probe failed: %d\n", err);
+			return err;
+		}
+	}
+
 	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
 			    GFP_KERNEL);
 	if (!plcd) {
diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
index ad3bdfe..23864b2 100644
--- a/include/video/platform_lcd.h
+++ b/include/video/platform_lcd.h
@@ -15,6 +15,7 @@ struct plat_lcd_data;
 struct fb_info;
 
 struct plat_lcd_data {
+	int	(*probe)(struct plat_lcd_data *);
 	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
 	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
 };
-- 
1.8.1.3

