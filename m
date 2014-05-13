Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbaEMKTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:19:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933053AbaEMKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/182] matroxfb: restore the registers M_ACCESS and M_PITCH
Date: Tue, 13 May 2014 11:28:15 +0200
Message-Id: <3693c50ad650893acd3b2e7952f88069d5990615.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a772d4736641ec1b421ad965e13457c17379fc86 upstream.

When X11 is running and the user switches back to console, the card
modifies the content of registers M_MACCESS and M_PITCH in periodic
intervals.

This patch fixes it by restoring the content of these registers before
issuing any accelerator command.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/matrox/matroxfb_accel.c | 38 ++++++++++++++++++++++++++---------
 drivers/video/matrox/matroxfb_base.h  |  2 ++
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_accel.c b/drivers/video/matrox/matroxfb_accel.c
index 8335a6fe303e..0d5cb85d071a 100644
--- a/drivers/video/matrox/matroxfb_accel.c
+++ b/drivers/video/matrox/matroxfb_accel.c
@@ -192,10 +192,18 @@ void matrox_cfbX_init(struct matrox_fb_info *minfo)
 	minfo->accel.m_dwg_rect = M_DWG_TRAP | M_DWG_SOLID | M_DWG_ARZERO | M_DWG_SGNZERO | M_DWG_SHIFTZERO;
 	if (isMilleniumII(minfo)) minfo->accel.m_dwg_rect |= M_DWG_TRANSC;
 	minfo->accel.m_opmode = mopmode;
+	minfo->accel.m_access = maccess;
+	minfo->accel.m_pitch = mpitch;
 }
 
 EXPORT_SYMBOL(matrox_cfbX_init);
 
+static void matrox_accel_restore_maccess(struct matrox_fb_info *minfo)
+{
+	mga_outl(M_MACCESS, minfo->accel.m_access);
+	mga_outl(M_PITCH, minfo->accel.m_pitch);
+}
+
 static void matrox_accel_bmove(struct matrox_fb_info *minfo, int vxres, int sy,
 			       int sx, int dy, int dx, int height, int width)
 {
@@ -207,7 +215,8 @@ static void matrox_accel_bmove(struct matrox_fb_info *minfo, int vxres, int sy,
 	CRITBEGIN
 
 	if ((dy < sy) || ((dy == sy) && (dx <= sx))) {
-		mga_fifo(2);
+		mga_fifo(4);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_SGNZERO |
 			 M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
@@ -215,7 +224,8 @@ static void matrox_accel_bmove(struct matrox_fb_info *minfo, int vxres, int sy,
 		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
-		mga_fifo(3);
+		mga_fifo(5);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
@@ -224,7 +234,8 @@ static void matrox_accel_bmove(struct matrox_fb_info *minfo, int vxres, int sy,
 		start = end+width;
 		dy += height-1;
 	}
-	mga_fifo(4);
+	mga_fifo(6);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_AR0, end);
 	mga_outl(M_AR3, start);
 	mga_outl(M_FXBNDRY, ((dx+width)<<16) | dx);
@@ -246,7 +257,8 @@ static void matrox_accel_bmove_lin(struct matrox_fb_info *minfo, int vxres,
 	CRITBEGIN
 
 	if ((dy < sy) || ((dy == sy) && (dx <= sx))) {
-		mga_fifo(2);
+		mga_fifo(4);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_SGNZERO |
 			M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
@@ -254,7 +266,8 @@ static void matrox_accel_bmove_lin(struct matrox_fb_info *minfo, int vxres,
 		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
-		mga_fifo(3);
+		mga_fifo(5);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
@@ -263,7 +276,8 @@ static void matrox_accel_bmove_lin(struct matrox_fb_info *minfo, int vxres,
 		start = end+width;
 		dy += height-1;
 	}
-	mga_fifo(5);
+	mga_fifo(7);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_AR0, end);
 	mga_outl(M_AR3, start);
 	mga_outl(M_FXBNDRY, ((dx+width)<<16) | dx);
@@ -298,7 +312,8 @@ static void matroxfb_accel_clear(struct matrox_fb_info *minfo, u_int32_t color,
 
 	CRITBEGIN
 
-	mga_fifo(5);
+	mga_fifo(7);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE);
 	mga_outl(M_FCOL, color);
 	mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
@@ -341,7 +356,8 @@ static void matroxfb_cfb4_clear(struct matrox_fb_info *minfo, u_int32_t bgx,
 	width >>= 1;
 	sx >>= 1;
 	if (width) {
-		mga_fifo(5);
+		mga_fifo(7);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE2);
 		mga_outl(M_FCOL, bgx);
 		mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
@@ -415,7 +431,8 @@ static void matroxfb_1bpp_imageblit(struct matrox_fb_info *minfo, u_int32_t fgx,
 
 	CRITBEGIN
 
-	mga_fifo(3);
+	mga_fifo(5);
+	matrox_accel_restore_maccess(minfo);
 	if (easy)
 		mga_outl(M_DWGCTL, M_DWG_ILOAD | M_DWG_SGNZERO | M_DWG_SHIFTZERO | M_DWG_BMONOWF | M_DWG_LINEAR | M_DWG_REPLACE);
 	else
@@ -425,7 +442,8 @@ static void matroxfb_1bpp_imageblit(struct matrox_fb_info *minfo, u_int32_t fgx,
 	fxbndry = ((xx + width - 1) << 16) | xx;
 	mmio = minfo->mmio.vbase;
 
-	mga_fifo(6);
+	mga_fifo(8);
+	matrox_accel_restore_maccess(minfo);
 	mga_writel(mmio, M_FXBNDRY, fxbndry);
 	mga_writel(mmio, M_AR0, ar0);
 	mga_writel(mmio, M_AR3, 0);
diff --git a/drivers/video/matrox/matroxfb_base.h b/drivers/video/matrox/matroxfb_base.h
index 11ed57bb704e..556d96ce40bf 100644
--- a/drivers/video/matrox/matroxfb_base.h
+++ b/drivers/video/matrox/matroxfb_base.h
@@ -307,6 +307,8 @@ struct matrox_accel_data {
 #endif
 	u_int32_t	m_dwg_rect;
 	u_int32_t	m_opmode;
+	u_int32_t	m_access;
+	u_int32_t	m_pitch;
 };
 
 struct v4l2_queryctrl;
-- 
1.9.3

