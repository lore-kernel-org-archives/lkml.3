Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaEULXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:23:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19048 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEULXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:23:15 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-01-537c8ca07a13
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 3/3] clk: s2mps11: Add support for S2MPS14 clocks
Date: Wed, 21 May 2014 13:23:01 +0200
Message-id: <1400671381-14792-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
References: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xa7oLe2qCDWa5WGycsZ7V4vULQ4uz
	TW/YLe5/PcpocXnXHDaLGef3MVmsPXKX3eLphItsFutnvGZx4PS4c20Pm0ffllWMHp83yQUw
	R3HZpKTmZJalFunbJXBlzP79nKngq2HFp//vGRsYb2h0MXJySAiYSPxZtIwNwhaTuHBvPZDN
	xSEksJRR4vPLD+wQTh+TxN3PK1hAqtgEjCU2L18C1iEikCsxv3EVWAezQDeTxOWOXUwgCWEB
	F4nr86axg9gsAqoSh5sbwGxeAXeJLZv3MkKsk5M4eWwyK4jNKeAh8at5HZgtBFTTcGA+4wRG
	3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoLqyw7GxcesDjEKcDAq8fAKXK0OFmJN
	LCuuzD3EKMHBrCTCe6yiJliINyWxsiq1KD++qDQntfgQIxMHp1QDo7TZ5icuvQ9Cd5xQXXU3
	+LNpwf6e3HkVdh1vJM/Ha/y/kO28a2XTpNzkvMvf3+TLBL6cn/OgtuX6Zs0J4REbbl/W3/r/
	7Qnj10s+GlWpmEsI3U6PaltTXPdnY9iqE8XdJ+L/v9Zd/Vx1Bb97VIfzNQuj/wfd7G9cd800
	PWYqkz13k0NF7iUtTyWW4oxEQy3mouJEAHxB/dIIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
s2mps11 clock driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig       |  8 +++---
 drivers/clk/clk-s2mps11.c | 64 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6f56d3a4f010..8f9ce8ba036d 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -65,12 +65,12 @@ config COMMON_CLK_SI570
 	  clock generators.
 
 config COMMON_CLK_S2MPS11
-	tristate "Clock driver for S2MPS11/S5M8767 MFD"
+	tristate "Clock driver for S2MPS1X/S5M8767 MFD"
 	depends on MFD_SEC_CORE
 	---help---
-	  This driver supports S2MPS11/S5M8767 crystal oscillator clock. These
-	  multi-function devices have 3 fixed-rate oscillators, clocked at
-	  32KHz each.
+	  This driver supports S2MPS11/S2MPS14/S5M8767 crystal oscillator
+	  clock. These multi-function devices have two (S2MPS14) or three
+	  (S2MPS11, S5M8767) fixed-rate oscillators, clocked at 32KHz each.
 
 config CLK_TWL6040
 	tristate "External McPDM functional clock from twl6040"
diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 23ffd89c4023..9b7b5859a420 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -1,7 +1,7 @@
 /*
  * clk-s2mps11.c - Clock driver for S2MPS11.
  *
- * Copyright (C) 2013 Samsung Electornics
+ * Copyright (C) 2013,2014 Samsung Electornics
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 #include <linux/module.h>
@@ -27,6 +23,7 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/mfd/samsung/core.h>
 
@@ -126,7 +123,21 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
 	},
 };
 
-static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
+static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
+	[S2MPS11_CLK_AP] = {
+		.name = "s2mps14_ap",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_BT] = {
+		.name = "s2mps14_bt",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
+static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev,
+		struct clk_init_data *clks_init)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *clk_np;
@@ -141,9 +152,12 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		if (!clks_init[i].name)
+			continue; /* Skip clocks not present in some devices */
 		of_property_read_string_index(clk_np, "clock-output-names", i,
-				&s2mps11_clks_init[i].name);
+				&clks_init[i].name);
+	}
 
 	return clk_np;
 }
@@ -153,6 +167,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
 	unsigned int s2mps11_reg;
+	struct clk_init_data *clks_init;
 	int i, ret = 0;
 	u32 val;
 
@@ -168,26 +183,34 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	if (!clk_table)
 		return -ENOMEM;
 
-	/* Store clocks of_node in first element of s2mps11_clks array */
-	s2mps11_clks->clk_np = s2mps11_clk_parse_dt(pdev);
-	if (IS_ERR(s2mps11_clks->clk_np))
-		return PTR_ERR(s2mps11_clks->clk_np);
-
 	switch(platform_get_device_id(pdev)->driver_data) {
 	case S2MPS11X:
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
+		clks_init = s2mps11_clks_init;
+		break;
+	case S2MPS14X:
+		s2mps11_reg = S2MPS14_REG_RTCCTRL;
+		clks_init = s2mps14_clks_init;
 		break;
 	case S5M8767X:
 		s2mps11_reg = S5M8767_REG_CTRL1;
+		clks_init = s2mps11_clks_init;
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device type\n");
 		return -EINVAL;
 	};
 
+	/* Store clocks of_node in first element of s2mps11_clks array */
+	s2mps11_clks->clk_np = s2mps11_clk_parse_dt(pdev, clks_init);
+	if (IS_ERR(s2mps11_clks->clk_np))
+		return PTR_ERR(s2mps11_clks->clk_np);
+
 	for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
+		if (!clks_init[i].name)
+			continue; /* Skip clocks not present in some devices */
 		s2mps11_clk->iodev = iodev;
-		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
+		s2mps11_clk->hw.init = &clks_init[i];
 		s2mps11_clk->mask = 1 << i;
 		s2mps11_clk->reg = s2mps11_reg;
 
@@ -220,8 +243,12 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clkdev_add(s2mps11_clk->lookup);
 	}
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		/* Skip clocks not present on S2MPS14 */
+		if (!clks_init[i].name)
+			continue;
 		clk_table[i] = s2mps11_clks[i].clk;
+	}
 
 	clk_data.clks = clk_table;
 	clk_data.clk_num = S2MPS11_CLKS_NUM;
@@ -254,14 +281,19 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 	/* Drop the reference obtained in s2mps11_clk_parse_dt */
 	of_node_put(s2mps11_clks[0].clk_np);
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		/* Skip clocks not present on S2MPS14 */
+		if (!s2mps11_clks[i].lookup)
+			continue;
 		clkdev_drop(s2mps11_clks[i].lookup);
+	}
 
 	return 0;
 }
 
 static const struct platform_device_id s2mps11_clk_id[] = {
 	{ "s2mps11-clk", S2MPS11X},
+	{ "s2mps14-clk", S2MPS14X},
 	{ "s5m8767-clk", S5M8767X},
 	{ },
 };
-- 
1.9.1

