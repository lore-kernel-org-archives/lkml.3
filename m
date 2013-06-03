Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3FCWTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:19:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab3FCWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:14 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nWQPX4Jv034A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=n2WasoeWmK4A:10 a=6zZ5Uxn1AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=-zc3DgLdyqHp_tMFs3cA:9 a=QwnTS9JGZEsA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221157.039073571@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christopher Harvey <charvey@matrox.com>, Julia Lemire <jlemire@matrox.com>,
        Mathieu Larouche <mathieu.larouche@matrox.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [27/65] drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0027-drm-mgag200-Fix-writes-into-MGA1064_PIX_CLK_CTL-regi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

[ Upstream commit fb70a6690875315a3a1454e52fa339441ee7612b ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   42 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index fa82ead..26518cc 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -190,12 +190,12 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
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
@@ -205,7 +205,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN | 0x80;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -213,7 +213,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_VREF_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~0x04;
-		WREG_DAC(MGA1064_VREF_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(50);
 
@@ -237,13 +237,13 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
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
@@ -254,7 +254,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -319,7 +319,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= 0x3 << 2;
@@ -327,12 +327,12 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 
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
@@ -343,7 +343,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
@@ -351,11 +351,11 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
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
@@ -364,7 +364,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	return 0;
 }
@@ -417,7 +417,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
 		tmp |= 0x3 << 2;
@@ -426,7 +426,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -440,13 +440,13 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
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
 
@@ -516,12 +516,12 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
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
@@ -531,7 +531,7 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
-- 
1.7.10.4


