Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaAWSSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:18:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbaAWSSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:18:36 -0500
Date: Thu, 23 Jan 2014 13:18:34 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] matroxfb: restore the registers M_ACCESS and M_PITCH
In-Reply-To: <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When X11 is running and the user switches back to console, the card
modifies the content of registers M_MACCESS and M_PITCH in periodic
intervals.

This patch fixes it by restoring the content of these registers before
issuing any accelerator command.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/video/matrox/matroxfb_accel.c |   38 +++++++++++++++++++++++++---------
 drivers/video/matrox/matroxfb_base.h  |    2 +
 2 files changed, 30 insertions(+), 10 deletions(-)

Index: linux-3.12.5/drivers/video/matrox/matroxfb_accel.c
===================================================================
--- linux-3.12.5.orig/drivers/video/matrox/matroxfb_accel.c	2013-12-15 16:32:04.056383894 +0100
+++ linux-3.12.5/drivers/video/matrox/matroxfb_accel.c	2013-12-15 16:33:10.271706929 +0100
@@ -192,10 +192,18 @@ void matrox_cfbX_init(struct matrox_fb_i
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
@@ -207,7 +215,8 @@ static void matrox_accel_bmove(struct ma
 	CRITBEGIN
 
 	if ((dy < sy) || ((dy == sy) && (dx <= sx))) {
-		mga_fifo(2);
+		mga_fifo(4);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_SGNZERO |
 			 M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
@@ -215,7 +224,8 @@ static void matrox_accel_bmove(struct ma
 		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
-		mga_fifo(3);
+		mga_fifo(5);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
@@ -224,7 +234,8 @@ static void matrox_accel_bmove(struct ma
 		start = end+width;
 		dy += height-1;
 	}
-	mga_fifo(4);
+	mga_fifo(6);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_AR0, end);
 	mga_outl(M_AR3, start);
 	mga_outl(M_FXBNDRY, ((dx+width)<<16) | dx);
@@ -246,7 +257,8 @@ static void matrox_accel_bmove_lin(struc
 	CRITBEGIN
 
 	if ((dy < sy) || ((dy == sy) && (dx <= sx))) {
-		mga_fifo(2);
+		mga_fifo(4);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_SGNZERO |
 			M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_AR5, vxres);
@@ -254,7 +266,8 @@ static void matrox_accel_bmove_lin(struc
 		start = sy*vxres+sx+curr_ydstorg(minfo);
 		end = start+width;
 	} else {
-		mga_fifo(3);
+		mga_fifo(5);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, M_DWG_BITBLT | M_DWG_SHIFTZERO | M_DWG_BFCOL | M_DWG_REPLACE);
 		mga_outl(M_SGN, 5);
 		mga_outl(M_AR5, -vxres);
@@ -263,7 +276,8 @@ static void matrox_accel_bmove_lin(struc
 		start = end+width;
 		dy += height-1;
 	}
-	mga_fifo(5);
+	mga_fifo(7);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_AR0, end);
 	mga_outl(M_AR3, start);
 	mga_outl(M_FXBNDRY, ((dx+width)<<16) | dx);
@@ -298,7 +312,8 @@ static void matroxfb_accel_clear(struct
 
 	CRITBEGIN
 
-	mga_fifo(5);
+	mga_fifo(7);
+	matrox_accel_restore_maccess(minfo);
 	mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE);
 	mga_outl(M_FCOL, color);
 	mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
@@ -341,7 +356,8 @@ static void matroxfb_cfb4_clear(struct m
 	width >>= 1;
 	sx >>= 1;
 	if (width) {
-		mga_fifo(5);
+		mga_fifo(7);
+		matrox_accel_restore_maccess(minfo);
 		mga_outl(M_DWGCTL, minfo->accel.m_dwg_rect | M_DWG_REPLACE2);
 		mga_outl(M_FCOL, bgx);
 		mga_outl(M_FXBNDRY, ((sx + width) << 16) | sx);
@@ -415,7 +431,8 @@ static void matroxfb_1bpp_imageblit(stru
 
 	CRITBEGIN
 
-	mga_fifo(3);
+	mga_fifo(5);
+	matrox_accel_restore_maccess(minfo);
 	if (easy)
 		mga_outl(M_DWGCTL, M_DWG_ILOAD | M_DWG_SGNZERO | M_DWG_SHIFTZERO | M_DWG_BMONOWF | M_DWG_LINEAR | M_DWG_REPLACE);
 	else
@@ -425,7 +442,8 @@ static void matroxfb_1bpp_imageblit(stru
 	fxbndry = ((xx + width - 1) << 16) | xx;
 	mmio = minfo->mmio.vbase;
 
-	mga_fifo(6);
+	mga_fifo(8);
+	matrox_accel_restore_maccess(minfo);
 	mga_writel(mmio, M_FXBNDRY, fxbndry);
 	mga_writel(mmio, M_AR0, ar0);
 	mga_writel(mmio, M_AR3, 0);
Index: linux-3.12.5/drivers/video/matrox/matroxfb_base.h
===================================================================
--- linux-3.12.5.orig/drivers/video/matrox/matroxfb_base.h	2013-12-15 16:31:56.823877143 +0100
+++ linux-3.12.5/drivers/video/matrox/matroxfb_base.h	2013-12-15 16:33:10.275039841 +0100
@@ -307,6 +307,8 @@ struct matrox_accel_data {
 #endif
 	u_int32_t	m_dwg_rect;
 	u_int32_t	m_opmode;
+	u_int32_t	m_access;
+	u_int32_t	m_pitch;
 };
 
 struct v4l2_queryctrl;

