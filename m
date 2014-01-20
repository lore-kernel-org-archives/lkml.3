Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaATVbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:31:25 -0500
Received: from home.keithp.com ([63.227.221.253]:60612 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaATVbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:31:23 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Subject: [PATCH] fbcon: Clean up fbcon data in fb_info on FB_EVENT_FB_UNBIND with 0 fbs
Date: Mon, 20 Jan 2014 13:31:10 -0800
Message-Id: <1390253470-23594-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When FB_EVENT_FB_UNBIND is sent, fbcon has two paths, one path taken
when there is another frame buffer to switch any affected vcs to and
another path when there isn't.

In the case where there is another frame buffer to use,
fbcon_fb_unbind calls set_con2fb_map to remap all of the affected vcs
to the replacement frame buffer. set_con2fb_map will eventually call
con2fb_release_oldinfo when the last vcs gets unmapped from the old
frame buffer.

con2fb_release_oldinfo frees the fbcon data that is hooked off of the
fb_info structure, including the cursor timer.

In the case where there isn't another frame buffer to use,
fbcon_fb_unbind simply calls fbcon_unbind, which doesn't clear the
con2fb_map or free the fbcon data hooked from the fb_info
structure. In particular, it doesn't stop the cursor blink timer. When
the fb_info structure is then freed, we end up with a timer queue
pointing into freed memory and "bad things" start happening.

This patch first changes con2fb_release_oldinfo so that it can take a
NULL pointer for the new frame buffer, but still does all of the
deallocation and cursor timer cleanup.

Finally, the patch tries to replicate some of what set_con2fb_map does
by clearing the con2fb_map for the affected vcs and calling the
modified con2fb_release_info function to clean up the fb_info structure.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/video/console/fbcon.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index cd8a802..9297a9b 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -759,7 +759,7 @@ static int con2fb_release_oldinfo(struct vc_data *vc, struct fb_info *oldinfo,
 		  newinfo in an undefined state. Thus, a call to
 		  fb_set_par() may be needed for the newinfo.
 		*/
-		if (newinfo->fbops->fb_set_par) {
+		if (newinfo && newinfo->fbops->fb_set_par) {
 			ret = newinfo->fbops->fb_set_par(newinfo);
 
 			if (ret)
@@ -3028,8 +3028,31 @@ static int fbcon_fb_unbind(int idx)
 			if (con2fb_map[i] == idx)
 				set_con2fb_map(i, new_idx, 0);
 		}
-	} else
+	} else {
+		struct fb_info *info = registered_fb[idx];
+
+		/* This is sort of like set_con2fb_map, except it maps
+		 * the consoles to no device and then releases the
+		 * oldinfo to free memory and cancel the cursor blink
+		 * timer. I can imagine this just becoming part of
+		 * set_con2fb_map where new_idx is -1
+		 */
+		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+			if (con2fb_map[i] == idx) {
+				con2fb_map[i] = -1;
+				if (!search_fb_in_map(idx)) {
+					ret = con2fb_release_oldinfo(vc_cons[i].d,
+								     info, NULL, i,
+								     idx, 0);
+					if (ret) {
+						con2fb_map[i] = idx;
+						return ret;
+					}
+				}
+			}
+		}
 		ret = fbcon_unbind();
+	}
 
 	return ret;
 }
-- 
1.8.5.2

