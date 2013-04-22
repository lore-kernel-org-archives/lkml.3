Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3DVO3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51437 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab3DVO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Airlie" <airlied@gmail.com>,
        "Lu Hua" <huax.lu@intel.com>, "Dave Airlie" <airlied@redhat.com>,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.723942461@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [69/75] fbcon: fix locking harder
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/vga/vga_switcheroo.c |    3 +++
 drivers/video/console/fbcon.c    |   11 ++++++++---
 drivers/video/fbmem.c            |    2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -26,6 +26,7 @@
 #include <linux/fb.h>
 
 #include <linux/pci.h>
+#include <linux/console.h>
 #include <linux/vga_switcheroo.h>
 
 struct vga_switcheroo_client {
@@ -256,8 +257,10 @@ static int vga_switchto_stage2(struct vg
 
 	if (new_client->fb_info) {
 		struct fb_event event;
+		console_lock();
 		event.info = new_client->fb_info;
 		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
+		console_unlock();
 	}
 
 	ret = vgasr_priv.handler->switchto(new_client->id);
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -843,6 +843,8 @@ static void con2fb_init_display(struct v
  *
  *	Maps a virtual console @unit to a frame buffer device
  *	@newidx.
+ *
+ *	This should be called with the console lock held.
  */
 static int set_con2fb_map(int unit, int newidx, int user)
 {
@@ -860,7 +862,7 @@ static int set_con2fb_map(int unit, int
 
 	if (!search_for_mapped_con() || !con_is_bound(&fb_con)) {
 		info_idx = newidx;
-		return fbcon_takeover(0);
+		return do_fbcon_takeover(0);
 	}
 
 	if (oldidx != -1)
@@ -868,7 +870,6 @@ static int set_con2fb_map(int unit, int
 
 	found = search_fb_in_map(newidx);
 
-	console_lock();
 	con2fb_map[unit] = newidx;
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
@@ -895,7 +896,6 @@ static int set_con2fb_map(int unit, int
 	if (!search_fb_in_map(info_idx))
 		info_idx = newidx;
 
-	console_unlock();
  	return err;
 }
 
@@ -3026,6 +3026,7 @@ static inline int fbcon_unbind(void)
 }
 #endif /* CONFIG_VT_HW_CONSOLE_BINDING */
 
+/* called with console_lock held */
 static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
@@ -3052,6 +3053,7 @@ static int fbcon_fb_unbind(int idx)
 	return ret;
 }
 
+/* called with console_lock held */
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
@@ -3089,6 +3091,7 @@ static int fbcon_fb_unregistered(struct
 	return 0;
 }
 
+/* called with console_lock held */
 static void fbcon_remap_all(int idx)
 {
 	int i;
@@ -3133,6 +3136,7 @@ static inline void fbcon_select_primary(
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
+/* called with console_lock held */
 static int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
@@ -3285,6 +3289,7 @@ static int fbcon_event_notify(struct not
 		ret = fbcon_fb_unregistered(info);
 		break;
 	case FB_EVENT_SET_CONSOLE_MAP:
+		/* called with console lock held */
 		con2fb = event->data;
 		ret = set_con2fb_map(con2fb->console - 1,
 				     con2fb->framebuffer, 1);
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1154,8 +1154,10 @@ static long do_fb_ioctl(struct fb_info *
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

