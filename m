Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaDRJmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:42:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45936 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 20/72] video/fb: Propagate error code from failing to unregister conflicting fb
Date: Fri, 18 Apr 2014 11:21:53 +0200
Message-Id: <9419c62ccf280244e27f3007752cfb9818e46479.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 46eeb2c144956e88197439b5ee5cf221a91b0a81 upstream.

If we fail to remove a conflicting fb driver, we need to abort the
loading of the second driver to avoid likely kernel panics.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/fbmem.c | 31 +++++++++++++++++++++----------
 include/linux/fb.h    |  4 ++--
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index cde461932760..7309ac704e26 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1577,10 +1577,10 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
 static int do_unregister_framebuffer(struct fb_info *fb_info);
 
 #define VGA_FB_PHYS 0xA0000
-static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
-				     const char *name, bool primary)
+static int do_remove_conflicting_framebuffers(struct apertures_struct *a,
+					      const char *name, bool primary)
 {
-	int i;
+	int i, ret;
 
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for (i = 0 ; i < FB_MAX; i++) {
@@ -1599,22 +1599,29 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 			printk(KERN_INFO "fb: conflicting fb hw usage "
 			       "%s vs %s - removing generic driver\n",
 			       name, registered_fb[i]->fix.id);
-			do_unregister_framebuffer(registered_fb[i]);
+			ret = do_unregister_framebuffer(registered_fb[i]);
+			if (ret)
+				return ret;
 		}
 	}
+
+	return 0;
 }
 
 static int do_register_framebuffer(struct fb_info *fb_info)
 {
-	int i;
+	int i, ret;
 	struct fb_event event;
 	struct fb_videomode mode;
 
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
-	do_remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
-					 fb_is_primary_device(fb_info));
+	ret = do_remove_conflicting_framebuffers(fb_info->apertures,
+						 fb_info->fix.id,
+						 fb_is_primary_device(fb_info));
+	if (ret)
+		return ret;
 
 	if (num_registered_fb == FB_MAX)
 		return -ENXIO;
@@ -1739,12 +1746,16 @@ int unlink_framebuffer(struct fb_info *fb_info)
 }
 EXPORT_SYMBOL(unlink_framebuffer);
 
-void remove_conflicting_framebuffers(struct apertures_struct *a,
-				     const char *name, bool primary)
+int remove_conflicting_framebuffers(struct apertures_struct *a,
+				    const char *name, bool primary)
 {
+	int ret;
+
 	mutex_lock(&registration_lock);
-	do_remove_conflicting_framebuffers(a, name, primary);
+	ret = do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(remove_conflicting_framebuffers);
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index ffac70aab3e9..8439a1600c1a 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -613,8 +613,8 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
 extern int unlink_framebuffer(struct fb_info *fb_info);
-extern void remove_conflicting_framebuffers(struct apertures_struct *a,
-				const char *name, bool primary);
+extern int remove_conflicting_framebuffers(struct apertures_struct *a,
+					   const char *name, bool primary);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);
-- 
1.9.2

