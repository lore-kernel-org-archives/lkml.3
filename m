Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaIPQkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbaIPQka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:40:30 -0400
Date: Tue, 16 Sep 2014 12:40:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] framebuffer: fix border color
Message-ID: <alpine.LRH.2.02.1409161238560.3150@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The framebuffer code uses the current background color to fill the border
when switching consoles, however, this results in inconsistent behavior.
For example:
- start Midnigh Commander
- the border is black
- switch to another console and switch back
- the border is cyan
- type something into the command line in mc
- the border is cyan
- switch to another console and switch back
- the border is black
- press F9 to go to menu
- the border is black
- switch to another console and switch back
- the border is dark blue

When switching to a console with Midnight Commander, the border is random
color that was left selected by the slang subsystem.

This patch fixes this inconsistency by always using black as the
background color when switching consoles.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/video/console/bitblit.c   |    3 +--
 drivers/video/console/fbcon_ccw.c |    3 +--
 drivers/video/console/fbcon_cw.c  |    3 +--
 drivers/video/console/fbcon_ud.c  |    3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-3.14.18/drivers/video/console/bitblit.c
===================================================================
--- linux-3.14.18.orig/drivers/video/console/bitblit.c	2014-09-16 00:15:21.622812568 +0200
+++ linux-3.14.18/drivers/video/console/bitblit.c	2014-09-16 00:16:00.447137568 +0200
@@ -205,7 +205,6 @@ static void bit_putcs(struct vc_data *vc
 static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only)
 {
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 	unsigned int cw = vc->vc_font.width;
 	unsigned int ch = vc->vc_font.height;
 	unsigned int rw = info->var.xres - (vc->vc_cols*cw);
@@ -214,7 +213,7 @@ static void bit_clear_margins(struct vc_
 	unsigned int bs = info->var.yres - bh;
 	struct fb_fillrect region;
 
-	region.color = attr_bgcol_ec(bgshift, vc, info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
Index: linux-3.14.18/drivers/video/console/fbcon_ccw.c
===================================================================
--- linux-3.14.18.orig/drivers/video/console/fbcon_ccw.c	2014-09-16 00:15:21.619479721 +0200
+++ linux-3.14.18/drivers/video/console/fbcon_ccw.c	2014-09-16 00:16:00.450470414 +0200
@@ -197,9 +197,8 @@ static void ccw_clear_margins(struct vc_
 	unsigned int bh = info->var.xres - (vc->vc_rows*ch);
 	unsigned int bs = vc->vc_rows*ch;
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
Index: linux-3.14.18/drivers/video/console/fbcon_cw.c
===================================================================
--- linux-3.14.18.orig/drivers/video/console/fbcon_cw.c	2014-09-16 00:15:21.622812568 +0200
+++ linux-3.14.18/drivers/video/console/fbcon_cw.c	2014-09-16 00:16:00.450470414 +0200
@@ -180,9 +180,8 @@ static void cw_clear_margins(struct vc_d
 	unsigned int bh = info->var.xres - (vc->vc_rows*ch);
 	unsigned int rs = info->var.yres - rw;
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
Index: linux-3.14.18/drivers/video/console/fbcon_ud.c
===================================================================
--- linux-3.14.18.orig/drivers/video/console/fbcon_ud.c	2014-09-16 00:15:21.622812568 +0200
+++ linux-3.14.18/drivers/video/console/fbcon_ud.c	2014-09-16 00:16:00.453803261 +0200
@@ -227,9 +227,8 @@ static void ud_clear_margins(struct vc_d
 	unsigned int rw = info->var.xres - (vc->vc_cols*cw);
 	unsigned int bh = info->var.yres - (vc->vc_rows*ch);
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
