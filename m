Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3AXGzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:55:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3AXGzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:55:14 -0500
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] fbcon: don't lose the console font across generic->chip driver switch
Date: Thu, 24 Jan 2013 16:19:51 +1000
Message-Id: <1359008391-10330-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

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

I'm open for better suggestions on this, but this does work in my brief
test here.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=892340

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/video/console/fbcon.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index fdefa8f..f8dbe76 100644
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
1.8.1

