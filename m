Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346Ab3E3Jra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:47:30 -0400
Received: from [207.46.163.26] ([207.46.163.26]:59403 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030302Ab3E3JrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:47:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839he5bhf0ah107ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14afh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <FlorianSchandinat@gmx.de>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liu.y.victor@gmail.com>, Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH] backlight: Turn backlight on/off when necessary
Date: Thu, 30 May 2013 16:13:53 +0800
Message-ID: <1369901633-31561-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to turn backlight on/off everytime a blanking
or unblanking event comes because the backlight status may have
already been what we want. Another thought is that one backlight
device may be shared by multiple framebuffers. We don't hope that
blanking one of the framebuffers would turn the backlight off for
all the other framebuffers, since they are likely active to show
display content. This patch adds logic to record each framebuffer's
backlight status to determine the backlight device use count and
whether the backlight should be turned on or off.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/video/backlight/backlight.c |   23 +++++++++++++++++------
 include/linux/backlight.h           |    6 ++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index c74e7aa..97ea2b8 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -31,13 +31,14 @@ static const char *const backlight_types[] = {
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
  * framebuffer driver. We're looking if that important event is blanking,
- * and if it is, we're switching backlight power as well ...
+ * and if it is and necessary, we're switching backlight power as well ...
  */
 static int fb_notifier_callback(struct notifier_block *self,
 				unsigned long event, void *data)
 {
 	struct backlight_device *bd;
 	struct fb_event *evdata = data;
+	int node = evdata->info->node;
 
 	/* If we aren't interested in this event, skip it immediately ... */
 	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
@@ -49,11 +50,21 @@ static int fb_notifier_callback(struct notifier_block *self,
 		if (!bd->ops->check_fb ||
 		    bd->ops->check_fb(bd, evdata->info)) {
 			bd->props.fb_blank = *(int *)evdata->data;
-			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
-				bd->props.state &= ~BL_CORE_FBBLANK;
-			else
-				bd->props.state |= BL_CORE_FBBLANK;
-			backlight_update_status(bd);
+			if (bd->props.fb_blank == FB_BLANK_UNBLANK &&
+			    !bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = true;
+				if (!bd->use_count++) {
+					bd->props.state &= ~BL_CORE_FBBLANK;
+					backlight_update_status(bd);
+				}
+			} else if (bd->props.fb_blank != FB_BLANK_UNBLANK &&
+				   bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = false;
+				if (!(--bd->use_count)) {
+					bd->props.state |= BL_CORE_FBBLANK;
+					backlight_update_status(bd);
+				}
+			}
 		}
 	mutex_unlock(&bd->ops_lock);
 	return 0;
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index da9a082..5de71a0 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -9,6 +9,7 @@
 #define _LINUX_BACKLIGHT_H
 
 #include <linux/device.h>
+#include <linux/fb.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 
@@ -101,6 +102,11 @@ struct backlight_device {
 	struct notifier_block fb_notif;
 
 	struct device dev;
+
+	/* Multiple framebuffers may share one backlight device */
+	bool fb_bl_on[FB_MAX];
+
+	int use_count;
 };
 
 static inline void backlight_update_status(struct backlight_device *bd)
-- 
1.7.1


