Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaEOReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:34:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53951 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbaEORcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:54 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-2f-5374fa4392cd
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH RFC 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
Date: Thu, 15 May 2014 19:32:30 +0200
Message-id: <1400175151-27779-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xq7rOv0qCDY7dZ7GY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	Yv2M1ywWq3b9YbRo/7uXzYHfY828NYweO2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wA
	exSXTUpqTmZZapG+XQJXxsHjv9gLNmhXzP54kqmBca5KFyMHh4SAicTxF+xdjJxAppjEhXvr
	2boYuTiEBJYySszdsBwsISTQxyTxeq40iM0moCbxueERG4gtIqAq8bltATtIA7PANBaJVcva
	wRqEBSIlnjU3ghWxABUtaXoKZvMKOEl03F/EBrFNTuL/yxVMIDangLPExyVT2CCWOUnc3dvB
	NoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLD9soNx8TGrQ4wCHIxKPLwd+4uD
	hVgTy4orcw8xSnAwK4nwmj8vCRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAqPaV6YGjC++OtV1m
	dRUSF9ZkxK76myT4qcnWj4Nzd8+8E/VuL1oyqm7zzbuTGJWf/+e/ad3MzOku0ZaBi+MdN8Ur
	uorsEdr9Jp3PoDT9rdlbI+n7C5j3Fss2ZCkWODOJpr6fM7FvYpbgiZNuLOHux7p+hsbsjp5d
	coVDKGGThUPd/hNLN71WYinOSDTUYi4qTgQAIHqPrjkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a driver that handles configuration of CLKOUT pin
of Exynos SoCs that can be used to output certain clocks from inside of
the SoC to a dedicated output pin.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 .../devicetree/bindings/arm/samsung/pmu.txt        |  18 ++++
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/exynos-clkout.c                | 107 +++++++++++++++++++++
 3 files changed, 126 insertions(+)
 create mode 100644 drivers/clk/samsung/exynos-clkout.c

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index b562634..67c7272 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -11,8 +11,26 @@ Properties:
 
  - reg : offset and length of the register set.
 
+ - #clock-cells : must be zero.
+
+ - clock-names : list of clock names for particular CLKOUT mux inputs in
+		following format:
+			"clkoutN", where N is a decimal number corresponding to
+			CLKOUT mux control bits value for given input, e.g.
+				"clkout0", "clkout7", "clkout15".
+
+ - clocks : list of phandles and specifiers to all input clocks listed in
+		clock-names property.
+
 Example :
 pmu_system_controller: system-controller@10040000 {
 	compatible = "samsung,exynos5250-pmu", "syscon";
 	reg = <0x10040000 0x5000>;
+	#clock-cells = <0>;
+	clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
+			"clkout4", "clkout8", "clkout9";
+	clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
+		<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
+		<&clock CLK_OUT_CPU>, <&clock CLK_XXTI>,
+		<&clock CLK_XUSBXTI>;
 };
diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 2cb62f8..3c40362 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
 obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
 obj-$(CONFIG_SOC_EXYNOS5440)	+= clk-exynos5440.o
 obj-$(CONFIG_ARCH_EXYNOS)	+= clk-exynos-audss.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos-clkout.o
 obj-$(CONFIG_S3C2410_COMMON_CLK)+= clk-s3c2410.o
 obj-$(CONFIG_S3C2410_COMMON_DCLK)+= clk-s3c2410-dclk.o
 obj-$(CONFIG_S3C2412_COMMON_CLK)+= clk-s3c2412.o
diff --git a/drivers/clk/samsung/exynos-clkout.c b/drivers/clk/samsung/exynos-clkout.c
new file mode 100644
index 0000000..461f1c3
--- /dev/null
+++ b/drivers/clk/samsung/exynos-clkout.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Figa <t.figa@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Clock driver for Exynos clock output
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/syscore_ops.h>
+
+#define EXYNOS_CLKOUT_PARENTS		32
+
+#define EXYNOS_PMU_DEBUG_REG		0xa00
+#define EXYNOS_CLKOUT_DISABLE_SHIFT	0
+#define EXYNOS_CLKOUT_MUX_SHIFT		8
+#define EXYNOS_CLKOUT_MUX_MASK		0x1f
+
+static DEFINE_SPINLOCK(clkout_lock);
+
+static void __init exynos_clkout_init(struct device_node *node)
+{
+	const char *parent_names[EXYNOS_CLKOUT_PARENTS];
+	struct clk *parents[EXYNOS_CLKOUT_PARENTS];
+	struct clk_gate *gate;
+	struct clk_mux *mux;
+	int parent_count;
+	struct clk *clk;
+	void *reg;
+	int i;
+
+	/* allocate mux and gate clock structs */
+	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
+	if (!mux)
+		return;
+
+	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
+	if (!gate)
+		goto free_mux;
+
+	parent_count = 0;
+	for (i = 0; i < EXYNOS_CLKOUT_PARENTS; ++i) {
+		char name[] = "clkoutXX";
+
+		snprintf(name, sizeof(name), "clkout%d", i);
+		parents[i] = of_clk_get_by_name(node, name);
+		if (IS_ERR(parents[i])) {
+			parent_names[i] = "none";
+			continue;
+		}
+
+		parent_names[i] = __clk_get_name(parents[i]);
+		parent_count = i + 1;
+	}
+
+	if (!parent_count)
+		goto free_gate;
+
+	reg = of_iomap(node, 0);
+	if (!reg)
+		goto clks_put;
+
+	gate->reg = reg + EXYNOS_PMU_DEBUG_REG;
+	gate->bit_idx = EXYNOS_CLKOUT_DISABLE_SHIFT;
+	gate->flags = CLK_GATE_SET_TO_DISABLE;
+	gate->lock = &clkout_lock;
+
+	mux->reg = reg + EXYNOS_PMU_DEBUG_REG;
+	mux->mask = EXYNOS_CLKOUT_MUX_MASK;
+	mux->shift = EXYNOS_CLKOUT_MUX_SHIFT;
+	mux->lock = &clkout_lock;
+
+	clk = clk_register_composite(NULL, "clkout", parent_names,
+					parent_count, &mux->hw,
+					&clk_mux_ops, NULL, NULL, &gate->hw,
+					&clk_gate_ops, 0);
+	if (IS_ERR(clk))
+		goto err_unmap;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return;
+
+err_unmap:
+	iounmap(reg);
+clks_put:
+	for (i = 0; i < EXYNOS_CLKOUT_PARENTS; ++i)
+		if (!IS_ERR(parents[i]))
+			clk_put(parents[i]);
+free_gate:
+	kfree(gate);
+free_mux:
+	kfree(mux);
+
+	pr_err("%s: failed to register clkout clock\n", __func__);
+}
+CLK_OF_DECLARE(exynos4210_clkout, "samsung,exynos4210-pmu", exynos_clkout_init);
+CLK_OF_DECLARE(exynos4412_clkout, "samsung,exynos4x12-pmu", exynos_clkout_init);
+CLK_OF_DECLARE(exynos5250_clkout, "samsung,exynos5250-pmu", exynos_clkout_init);
+CLK_OF_DECLARE(exynos5420_clkout, "samsung,exynos5420-pmu", exynos_clkout_init);
-- 
1.9.2

