Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966378Ab3DRJT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:19:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab3DRJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 67/72] fbcon: fix locking harder
Date: Thu, 18 Apr 2013 10:16:52 +0100
Message-Id: <1366276617-3553-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

commit 054430e773c9a1e26f38e30156eff02dedfffc17 upstream.

Okay so Alan's patch handled the case where there was no registered fbcon,
however the other path entered in set_con2fb_map pit.

In there we called fbcon_takeover, but we also took the console lock in a couple
of places. So push the console lock out to the callers of set_con2fb_map,

this means fbmem and switcheroo needed to take the lock around the fb notifier
entry points that lead to this.

This should fix the efifb regression seen by Maarten.

Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Tested-by: Lu Hua <huax.lu@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c |  3 +++
 drivers/video/console/fbcon.c    | 11 ++++++++---
 drivers/video/fbmem.c            |  2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 5b3c7d1..4d53351 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -26,6 +26,7 @@
 #include <linux/fb.h>
 
 #include <linux/pci.h>
+#include <linux/console.h>
 #include <linux/vga_switcheroo.h>
 
 #include <linux/vgaarb.h>
@@ -323,8 +324,10 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 
 	if (new_client->fb_info) {
 		struct fb_event event;
+		console_lock();
 		event.info = new_client->fb_info;
 		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
+		console_unlock();
 	}
 
 	ret = vgasr_priv.handler->switchto(new_client->id);
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 5bf163e..18ded2d 100644
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
 
@@ -3025,6 +3025,7 @@ static inline int fbcon_unbind(void)
 }
 #endif /* CONFIG_VT_HW_CONSOLE_BINDING */
 
+/* called with console_lock held */
 static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
@@ -3051,6 +3052,7 @@ static int fbcon_fb_unbind(int idx)
 	return ret;
 }
 
+/* called with console_lock held */
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
@@ -3088,6 +3090,7 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	return 0;
 }
 
+/* called with console_lock held */
 static void fbcon_remap_all(int idx)
 {
 	int i;
@@ -3132,6 +3135,7 @@ static inline void fbcon_select_primary(struct fb_info *info)
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
+/* called with console_lock held */
 static int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
@@ -3284,6 +3288,7 @@ static int fbcon_event_notify(struct notifier_block *self,
 		ret = fbcon_fb_unregistered(info);
 		break;
 	case FB_EVENT_SET_CONSOLE_MAP:
+		/* called with console lock held */
 		con2fb = event->data;
 		ret = set_con2fb_map(con2fb->console - 1,
 				     con2fb->framebuffer, 1);
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index afa804f..e4cc585 100644
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
1.8.1.2

