Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaADF2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:28:06 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48300 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaADF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:28:03 -0500
Date: Fri, 3 Jan 2014 21:28:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
Message-ID: <20140104052756.GA32561@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
get_unaligned_le16 to access it.

Also let's add build time check to make sure it stays aligned.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/ims-pcu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 513ecdf..b8f1029 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -116,6 +116,8 @@ struct ims_pcu {
 	bool setup_complete; /* Input and LED devices have been created */
 };
 
+#define IMS_PCU_CHECK_CMD_BUF_ALIGNMENT(offset, alignment)	\
+	IS_ALIGNED(offsetof(struct ims_pcu, cmd_buf[offset]), alignment)
 
 /*********************************************************************
  *             Buttons Input device support                          *
@@ -999,8 +1001,10 @@ ims_pcu_backlight_get_brightness(struct led_classdev *cdev)
 		/* Assume the LED is OFF */
 		brightness = LED_OFF;
 	} else {
-		brightness =
-			get_unaligned_le16(&pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
+		BUILD_BUG_ON(!IMS_PCU_CHECK_CMD_BUF_ALIGNMENT(
+				IMS_PCU_DATA_OFFSET, 2));
+		brightness = le16_to_cpup(
+				(__le16 *)&pcu->cmd_buf[IMS_PCU_DATA_OFFSET]);
 	}
 
 	mutex_unlock(&pcu->cmd_mutex);
-- 
1.8.4.2


-- 
Dmitry
