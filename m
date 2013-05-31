Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3EaPtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:49:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62047 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3EaPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:49:44 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCHv2 2/2] atmel_lcdfb: blank the backlight on remove
Date: Fri, 31 May 2013 17:49:35 +0200
Message-Id: <1370015375-5954-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CACQ1gAh5HL8ouhe3YeGe4B9AO+L02C+wF5a2pUvka01PbupCDg@mail.gmail.com>
References: <CACQ1gAh5HL8ouhe3YeGe4B9AO+L02C+wF5a2pUvka01PbupCDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing atmel_lcdfb module, the backlight is unregistered but not
blanked. (only for CONFIG_BACKLIGHT_ATMEL_LCDC case).
This can result in the screen going full white depending on how the PWM
is wired.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/video/atmel_lcdfb.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 6e6491f..effdb37 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -223,8 +223,14 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 
 static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
-	if (sinfo->backlight)
-		backlight_device_unregister(sinfo->backlight);
+	if (!sinfo->backlight)
+		return;
+
+	if (sinfo->backlight->ops) {
+		sinfo->backlight->props.power = FB_BLANK_POWERDOWN;
+		sinfo->backlight->ops->update_status(sinfo->backlight);
+	}
+	backlight_device_unregister(sinfo->backlight);
 }
 
 #else
-- 
1.7.10.4

