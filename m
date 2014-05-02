Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaEBQ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:29:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/151] matroxfb: restore the registers M_ACCESS and M_PITCH
Date: Fri,  2 May 2014 08:36:36 -0700
Message-Id: <1399045139-4531-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit a772d4736641ec1b421ad965e13457c17379fc86 upstream.

When X11 is running and the user switches back to console, the card
modifies the content of registers M_MACCESS and M_PITCH in periodic
intervals.

This patch fixes it by restoring the content of these registers before
issuing any accelerator command.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/video/matrox/matroxfb_accel.c | 38 ++++++++++++++++++++++++++---------
 drivers/video/matrox/matroxfb_base.h  |  2 ++
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_accel.c b/drivers/video/matrox/matroxfb_accel.c
index 8335a6f..0d5cb85 100644
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
index 11ed57b..556d96c 100644
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
1.9.1

