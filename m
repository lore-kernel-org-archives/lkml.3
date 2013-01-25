Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3AYBoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3AYBny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:43:54 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>
Subject: [PATCH] fbcon: fix locking harder
Date: Fri, 25 Jan 2013 11:43:44 +1000
Message-Id: <1359078224-3327-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay so Alan's patch handled the case where there was no registered fbcon,
however the other path entered in set_con2fb_map pit.

In there we called fbcon_takeover, but we also took the console lock in a couple
of places. So push the console lock out to the callers of set_con2fb_map,

this means fbmem and switcheroo needed to take the lock around the fb notifier
entry points that lead to this.

This should fix the efifb regression seen by Maarten.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vga_switcheroo.c |  3 +++
 drivers/video/console/fbcon.c    | 11 ++++++++---
 drivers/video/fbmem.c            |  2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index fa60add..cf787e1 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -25,6 +25,7 @@
 #include <linux/fb.h>
 
 #include <linux/pci.h>
+#include <linux/console.h>
 #include <linux/vga_switcheroo.h>
 
 #include <linux/vgaarb.h>
@@ -337,8 +338,10 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 
 	if (new_client->fb_info) {
 		struct fb_event event;
+		console_lock();
 		event.info = new_client->fb_info;
 		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
+		console_unlock();
 	}
 
 	ret = vgasr_priv.handler->switchto(new_client->id);
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 2aef9ca..2e2d959 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -842,6 +842,8 @@ static void con2fb_init_display(struct vc_data *vc, struct fb_info *info,
  *
  *	Maps a virtual console @unit to a frame buffer device
  *	@newidx.
+ *
+ *	This should be called with the console lock held.
  */
 static int set_con2fb_map(int unit, int newidx, int user)
 {
@@ -859,7 +861,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
 	if (!search_for_mapped_con() || !con_is_bound(&fb_con)) {
 		info_idx = newidx;
-		return fbcon_takeover(0);
+		return do_fbcon_takeover(0);
 	}
 
 	if (oldidx != -1)
@@ -867,7 +869,6 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
 	found = search_fb_in_map(newidx);
 
-	console_lock();
 	con2fb_map[unit] = newidx;
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
@@ -894,7 +895,6 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (!search_fb_in_map(info_idx))
 		info_idx = newidx;
 
-	console_unlock();
  	return err;
 }
 
@@ -3019,6 +3019,7 @@ static inline int fbcon_unbind(void)
 }
 #endif /* CONFIG_VT_HW_CONSOLE_BINDING */
 
+/* called with console_lock held */
 static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
@@ -3045,6 +3046,7 @@ static int fbcon_fb_unbind(int idx)
 	return ret;
 }
 
+/* called with console_lock held */
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
@@ -3082,6 +3084,7 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	return 0;
 }
 
+/* called with console_lock held */
 static void fbcon_remap_all(int idx)
 {
 	int i;
@@ -3126,6 +3129,7 @@ static inline void fbcon_select_primary(struct fb_info *info)
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
+/* called with console_lock held */
 static int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
@@ -3278,6 +3282,7 @@ static int fbcon_event_notify(struct notifier_block *self,
 		ret = fbcon_fb_unregistered(info);
 		break;
 	case FB_EVENT_SET_CONSOLE_MAP:
+		/* called with console lock held */
 		con2fb = event->data;
 		ret = set_con2fb_map(con2fb->console - 1,
 				     con2fb->framebuffer, 1);
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 070b9a1..dc61c12 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1177,8 +1177,10 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		event.data = &con2fb;
 		if (!lock_fb_info(info))
 			return -ENODEV;
+		console_lock();
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
+		console_unlock();
 		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
-- 
1.8.1

