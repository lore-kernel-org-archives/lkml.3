Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab3B1PD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:03:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab3B1Ote (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 091/139] vgacon/vt: clear buffer attributes when we load a 512 character font (v2)
Date: Thu, 28 Feb 2013 14:44:01 +0000
Message-Id: <1362062689-2567-92-git-send-email-luis.henriques@canonical.com>
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

commit 2a2483072393b27f4336ab068a1f48ca19ff1c1e upstream.

When we switch from 256->512 byte font rendering mode, it means the
current contents of the screen is being reinterpreted. The bit that holds
the high bit of the 9-bit font, may have been previously set, and thus
the new font misrenders.

The problem case we see is grub2 writes spaces with the bit set, so it
ends up with data like 0x820, which gets reinterpreted into 0x120 char
which the font translates into G with a circumflex. This flashes up on
screen at boot and is quite ugly.

A current side effect of this patch though is that any rendering on the
screen changes color to a slightly darker color, but at least the screen
no longer corrupts.

v2: as suggested by hpa, always clear the attribute space, whether we
are are going to or from 512 chars.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/vt.c            |  2 +-
 drivers/video/console/vgacon.c | 22 +++++++++++++++-------
 include/linux/vt_kern.h        |  1 +
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index a13f7e1..3b4f5b6 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -656,7 +656,7 @@ static inline void save_screen(struct vc_data *vc)
  *	Redrawing of screen
  */
 
-static void clear_buffer_attributes(struct vc_data *vc)
+void clear_buffer_attributes(struct vc_data *vc)
 {
 	unsigned short *p = (unsigned short *)vc->vc_origin;
 	int count = vc->vc_screenbuf_size / 2;
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index d449a74..5855d17 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1064,7 +1064,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 	unsigned short video_port_status = vga_video_port_reg + 6;
 	int font_select = 0x00, beg, i;
 	char *charmap;
-	
+	bool clear_attribs = false;
 	if (vga_video_type != VIDEO_TYPE_EGAM) {
 		charmap = (char *) VGA_MAP_MEM(colourmap, 0);
 		beg = 0x0e;
@@ -1169,12 +1169,6 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 
 	/* if 512 char mode is already enabled don't re-enable it. */
 	if ((set) && (ch512 != vga_512_chars)) {
-		/* attribute controller */
-		for (i = 0; i < MAX_NR_CONSOLES; i++) {
-			struct vc_data *c = vc_cons[i].d;
-			if (c && c->vc_sw == &vga_con)
-				c->vc_hi_font_mask = ch512 ? 0x0800 : 0;
-		}
 		vga_512_chars = ch512;
 		/* 256-char: enable intensity bit
 		   512-char: disable intensity bit */
@@ -1185,8 +1179,22 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		   it means, but it works, and it appears necessary */
 		inb_p(video_port_status);
 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
+		clear_attribs = true;
 	}
 	raw_spin_unlock_irq(&vga_lock);
+
+	if (clear_attribs) {
+		for (i = 0; i < MAX_NR_CONSOLES; i++) {
+			struct vc_data *c = vc_cons[i].d;
+			if (c && c->vc_sw == &vga_con) {
+				/* force hi font mask to 0, so we always clear
+				   the bit on either transition */
+				c->vc_hi_font_mask = 0x00;
+				clear_buffer_attributes(c);
+				c->vc_hi_font_mask = ch512 ? 0x0800 : 0;
+			}
+		}
+	}
 	return 0;
 }
 
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 50ae7d0..1f55665 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -47,6 +47,7 @@ int con_set_cmap(unsigned char __user *cmap);
 int con_get_cmap(unsigned char __user *cmap);
 void scrollback(struct vc_data *vc, int lines);
 void scrollfront(struct vc_data *vc, int lines);
+void clear_buffer_attributes(struct vc_data *vc);
 void update_region(struct vc_data *vc, unsigned long start, int count);
 void redraw_screen(struct vc_data *vc, int is_switch);
 #define update_screen(x) redraw_screen(x, 0)
-- 
1.8.1.2

