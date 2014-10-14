Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaJNLyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:54:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:20149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaJNLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:54:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,716,1406617200"; 
   d="scan'208";a="614197348"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] video/console: Resolve several shadow warnings
Date: Tue, 14 Oct 2014 04:53:49 -0700
Message-Id: <1413287629-11749-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve shadow warnings that appear in W=2 builds by renaming
the "state" global to "vgastate".

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/video/console/vgacon.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 6e6aa70..517f565 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -56,7 +56,7 @@ static int cursor_size_lastfrom;
 static int cursor_size_lastto;
 static u32 vgacon_xres;
 static u32 vgacon_yres;
-static struct vgastate state;
+static struct vgastate vgastate;
 
 #define BLANK 0x0020
 
@@ -400,7 +400,7 @@ static const char *vgacon_startup(void)
 
 	vga_video_num_lines = screen_info.orig_video_lines;
 	vga_video_num_columns = screen_info.orig_video_cols;
-	state.vgabase = NULL;
+	vgastate.vgabase = NULL;
 
 	if (screen_info.orig_video_mode == 7) {
 		/* Monochrome display */
@@ -851,12 +851,12 @@ static void vga_set_palette(struct vc_data *vc, unsigned char *table)
 {
 	int i, j;
 
-	vga_w(state.vgabase, VGA_PEL_MSK, 0xff);
+	vga_w(vgastate.vgabase, VGA_PEL_MSK, 0xff);
 	for (i = j = 0; i < 16; i++) {
-		vga_w(state.vgabase, VGA_PEL_IW, table[i]);
-		vga_w(state.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
-		vga_w(state.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
-		vga_w(state.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
+		vga_w(vgastate.vgabase, VGA_PEL_IW, table[i]);
+		vga_w(vgastate.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
+		vga_w(vgastate.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
+		vga_w(vgastate.vgabase, VGA_PEL_D, vc->vc_palette[j++] >> 2);
 	}
 }
 
@@ -1008,7 +1008,7 @@ static int vgacon_blank(struct vc_data *c, int blank, int mode_switch)
 	switch (blank) {
 	case 0:		/* Unblank */
 		if (vga_vesa_blanked) {
-			vga_vesa_unblank(&state);
+			vga_vesa_unblank(&vgastate);
 			vga_vesa_blanked = 0;
 		}
 		if (vga_palette_blanked) {
@@ -1022,7 +1022,7 @@ static int vgacon_blank(struct vc_data *c, int blank, int mode_switch)
 	case 1:		/* Normal blanking */
 	case -1:	/* Obsolete */
 		if (!mode_switch && vga_video_type == VIDEO_TYPE_VGAC) {
-			vga_pal_blank(&state);
+			vga_pal_blank(&vgastate);
 			vga_palette_blanked = 1;
 			return 0;
 		}
@@ -1034,7 +1034,7 @@ static int vgacon_blank(struct vc_data *c, int blank, int mode_switch)
 		return 1;
 	default:		/* VESA blanking */
 		if (vga_video_type == VIDEO_TYPE_VGAC) {
-			vga_vesa_blank(&state, blank - 1);
+			vga_vesa_blank(&vgastate, blank - 1);
 			vga_vesa_blanked = blank;
 		}
 		return 0;
@@ -1280,7 +1280,7 @@ static int vgacon_font_set(struct vc_data *c, struct console_font *font, unsigne
 	    (charcount != 256 && charcount != 512))
 		return -EINVAL;
 
-	rc = vgacon_do_font_op(&state, font->data, 1, charcount == 512);
+	rc = vgacon_do_font_op(&vgastate, font->data, 1, charcount == 512);
 	if (rc)
 		return rc;
 
@@ -1299,7 +1299,7 @@ static int vgacon_font_get(struct vc_data *c, struct console_font *font)
 	font->charcount = vga_512_chars ? 512 : 256;
 	if (!font->data)
 		return 0;
-	return vgacon_do_font_op(&state, font->data, 0, vga_512_chars);
+	return vgacon_do_font_op(&vgastate, font->data, 0, vga_512_chars);
 }
 
 #else
-- 
1.9.3

