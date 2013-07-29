Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3G2RBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:01:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab3G2RBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:01:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 6/6] mfd: da9063: add 32 kHz output clock to clock tree
Date: Mon, 29 Jul 2013 19:00:47 +0200
Message-Id: <1375117247-6376-7-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/mfd/da9063-core.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index c9cf8d9..adcdc50 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/clk-provider.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -107,10 +108,68 @@ static struct mfd_cell da9063_devs[] = {
 	},
 };
 
+struct da9063_out_32k_clk {
+	struct clk_hw clk_hw;
+	struct regmap *regmap;
+};
+
+static int da9063_out_32k_prepare(struct clk_hw *hw)
+{
+	struct da9063_out_32k_clk *out_32k =
+			container_of(hw, struct da9063_out_32k_clk, clk_hw);
+
+	return regmap_update_bits(out_32k->regmap, DA9063_REG_EN_32K,
+				  DA9063_OUT_32K_EN, DA9063_OUT_32K_EN);
+}
+
+static void da9063_out_32k_unprepare(struct clk_hw *hw)
+{
+	struct da9063_out_32k_clk *out_32k =
+			container_of(hw, struct da9063_out_32k_clk, clk_hw);
+
+	regmap_update_bits(out_32k->regmap, DA9063_REG_EN_32K,
+			   DA9063_OUT_32K_EN, 0);
+}
+
+static int da9063_out_32k_is_prepared(struct clk_hw *hw)
+{
+	struct da9063_out_32k_clk *out_32k =
+			container_of(hw, struct da9063_out_32k_clk, clk_hw);
+	int val;
+
+	regmap_read(out_32k->regmap, DA9063_REG_EN_32K, &val);
+
+	return val & DA9063_OUT_32K_EN;
+}
+
+static unsigned long da9063_out_32k_recalc_rate(struct clk_hw *hw,
+						unsigned long parent_rate)
+{
+	return 32000;
+}
+
+static long da9063_out_32k_round_rate(struct clk_hw *hw,
+				      unsigned long rate,
+				      unsigned long *prate)
+{
+	return 32000;
+}
+
+static const struct clk_ops da9063_out_32k_ops = {
+	.prepare = da9063_out_32k_prepare,
+	.unprepare = da9063_out_32k_unprepare,
+	.is_prepared = da9063_out_32k_is_prepared,
+	.recalc_rate = da9063_out_32k_recalc_rate,
+	.round_rate = da9063_out_32k_round_rate,
+};
+
 int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 {
 	struct da9063_pdata *pdata = da9063->dev->platform_data;
+	struct da9063_out_32k_clk *out_32k;
+	struct clk_init_data init;
 	int model, revision;
+	struct clk *clk;
 	int ret;
 
 	if (pdata) {
@@ -165,6 +224,23 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		return ret;
 	}
 
+	out_32k = devm_kzalloc(da9063->dev, sizeof(*out_32k), GFP_KERNEL);
+	if (!out_32k)
+		return -ENOMEM;
+
+	init.name = "da9063_out_32k";
+	init.ops = &da9063_out_32k_ops;
+	init.flags = CLK_IS_BASIC | CLK_IS_ROOT;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+
+	out_32k->clk_hw.init = &init;
+	out_32k->regmap = da9063->regmap;
+
+	clk = devm_clk_register(da9063->dev, &out_32k->clk_hw);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	ret = mfd_add_devices(da9063->dev, -1, da9063_devs,
 			      ARRAY_SIZE(da9063_devs), NULL, da9063->irq_base,
 			      NULL);
-- 
1.8.3.2

