Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaE3N1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:27:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:57720 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaE3N1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:27:15 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com, geert@linux-m68k.org, broonie@linaro.org,
        rdunlap@infradead.org, dh.herrmann@gmail.com, airlied@redhat.com,
        mtosatti@redhat.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] console: Add persistent scrollback buffers for all VGA consoles
Date: Fri, 30 May 2014 15:27:05 +0200
Message-Id: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:f0swfU95vNTqOHBS8hC0v4p7gjeZKIs9uydIPOMzMnr8U4JTM4h
 wMWm9qfQ5FdAhNnqNWTRlqMCqJOUEv3zVtU4EzawhRVqTYsviHujlycBJ8Qct1zaDLwQR4S
 FHGfqHOkBm+fuRp8rxgZ75zPP1pt96fARaJPr42rqik3barV3v7hw8yLY31rrxDX3Cdwtrc
 /UKUQzbXEQHrkLRB+UYSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a scrollback buffers for each VGA console. The benefit is that
the scrollback history is not flushed when switching between consoles
but is persistent.
The buffers are allocated on demand when a new console is opened.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/video/console/Kconfig  |    6 +-
 drivers/video/console/vgacon.c |  124 ++++++++++++++++++++++++----------------
 2 files changed, 79 insertions(+), 51 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index fe1cd01..d7ec96c 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -38,14 +38,14 @@ config VGACON_SOFT_SCROLLBACK
 	 RAM to allocate for this buffer.  If unsure, say 'N'.
 
 config VGACON_SOFT_SCROLLBACK_SIZE
-       int "Scrollback Buffer Size (in KB)"
+       int "Scrollback Buffer Size per console (in KB)"
        depends on VGACON_SOFT_SCROLLBACK
        range 1 1024
        default "64"
        help
          Enter the amount of System RAM to allocate for the scrollback
-	 buffer.  Each 64KB will give you approximately 16 80x25
-	 screenfuls of scrollback buffer
+	 buffer for each VGA console. Each 64KB will give you approximately
+	 16 80x25 screenfuls of scrollback buffer.
 
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 9d8feac..215eafb 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -181,75 +181,101 @@ static inline void vga_set_mem_top(struct vc_data *c)
 
 #ifdef CONFIG_VGACON_SOFT_SCROLLBACK
 /* software scrollback */
-static void *vgacon_scrollback;
-static int vgacon_scrollback_tail;
-static int vgacon_scrollback_size;
-static int vgacon_scrollback_rows;
-static int vgacon_scrollback_cnt;
-static int vgacon_scrollback_cur;
-static int vgacon_scrollback_save;
-static int vgacon_scrollback_restore;
-
-static void vgacon_scrollback_init(int pitch)
+struct vgacon_scrollback_info {
+	void *data;
+	int tail;
+	int size;
+	int rows;
+	int cnt;
+	int cur;
+	int save;
+	int restore;
+} vgacon_scrollbacks[MAX_NR_CONSOLES];
+
+static void vgacon_scrollback_init(int vc_num)
 {
+	int pitch = vga_video_num_columns * 2;
 	int rows = CONFIG_VGACON_SOFT_SCROLLBACK_SIZE * 1024/pitch;
+	void *data;
 
-	if (vgacon_scrollback) {
-		vgacon_scrollback_cnt  = 0;
-		vgacon_scrollback_tail = 0;
-		vgacon_scrollback_cur  = 0;
-		vgacon_scrollback_rows = rows - 1;
-		vgacon_scrollback_size = rows * pitch;
+	data = kcalloc(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, 1024, GFP_NOWAIT);
+	if (!data) {
+		pr_warn("VGAcon: failed to allocate memory for scrollback.\n");
+		vgacon_scrollbacks[vc_num].data = NULL;
+		return;
 	}
+
+	vgacon_scrollbacks[vc_num].data = data;
+	vgacon_scrollbacks[vc_num].cnt  = 0;
+	vgacon_scrollbacks[vc_num].tail = 0;
+	vgacon_scrollbacks[vc_num].cur  = 0;
+	vgacon_scrollbacks[vc_num].rows = rows - 1;
+	vgacon_scrollbacks[vc_num].size = rows * pitch;
+}
+
+static void vgacon_switch_scrollback(int vc_num)
+{
+	if (!vgacon_scrollbacks[vc_num].data)
+		vgacon_scrollback_init(vc_num);
 }
 
 static void vgacon_scrollback_startup(void)
 {
-	vgacon_scrollback = kcalloc(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, 1024, GFP_NOWAIT);
-	vgacon_scrollback_init(vga_video_num_columns * 2);
+	int i;
+
+	for (i = 0; i < MAX_NR_CONSOLES; ++i)
+		vgacon_scrollbacks[i].data = NULL;
+
+	vgacon_scrollback_init(0);
 }
 
 static void vgacon_scrollback_update(struct vc_data *c, int t, int count)
 {
+	struct vgacon_scrollback_info *scrollback;
 	void *p;
 
-	if (!vgacon_scrollback_size || c->vc_num != fg_console)
+	scrollback = &vgacon_scrollbacks[c->vc_num];
+	if (!scrollback->data || !scrollback->size)
 		return;
 
 	p = (void *) (c->vc_origin + t * c->vc_size_row);
 
 	while (count--) {
-		scr_memcpyw(vgacon_scrollback + vgacon_scrollback_tail,
+		scr_memcpyw(scrollback->data + scrollback->tail,
 			    p, c->vc_size_row);
-		vgacon_scrollback_cnt++;
+		scrollback->cnt++;
 		p += c->vc_size_row;
-		vgacon_scrollback_tail += c->vc_size_row;
+		scrollback->tail += c->vc_size_row;
 
-		if (vgacon_scrollback_tail >= vgacon_scrollback_size)
-			vgacon_scrollback_tail = 0;
+		if (scrollback->tail >= scrollback->size)
+			scrollback->tail = 0;
 
-		if (vgacon_scrollback_cnt > vgacon_scrollback_rows)
-			vgacon_scrollback_cnt = vgacon_scrollback_rows;
+		if (scrollback->cnt > scrollback->rows)
+			scrollback->cnt = scrollback->rows;
 
-		vgacon_scrollback_cur = vgacon_scrollback_cnt;
+		scrollback->cur = scrollback->cnt;
 	}
 }
 
 static void vgacon_restore_screen(struct vc_data *c)
 {
-	vgacon_scrollback_save = 0;
+	struct vgacon_scrollback_info *scrollback;
+
+	scrollback = &vgacon_scrollbacks[c->vc_num];
+	scrollback->save = 0;
 
-	if (!vga_is_gfx && !vgacon_scrollback_restore) {
+	if (!vga_is_gfx && !scrollback->restore) {
 		scr_memcpyw((u16 *) c->vc_origin, (u16 *) c->vc_screenbuf,
 			    c->vc_screenbuf_size > vga_vram_size ?
 			    vga_vram_size : c->vc_screenbuf_size);
-		vgacon_scrollback_restore = 1;
-		vgacon_scrollback_cur = vgacon_scrollback_cnt;
+		scrollback->restore = 1;
+		scrollback->cur = scrollback->cnt;
 	}
 }
 
 static int vgacon_scrolldelta(struct vc_data *c, int lines)
 {
+	struct vgacon_scrollback_info *scrollback;
 	int start, end, count, soff;
 
 	if (!lines) {
@@ -258,41 +284,42 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 		return 1;
 	}
 
-	if (!vgacon_scrollback)
+	scrollback = &vgacon_scrollbacks[c->vc_num];
+	if (!scrollback->data)
 		return 1;
 
-	if (!vgacon_scrollback_save) {
+	if (!scrollback->save) {
 		vgacon_cursor(c, CM_ERASE);
 		vgacon_save_screen(c);
-		vgacon_scrollback_save = 1;
+		scrollback->save = 1;
 	}
 
-	vgacon_scrollback_restore = 0;
-	start = vgacon_scrollback_cur + lines;
+	scrollback->restore = 0;
+	start = scrollback->cur + lines;
 	end = start + abs(lines);
 
 	if (start < 0)
 		start = 0;
 
-	if (start > vgacon_scrollback_cnt)
-		start = vgacon_scrollback_cnt;
+	if (start > scrollback->cnt)
+		start = scrollback->cnt;
 
 	if (end < 0)
 		end = 0;
 
-	if (end > vgacon_scrollback_cnt)
-		end = vgacon_scrollback_cnt;
+	if (end > scrollback->cnt)
+		end = scrollback->cnt;
 
-	vgacon_scrollback_cur = start;
+	scrollback->cur = start;
 	count = end - start;
-	soff = vgacon_scrollback_tail - ((vgacon_scrollback_cnt - end) *
+	soff = scrollback->tail - ((scrollback->cnt - end) *
 					 c->vc_size_row);
 	soff -= count * c->vc_size_row;
 
 	if (soff < 0)
-		soff += vgacon_scrollback_size;
+		soff += scrollback->size;
 
-	count = vgacon_scrollback_cnt - start;
+	count = scrollback->cnt - start;
 
 	if (count > c->vc_rows)
 		count = c->vc_rows;
@@ -306,13 +333,13 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 
 		count *= c->vc_size_row;
 		/* how much memory to end of buffer left? */
-		copysize = min(count, vgacon_scrollback_size - soff);
-		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
+		copysize = min(count, scrollback->size - soff);
+		scr_memcpyw(d, scrollback->data + soff, copysize);
 		d += copysize;
 		count -= copysize;
 
 		if (count) {
-			scr_memcpyw(d, vgacon_scrollback, count);
+			scr_memcpyw(d, scrollback->data, count);
 			d += count;
 		}
 
@@ -327,6 +354,7 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 #define vgacon_scrollback_startup(...) do { } while (0)
 #define vgacon_scrollback_init(...)    do { } while (0)
 #define vgacon_scrollback_update(...)  do { } while (0)
+#define vgacon_switch_scrollback(...)  do { } while (0)
 
 static void vgacon_restore_screen(struct vc_data *c)
 {
@@ -842,7 +870,7 @@ static int vgacon_switch(struct vc_data *c)
 			vgacon_doresize(c, c->vc_cols, c->vc_rows);
 	}
 
-	vgacon_scrollback_init(c->vc_size_row);
+	vgacon_switch_scrollback(c->vc_num);
 	return 0;		/* Redrawing not needed */
 }
 
-- 
1.7.10.4

