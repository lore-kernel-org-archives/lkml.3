Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaBQKDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:03:54 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:59783 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaBQKDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:03:50 -0500
Subject: [PATCH v7 2/8] clk: sunxi: Implement MMC phase control
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?utf-8?b?TMOzcGV6?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Mon, 17 Feb 2014 11:02:21 +0100
Message-ID: <20140217100221.15040.47203.stgit@pagira.o2s.ch>
In-Reply-To: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/clk/sunxi/clk-sunxi.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index abb6c5a..33b9977 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -377,6 +377,41 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32 parent_rate,
 
 
 /**
+ * clk_sunxi_mmc_phase_control() - configures MMC clock phase control
+ */
+
+void clk_sunxi_mmc_phase_control(struct clk_hw *hw, u8 sample, u8 output)
+{
+	#define to_clk_composite(_hw) container_of(_hw, struct clk_composite, hw)
+	#define to_clk_factors(_hw) container_of(_hw, struct clk_factors, hw)
+
+	struct clk_composite *composite = to_clk_composite(hw);
+	struct clk_hw *rate_hw = composite->rate_hw;
+	struct clk_factors *factors = to_clk_factors(rate_hw);
+	unsigned long flags = 0;
+	u32 reg;
+
+	if (factors->lock)
+		spin_lock_irqsave(factors->lock, flags);
+
+	reg = readl(factors->reg);
+
+	/* set sample clock phase control */
+	reg &= ~(0x7 << 20);
+	reg |= ((sample & 0x7) << 20);
+
+	/* set output clock phase control */
+	reg &= ~(0x7 << 8);
+	reg |= ((output & 0x7) << 8);
+
+	writel(reg, factors->reg);
+
+	if (factors->lock)
+		spin_unlock_irqrestore(factors->lock, flags);
+}
+
+
+/**
  * sunxi_factors_clk_setup() - Setup function for factor clocks
  */
 

