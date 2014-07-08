Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaGHHax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:30:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13779 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaGHHav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:30:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jul 2014 00:20:07 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <abrestic@chromium.org>, <pdeschrijver@nvidia.com>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <tj@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] clk: tegra: Use XUSB-compatible SATA PLL sequence
Date: Tue, 8 Jul 2014 10:30:15 +0300
Message-ID: <1404804615-23587-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <CAL1qeaHo_HEoXoCQjQuqux_BNPtz4BtOnrYTa4=vcNQCYxiDSg@mail.gmail.com>
References: <CAL1qeaHo_HEoXoCQjQuqux_BNPtz4BtOnrYTa4=vcNQCYxiDSg@mail.gmail.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a sequence for enabling hardware control of the SATA PLL
that works both when using the SATA lane with SATA and when
using it with XUSB.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
Andrew: yes, it does :)
Peter: Feel free to squash if that works for you.

 drivers/clk/tegra/clk-pll.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index f070c36..c7c6d8f 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -112,6 +112,9 @@
 
 #define SATA_PLL_CFG0		0x490
 #define SATA_PLL_CFG0_PADPLL_RESET_SWCTL	BIT(0)
+#define SATA_PLL_CFG0_PADPLL_USE_LOCKDET	BIT(2)
+#define SATA_PLL_CFG0_SEQ_ENABLE		BIT(24)
+#define SATA_PLL_CFG0_SEQ_START_STATE		BIT(25)
 
 #define PLLE_MISC_PLLE_PTS	BIT(8)
 #define PLLE_MISC_IDDQ_SW_VALUE	BIT(13)
@@ -1367,6 +1370,14 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	/* Enable hw control of SATA pll */
 	val = pll_readl(SATA_PLL_CFG0, pll);
 	val &= ~SATA_PLL_CFG0_PADPLL_RESET_SWCTL;
+	val |= SATA_PLL_CFG0_PADPLL_USE_LOCKDET;
+	val |= SATA_PLL_CFG0_SEQ_START_STATE;
+	pll_writel(val, SATA_PLL_CFG0, pll);
+
+	udelay(1);
+
+	val = pll_readl(SATA_PLL_CFG0, pll);
+	val |= SATA_PLL_CFG0_SEQ_ENABLE;
 	pll_writel(val, SATA_PLL_CFG0, pll);
 
 out:
-- 
1.8.1.5

