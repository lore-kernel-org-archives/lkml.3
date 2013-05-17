Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3EQWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:16:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3EQVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Harvey <charvey@matrox.com>,
        Julia Lemire <jlemire@matrox.com>,
        Mathieu Larouche <mathieu.larouche@matrox.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 049/102] drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
Date: Fri, 17 May 2013 14:36:04 -0700
Message-Id: <20130517213249.503520569@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   42 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -189,12 +189,12 @@ static int mga_g200wb_set_plls(struct mg
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
@@ -204,7 +204,7 @@ static int mga_g200wb_set_plls(struct mg
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN | 0x80;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -212,7 +212,7 @@ static int mga_g200wb_set_plls(struct mg
 		WREG8(DAC_INDEX, MGA1064_VREF_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~0x04;
-		WREG_DAC(MGA1064_VREF_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(50);
 
@@ -236,13 +236,13 @@ static int mga_g200wb_set_plls(struct mg
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
@@ -253,7 +253,7 @@ static int mga_g200wb_set_plls(struct mg
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -318,7 +318,7 @@ static int mga_g200ev_set_plls(struct mg
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= 0x3 << 2;
@@ -326,12 +326,12 @@ static int mga_g200ev_set_plls(struct mg
 
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
@@ -342,7 +342,7 @@ static int mga_g200ev_set_plls(struct mg
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
@@ -350,11 +350,11 @@ static int mga_g200ev_set_plls(struct mg
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
@@ -363,7 +363,7 @@ static int mga_g200ev_set_plls(struct mg
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	return 0;
 }
@@ -416,7 +416,7 @@ static int mga_g200eh_set_plls(struct mg
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
 		tmp |= 0x3 << 2;
@@ -425,7 +425,7 @@ static int mga_g200eh_set_plls(struct mg
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -439,13 +439,13 @@ static int mga_g200eh_set_plls(struct mg
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
 
@@ -515,12 +515,12 @@ static int mga_g200er_set_plls(struct mg
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
@@ -530,7 +530,7 @@ static int mga_g200er_set_plls(struct mg
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 


