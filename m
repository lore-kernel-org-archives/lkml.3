Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaKROKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:10:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaKROJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/206] framebuffer: fix border color
Date: Tue, 18 Nov 2014 15:07:27 +0100
Message-Id: <813324190f068e9e710ef2078deed32bc9df0f56.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

