Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaEOAdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:33:17 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:55501 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaEOAdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:12 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jim Lin <jilin@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 01/10] clk: tegra: Enable hardware control of PLLE
Date: Wed, 14 May 2014 17:32:57 -0700
Message-Id: <1400113986-339-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

Enable hardware control of PLLE spread-spectrum, IDDQ, and enable
controls when enabling PLLE.  The hardware (e.g. XUSB) using PLLE
will use these controls for power-saving optimizations.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-pll.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0d20241..84ca8b9 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -96,10 +96,20 @@
 	(PLLE_SS_MAX_VAL | PLLE_SS_INC_VAL | PLLE_SS_INCINTRV_VAL)
 
 #define PLLE_AUX_PLLP_SEL	BIT(2)
+#define PLLE_AUX_USE_LOCKDET	BIT(3)
 #define PLLE_AUX_ENABLE_SWCTL	BIT(4)
+#define PLLE_AUX_SS_SWCTL	BIT(6)
 #define PLLE_AUX_SEQ_ENABLE	BIT(24)
+#define PLLE_AUX_SEQ_START_STATE BIT(25)
 #define PLLE_AUX_PLLRE_SEL	BIT(28)
 
+#define XUSBIO_PLL_CFG0		0x51c
+#define XUSBIO_PLL_CFG0_PADPLL_RESET_SWCTL	BIT(0)
+#define XUSBIO_PLL_CFG0_CLK_ENABLE_SWCTL	BIT(2)
+#define XUSBIO_PLL_CFG0_PADPLL_USE_LOCKDET	BIT(6)
+#define XUSBIO_PLL_CFG0_SEQ_ENABLE		BIT(24)
+#define XUSBIO_PLL_CFG0_SEQ_START_STATE		BIT(25)
+
 #define PLLE_MISC_PLLE_PTS	BIT(8)
 #define PLLE_MISC_IDDQ_SW_VALUE	BIT(13)
 #define PLLE_MISC_IDDQ_SW_CTRL	BIT(14)
@@ -1318,7 +1328,28 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	pll_writel(val, PLLE_SS_CTRL, pll);
 	udelay(1);
 
-	/* TODO: enable hw control of xusb brick pll */
+	/* Enable hw control of xusb brick pll */
+	val = pll_readl_misc(pll);
+	val &= ~PLLE_MISC_IDDQ_SW_CTRL;
+	pll_writel_misc(val, pll);
+
+	val = pll_readl(pll->params->aux_reg, pll);
+	val |= (PLLE_AUX_USE_LOCKDET | PLLE_AUX_SEQ_START_STATE);
+	val &= ~(PLLE_AUX_ENABLE_SWCTL | PLLE_AUX_SS_SWCTL);
+	pll_writel(val, pll->params->aux_reg, pll);
+	udelay(1);
+	val |= PLLE_AUX_SEQ_ENABLE;
+	pll_writel(val, pll->params->aux_reg, pll);
+
+	val = pll_readl(XUSBIO_PLL_CFG0, pll);
+	val |= (XUSBIO_PLL_CFG0_PADPLL_USE_LOCKDET |
+		XUSBIO_PLL_CFG0_SEQ_START_STATE);
+	val &= ~(XUSBIO_PLL_CFG0_CLK_ENABLE_SWCTL |
+		 XUSBIO_PLL_CFG0_PADPLL_RESET_SWCTL);
+	pll_writel(val, XUSBIO_PLL_CFG0, pll);
+	udelay(1);
+	val |= XUSBIO_PLL_CFG0_SEQ_ENABLE;
+	pll_writel(val, XUSBIO_PLL_CFG0, pll);
 
 out:
 	if (pll->lock)
-- 
1.9.1.423.g4596e3a

