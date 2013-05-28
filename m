Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3E1Vgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:36:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3E1VYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 39/78] drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
Date: Tue, 28 May 2013 14:19:48 -0700
Message-Id: <1369776027-17859-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit fb70a6690875315a3a1454e52fa339441ee7612b upstream.

The original line,
  WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
wrote tmp into MGA1064_PIX_CLK_CTL_CLK_DIS, where
MGA1064_PIX_CLK_CTL_CLK_DIS is an offset into
MGA1064_PIX_CLK_CTL. Change the line to write properly into
MGA1064_PIX_CLK_CTL. There were other chunks of code nearby that use
the same pattern (but work correctly), so this patch updates them all
to use this new (slightly more efficient) write pattern. The WREG_DAC
macro was causing the DAC_INDEX register to be set to the same value
twice. WREG8(DAC_DATA, foo) takes advantage of the fact that DAC_INDEX
is already at the value we want.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Acked-by: Mathieu Larouche <mathieu.larouche@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 2e7c949..91d7859 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -189,12 +189,12 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_REMHEADCTL_CLKDIS;
-		WREG_DAC(MGA1064_REMHEADCTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		/* select PLL Set C */
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
@@ -204,7 +204,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN | 0x80;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -212,7 +212,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_VREF_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~0x04;
-		WREG_DAC(MGA1064_VREF_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(50);
 
@@ -236,13 +236,13 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 		tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_REMHEADCTL_CLKSL_MSK;
 		tmp |= MGA1064_REMHEADCTL_CLKSL_PLL;
-		WREG_DAC(MGA1064_REMHEADCTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		/* reset dotclock rate bit */
 		WREG8(MGAREG_SEQ_INDEX, 1);
@@ -253,7 +253,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -318,7 +318,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= 0x3 << 2;
@@ -326,12 +326,12 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 
 	WREG8(DAC_INDEX, MGA1064_PIX_PLL_STAT);
 	tmp = RREG8(DAC_DATA);
-	WREG_DAC(MGA1064_PIX_PLL_STAT, tmp & ~0x40);
+	WREG8(DAC_DATA, tmp & ~0x40);
 
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG_DAC(MGA1064_EV_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_EV_PIX_PLLC_N, n);
@@ -342,7 +342,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
@@ -350,11 +350,11 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 	tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG8(DAC_INDEX, MGA1064_PIX_PLL_STAT);
 	tmp = RREG8(DAC_DATA);
-	WREG_DAC(MGA1064_PIX_PLL_STAT, tmp | 0x40);
+	WREG8(DAC_DATA, tmp | 0x40);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= (0x3 << 2);
@@ -363,7 +363,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	return 0;
 }
@@ -416,7 +416,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
 		tmp |= 0x3 << 2;
@@ -425,7 +425,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -439,13 +439,13 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 		tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -515,12 +515,12 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_REMHEADCTL_CLKDIS;
-	WREG_DAC(MGA1064_REMHEADCTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= (0x3<<2) | 0xc0;
@@ -530,7 +530,7 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
-- 
1.8.1.2

