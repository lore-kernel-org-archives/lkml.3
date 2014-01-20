Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaATFqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:46:10 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:24934
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbaATFqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:46:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <jg1.han@samsung.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <plagnioj@jcrosoft.com>,
        <tomi.valkeinen@ti.com>
Subject: [PATCH v2] backlight: turn backlight on/off when necessary
Date: Mon, 20 Jan 2014 13:47:26 +0800
Message-ID: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to turn backlight on/off everytime a blanking
or unblanking event comes because the backlight status may
have already been what we want. Another thought is that one
backlight device may be shared by multiple framebuffers. We
don't hope blanking one of the framebuffers may turn the
backlight off for all the other framebuffers, since they are
likely being active to display something. This patch adds
some logics to record each framebuffer's backlight usage to
determine the backlight device use count and whether the
backlight should be turned on or off. To be more specific,
only one unblank operation on a certain blanked framebuffer
may increase the backlight device's use count by one, while
one blank operation on a certain unblanked framebuffer may
decrease the use count by one, because the userspace is
likely to unblank a unblanked framebuffer or blank a blanked
framebuffer.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v1 can be found at https://lkml.org/lkml/2013/5/30/139

v1->v2:
* Make the commit message be more specific about the condition
  in which backlight device use count can be increased/decreased.
* Correct the setting for bd->props.fb_blank.

 drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
 include/linux/backlight.h           |    6 ++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 5d05555..42044be 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -34,13 +34,15 @@ static const char *const backlight_types[] = {
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
+	int fb_blank = 0;
 
 	/* If we aren't interested in this event, skip it immediately ... */
 	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
@@ -51,12 +53,24 @@ static int fb_notifier_callback(struct notifier_block *self,
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
 		    bd->ops->check_fb(bd, evdata->info)) {
-			bd->props.fb_blank = *(int *)evdata->data;
-			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
-				bd->props.state &= ~BL_CORE_FBBLANK;
-			else
-				bd->props.state |= BL_CORE_FBBLANK;
-			backlight_update_status(bd);
+			fb_blank = *(int *)evdata->data;
+			if (fb_blank == FB_BLANK_UNBLANK &&
+			    !bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = true;
+				if (!bd->use_count++) {
+					bd->props.state &= ~BL_CORE_FBBLANK;
+					bd->props.fb_blank = FB_BLANK_UNBLANK;
+					backlight_update_status(bd);
+				}
+			} else if (fb_blank != FB_BLANK_UNBLANK &&
+				   bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = false;
+				if (!(--bd->use_count)) {
+					bd->props.state |= BL_CORE_FBBLANK;
+					bd->props.fb_blank = FB_BLANK_POWERDOWN;
+					backlight_update_status(bd);
+				}
+			}
 		}
 	mutex_unlock(&bd->ops_lock);
 	return 0;
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 5f9cd96..7264742 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -9,6 +9,7 @@
 #define _LINUX_BACKLIGHT_H
 
 #include <linux/device.h>
+#include <linux/fb.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 
@@ -104,6 +105,11 @@ struct backlight_device {
 	struct list_head entry;
 
 	struct device dev;
+
+	/* Multiple framebuffers may share one backlight device */
+	bool fb_bl_on[FB_MAX];
+
+	int use_count;
 };
 
 static inline void backlight_update_status(struct backlight_device *bd)
-- 
1.7.9.5


