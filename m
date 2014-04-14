Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaDNHzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:55:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48873 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaDNHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:55:37 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c2-534b9476acee
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 resend] clk: s2mps11: Add support for S2MPS14 clocks
Date: Mon, 14 Apr 2014 09:55:22 +0200
Message-id: <1397462122-24447-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397462122-24447-1-git-send-email-k.kozlowski@samsung.com>
References: <1397462122-24447-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xq7plU7yDDVoncltsnLGe1eL1C0OL
	s01v2C0u75rDZjHj/D4mi7VH7rJbPJ1wkc1i/YzXLA4cHneu7WHz6NuyitHj8ya5AOYoLpuU
	1JzMstQifbsErowT01YzFmzRr3iwvo2pgXGjWhcjJ4eEgInE/a+b2SFsMYkL99azdTFycQgJ
	LGWUWPpmDzuE08ck8XDva1aQKjYBY4nNy5ewgdgiArkS8xtXgdnMAs8ZJZ5+DwexhQXcJRqX
	zwWrZxFQlbjffwFsAy9Q/MuKh0wQ2xQkln1Zywxicwp4SNw9dBMsLgRUc/bebaYJjLwLGBlW
	MYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE0pcdjIuPWR1iFOBgVOLhTdjuGSzEmlhWXJl7
	iFGCg1lJhHdbhlewEG9KYmVValF+fFFpTmrxIUYmDk6pBsbyezdyzGz3v7dQED2x45GbLY+D
	yQxW7uMBV3a6XVxyZnPIRG1rf+d8ro7pTFk9N2aGmKTor74TfOHONtU/Wznv6nj8lwR64Ome
	3RwvpP4v1osM/slyS9TJe/8Zrr9lbZPO9srXu/I8jar+zOnft27n0/gb51Mjm4yUDrWG9fX/
	e8L5g+lbuxJLcUaioRZzUXEiAIv7q84DAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
s2mps11 clock driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/Kconfig       |  8 +++----
 drivers/clk/clk-s2mps11.c | 61 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 19 deletions(-)

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
index f2f62a1bf61a..b78eafeab038 100644
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
 
@@ -125,7 +122,21 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
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
@@ -145,9 +156,12 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 	if (!clk_table)
 		return ERR_PTR(-ENOMEM);
 
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
@@ -158,6 +172,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
 	struct device_node *clk_np = NULL;
 	unsigned int s2mps11_reg;
+	struct clk_init_data *clks_init;
 	int i, ret = 0;
 	u32 val;
 
@@ -168,25 +183,33 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 	s2mps11_clk = s2mps11_clks;
 
-	clk_np = s2mps11_clk_parse_dt(pdev);
-	if (IS_ERR(clk_np))
-		return PTR_ERR(clk_np);
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
 
+	clk_np = s2mps11_clk_parse_dt(pdev, clks_init);
+	if (IS_ERR(clk_np))
+		return PTR_ERR(clk_np);
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
 	}
 
 	if (clk_table) {
-		for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+		for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+			/* Skip clocks not present on S2MPS14 */
+			if (!clks_init[i].name)
+				continue;
 			clk_table[i] = s2mps11_clks[i].clk;
+		}
 
 		clk_data.clks = clk_table;
 		clk_data.clk_num = S2MPS11_CLKS_NUM;
@@ -250,14 +277,18 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 	struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		if (!s2mps11_clks[i].lookup)
+			continue; /* Skip clocks not present in some devices */
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
1.8.3.2

