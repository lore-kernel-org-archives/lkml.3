Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab3B1PDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:03:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab3B1Oti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kay Sievers <kay.sievers@vrfy.org>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 092/139] fbcon: don't lose the console font across generic->chip driver switch
Date: Thu, 28 Feb 2013 14:44:02 +0000
Message-Id: <1362062689-2567-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit ae1287865f5361fa138d4d3b1b6277908b54eac9 upstream.

If grub2 loads efifb/vesafb, then when systemd starts it can set the console
font on that framebuffer device, however when we then load the native KMS
driver, the first thing it does is tear down the generic framebuffer driver.

The thing is the generic code is doing the right thing, it frees the font
because otherwise it would leak memory. However we can assume that if you
are removing the generic firmware driver (vesa/efi/offb), that a new driver
*should* be loading soon after, so we effectively leak the font.

However the old code left a dangling pointer in vc->vc_font.data and we
can now reuse that dangling pointer to load the font into the new
driver, now that we aren't freeing it.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=892340

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/console/fbcon.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 88e9204..bdcd34d 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -990,7 +990,7 @@ static const char *fbcon_startup(void)
 	}
 
 	/* Setup default font */
-	if (!p->fontdata) {
+	if (!p->fontdata && !vc->vc_font.data) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
 						info->var.yres,
@@ -1000,6 +1000,8 @@ static const char *fbcon_startup(void)
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
 		vc->vc_font.charcount = 256; /* FIXME  Need to support more fonts */
+	} else {
+		p->fontdata = vc->vc_font.data;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1159,9 +1161,9 @@ static void fbcon_init(struct vc_data *vc, int init)
 	ops->p = &fb_display[fg_console];
 }
 
-static void fbcon_free_font(struct display *p)
+static void fbcon_free_font(struct display *p, bool freefont)
 {
-	if (p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
+	if (freefont && p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
 		kfree(p->fontdata - FONT_EXTRA_WORDS * sizeof(int));
 	p->fontdata = NULL;
 	p->userfont = 0;
@@ -1173,8 +1175,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	struct fb_info *info;
 	struct fbcon_ops *ops;
 	int idx;
+	bool free_font = true;
 
-	fbcon_free_font(p);
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1185,6 +1187,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (!info)
 		goto finished;
 
+	if (info->flags & FBINFO_MISC_FIRMWARE)
+		free_font = false;
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -1196,6 +1200,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
 
+	fbcon_free_font(p, free_font);
+
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
 
-- 
1.8.1.2

