Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaKYKmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaKYKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 116/254] framebuffer: fix border color
Date: Tue, 25 Nov 2014 10:37:46 +0000
Message-Id: <1416912004-5928-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f74a289b9480648a654e5afd8458c2263c03a1e1 upstream.

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
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/console/bitblit.c   | 3 +--
 drivers/video/console/fbcon_ccw.c | 3 +--
 drivers/video/console/fbcon_cw.c  | 3 +--
 drivers/video/console/fbcon_ud.c  | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 61b182bf32a2..dbfe4eecf12e 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -205,7 +205,6 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only)
 {
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 	unsigned int cw = vc->vc_font.width;
 	unsigned int ch = vc->vc_font.height;
 	unsigned int rw = info->var.xres - (vc->vc_cols*cw);
@@ -214,7 +213,7 @@ static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 	unsigned int bs = info->var.yres - bh;
 	struct fb_fillrect region;
 
-	region.color = attr_bgcol_ec(bgshift, vc, info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_ccw.c b/drivers/video/console/fbcon_ccw.c
index 41b32ae23dac..5a3cbf6dff4d 100644
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -197,9 +197,8 @@ static void ccw_clear_margins(struct vc_data *vc, struct fb_info *info,
 	unsigned int bh = info->var.xres - (vc->vc_rows*ch);
 	unsigned int bs = vc->vc_rows*ch;
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_cw.c b/drivers/video/console/fbcon_cw.c
index a93670ef7f89..e7ee44db4e98 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -180,9 +180,8 @@ static void cw_clear_margins(struct vc_data *vc, struct fb_info *info,
 	unsigned int bh = info->var.xres - (vc->vc_rows*ch);
 	unsigned int rs = info->var.yres - rw;
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_ud.c b/drivers/video/console/fbcon_ud.c
index ff0872c0498b..19e3714abfe8 100644
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -227,9 +227,8 @@ static void ud_clear_margins(struct vc_data *vc, struct fb_info *info,
 	unsigned int rw = info->var.xres - (vc->vc_cols*cw);
 	unsigned int bh = info->var.yres - (vc->vc_rows*ch);
 	struct fb_fillrect region;
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
 
-	region.color = attr_bgcol_ec(bgshift,vc,info);
+	region.color = 0;
 	region.rop = ROP_COPY;
 
 	if (rw && !bottom_only) {
-- 
2.1.0

