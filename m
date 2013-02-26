Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab3B0ACL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:02:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab3BZX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [ 39/53] fbcon: dont lose the console font across generic->chip driver switch
Date: Tue, 26 Feb 2013 15:58:08 -0800
Message-Id: <20130226235623.902759975@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/fbcon.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -991,7 +991,7 @@ static const char *fbcon_startup(void)
 	}
 
 	/* Setup default font */
-	if (!p->fontdata) {
+	if (!p->fontdata && !vc->vc_font.data) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
 						info->var.yres,
@@ -1001,6 +1001,8 @@ static const char *fbcon_startup(void)
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
 		vc->vc_font.charcount = 256; /* FIXME  Need to support more fonts */
+	} else {
+		p->fontdata = vc->vc_font.data;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1160,9 +1162,9 @@ static void fbcon_init(struct vc_data *v
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
@@ -1174,8 +1176,8 @@ static void fbcon_deinit(struct vc_data
 	struct fb_info *info;
 	struct fbcon_ops *ops;
 	int idx;
+	bool free_font = true;
 
-	fbcon_free_font(p);
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1186,6 +1188,8 @@ static void fbcon_deinit(struct vc_data
 	if (!info)
 		goto finished;
 
+	if (info->flags & FBINFO_MISC_FIRMWARE)
+		free_font = false;
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -1197,6 +1201,8 @@ static void fbcon_deinit(struct vc_data
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
 
+	fbcon_free_font(p, free_font);
+
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
 


