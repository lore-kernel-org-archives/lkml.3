Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaLWKtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:49:46 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61112 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaLWKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-80-54994890219f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 5/8] ARM: l2c: Add support for overriding prefetch settings
Date: Tue, 23 Dec 2014 11:48:33 +0100
Message-id: <1419331716-8972-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xa7oTPGaGGNxdq2bxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJVx8XQ7c8EWhYqDc24zNTBekepi5OSQEDCROHT+EjOELSZx4d56NhBbSGAp
	o8TLp5ldjFxAdh+TRGv/U1aQBJuAoUTX2y6wIhEBN4l/6w6xgRQxC0xjkdh05DzYJGEBf4k7
	DcuZQGwWAVWJzUt7wGxeAXeJJ3e+MUJsk5P4/3IFWJxTwEPi5KLNTBCb3SW2PT3IMoGRdwEj
	wypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLj4uoNx6TGrQ4wCHIxKPLwXv80IEWJNLCuu
	zD3EKMHBrCTC+1J8ZogQb0piZVVqUX58UWlOavEhRiYOTqkGxvmL295/9liyXiR+q1Xqd3fe
	570KxxwWftkz5ZWNsmxXTWl7q6s/d+7shV3S0W8/B9p5Z5wwePPpxvlnbtsz969c9srhYw7L
	S3Olbfnv/0Vvf7gldEfWI61Eqa+3Pt/7KbpMlIcxtHtiT8mKWfPyW0x0s1epFtQ6xS700bCs
	SDS1FOstKGncq8RSnJFoqMVcVJwIAC82Y01pAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Firmware on certain boards (e.g. ODROID-U3) can leave incorrect L2C prefetch
settings configured in registers leading to crashes if L2C is enabled
without overriding them. This patch introduces bindings to enable
prefetch settings to be specified from DT and necessary support in the
driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[mszyprow: rebased onto v3.18-rc1, added error message when prefetch related
 dt property has been provided without any value]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 10 +++++
 arch/arm/mm/cache-l2x0.c                       | 54 ++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index 292ef7ca3058..0dbabe9a6b0a 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -57,6 +57,16 @@ Optional properties:
 - cache-id-part: cache id part number to be used if it is not present
   on hardware
 - wt-override: If present then L2 is forced to Write through mode
+- arm,double-linefill : Override double linefill enable setting. Enable if
+  non-zero, disable if zero.
+- arm,double-linefill-incr : Override double linefill on INCR read. Enable
+  if non-zero, disable if zero.
+- arm,double-linefill-wrap : Override double linefill on WRAP read. Enable
+  if non-zero, disable if zero.
+- arm,prefetch-drop : Override prefetch drop enable setting. Enable if non-zero,
+  disable if zero.
+- arm,prefetch-offset : Override prefetch offset value. Valid values are
+  0-7, 15, 23, and 31.
 
 Example:
 
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index d214be207517..6f9d5a02d053 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1169,6 +1169,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
 	u32 assoc;
+	u32 prefetch;
+	u32 val;
 	int ret;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
@@ -1214,6 +1216,58 @@ static void __init l2c310_of_parse(const struct device_node *np,
 		       assoc);
 		break;
 	}
+
+	prefetch = l2x0_saved_regs.prefetch_ctrl;
+
+	ret = of_property_read_u32(np, "arm,double-linefill", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,double-linefill property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-incr", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,double-linefill-incr property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,double-linefill-wrap", &val);
+	if (ret == 0) {
+		if (!val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,double-linefill-wrap property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-drop", &val);
+	if (ret == 0) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,prefetch-drop property value is missing\n");
+	}
+
+	ret = of_property_read_u32(np, "arm,prefetch-offset", &val);
+	if (ret == 0) {
+		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
+		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
+	} else if (ret != -EINVAL) {
+		pr_err("L2C-310 OF arm,prefetch-offset property value is missing\n");
+	}
+
+	l2x0_saved_regs.prefetch_ctrl = prefetch;
 }
 
 static const struct l2c_init_data of_l2c310_data __initconst = {
-- 
1.9.2

