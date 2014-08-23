Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaHWLZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:02 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1746 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbaHWLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829917"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] video: fbdev: matrox: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:24 +0200
Message-Id: <1408792831-25615-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/video/fbdev/matrox/matroxfb_maven.c |   20 +++++-----
 drivers/video/fbdev/matrox/matroxfb_base.c  |   52 ++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/video/fbdev/matrox/matroxfb_maven.c b/drivers/video/fbdev/matrox/matroxfb_maven.c
index ee41a0f..bf5ce04 100644
--- a/drivers/video/fbdev/matrox/matroxfb_maven.c
+++ b/drivers/video/fbdev/matrox/matroxfb_maven.c
@@ -201,21 +201,23 @@ struct matrox_pll_ctl {
 };
 
 static const struct matrox_pll_features2 maven1000_pll = {
-	 50000000,
-	300000000,
-	 5, 128,
-	 3,  32,
-	 3
+	.vco_freq_min = 50000000,
+	.vco_freq_max = 300000000,
+	.feed_div_min = 5,
+	.feed_div_max = 128,
+	.in_div_min = 3,
+	.in_div_max = 32,
+	.post_shift_max = 3
 };
 
 static const struct matrox_pll_ctl maven_PAL = {
-	540000,
-	    50
+	.ref_freq = 540000,
+	.den = 50
 };
 
 static const struct matrox_pll_ctl maven_NTSC = {
-	450450,	/* 27027000/60 == 27000000/59.94005994 */
-	    60
+	.ref_freq = 450450,	/* 27027000/60 == 27000000/59.94005994 */
+	.den = 60
 };
 
 static int matroxfb_PLL_mavenclock(const struct matrox_pll_features2* pll,
diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 7116c53..62539ca 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1341,19 +1341,57 @@ struct video_board {
 	struct matrox_switch* lowlevel;
 		 };
 #ifdef CONFIG_FB_MATROX_MILLENIUM
-static struct video_board vbMillennium		= {0x0800000, 0x0800000, FB_ACCEL_MATROX_MGA2064W,	&matrox_millennium};
-static struct video_board vbMillennium2		= {0x1000000, 0x0800000, FB_ACCEL_MATROX_MGA2164W,	&matrox_millennium};
-static struct video_board vbMillennium2A	= {0x1000000, 0x0800000, FB_ACCEL_MATROX_MGA2164W_AGP,	&matrox_millennium};
+static struct video_board vbMillennium = {
+	.maxvram = 0x0800000,
+	.maxdisplayable = 0x0800000,
+	.accelID = FB_ACCEL_MATROX_MGA2064W,
+	.lowlevel = &matrox_millennium
+};
+
+static struct video_board vbMillennium2 = {
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x0800000,
+	.accelID = FB_ACCEL_MATROX_MGA2164W,
+	.lowlevel = &matrox_millennium
+};
+
+static struct video_board vbMillennium2A = {
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x0800000,
+	.accelID = FB_ACCEL_MATROX_MGA2164W_AGP,
+	.lowlevel = &matrox_millennium
+};
 #endif	/* CONFIG_FB_MATROX_MILLENIUM */
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
-static struct video_board vbMystique		= {0x0800000, 0x0800000, FB_ACCEL_MATROX_MGA1064SG,	&matrox_mystique};
+static struct video_board vbMystique = {
+	.maxvram = 0x0800000,
+	.maxdisplayable = 0x0800000,
+	.accelID = FB_ACCEL_MATROX_MGA1064SG,
+	.lowlevel = &matrox_mystique
+};
 #endif	/* CONFIG_FB_MATROX_MYSTIQUE */
 #ifdef CONFIG_FB_MATROX_G
-static struct video_board vbG100		= {0x0800000, 0x0800000, FB_ACCEL_MATROX_MGAG100,	&matrox_G100};
-static struct video_board vbG200		= {0x1000000, 0x1000000, FB_ACCEL_MATROX_MGAG200,	&matrox_G100};
+static struct video_board vbG100 = {
+	.maxvram = 0x0800000,
+	.maxdisplayable = 0x0800000,
+	.accelID = FB_ACCEL_MATROX_MGAG100,
+	.lowlevel = &matrox_G100
+};
+
+static struct video_board vbG200 = {
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x1000000,
+	.accelID = FB_ACCEL_MATROX_MGAG200,
+	.lowlevel = &matrox_G100
+};
 /* from doc it looks like that accelerator can draw only to low 16MB :-( Direct accesses & displaying are OK for
    whole 32MB */
-static struct video_board vbG400		= {0x2000000, 0x1000000, FB_ACCEL_MATROX_MGAG400,	&matrox_G100};
+static struct video_board vbG400 = {
+	.maxvram = 0x2000000,
+	.maxdisplayable = 0x1000000,
+	.accelID = FB_ACCEL_MATROX_MGAG400,
+	.lowlevel = &matrox_G100
+};
 #endif
 
 #define DEVF_VIDEO64BIT		0x0001

