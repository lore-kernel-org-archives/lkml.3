Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3IZPe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:34:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16516 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3IZPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:34:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Sep 2013 08:34:26 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: PLLE spread spectrum control
Date: Thu, 26 Sep 2013 18:34:05 +0300
Message-ID: <1380209654-25458-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add spread spectrum control for PLLE in Tegra114.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 87f0533..f0577e3 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -77,7 +77,23 @@
 #define PLLE_MISC_SETUP_VALUE (7 << PLLE_MISC_SETUP_BASE_SHIFT)
 
 #define PLLE_SS_CTRL 0x68
-#define PLLE_SS_DISABLE (7 << 10)
+#define PLLE_SS_CNTL_BYPASS_SS BIT(10)
+#define PLLE_SS_CNTL_INTERP_RESET BIT(11)
+#define PLLE_SS_CNTL_SSC_BYP BIT(12)
+#define PLLE_SS_CNTL_CENTER BIT(14)
+#define PLLE_SS_CNTL_INVERT BIT(15)
+#define PLLE_SS_DISABLE (PLLE_SS_CNTL_BYPASS_SS | PLLE_SS_CNTL_INTERP_RESET |\
+				PLLE_SS_CNTL_SSC_BYP)
+#define PLLE_SS_MAX_MASK 0x1ff
+#define PLLE_SS_MAX_VAL 0x25
+#define PLLE_SS_INC_MASK (0xff << 16)
+#define PLLE_SS_INC_VAL (0x1 << 16)
+#define PLLE_SS_INCINTRV_MASK (0x3f << 24)
+#define PLLE_SS_INCINTRV_VAL (0x20 << 24)
+#define PLLE_SS_COEFFICIENTS_MASK \
+	(PLLE_SS_MAX_MASK | PLLE_SS_INC_MASK | PLLE_SS_INCINTRV_MASK)
+#define PLLE_SS_COEFFICIENTS_VAL \
+	(PLLE_SS_MAX_VAL | PLLE_SS_INC_VAL | PLLE_SS_INCINTRV_VAL)
 
 #define PLLE_AUX_PLLP_SEL	BIT(2)
 #define PLLE_AUX_ENABLE_SWCTL	BIT(4)
@@ -1286,6 +1302,18 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	if (ret < 0)
 		goto out;
 
+	val = pll_readl(PLLE_SS_CTRL, pll);
+	val &= ~(PLLE_SS_CNTL_CENTER | PLLE_SS_CNTL_INVERT);
+	val &= ~PLLE_SS_COEFFICIENTS_MASK;
+	val |= PLLE_SS_COEFFICIENTS_VAL;
+	pll_writel(val, PLLE_SS_CTRL, pll);
+	val &= ~(PLLE_SS_CNTL_SSC_BYP | PLLE_SS_CNTL_BYPASS_SS);
+	pll_writel(val, PLLE_SS_CTRL, pll);
+	udelay(1);
+	val &= ~PLLE_SS_CNTL_INTERP_RESET;
+	pll_writel(val, PLLE_SS_CTRL, pll);
+	udelay(1);
+
 	/* TODO: enable hw control of xusb brick pll */
 
 out:
-- 
1.7.7.rc0.72.g4b5ea.dirty

