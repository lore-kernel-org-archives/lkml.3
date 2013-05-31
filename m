Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3EaO3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:29:09 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34021 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3EaO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:28:57 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/2] atmel_lcdfb: blank the backlight on remove
Date: Fri, 31 May 2013 16:28:39 +0200
Message-Id: <1370010519-18691-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370010519-18691-1-git-send-email-richard.genoud@gmail.com>
References: <1370010519-18691-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing atmel_lcdfb module, the backlight is unregistered but not
blanked. (only for CONFIG_BACKLIGHT_ATMEL_LCDC case).
This can result in the screen going full white depending on how the PWM
is wired.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/video/atmel_lcdfb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 6e6491f..e00318f 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -223,8 +223,13 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 
 static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
-	if (sinfo->backlight)
+	if (sinfo->backlight) {
+		if (sinfo->backlight->ops) {
+			sinfo->backlight->props.power = FB_BLANK_POWERDOWN;
+			sinfo->backlight->ops->update_status(sinfo->backlight);
+		}
 		backlight_device_unregister(sinfo->backlight);
+	}
 }
 
 #else
-- 
1.7.10.4

