Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbaGDRxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:53:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759411AbaGDRtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:02 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-2a-53b6e909dbfc
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 06/19] clk: samsung: Add S5PV210 Audio Subsystem clock driver
Date: Fri, 04 Jul 2014 19:48:06 +0200
Message-id: <1404496099-26708-7-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7qcL7cFG2z8w2bxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CV8XDhQ7aC
	/viKj2/7GRsYG/y7GDk5JARMJE7cucQCYYtJXLi3nq2LkYtDSGApo0TP+kXMEE4fk8Sev+sY
	QarYBNQkPjc8YgOxRQRUJT63LWDvYuTgYBa4zSTRKgwSFhbwlVi94yBYOQtQSefvqawgNq+A
	k8TeO9fZIJbJSfRue8MMYnMKOEtMXHeBCcQWAqr5838+ywRG3gWMDKsYRVNLkwuKk9JzDfWK
	E3OLS/PS9ZLzczcxQsLxyw7GxcesDjEKcDAq8fA2rtgQLMSaWFZcmXuIUYKDWUmE98+qbcFC
	vCmJlVWpRfnxRaU5qcWHGJk4OKUaGLtzk6c5L5cI12GuNRdsE8lOOtR87IbpnAhz847coyuN
	tJWKz5+YaH/4AVf9FYuNpxdlzZ7iJhSkvV/1eYjMlxPPxC4ZHDjvYfOwY8ahQyGcF/vcNNas
	4Lb0vN/Yoz3HzDGp4WfJE42Zy3Vd7M5LqKg/+rTfcMf7B0X+6QtNZG2XvzfY+qFBUYmlOCPR
	UIu5qDgRABhU1MIlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for clock controller being a part of Audio
Subsystem present on S5PV210 and compatible SoCs. It is used to provide
clocks for other IP blocks of this subsystem.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
---
 .../bindings/clock/clk-s5pv210-audss.txt           |  53 +++++
 drivers/clk/samsung/Makefile                       |   2 +-
 drivers/clk/samsung/clk-s5pv210-audss.c            | 241 +++++++++++++++++++++
 include/dt-bindings/clock/s5pv210-audss.h          |  34 +++
 4 files changed, 329 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210-audss.c
 create mode 100644 include/dt-bindings/clock/s5pv210-audss.h

diff --git a/Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt b/Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt
new file mode 100644
index 0000000..4fc869b
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-s5pv210-audss.txt
@@ -0,0 +1,53 @@
+* Samsung Audio Subsystem Clock Controller
+
+The Samsung Audio Subsystem clock controller generates and supplies clocks
+to Audio Subsystem block available in the S5PV210 and compatible SoCs.
+
+Required Properties:
+
+- compatible: should be "samsung,s5pv210-audss-clock".
+- reg: physical base address and length of the controller's register set.
+
+- #clock-cells: should be 1.
+
+- clocks:
+  - hclk: AHB bus clock of the Audio Subsystem.
+  - xxti: Optional fixed rate PLL reference clock, parent of mout_audss. If
+    not specified (i.e. xusbxti is used for PLL reference), it is fixed to
+    a clock named "xxti".
+  - fout_epll: Input PLL to the AudioSS block, parent of mout_audss.
+  - iiscdclk0: Optional external i2s clock, parent of mout_i2s. If not
+    specified, it is fixed to a clock named "iiscdclk0".
+  - sclk_audio0: Audio bus clock, parent of mout_i2s.
+
+- clock-names: Aliases for the above clocks. They should be "hclk",
+  "xxti", "fout_epll", "iiscdclk0", and "sclk_audio0" respectively.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/s5pv210-audss-clk.h header and can be used in device
+tree sources.
+
+Example: Clock controller node.
+
+	clk_audss: clock-controller@c0900000 {
+		compatible = "samsung,s5pv210-audss-clock";
+		reg = <0xc0900000 0x1000>;
+		#clock-cells = <1>;
+		clock-names = "hclk", "xxti",
+				"fout_epll", "sclk_audio0";
+		clocks = <&clocks DOUT_HCLKP>, <&xxti>,
+				<&clocks FOUT_EPLL>, <&clocks SCLK_AUDIO0>;
+	};
+
+Example: I2S controller node that consumes the clock generated by the clock
+	 controller. Refer to the standard clock bindings for information
+         about 'clocks' and 'clock-names' property.
+
+	i2s0: i2s@03830000 {
+		/* ... */
+		clock-names = "iis", "i2s_opclk0",
+				"i2s_opclk1";
+		clocks = <&clk_audss CLK_I2S>, <&clk_audss CLK_I2S>,
+				<&clk_audss CLK_DOUT_AUD_BUS>;
+		/* ... */
+	};
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 49d6ce1..9f256a4 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -16,4 +16,4 @@ obj-$(CONFIG_S3C2410_COMMON_DCLK)+= clk-s3c2410-dclk.o
 obj-$(CONFIG_S3C2412_COMMON_CLK)+= clk-s3c2412.o
 obj-$(CONFIG_S3C2443_COMMON_CLK)+= clk-s3c2443.o
 obj-$(CONFIG_ARCH_S3C64XX)	+= clk-s3c64xx.o
-obj-$(CONFIG_ARCH_S5PV210)	+= clk-s5pv210.o
+obj-$(CONFIG_ARCH_S5PV210)	+= clk-s5pv210.o clk-s5pv210-audss.o
diff --git a/drivers/clk/samsung/clk-s5pv210-audss.c b/drivers/clk/samsung/clk-s5pv210-audss.c
new file mode 100644
index 0000000..a8053b4
--- /dev/null
+++ b/drivers/clk/samsung/clk-s5pv210-audss.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (c) 2014 Tomasz Figa <t.figa@samsung.com>
+ *
+ * Based on Exynos Audio Subsystem Clock Controller driver:
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * Author: Padmavathi Venna <padma.v@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Driver for Audio Subsystem Clock Controller of S5PV210-compatible SoCs.
+*/
+
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+#include <linux/syscore_ops.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <dt-bindings/clock/s5pv210-audss.h>
+
+static DEFINE_SPINLOCK(lock);
+static struct clk **clk_table;
+static void __iomem *reg_base;
+static struct clk_onecell_data clk_data;
+
+#define ASS_CLK_SRC 0x0
+#define ASS_CLK_DIV 0x4
+#define ASS_CLK_GATE 0x8
+
+#ifdef CONFIG_PM_SLEEP
+static unsigned long reg_save[][2] = {
+	{ASS_CLK_SRC,  0},
+	{ASS_CLK_DIV,  0},
+	{ASS_CLK_GATE, 0},
+};
+
+static int s5pv210_audss_clk_suspend(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(reg_save); i++)
+		reg_save[i][1] = readl(reg_base + reg_save[i][0]);
+
+	return 0;
+}
+
+static void s5pv210_audss_clk_resume(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(reg_save); i++)
+		writel(reg_save[i][1], reg_base + reg_save[i][0]);
+}
+
+static struct syscore_ops s5pv210_audss_clk_syscore_ops = {
+	.suspend	= s5pv210_audss_clk_suspend,
+	.resume		= s5pv210_audss_clk_resume,
+};
+#endif /* CONFIG_PM_SLEEP */
+
+/* register s5pv210_audss clocks */
+static int s5pv210_audss_clk_probe(struct platform_device *pdev)
+{
+	int i, ret = 0;
+	struct resource *res;
+	const char *mout_audss_p[2];
+	const char *mout_i2s_p[3];
+	const char *hclk_p;
+	struct clk *hclk, *pll_ref, *pll_in, *cdclk, *sclk_audio;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(reg_base)) {
+		dev_err(&pdev->dev, "failed to map audss registers\n");
+		return PTR_ERR(reg_base);
+	}
+
+	clk_table = devm_kzalloc(&pdev->dev,
+				sizeof(struct clk *) * AUDSS_MAX_CLKS,
+				GFP_KERNEL);
+	if (!clk_table)
+		return -ENOMEM;
+
+	clk_data.clks = clk_table;
+	clk_data.clk_num = AUDSS_MAX_CLKS;
+
+	hclk = devm_clk_get(&pdev->dev, "hclk");
+	if (IS_ERR(hclk)) {
+		dev_err(&pdev->dev, "failed to get hclk clock\n");
+		return PTR_ERR(hclk);
+	}
+
+	pll_in = devm_clk_get(&pdev->dev, "fout_epll");
+	if (IS_ERR(pll_in)) {
+		dev_err(&pdev->dev, "failed to get fout_epll clock\n");
+		return PTR_ERR(pll_in);
+	}
+
+	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio0");
+	if (IS_ERR(sclk_audio)) {
+		dev_err(&pdev->dev, "failed to get sclk_audio0 clock\n");
+		return PTR_ERR(sclk_audio);
+	}
+
+	/* iiscdclk0 is an optional external I2S codec clock */
+	cdclk = devm_clk_get(&pdev->dev, "iiscdclk0");
+	pll_ref = devm_clk_get(&pdev->dev, "xxti");
+
+	if (!IS_ERR(pll_ref))
+		mout_audss_p[0] = __clk_get_name(pll_ref);
+	else
+		mout_audss_p[0] = "xxti";
+	mout_audss_p[1] = __clk_get_name(pll_in);
+	clk_table[CLK_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
+				mout_audss_p, ARRAY_SIZE(mout_audss_p),
+				CLK_SET_RATE_NO_REPARENT,
+				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
+
+	mout_i2s_p[0] = "mout_audss";
+	if (!IS_ERR(cdclk))
+		mout_i2s_p[1] = __clk_get_name(cdclk);
+	else
+		mout_i2s_p[1] = "iiscdclk0";
+	mout_i2s_p[2] = __clk_get_name(sclk_audio);
+	clk_table[CLK_MOUT_I2S_A] = clk_register_mux(NULL, "mout_i2s_audss",
+				mout_i2s_p, ARRAY_SIZE(mout_i2s_p),
+				CLK_SET_RATE_NO_REPARENT,
+				reg_base + ASS_CLK_SRC, 2, 2, 0, &lock);
+
+	clk_table[CLK_DOUT_AUD_BUS] = clk_register_divider(NULL,
+				"dout_aud_bus", "mout_audss", 0,
+				reg_base + ASS_CLK_DIV, 0, 4, 0, &lock);
+	clk_table[CLK_DOUT_I2S_A] = clk_register_divider(NULL, "dout_i2s_audss",
+				"mout_i2s_audss", 0, reg_base + ASS_CLK_DIV,
+				4, 4, 0, &lock);
+
+	clk_table[CLK_I2S] = clk_register_gate(NULL, "i2s_audss",
+				"dout_i2s_audss", CLK_SET_RATE_PARENT,
+				reg_base + ASS_CLK_GATE, 6, 0, &lock);
+
+	hclk_p = __clk_get_name(hclk);
+
+	clk_table[CLK_HCLK_I2S] = clk_register_gate(NULL, "hclk_i2s_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 5, 0, &lock);
+	clk_table[CLK_HCLK_UART] = clk_register_gate(NULL, "hclk_uart_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 4, 0, &lock);
+	clk_table[CLK_HCLK_HWA] = clk_register_gate(NULL, "hclk_hwa_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 3, 0, &lock);
+	clk_table[CLK_HCLK_DMA] = clk_register_gate(NULL, "hclk_dma_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 2, 0, &lock);
+	clk_table[CLK_HCLK_BUF] = clk_register_gate(NULL, "hclk_buf_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 1, 0, &lock);
+	clk_table[CLK_HCLK_RP] = clk_register_gate(NULL, "hclk_rp_audss",
+				hclk_p, CLK_IGNORE_UNUSED,
+				reg_base + ASS_CLK_GATE, 0, 0, &lock);
+
+	for (i = 0; i < clk_data.clk_num; i++) {
+		if (IS_ERR(clk_table[i])) {
+			dev_err(&pdev->dev, "failed to register clock %d\n", i);
+			ret = PTR_ERR(clk_table[i]);
+			goto unregister;
+		}
+	}
+
+	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
+					&clk_data);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add clock provider\n");
+		goto unregister;
+	}
+
+#ifdef CONFIG_PM_SLEEP
+	register_syscore_ops(&s5pv210_audss_clk_syscore_ops);
+#endif
+
+	return 0;
+
+unregister:
+	for (i = 0; i < clk_data.clk_num; i++) {
+		if (!IS_ERR(clk_table[i]))
+			clk_unregister(clk_table[i]);
+	}
+
+	return ret;
+}
+
+static int s5pv210_audss_clk_remove(struct platform_device *pdev)
+{
+	int i;
+
+	of_clk_del_provider(pdev->dev.of_node);
+
+	for (i = 0; i < clk_data.clk_num; i++) {
+		if (!IS_ERR(clk_table[i]))
+			clk_unregister(clk_table[i]);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id s5pv210_audss_clk_of_match[] = {
+	{ .compatible = "samsung,s5pv210-audss-clock", },
+	{},
+};
+
+static struct platform_driver s5pv210_audss_clk_driver = {
+	.driver	= {
+		.name = "s5pv210-audss-clk",
+		.owner = THIS_MODULE,
+		.of_match_table = s5pv210_audss_clk_of_match,
+	},
+	.probe = s5pv210_audss_clk_probe,
+	.remove = s5pv210_audss_clk_remove,
+};
+
+static int __init s5pv210_audss_clk_init(void)
+{
+	return platform_driver_register(&s5pv210_audss_clk_driver);
+}
+core_initcall(s5pv210_audss_clk_init);
+
+static void __exit s5pv210_audss_clk_exit(void)
+{
+	platform_driver_unregister(&s5pv210_audss_clk_driver);
+}
+module_exit(s5pv210_audss_clk_exit);
+
+MODULE_AUTHOR("Tomasz Figa <t.figa@samsung.com>");
+MODULE_DESCRIPTION("S5PV210 Audio Subsystem Clock Controller");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:s5pv210-audss-clk");
diff --git a/include/dt-bindings/clock/s5pv210-audss.h b/include/dt-bindings/clock/s5pv210-audss.h
new file mode 100644
index 0000000..fe57406
--- /dev/null
+++ b/include/dt-bindings/clock/s5pv210-audss.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2014 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This header provides constants for Samsung audio subsystem
+ * clock controller.
+ *
+ * The constants defined in this header are being used in dts
+ * and s5pv210 audss driver.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_S5PV210_AUDSS_H
+#define _DT_BINDINGS_CLOCK_S5PV210_AUDSS_H
+
+#define CLK_MOUT_AUDSS		0
+#define CLK_MOUT_I2S_A		1
+
+#define CLK_DOUT_AUD_BUS	2
+#define CLK_DOUT_I2S_A		3
+
+#define CLK_I2S			4
+#define CLK_HCLK_I2S		5
+#define CLK_HCLK_UART		6
+#define CLK_HCLK_HWA		7
+#define CLK_HCLK_DMA		8
+#define CLK_HCLK_BUF		9
+#define CLK_HCLK_RP		10
+
+#define AUDSS_MAX_CLKS		11
+
+#endif
-- 
1.9.3

